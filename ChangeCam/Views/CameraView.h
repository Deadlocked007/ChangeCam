//
//  CameraView.h
//  ChangeCam
//
//  Created by Siraj Zaneer on 4/29/18.
//  Copyright © 2018 Siraj Zaneer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface CameraView : UIView

@property(nonatomic) AVCaptureVideoPreviewLayer *videoPreviewLayer;

@end
