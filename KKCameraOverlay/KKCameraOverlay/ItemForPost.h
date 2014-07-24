//
//  ItemForPost.h
//  KKCameraOverlay
//
//  Created by hdk on 2014. 7. 24..
//  Copyright (c) 2014년 Kevin. All rights reserved.
//

// 아이템 등록용 클래스

#import <Foundation/Foundation.h>

@interface ItemForPost : NSObject

@property (nonatomic, strong) NSMutableArray *images; // 단말기 사진 파일 경로
@property (nonatomic, copy) NSString *title; // 제목
@property (nonatomic, copy) NSString *description; // 상세설명
@property (nonatomic, copy) NSString *category; // 카테고리
@property (nonatomic, copy) NSString *itemState; // 아이템상태
@property (nonatomic, copy) NSString *sellMethod; // 판매방법
@property (nonatomic, assign, getter = isIncludeDeliveryFee) BOOL includeDeliveryFee; // 택배비포함
@property (nonatomic, assign, getter = isAcceptExchange) BOOL acceptExchange; // 교신받습니다.

@end
