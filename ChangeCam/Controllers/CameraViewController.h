//
//  CameraViewController.h
//  ChangeCam
//
//  Created by Siraj Zaneer on 4/29/18.
//  Copyright © 2018 Siraj Zaneer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "CameraView.h"

@interface CameraViewController : UIViewController

@property AVCaptureSession *captureSession;

@property (weak, nonatomic) IBOutlet CameraView *cameraView;

- (void)setupCamera;
- (void)setupCaptureSession;
- (void)showCameraPreview;

@end
