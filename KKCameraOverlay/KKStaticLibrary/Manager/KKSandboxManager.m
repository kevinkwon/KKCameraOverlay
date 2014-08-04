//
//  KKSandBoxManager.m
//  KKCameraOverlay
//
//  Created by hdk on 2014. 7. 24..
//  Copyright (c) 2014년 Kevin. All rights reserved.
//

// sandBox 관리자

#import "KKSandboxManager.h"

@implementation KKSandboxManager
static KKSandboxManager *sharedInstance = nil;

+ (KKSandboxManager *)sharedInstance
{
    //  Static local predicate must be initialized to 0
    static dispatch_once_t onceToken = 0;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[KKSandboxManager alloc] init];
        // Do any other initialisation stuff here
    });
    return sharedInstance;
}

+ (void)releaseInstance
{
    sharedInstance = nil;
}

- (NSString *)directoryForType:(KKSandboxType)type
{
    // return TempDirectory
    if  (type == KKSandBoxTypeTmp) {
        return NSTemporaryDirectory();
    }
    
    NSArray *paths = nil;
    NSString *directory = nil;
    NSSearchPathDirectory searchPathDirectory = 0;
    
    switch (type) {
        case KKSandBoxTypeDocuments:
            searchPathDirectory = NSDocumentDirectory;
            break;
        case KKSandBoxTypeLibrary:
            searchPathDirectory = NSLibraryDirectory;
            break;
        case KKSandBoxTypeLibraryCacheItemImagesForPost:
        case KKSandBoxTypeLibraryCache:
            searchPathDirectory = NSCachesDirectory;
            break;
        default:
            break;
    }
    
    if (searchPathDirectory == 0) {
        return nil;
    }
    paths = NSSearchPathForDirectoriesInDomains(searchPathDirectory, NSUserDomainMask, YES);
    directory = paths[0];
    
    if (type == KKSandBoxTypeLibraryCacheItemImagesForPost) {
        directory = [directory stringByAppendingPathComponent:@"itemImagesForPost"];
        
        NSFileManager *manager = [NSFileManager defaultManager];
        if (![manager fileExistsAtPath:directory]) {
            [manager createDirectoryAtPath:directory withIntermediateDirectories:YES attributes:nil error:NULL];
        }
    }
    
    return directory;
}

- (BOOL)writeData:(NSData *)data fileName:(NSString *)fileName directoryType:(KKSandboxType)sandBoxType
{
    NSString *targetDirectory = [self directoryForType:sandBoxType];
    NSString *targetFilePath = [targetDirectory stringByAppendingPathComponent:fileName];
    NSLog(@"데이터 쓰기 : %@" , targetFilePath);
    return [data writeToFile:targetFilePath atomically:NO];
}

- (NSData *)readData:(NSString *)fileName directoryType:(KKSandboxType)sandBoxType
{
    NSString *targetDirectory = [self directoryForType:sandBoxType];
    NSString *targetFilePath = [targetDirectory stringByAppendingPathComponent:fileName];
    return [NSData dataWithContentsOfFile:targetFilePath];
}

- (NSData *)dataFromImage:(UIImage *)image compressionQuality:(CGFloat)quality extention:(NSString *)extension
{
    if ([extension isEqualToString:@"png"]) {
        return UIImagePNGRepresentation(image);
    }
    else if ([extension isEqualToString:@"jpg"]) {
        return UIImageJPEGRepresentation(image, quality);
    }
    return nil;
}

- (BOOL)removeDirectory:(KKSandboxType)sandboxType
{
    NSFileManager *manager = [NSFileManager defaultManager];
    NSString *directory = [self directoryForType:sandboxType];
	// NSArray *files = [manager contentsOfDirectoryAtPath:directory error:NULL];
    
    return [manager removeItemAtPath:directory error:NULL];
}

- (BOOL)removeFileName:(NSString *)fileName directoryType:(KKSandboxType)sandBoxType
{
	NSFileManager *manager = [NSFileManager defaultManager];
    NSString *targetDirectory = [self directoryForType:sandBoxType];
    NSString *targetFilePath = [targetDirectory stringByAppendingPathComponent:fileName];
    return [manager removeItemAtPath:targetFilePath error:NULL];
}


@end
