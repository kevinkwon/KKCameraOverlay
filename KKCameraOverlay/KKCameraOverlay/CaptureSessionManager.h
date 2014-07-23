//
//  CaptureManager.h
//  KKCameraOverlay
//
//  Created by hdk on 2014. 7. 23..
//  Copyright (c) 2014년 Kevin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

extern NSString *const kImageCapturedSuccessfully;

@interface CaptureSessionManager : NSObject

@property (strong) AVCaptureVideoPreviewLayer *previewLayer;
@property (strong) AVCaptureSession *captureSession;
@property (strong) AVCaptureStillImageOutput *stillImageOutput;
@property (nonatomic, strong) UIImage *stillImage;
@property BOOL isUsingFrontFacingCamera;

- (void)addVideoPreviewLayer;
- (void)addStillImageOutput;
- (void)captureStillImage;
- (void)addVideoInputFrontCamera:(BOOL)front;

- (void)switchCamera;


@end
