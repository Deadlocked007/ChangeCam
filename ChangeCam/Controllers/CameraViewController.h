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
#import "CameraView.h"

@interface CameraViewController : UIViewController <AVCaptureVideoDataOutputSampleBufferDelegate>

@property AVCaptureSession *captureSession;
@property AVCaptureVideoDataOutput *videoOutput;
@property dispatch_queue_t videoOutputQueue;

@property (weak, nonatomic) IBOutlet CameraView *cameraView;

- (void)setupCamera;
- (void)setupCaptureSession;
- (void)showCameraPreview;

@end

