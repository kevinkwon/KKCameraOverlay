//
//  CameraViewController.h
//  KKCameraOverlay
//
//  Created by hdk on 2014. 7. 22..
//  Copyright (c) 2014년 Kevin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "KKCaptureSessionManager.h"
#import "ItemForPost.h"
#import "KKImageScrollView.h"

@interface CameraViewController : UIViewController <KKImageScrollViewDelegate>
{
}

@property (assign, nonatomic, readonly) NSInteger selectedImageIndex; // 선택된 이미지 인덱스

@property (assign, nonatomic) NSInteger maxImageNumber; // 최대 선택 가능한 이미지 수

@property (strong, nonatomic) ItemForPost *item; // 등록용 아이템

@property (strong, nonatomic) KKCaptureSessionManager *captureManager; // 사진 캡쳐 매니져

@property (weak, nonatomic) IBOutlet UIImageView *previewImageView; // 이미지가 보이는 뷰

@property (weak, nonatomic) IBOutlet KKImageScrollView *imageScrollView; // 상단에 이미지 스크롤 뷰

@property (weak, nonatomic) IBOutlet UIButton *captureButton; // 캡쳐 버튼

- (IBAction)captureButtonPressed:(id)sender; // 캡쳐 버튼 메소드

@property (weak, nonatomic) IBOutlet UIButton *flashButton; // 플래시 버튼

- (IBAction)flashButtonPressed:(id)sender; // 플래쉬 버튼 메소드

@property (weak, nonatomic) IBOutlet UIButton *albumButton; // 앨범 버튼

- (IBAction)albumButtonPressed:(id)sender; // 앨범 버튼 메소드

@property (assign, nonatomic, getter = isPreviewMode) BOOL previewMode; // 이미지 보고 있는 모드, YES 촬영모드, NO 미리보기 모드

@property (weak, nonatomic) IBOutlet UIButton *deleteImageButton; // 삭제 버튼

- (IBAction)deleteImageButtonPressed:(id)sender; // 삭제 버튼 메소드

@property (weak, nonatomic) IBOutlet UIButton *cancelPreviewModeButton; // 취소 버튼 (촬영 모드로 변경)

- (IBAction)cancelPreviewModeButtonPressed:(UIButton *)sender; // 쉬소 버튼 메소드

@end
