//
//  WKCCacheaManager.h
//  ABC
//
//  Created by wkcloveYang on 2019/8/19.
//  Copyright © 2019 wkcloveYang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <Photos/Photos.h>

@interface WKCAlbumCacheManager : NSObject

/**
  单例对象
 */
+ (WKCAlbumCacheManager *)shared;

/**
  缓存照片 (使用通用options)
  @param assets     集合
  @param targetSize 缩略图大小
 */
- (void)startCacheAssets:(NSArray <PHAsset *>*)assets
              targetSize:(CGSize)targetSize;

/**
 缓存照片
 @param assets     集合
 @param targetSize 缩略图大小
 @param options    参数
 */
- (void)startCacheAssets:(NSArray <PHAsset *>*)assets
              targetSize:(CGSize)targetSize
                 options:(PHImageRequestOptions *)options;

/**
 停止缓存
 */
- (void)stopCacheAssets;

@end

