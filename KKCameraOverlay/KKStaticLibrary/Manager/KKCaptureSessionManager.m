//
//  CaptureManager.m
//  KKCameraOverlay
//
//  Created by hdk on 2014. 7. 23..
//  Copyright (c) 2014년 Kevin. All rights reserved.
//

#import "KKCaptureSessionManager.h"
#import <ImageIO/ImageIO.h>

@implementation KKCaptureSessionManager

#pragma mark Capture Session Configuration
- (id)init {
	if ((self = [super init])) {
        self.captureSession = [[AVCaptureSession alloc] init];
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
            [self.captureSession setSessionPreset:AVCaptureSessionPresetPhoto];
        }
        else {
            [self.captureSession setSessionPreset:AVCaptureSessionPresetPhoto];
        }
	}
	return self;
}

- (void)addVideoInputFrontCamera:(BOOL)front {
    // Select a video device, make an input
    NSArray *devices = [AVCaptureDevice devices];
    AVCaptureDevice *frontCamera;
    AVCaptureDevice *backCamera;
    
    for (AVCaptureDevice *device in devices) {
        
        // NSLog(@"Device name: %@", [device localizedName]);
        
        if ([device hasMediaType:AVMediaTypeVideo]) {
            
            if ([device position] == AVCaptureDevicePositionBack) {
                // NSLog(@"Device position : back");
                backCamera = device;
            }
            else {
                // NSLog(@"Device position : front");
                frontCamera = device;
            }
        }
    }
    
    NSError *error = nil;
    
    if (front) {
        AVCaptureDeviceInput *frontFacingCameraDeviceInput = [AVCaptureDeviceInput deviceInputWithDevice:frontCamera error:&error];
        if (!error) {
            if ([self.captureSession canAddInput:frontFacingCameraDeviceInput]) {
                [self.captureSession addInput:frontFacingCameraDeviceInput];
                
                self.isUsingFrontFacingCamera = YES;
            } else {
                NSLog(@"Couldn't add front facing video input");
            }
        }
    } else {
        AVCaptureDeviceInput *backFacingCameraDeviceInput = [AVCaptureDeviceInput deviceInputWithDevice:backCamera error:&error];
        if (!error) {
            if ([self.captureSession canAddInput:backFacingCameraDeviceInput]) {
                [self.captureSession addInput:backFacingCameraDeviceInput];
                
                self.isUsingFrontFacingCamera = NO;
            } else {
                NSLog(@"Couldn't add back facing video input");
            }
        }
    }
}

- (void)addStillImageOutput
{
    _stillImageOutput = [[AVCaptureStillImageOutput alloc] init];
    
//    NSDictionary *pixelAspectRatio = @{AVVideoPixelAspectRatioHorizontalSpacingKey:@1.0, AVVideoPixelAspectRatioVerticalSpacingKey:@1.0f};
//    NSDictionary *outputSettingInfo = @{AVVideoCodecKey:AVVideoCodecJPEG
//                                        , AVVideoWidthKey:@1920
//                                        , AVVideoHeightKey:@1920
//                                        , AVVideoPixelAspectRatioKey:pixelAspectRatio};
//    [self.stillImageOutput setOutputSettings:outputSettingInfo];
    
    AVCaptureConnection *videoConnection = nil;
    for (AVCaptureConnection *connection in [self.stillImageOutput connections]) {
        for (AVCaptureInputPort *port in [connection inputPorts]) {
            if ([[port mediaType] isEqual:AVMediaTypeVideo] ) {
                videoConnection = connection;
                break;
            }
        }
        if (videoConnection) {
            break;
        }
    }
    
    if ([self.captureSession canAddOutput:self.stillImageOutput]) {
        [self.captureSession addOutput:self.stillImageOutput];
    }
}

- (void)addVideoPreviewLayer {
    self.previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.captureSession];
    self.previewLayer.backgroundColor = [[UIColor blackColor]CGColor];
    [self.previewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
}

- (void)switchCamera {
    AVCaptureDevicePosition desiredPosition;
    
    // Get the opposite camera device of current
    if (self.isUsingFrontFacingCamera)
        desiredPosition = AVCaptureDevicePositionBack;
    else
        desiredPosition = AVCaptureDevicePositionFront;
    
    
    //Loop through available devices and select the one of our desiredPosition
    for (AVCaptureDevice *device in [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo])
    {
        if ([device position] == desiredPosition)
        {
            // Begin a Configuration Change
            [self.captureSession beginConfiguration];
            
            // Init new input as AVCaptureDeviceInput and remove the old input/.
            AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
            for (AVCaptureInput *oldInput in [self.captureSession inputs])
            {
                [self.captureSession removeInput:oldInput];
            }
            
            // Add new input to session and commit the configuartion changes.
            [self.captureSession addInput:input];
            [self.captureSession commitConfiguration];
            break;
        }
    }
    
    self.isUsingFrontFacingCamera = !self.isUsingFrontFacingCamera;
}

- (void)captureStillImage:(KKCaptureSessionManagerDidCaptureSuccess_t)success
{
	AVCaptureConnection *videoConnection = nil;
	for (AVCaptureConnection *connection in [self.stillImageOutput connections]) {
		for (AVCaptureInputPort *port in [connection inputPorts]) {
			if ([[port mediaType] isEqual:AVMediaTypeVideo]) {
				videoConnection = connection;
				break;
			}
		}
		if (videoConnection) {
            break;
        }
	}
    
	NSLog(@"about to request a capture from: %@", [self stillImageOutput]);
	[[self stillImageOutput] captureStillImageAsynchronouslyFromConnection:videoConnection
                                                         completionHandler:^(CMSampleBufferRef imageSampleBuffer, NSError *error) {
                                                             if (error) {
                                                                 [self displayErrorOnMainQueue:error withMessage:@"Take picture failed"];
                                                             }
                                                             else {
                                                                 CFDictionaryRef exifAttachments = CMGetAttachment(imageSampleBuffer, kCGImagePropertyExifDictionary, NULL);
                                                                 if (exifAttachments) {
                                                                     NSLog(@"attachements: %@", exifAttachments);
                                                                 } else {
                                                                     NSLog(@"no attachments");
                                                                 }
                                                                 
                                                                 NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageSampleBuffer];
                                                                 UIImage *image = [[UIImage alloc] initWithData:imageData];

                                                                 if (success) {
                                                                     success(image);
                                                                 }
                                                             }
                                                         }];
}

- (void)dealloc {
	[self.captureSession stopRunning];
}

// utility routine to display error aleart if takePicture fails
- (void)displayErrorOnMainQueue:(NSError *)error withMessage:(NSString *)message
{
	dispatch_async(dispatch_get_main_queue(), ^(void) {
		UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"%@ (%d)", message, (int)[error code]]
															message:[error localizedDescription]
														   delegate:nil
												  cancelButtonTitle:@"Dismiss"
												  otherButtonTitles:nil];
		[alertView show];
		// [alertView release];
	});
}

- (void)toggleFlashlight
{
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    if (device.torchMode == AVCaptureTorchModeOff || device.torchMode == AVCaptureTorchModeAuto)
    {
        // Start session configuration
        [self.captureSession beginConfiguration];
        [device lockForConfiguration:nil];
        
        // Set torch to on
        [device setTorchMode:AVCaptureTorchModeOn];
        
        [device unlockForConfiguration];
        [self.captureSession commitConfiguration];
    }
    else
    {
        // Start session configuration
        [self.captureSession beginConfiguration];
        [device lockForConfiguration:nil];
        
        // Set torch to on
        [device setTorchMode:AVCaptureTorchModeOff];
        
        [device unlockForConfiguration];
        [self.captureSession commitConfiguration];

    }
}

@end