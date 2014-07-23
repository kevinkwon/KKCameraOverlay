//
//  CameraViewController.h
//  KKCameraOverlay
//
//  Created by hdk on 2014. 7. 22..
//  Copyright (c) 2014년 Kevin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "CaptureSessionManager.h"

@interface CameraViewController : UIViewController
@property (strong) CaptureSessionManager *captureManager;

@property (weak, nonatomic) IBOutlet UIView *previewView;
- (IBAction)switchCamera:(id)sender;
- (IBAction)captureStillImage:(id)sender;
@end
