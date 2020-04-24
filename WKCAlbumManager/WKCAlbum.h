//
//  WKCAlbum.h
//  dddd
//
//  Created by wkcloveYang on 2019/7/30.
//  Copyright © 2019 wkcloveYang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WKCAlbumItem.h"

/**
 想要获取的数据类型
 @enum WKCAlbumRequstTypeImageOnly 只有静图
 @enum WKCAlbumRequstTypeImageAndGif 静图和gif
 @enum WKCAlbumRequstTypeImageAndGifAndLivePhoto 静图、Gif、Livephoto
 @enum WKCAlbumRequstTypeVideoOnly Video
 @enum WKCAlbumRequstTypeAudioOnly Audio
 @enum WKCAlbumRequstTypeVideoAndAudio Video和Audio
 @enum WKCAlbumRequstTypeImageAndVideo Video和Image
 @enum WKCAlbumRequstTypeAll 全部内容
 */
typedef NS_ENUM(NSInteger, WKCAlbumRequstType) {
    WKCAlbumRequstTypeImageOnly               = 0,
    WKCAlbumRequstTypeImageAndGif             = 1,
    WKCAlbumRequstTypeLivePhotoOnly           = 2,
    WKCAlbumRequstTypeImageAndGifAndLivePhoto = 3,
    WKCAlbumRequstTypeVideoOnly               = 4,
    WKCAlbumRequstTypeAudioOnly               = 5,
    WKCAlbumRequstTypeVideoAndAudio           = 6,
    WKCAlbumRequstTypeImageAndVideo           = 7,
    WKCAlbumRequstTypeAll                     = 8
};


@interface WKCAlbum : NSObject

/**
  item数组
 */
@property (nonatomic, strong, readonly) NSArray <WKCAlbumItem *>* items;

/**
  缩略图item
 */
@property (nonatomic, strong, readonly) WKCAlbumItem * thumbItem;

/**
 collection
 */
@property (nonatomic, strong, readonly) PHAssetCollection * collection;



/**
  初始化
  @param collection 相册集
  @param type       Requst类型
 */
- (instancetype)initWithCollection:(PHAssetCollection *)collection
                        requstType:(WKCAlbumRequstType)type;

/**
  请求数据
 */
- (void)fetchItems;

@end

