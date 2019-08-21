//
//  WKCAlbumItem.h
//  ABC
//
//  Created by wkcloveYang on 2019/8/19.
//  Copyright © 2019 wkcloveYang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>

typedef void(^WKCAlbumImageHandle)(UIImage * image, NSDictionary * info);
typedef void(^WKCAlbumImageDataHandle)(NSData * data, NSDictionary * info);
typedef void(^WKCAlbumVideoAssetHandle)(AVAsset * asset, AVAudioMix * audioMix, NSDictionary * info);
typedef void(^WKCAlbumVideoAVItemHandle)(AVPlayerItem * playerItem, NSDictionary * info);
typedef void(^WKCAlbumLivePhotoHandle)(PHLivePhoto * livePhoto, NSDictionary * info);
typedef void(^WKCAlbumiCloudHandle)(BOOL isIniCloud);

/**
  asset类型
  @enum WKCAlbumItemTypeImage     静图
  @enum WKCAlbumItemTypeGif       gif
  @enum WKCAlbumItemTypeVideo     视频
  @enum WKCAlbumItemTypeAudio     音频
  @enum WKCAlbumItemTypeLivePhoto livePhoto
 */
typedef NS_ENUM(NSInteger, WKCAlbumItemType) {
    WKCAlbumItemTypeImage     = 0,
    WKCAlbumItemTypeGif       = 1,
    WKCAlbumItemTypeVideo     = 2,
    WKCAlbumItemTypeAudio     = 3,
    WKCAlbumItemTypeLivePhoto = 4
};

@interface WKCAlbumItem : NSObject

/**
  请求ID
 */
@property (nonatomic, assign, readonly) PHImageRequestID requestId;

/**
  Asset
 */
@property (nonatomic, strong, readonly) PHAsset * asset;

/**
  Asset类型
 */
@property (nonatomic, assign, readonly) WKCAlbumItemType type;




/**
  初始化
  @param asset  信息
 */
- (instancetype)initWithAsset:(PHAsset *)asset;


/**
  请求Image缩略图 (请求缩略图时, 不能判断是都在iCloud)
  @param size 大小
  @param handle 回调
 */
- (void)fetchImageThumbAtSize:(CGSize )size
                       handle:(WKCAlbumImageHandle)handle;

/**
  请求是否在iCloud
  @param handle 回调
 */
- (void)fetchImageWithiCloudAnalyseHandle:(WKCAlbumiCloudHandle)handle;

/**
  请求Image原图 (通用Option)
  @param handle 回调
 */
- (void)fetchImageHandle:(WKCAlbumImageHandle)handle;

/**
 请求Image原图 (自定义Option)
 @param option 配置参数
 @param handle 回调
 */
- (void)fetchImageOption:(PHImageRequestOptions *)option
                  handle:(WKCAlbumImageHandle)handle;

/**
 请求Image
 @param size 大小
 @param option 配置参数
 @param handle 回调
 */
- (void)fetchImageAtSize:(CGSize)size
                  option:(PHImageRequestOptions *)option
                  handle:(WKCAlbumImageHandle)handle;

/**
  请求Image原图或者Gif(以NSData)回调
  @param handle 回调
 */
- (void)fetchImageOrGifDataHandle:(WKCAlbumImageDataHandle)handle;


/**
  请求Video缩略图
  @param size 大小
  @param handle 回调
 */
- (void)fetchVideoThumbnailAtSize:(CGSize)size
                           handle:(WKCAlbumImageHandle)handle;

/**
  请求VideoAsset
  @param handle 回调
 */
- (void)fetchVideoAVAsset:(WKCAlbumVideoAssetHandle)handle;

/**
  请求VideoItem
  @param handle 回调
 */
- (void)fetchVideoPlayerItem:(WKCAlbumVideoAVItemHandle)handle;




/**
  请求LivePhoto
  @param handle 回调
 */
- (void)fetchLivePhoto:(WKCAlbumLivePhotoHandle)handle;


@end

