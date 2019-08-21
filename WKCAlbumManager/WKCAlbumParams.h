//
//  WKCAlbumParams.h
//  ABC
//
//  Created by wkcloveYang on 2019/8/21.
//  Copyright © 2019 wkcloveYang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>

@interface WKCAlbumParams : NSObject


/**
 通用Option参数
 */
@property (nonatomic, strong, readonly) PHImageRequestOptions * imageOptions;

/**
 iCloud用Option参数
 */
@property (nonatomic, strong, readonly) PHImageRequestOptions * iCloudOptions;

/**
 Video用Option参数
 */
@property (nonatomic, strong, readonly) PHVideoRequestOptions * videoPtions;

/**
 LivePhoto用Option参数
 */
@property (nonatomic, strong, readonly) PHLivePhotoRequestOptions * livePhotoOptions;

/**
 通用imageManager
 */
@property (nonatomic, strong, readonly) PHCachingImageManager * imageManager;

/**
  单例对象
 */
+ (WKCAlbumParams *)shared;

@end

