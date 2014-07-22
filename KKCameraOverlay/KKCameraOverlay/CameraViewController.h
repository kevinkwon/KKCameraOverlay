//
//  CameraViewController.h
//  KKCameraOverlay
//
//  Created by hdk on 2014. 7. 22..
//  Copyright (c) 2014년 Kevin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface CameraViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIView *previewView;
- (IBAction)switchCamera:(id)sender;

@property (strong, nonatomic) AVCaptureSession *session;
@property (strong) AVCaptureDevice *videoDevice;
@property (strong) AVCaptureDeviceInput *videoInput;
@property (strong) AVCaptureStillImageOutput *stillImageOutput;
@property BOOL isUsingFrontFacingCamera;

- (AVCaptureDevice *) backCamera;
- (AVCaptureDevice *) frontCamera;

@end
