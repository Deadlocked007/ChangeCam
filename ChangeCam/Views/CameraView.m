//
//  CameraView.m
//  ChangeCam
//
//  Created by Siraj Zaneer on 4/29/18.
//  Copyright © 2018 Siraj Zaneer. All rights reserved.
//

#import "CameraView.h"

@implementation CameraView

+ (Class)layerClass {
    return [AVCaptureVideoPreviewLayer self];
}

- (AVCaptureVideoPreviewLayer *)videoPreviewLayer {
    return (AVCaptureVideoPreviewLayer *)[self layer];
}

@end
