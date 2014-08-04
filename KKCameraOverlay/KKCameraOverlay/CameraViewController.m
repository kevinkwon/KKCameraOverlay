//
//  CameraViewController.m
//  KKCameraOverlay
//
//  Created by hdk on 2014. 7. 22..
//  Copyright (c) 2014년 Kevin. All rights reserved.
//

#import "CameraViewController.h"
#import "KKSandboxManager.h"
#import "UIImage+Resize.h"

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
        self.captureManager = [[KKCaptureSessionManager alloc]init];
        [self.captureManager addVideoInputFrontCamera:NO]; // set to YES for Front Camera, No for Back camera
        [self.captureManager addStillImageOutput];
        [self.captureManager addVideoPreviewLayer];
    }
    self.captureManager.previewLayer.frame = self.previewImageView.frame;
    self.captureManager.previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    
    [self.view.layer addSublayer:self.captureManager.previewLayer];
    
	[[self.captureManager captureSession] startRunning];
    
    self.imageScrollView.label.text = @"사진을 등록해주세요.";
    self.imageScrollView.label.textAlignment = NSTextAlignmentCenter;
    self.imageScrollView.delegate = self;
    
    // 탭 제스쳐를 추가한다.
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(viewTapped:)];
    [self.view addGestureRecognizer:singleTap];
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


#pragma mark - Private Method
- (IBAction)cancelPreviewModeButtonPressed:(UIButton *)sender {
    NSLog(@"사진추가 버튼 눌림, 촬영을 계속함");
    
    NSLog(@"카메라 뷰가 터치됨, 카메라를 원래되로 돌려놈");
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.captureManager.previewLayer.frame = self.previewImageView.frame;
        self.captureManager.previewLayer.borderWidth = 0;
        self.captureManager.previewLayer.opacity = 1.0;
        
        self.albumButton.transform = CGAffineTransformIdentity;
        self.captureButton.transform = CGAffineTransformIdentity;
        self.flashButton.transform = CGAffineTransformIdentity;
        
        self.deleteImageButton.transform = CGAffineTransformIdentity;
        self.cancelPreviewModeButton.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        self.previewMode = NO;
        self.previewImageView.image = nil;
        
        [self.imageScrollView resetImageLayer];
    }];
}

- (IBAction)deleteImageButtonPressed:(UIButton *)sender {
    
}

- (void)viewTapped:(UITapGestureRecognizer *)gesture
{
    if (!self.isPreviewMode) {
        return;
    }
    
    [self cancelPreviewModeButtonPressed:nil];
}


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
        NSLog(@"1.캡쳐한이미지 사이즈:%@", NSStringFromCGSize(image.size));
        // 이미지를 저장한다.
        
        // 아이템 객제가 없으면 생성
        if (!_item) {
            _item = [[ItemForPost alloc]init];
        }
        
        // 현재시간으로 파일명 만듬
        NSDate *date = [NSDate date];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyyMMddHHmmss"];
        NSString *filename = [NSString stringWithFormat:@"itemImage%@.jpg", [dateFormatter stringFromDate:date]];
        NSString *thumbnailFilename = [NSString stringWithFormat:@"thumb_itemImage%@.jpg", [dateFormatter stringFromDate:date]];
        
        // 이미지를 저장함
        KKSandboxManager *sandboxManager = [KKSandboxManager sharedInstance];
        UIImage *resizedImage = [image resizedImage:CGSizeMake(1280, 1280) interpolationQuality:kCGInterpolationDefault];
        [sandboxManager writeData:[sandboxManager dataFromImage:resizedImage compressionQuality:0.8 extention:@"jpg"] fileName:filename directoryType:KKSandBoxTypeLibraryCacheItemImagesForPost];
        
        // 썸네일도 만들어 저장함
        resizedImage = [resizedImage resizedImage:CGSizeMake(640, 640) interpolationQuality:kCGInterpolationDefault];
        [sandboxManager writeData:[sandboxManager dataFromImage:resizedImage compressionQuality:0.8 extention:@"jpg"] fileName:thumbnailFilename directoryType:KKSandBoxTypeLibraryCacheItemImagesForPost];

        // 어레이가 없으면 생성
        if (!_item.images) {
            _item.images = [[NSMutableArray alloc]init];
        }
        [_item.images addObject:filename];
        
        [self.imageScrollView addImage:resizedImage];
        
        self.captureButton.enabled = YES;
    }];
}

- (IBAction)flashButtonPressed:(id)sender {
    [self.captureManager toggleFlashlight];
}

- (IBAction)albumButtonPressed:(id)sender {
}


#pragma mark - KKImageScrollViewDelegate
- (void)KKImageScrollView:(KKImageScrollView *)view selectedImageView:(UIImageView *)imageView
{
    // 이미지를 화면에 보여줌
    self.previewImageView.image = imageView.image;

    // 카메라 뷰를 작게 만들어줌
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.captureManager.previewLayer.frame = CGRectMake(CGRectGetMinX(self.previewImageView.frame)
                                                            , CGRectGetMaxY(self.previewImageView.frame) - 55
                                                            , 55
                                                            , 55);
        self.captureManager.previewLayer.borderColor = [[UIColor whiteColor]CGColor];
        self.captureManager.previewLayer.borderWidth = 1;
        self.captureManager.previewLayer.opacity = 0.8;
        
        self.albumButton.transform = CGAffineTransformMakeTranslation(0.0, 43.0);
        self.captureButton.transform = CGAffineTransformMakeTranslation(0.0, 43.0);
        self.flashButton.transform = CGAffineTransformMakeTranslation(0.0, 43.0);
        
        self.deleteImageButton.transform = CGAffineTransformMakeTranslation(5.0 + CGRectGetWidth(self.deleteImageButton.frame)
                                                                            , 0.0);
        self.cancelPreviewModeButton.transform = CGAffineTransformMakeTranslation(- 5.0f - CGRectGetWidth(self.cancelPreviewModeButton.frame)
                                                                                  , 0.0);
    } completion:^(BOOL finished) {
        self.previewMode = YES;
    }];
}

@end
