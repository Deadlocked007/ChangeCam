//
//  CameraViewController.h
//  ChangeCam
//
//  Created by Siraj Zaneer on 4/29/18.
//  Copyright © 2018 Siraj Zaneer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreMedia/CoreMedia.h>
#import <CoreML/CoreML.h>
#import <Vision/Vision.h>
#import "FNS_The_Scream.h"
#import "CameraView.h"

@interface CameraViewController : UIViewController <AVCaptureVideoDataOutputSampleBufferDelegate, AVCapturePhotoCaptureDelegate>

@property AVCaptureSession *captureSession;
@property AVCaptureVideoDataOutput *videoOutput;
@property AVCapturePhotoOutput *photoOutput;
@property dispatch_queue_t videoOutputQueue;
@property FNS_The_Scream *mosaicModel;
@property VNCoreMLModel *mosaicVisionModel;
@property VNRequest *request;
@property dispatch_queue_t changedVideoOutputQueue;
    
@property (weak, nonatomic) IBOutlet CameraView *cameraView;
@property (weak, nonatomic) IBOutlet UIImageView *cameraImageView;
@property (weak, nonatomic) IBOutlet UIButton *captureButton;

- (IBAction)onCapture:(UIButton *)sender;

- (void)setupCamera;
- (void)setupCaptureSession;
- (void)showCameraPreview;
- (void)setupML;

@end

