//
//  KKImageUtil.h
//  KKCameraOverlay
//
//  Created by hdk on 2014. 7. 25..
//  Copyright (c) 2014년 Kevin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KKImageUtil : NSObject

// 이미지 리사이즈
+ (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize;

@end
