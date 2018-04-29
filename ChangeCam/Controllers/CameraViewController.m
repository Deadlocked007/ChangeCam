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
    AVCapturePhotoOutput *photoOutput;
    
    _captureSession = [[AVCaptureSession alloc] init];
    [_captureSession beginConfiguration];
    videoDevice = [AVCaptureDevice defaultDeviceWithDeviceType:AVCaptureDeviceTypeBuiltInWideAngleCamera mediaType:AVMediaTypeVideo position:AVCaptureDevicePositionUnspecified];
    videoDeviceInput = [AVCaptureDeviceInput deviceInputWithDevice:videoDevice error:&error];
    if (error) {
        NSLog(@"%@", [error localizedDescription]);
    } else if ([_captureSession canAddInput:videoDeviceInput]) {
        [_captureSession addInput:videoDeviceInput];
        photoOutput = [[AVCapturePhotoOutput alloc] init];
        if ([_captureSession canAddOutput:photoOutput]) {
            _captureSession.sessionPreset = AVCaptureSessionPresetPhoto;
            [_captureSession addOutput:photoOutput];
            [_captureSession commitConfiguration];
            [self showCameraPreview];
        }
    }
}

- (void)showCameraPreview {
    _cameraView.videoPreviewLayer.session = _captureSession;
    [_captureSession startRunning];
}

@end
