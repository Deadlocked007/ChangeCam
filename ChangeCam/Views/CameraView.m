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
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
