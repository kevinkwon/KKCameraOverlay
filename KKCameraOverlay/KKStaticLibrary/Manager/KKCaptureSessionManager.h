//
//  CaptureManager.h
//  KKCameraOverlay
//
//  Created by hdk on 2014. 7. 23..
//  Copyright (c) 2014년 Kevin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

typedef void (^KKCaptureSessionManagerDidCaptureSuccess_t)(UIImage *image);

@interface KKCaptureSessionManager : NSObject

@property (strong, nonatomic) AVCaptureVideoPreviewLayer *previewLayer;
@property (strong, nonatomic) AVCaptureSession *captureSession;
@property (strong, nonatomic) AVCaptureStillImageOutput *stillImageOutput;
@property (nonatomic, strong) UIImage *stillImage;
@property BOOL isUsingFrontFacingCamera;

- (void)addVideoPreviewLayer;
- (void)addStillImageOutput;
- (void)captureStillImage:(KKCaptureSessionManagerDidCaptureSuccess_t)success;
- (void)addVideoInputFrontCamera:(BOOL)front;

- (void)switchCamera;
- (void)toggleFlashlight;

@end
