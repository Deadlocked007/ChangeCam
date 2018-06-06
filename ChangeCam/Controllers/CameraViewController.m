//
//  CameraViewController.m
//  ChangeCam
//
//  Created by Siraj Zaneer on 4/29/18.
//  Copyright © 2018 Siraj Zaneer. All rights reserved.
//

#import "CameraViewController.h"

@interface CameraViewController ()

@end

@implementation CameraViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupML];
    [self setupCamera];
}

- (void)setupCamera {
    // Check and request authorization status of capture
    switch ([AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo]) {
        case AVAuthorizationStatusAuthorized: {
            [self setupCaptureSession];
            break;
        }
        case AVAuthorizationStatusNotDetermined: {
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                if (granted) {
                    [self setupCaptureSession];
                }
            }];
            break;
        }
        case AVAuthorizationStatusRestricted: {
            NSLog(@"hello");
            break;
        }
        case AVAuthorizationStatusDenied: {
            NSLog(@"hello");
            break;
        }
        default:
            break;
    }
}

- (void)setupCaptureSession {
    AVCaptureDevice *videoDevice;
    NSError *error;
    AVCaptureDeviceInput *videoDeviceInput;
    
    _captureSession = [[AVCaptureSession alloc] init];
    [_captureSession beginConfiguration];
    _captureSession.sessionPreset = AVCaptureSessionPreset352x288;
    
    videoDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    if ([videoDevice isFocusModeSupported:AVCaptureFocusModeContinuousAutoFocus]) {
        [videoDevice lockForConfiguration:&error];
        if (error) {
            NSLog(@"%@", [error localizedDescription]);
            error = nil;
        } else {
            videoDevice.focusMode = AVCaptureFocusModeContinuousAutoFocus;
            [videoDevice unlockForConfiguration];
        }
    }

    
    videoDeviceInput = [AVCaptureDeviceInput deviceInputWithDevice:videoDevice error:&error];
    if (error) {
        NSLog(@"%@", [error localizedDescription]);
    } else if ([_captureSession canAddInput:videoDeviceInput]) {
        [_captureSession addInput:videoDeviceInput];
        
        // Add output for capturing live frames
        _videoOutput = [[AVCaptureVideoDataOutput alloc] init];
        if ([_captureSession canAddOutput:_videoOutput]) {
            _videoOutput.alwaysDiscardsLateVideoFrames = YES;
            _videoOutputQueue = dispatch_queue_create("videoOutputQueue", DISPATCH_QUEUE_SERIAL);
            [_videoOutput setSampleBufferDelegate:self queue:_videoOutputQueue];
            [_captureSession addOutput:_videoOutput];
            [_videoOutput connectionWithMediaType:AVMediaTypeVideo].videoOrientation = AVCaptureVideoOrientationPortrait;
        }
        
        [_captureSession commitConfiguration];
        [self showCameraPreview];
    }
}

- (void)showCameraPreview {
    _cameraView.videoPreviewLayer.videoGravity = AVLayerVideoGravityResizeAspect;
    //_cameraView.videoPreviewLayer.session = _captureSession;
    [_captureSession startRunning];
}

- (void)captureOutput:(AVCaptureOutput *)output didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection {
    __block CVPixelBufferRef imageBuffer;
    __block VNImageRequestHandler *handler;
    __block NSError *error;

    dispatch_sync(self->_changedVideoOutputQueue, ^{
        imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
        if (imageBuffer) {
            handler = [[VNImageRequestHandler alloc] initWithCVPixelBuffer:imageBuffer options:[[NSDictionary alloc] init]];
            [handler performRequests:[NSArray arrayWithObjects:self->_request, nil] error:&error];
        }
    });
}

- (IBAction)onCapture:(UIButton *)sender {
//    AVCapturePhotoSettings *settings;
    if (_captureSession.isRunning) {
        [_captureSession stopRunning];
    } else {
        [_captureSession startRunning];
    }
//    settings = [AVCapturePhotoSettings photoSettingsWithFormat:@{AVVideoCodecKey : AVVideoCodecTypeJPEG}];
//    [_photoOutput capturePhotoWithSettings:settings delegate:self];
}

- (void)setupML {
    NSError *error;
    __block NSArray *results;
    __block VNPixelBufferObservation *observation;
    __block CIImage *imageObject;
    __block UIImage *image;

    _changedVideoOutputQueue = dispatch_queue_create("changedVideoOutputQueue", DISPATCH_QUEUE_SERIAL);
    _mosaicModel = [[FNS_The_Scream alloc] init];
    _mosaicVisionModel = [VNCoreMLModel modelForMLModel:_mosaicModel.model error:&error];
    if (error) {
        NSLog(@"%@", [error localizedDescription]);
    } else {
        _request = [[VNCoreMLRequest alloc] initWithModel:_mosaicVisionModel completionHandler:^(VNRequest * _Nonnull request, NSError * _Nullable error) {
            if (error) {
                NSLog(@"%@", [error localizedDescription]);
            } else {
                if (request.results) {
                    results = request.results;
                    
                    observation = results[0];
                    imageObject = [CIImage imageWithCVImageBuffer:observation.pixelBuffer];
                    image = [UIImage imageWithCIImage:imageObject];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        self->_cameraImageView.image = image;
                    });
                }
            }
        }];
        
    }
}

@end
