//
//  CaptureManager.m
//  KKCameraOverlay
//
//  Created by hdk on 2014. 7. 23..
//  Copyright (c) 2014년 Kevin. All rights reserved.
//

#import "CaptureSessionManager.h"
#import <ImageIO/ImageIO.h>

NSString *const kImageCapturedSuccessfully = @"imageCapturedSuccessfully";

@implementation CaptureSessionManager

#pragma mark Capture Session Configuration
- (id)init {
	if ((self = [super init])) {
        self.captureSession = [[AVCaptureSession alloc] init];
	}
	return self;
}

- (void)addVideoPreviewLayer {
    self.previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:[self captureSession]];
    [self.previewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
}

- (void)addVideoInputFrontCamera:(BOOL)front {
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
            if ([[self captureSession] canAddInput:frontFacingCameraDeviceInput]) {
                [[self captureSession] addInput:frontFacingCameraDeviceInput];
                
                self.isUsingFrontFacingCamera = YES;
            } else {
                NSLog(@"Couldn't add front facing video input");
            }
        }
    } else {
        AVCaptureDeviceInput *backFacingCameraDeviceInput = [AVCaptureDeviceInput deviceInputWithDevice:backCamera error:&error];
        if (!error) {
            if ([[self captureSession] canAddInput:backFacingCameraDeviceInput]) {
                [[self captureSession] addInput:backFacingCameraDeviceInput];
                
                self.isUsingFrontFacingCamera = NO;
            } else {
                NSLog(@"Couldn't add back facing video input");
            }
        }
    }
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

- (void)addStillImageOutput
{
    self.stillImageOutput = [[AVCaptureStillImageOutput alloc] init];

    NSDictionary *outputSettingInfo = @{AVVideoCodecKey:AVVideoCodecJPEG, AVVideoWidthKey:@1920, AVVideoHeightKey:@1920};
    [[self stillImageOutput] setOutputSettings:outputSettingInfo];
    
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
    
    [self.captureSession addOutput:self.stillImageOutput];
}

- (void)captureStillImage
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
                                                             CFDictionaryRef exifAttachments = CMGetAttachment(imageSampleBuffer, kCGImagePropertyExifDictionary, NULL);
                                                             if (exifAttachments) {
                                                                 NSLog(@"attachements: %@", exifAttachments);
                                                             } else {
                                                                 NSLog(@"no attachments");
                                                             }
                                                             NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageSampleBuffer];
                                                             UIImage *image = [[UIImage alloc] initWithData:imageData];
                                                             self.stillImage = image;
                                                             // [image release];
                                                             [[NSNotificationCenter defaultCenter] postNotificationName:kImageCapturedSuccessfully object:nil];
                                                         }];
}

- (void)dealloc {
	[self.captureSession stopRunning];
}

@end