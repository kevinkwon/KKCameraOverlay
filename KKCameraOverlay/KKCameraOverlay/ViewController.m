//
//  ViewController.m
//  KKCameraOverlay
//
//  Created by hdk on 2014. 7. 18..
//  Copyright (c) 2014년 Kevin. All rights reserved.
//

#import "ViewController.h"
#import "CameraViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self performSelector:@selector(registerButtonPressed:) withObject:nil afterDelay:0.5];
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
        CameraViewController *target = [[CameraViewController alloc]initWithNibName:@"CameraViewController" bundle:nil];
        UINavigationController *nc = [[UINavigationController alloc]initWithRootViewController:target];
        
        [self presentViewController:nc animated:NO completion:nil];
    }
}

@end
