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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// Run session setup after subviews are laid out.
- (void)viewDidLayoutSubviews
{
    
    self.captureManager = [[CaptureSessionManager alloc]init];
    [self.captureManager addVideoInputFrontCamera:NO]; // set to YES for Front Camera, No for Back camera
    [self.captureManager addStillImageOutput];
    [self.captureManager addVideoPreviewLayer];
    
	CGRect layerRect = self.previewView.layer.bounds;
    self.captureManager.previewLayer.bounds = layerRect;
    [[[self captureManager] previewLayer] setPosition:CGPointMake(CGRectGetMidX(layerRect),CGRectGetMidY(layerRect))];
	[[[self view] layer] addSublayer:[[self captureManager] previewLayer]];
    
//    UIImageView *overlayImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"overlaygraphic.png"]];
//    [overlayImageView setFrame:CGRectMake(30, 100, 260, 200)];
//    [[self view] addSubview:overlayImageView];
    
//    UIButton *overlayButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    [overlayButton setImage:[UIImage imageNamed:@"scanbutton.png"] forState:UIControlStateNormal];
//    [overlayButton setFrame:CGRectMake(130, 320, 60, 30)];
//    [overlayButton addTarget:self action:@selector(scanButtonPressed) forControlEvents:UIControlEventTouchUpInside];
//    [[self view] addSubview:overlayButton];
    
//    UILabel *tempLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 50, 120, 30)];
//    [self setScanningLabel:tempLabel];
//    [tempLabel release];
//	[scanningLabel setBackgroundColor:[UIColor clearColor]];
//	[scanningLabel setFont:[UIFont fontWithName:@"Courier" size: 18.0]];
//	[scanningLabel setTextColor:[UIColor redColor]];
//	[scanningLabel setText:@"Saving..."];
//    [scanningLabel setHidden:YES];
//	[[self view] addSubview:scanningLabel];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(saveImageToPhotoAlbum) name:kImageCapturedSuccessfully object:nil];
    
	[[self.captureManager captureSession] startRunning];
}

- (void)saveImageToPhotoAlbum
{
    UIImageWriteToSavedPhotosAlbum([[self captureManager] stillImage], self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
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

}

/* 다른 방법
 // Run session setup after subviews are laid out.
 - (void)viewDidLayoutSubviews
 {
 // Create AVCaptureSession and set the quality of the output
 self.session = [[AVCaptureSession alloc] init];
 self.session.sessionPreset = AVCaptureSessionPresetPhoto;
 
 // Get the Back Camera Device, init a AVCaptureDeviceInput linking the Device and add the input to the session.
 self.videoDevice = [self backCamera];
 self.videoInput = [AVCaptureDeviceInput deviceInputWithDevice:self.videoDevice error:nil];
 [self.session addInput:self.videoInput];
 
 // Insert code to add still image output here
 
 // Init the AVCaptureVideoPreviewLayer with our created session. Get the UIView layer
 AVCaptureVideoPreviewLayer *captureVideoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.session];
 CALayer *viewLayer = self.previewView.layer;
 
 // Set the AVCaptureVideoPreviewLayer bounds to the main view bounds and fill it accordingly. Add as sublayer to the main UIView
 [viewLayer setMasksToBounds:YES];
 captureVideoPreviewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
 captureVideoPreviewLayer.frame = [viewLayer bounds];
 [viewLayer addSublayer:captureVideoPreviewLayer];
 
 // Start Running the Session
 [self.session startRunning];
 }
 */
@end
