//
//  ViewController.m
//  KKCameraOverlay
//
//  Created by hdk on 2014. 7. 18..
//  Copyright (c) 2014년 Kevin. All rights reserved.
//

#import "ViewController.h"
#import "OverlayView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self performSelector:@selector(registerButtonPressed:) withObject:nil afterDelay:1.0];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)registerButtonPressed:(id)sender {
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        
        // alert the user that the camera can't be accessed
        UIAlertView *noCameraAlert = [[UIAlertView alloc] initWithTitle:@"No Camera" message:@"Unable to access the camera!" delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil, nil];
        [noCameraAlert show];
        
    } else {
        OverlayView *overlayView = nil;
        NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"OverlayView" owner:self options:nil];

        for (id oneObject in nib) {
            if ([oneObject isKindOfClass:[OverlayView class]]){
                overlayView = (OverlayView *)oneObject;
            }
        }
        
        UIImagePickerController *picker = [[UIImagePickerController alloc]init];
        picker.delegate = self;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        picker.allowsEditing = NO;
        picker.showsCameraControls = NO;
        overlayView.frame = picker.view.frame;
        picker.cameraOverlayView = overlayView;
        
        UINavigationController *nc = [[UINavigationController alloc]initWithRootViewController:picker];
        [self presentViewController:nc animated:YES completion:nil];
    }
}

#pragma mark - UIImagePickerController Delegate Method
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo NS_DEPRECATED_IOS(2_0, 3_0)
{
    NSLog(@"이미지 피킹 완료%@", image);
    NSLog(@"editingInfo:%@", editingInfo);
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSLog(@"동영상선택됨");
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    NSLog(@"취소됨");
    [picker dismissViewControllerAnimated:YES completion:nil];
}


@end
