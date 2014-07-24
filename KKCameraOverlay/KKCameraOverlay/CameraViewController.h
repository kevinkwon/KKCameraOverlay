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
#import "ItemForPost.h"
#import "KKImageScrollView.h"

@interface CameraViewController : UIViewController <KKImageScrollViewDelegate>
{
}

@property (strong, nonatomic) ItemForPost *item;

@property (strong, nonatomic) CaptureSessionManager *captureManager;

@property (weak, nonatomic) IBOutlet UIImageView *previewImageView;

@property (weak, nonatomic) IBOutlet KKImageScrollView *imageScrollView;

@property (weak, nonatomic) IBOutlet UIButton *captureButton;

- (IBAction)captureButtonPressed:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *flashButton;

- (IBAction)flashButtonPressed:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *albumButton;

- (IBAction)albumButtonPressed:(id)sender;

@end
