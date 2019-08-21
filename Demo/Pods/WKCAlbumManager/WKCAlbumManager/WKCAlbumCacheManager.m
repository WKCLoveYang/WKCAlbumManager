//
//  WKCCacheaManager.m
//  ABC
//
//  Created by wkcloveYang on 2019/8/19.
//  Copyright © 2019 wkcloveYang. All rights reserved.
//

#import "WKCAlbumCacheManager.h"
#import "WKCAlbumParams.h"

@implementation WKCAlbumCacheManager

+ (WKCAlbumCacheManager *)shared
{
    static WKCAlbumCacheManager * instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[WKCAlbumCacheManager alloc] init];
    });
    
    return instance;
}

- (void)startCacheAssets:(NSArray <PHAsset *>*)assets
              targetSize:(CGSize)targetSize
{
    [self startCacheAssets:assets
                targetSize:targetSize
                   options:WKCAlbumParams.shared.imageOptions];
}

- (void)startCacheAssets:(NSArray <PHAsset *>*)assets
              targetSize:(CGSize)targetSize
                 options:(PHImageRequestOptions *)options
{
    [WKCAlbumParams.shared.imageManager startCachingImagesForAssets:assets targetSize:targetSize contentMode:PHImageContentModeDefault options:options];
}

- (void)stopCacheAssets
{
    [WKCAlbumParams.shared.imageManager stopCachingImagesForAllAssets];
}

@end
