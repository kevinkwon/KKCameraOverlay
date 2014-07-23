//
//  CameraViewController.m
//  KKCameraOverlay
//
//  Created by hdk on 2014. 7. 22..
//  Copyright (c) 2014년 Kevin. All rights reserved.
//

#import "CameraViewController.h"

@interface CameraViewController ()

@end

@implementation CameraViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"아이템 사진을 등록하세요";
    
    if (!self.captureManager) {
        self.captureManager = [[CaptureSessionManager alloc]init];
        [self.captureManager addVideoInputFrontCamera:NO]; // set to YES for Front Camera, No for Back camera
        [self.captureManager addStillImageOutput];
        [self.captureManager addVideoPreviewLayer];
    }
    self.captureManager.previewLayer.frame = self.previewView.layer.bounds;
    self.captureManager.previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    
    [self.previewView.layer addSublayer:self.captureManager.previewLayer];
    
	[[self.captureManager captureSession] startRunning];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// Run session setup after subviews are laid out.
- (void)viewDidLayoutSubviews
{
}

- (void)saveImageToPhotoAlbum:(UIImage *)image
{
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    if (error != NULL) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error!" message:@"Image couldn't be saved" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
        // [alert release];
    }
}

- (IBAction)captureStillImage:(id)sender {
    self.captureButton.enabled = NO;
    [self.captureManager captureStillImage:^(UIImage *image) {
        [self saveImageToPhotoAlbum:image];
        self.captureButton.enabled = YES;
    }];
}

@end
