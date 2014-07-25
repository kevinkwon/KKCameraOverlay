//
//  KKImageScrollView.h
//  KKCameraOverlay
//
//  Created by hdk on 2014. 7. 24..
//  Copyright (c) 2014년 Kevin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class KKImageScrollView;
@protocol KKImageScrollViewDelegate <UIScrollViewDelegate>

- (void)KKImageScrollView:(KKImageScrollView *)view selectedImageView:(UIImageView *)imageView;

@end

@interface KKImageScrollView : UIScrollView

@property (weak, nonatomic) id <KKImageScrollViewDelegate> delegate;
@property (strong, nonatomic) UILabel *label;
@property (strong, nonatomic) NSMutableArray *images;

- (void)addImage:(UIImage *)image;
- (void)removeImageAtIndex:(NSInteger)index;

- (void)resetImageLayer;

@end
