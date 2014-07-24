//
//  KKImageScrollView.m
//  KKCameraOverlay
//
//  Created by hdk on 2014. 7. 24..
//  Copyright (c) 2014년 Kevin. All rights reserved.
//

#import "KKImageScrollView.h"

#define kMARGIN 5.0

@implementation KKImageScrollView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self configureView];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)awakeFromNib
{
    [self configureView];
}

- (void)configureView
{
    _label = [[UILabel alloc]init];
    _label.frame = self.bounds;
    [self addSubview:_label];
}

- (void)addImage:(UIImage *)image
{
    if (!self.images) {
        self.images = [NSMutableArray array];
    }
    
    UIImageView *imageView = [[UIImageView alloc]initWithImage:image];
    
    CGPoint offset = CGPointMake(0, 0);

    if (self.images.count == 0) {
        offset.x = kMARGIN;
        offset.y = kMARGIN;
    }
    else {
        UIImageView *lastImageView = [self.images lastObject];
        offset.y = kMARGIN;
        offset.x = CGRectGetMaxX(lastImageView.frame) + kMARGIN;
    }
    CGFloat height = CGRectGetHeight(self.frame) - kMARGIN * 2;
    CGSize size = CGSizeMake(height, height);
    imageView.frame = CGRectMake(offset.x + 10.0, offset.y, size.width, size.height);
    imageView.alpha = 0.0;
    imageView.tag = self.images.count;

    // 이미지뷰가 터치되었을 때
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(singleTapped:)];
    [self addGestureRecognizer:singleTap];
    
    [self addSubview:imageView];
    
    // scrollView에 붙인다.
    [UIView animateWithDuration:0.2f delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        imageView.alpha = 1.0;
        imageView.frame = CGRectMake(offset.x, offset.y, size.width, size.height);

        if (self.images.count == 0) {
            _label.alpha = 0;
            _label.transform = CGAffineTransformMakeTranslation(0, 10.0f);
        }
    } completion:^(BOOL finished) {
        if (CGRectGetMaxX(imageView.frame) <= CGRectGetWidth(self.frame) - kMARGIN) {
            self.contentSize = self.bounds.size;
        }
        else {
            self.contentSize = CGSizeMake(CGRectGetMaxX(imageView.frame) + kMARGIN, CGRectGetHeight(self.frame));
        }
    }];
    
    [self.images addObject:imageView];
}

- (void)removeImageAtIndex:(NSInteger)index
{
    if ([self.images count] < 1) {
        return;
    }
    
    UIImageView *removeImageView = self.images [index];
    
    // scrollView에서 뗀다
    [UIView animateWithDuration:0.2f delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        removeImageView.alpha = 0.0;
        removeImageView.frame = CGRectMake(CGRectGetMinX(removeImageView.frame)
                                           , CGRectGetMinY(removeImageView.frame) + 10.0
                                           , CGRectGetWidth(removeImageView.frame)
                                           , CGRectGetHeight(removeImageView.frame));
        if (self.images.count == 1) {
            _label.alpha = 1;
            _label.transform = CGAffineTransformIdentity;
        }
    } completion:^(BOOL finished) {
        [removeImageView removeFromSuperview];
        [self.images removeObjectAtIndex:index];
        
        UIImageView *lastImageView = [self.images lastObject];
        
        if (CGRectGetMaxX(lastImageView.frame) <= CGRectGetWidth(self.frame) - kMARGIN) {
            self.contentSize = self.bounds.size;
        }
        else {
            self.contentSize = CGSizeMake(CGRectGetMaxX(lastImageView.frame) + kMARGIN, CGRectGetHeight(self.frame));
        }
    }];
}

- (void)singleTapped:(UITapGestureRecognizer *)gesture
{
    CGPoint touchPoint = [gesture locationInView:self];
    for (UIImageView *imageView in self.images) {
        if (CGRectContainsPoint(imageView.frame, touchPoint)) {
            imageView.layer.borderColor = [[UIColor redColor]CGColor];
            imageView.layer.borderWidth = 1.0;
            [self.delegate KKImageScrollView:self selectedImage:imageView.image];
        }
        else {
            imageView.layer.borderColor = [[UIColor redColor]CGColor];
            imageView.layer.borderWidth = 0.0;
        }
    }
    
         
}

@end
