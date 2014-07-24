//
//  CameraViewController.m
//  KKCameraOverlay
//
//  Created by hdk on 2014. 7. 22..
//  Copyright (c) 2014년 Kevin. All rights reserved.
//

#import "CameraViewController.h"
#import "KKSandboxManager.h"

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
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"NEXT" style:UIBarButtonItemStyleBordered target:self action:@selector(nextStep)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"Close" style:UIBarButtonItemStyleBordered target:self action:@selector(close)];
    
    if (!self.captureManager) {
        self.captureManager = [[CaptureSessionManager alloc]init];
        [self.captureManager addVideoInputFrontCamera:NO]; // set to YES for Front Camera, No for Back camera
        [self.captureManager addStillImageOutput];
        [self.captureManager addVideoPreviewLayer];
    }
    self.captureManager.previewLayer.frame = self.previewImageView.layer.bounds;
    self.captureManager.previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    
    [self.previewImageView.layer addSublayer:self.captureManager.previewLayer];
    
	[[self.captureManager captureSession] startRunning];
    
    self.imageScrollView.label.text = @"사진을 등록해주세요.";
    self.imageScrollView.label.textAlignment = NSTextAlignmentCenter;
    self.imageScrollView.delegate = self;
}

- (void)imageViewTapped:(UIImageView *)sender {
    NSLog(@"tab됨");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// Run session setup after subviews are laid out.
//- (void)viewDidLayoutSubviews
//{
//}

- (void)nextStep
{
    
}

- (void)close
{
    [self dismissViewControllerAnimated:YES completion:nil];
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

- (IBAction)captureButtonPressed:(id)sender {
    self.captureButton.enabled = NO;
    
    [self.captureManager captureStillImage:^(UIImage *image) {
        // 이미지를 저장한다.
        
        // 아이템 객제가 없으면 생성
        if (!_item) {
            _item = [[ItemForPost alloc]init];
        }
        
        // 현재시간으로 파일명 만듬
        NSDate *date = [NSDate date];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyyMMddHHmmss"];
        NSString *filename = [NSString stringWithFormat:@"itemImage_%@.jpg", [dateFormatter stringFromDate:date]];
        NSLog(@"filename:%@", filename);
        
        // 이미지 저장할 파일명은
        KKSandboxManager *sandboxManager = [KKSandboxManager sharedInstance];
        [sandboxManager writeData:[sandboxManager dataFromImage:image compressionQuality:0.8 extention:@"jpg"] fileName:filename directoryType:KKSandBoxTypeLibraryCacheItemImagesForPost];

        // 어레이가 없으면 생성
        if (!_item.images) {
            _item.images = [[NSMutableArray alloc]init];
        }
        [_item.images addObject:filename];
        
        [self.imageScrollView addImage:image];
        
        self.captureButton.enabled = YES;
    }];
}

- (IBAction)flashButtonPressed:(id)sender {
}

- (IBAction)albumButtonPressed:(id)sender {
}

- (void)KKImageScrollView:(KKImageScrollView *)view selectedImage:(UIImage *)image
{
    NSLog(@"터치된 이미지");
}

@end
