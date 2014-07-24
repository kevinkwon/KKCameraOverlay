//
//  KKSandBoxManager.h
//  KKCameraOverlay
//
//  Created by hdk on 2014. 7. 24..
//  Copyright (c) 2014년 Kevin. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, KKSandboxType) {
    KKSandBoxTypeDocuments = 1,
    KKSandBoxTypeLibrary,
    KKSandBoxTypeLibraryCache,
    KKSandBoxTypeLibraryCacheItemImagesForPost,
    KKSandBoxTypeTmp,
};

@interface KKSandboxManager : NSObject

+ (KKSandboxManager *)sharedInstance;

+ (void)releaseInstance;

- (NSString *)directoryForType:(KKSandboxType)type;

- (BOOL)writeData:(NSData *)data fileName:(NSString *)fileName directoryType:(KKSandboxType)sandBoxType;

- (NSData *)readData:(NSString *)fileName directoryType:(KKSandboxType)sandBoxType;

- (NSData *)dataFromImage:(UIImage *)image compressionQuality:(CGFloat)quality extention:(NSString *)extension;

- (BOOL)removeDirectory:(KKSandboxType)sandboxType;

@end
