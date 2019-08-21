//
//  WKCAlbumManager.h
//  dddd
//
//  Created by wkcloveYang on 2019/7/30.
//  Copyright © 2019 wkcloveYang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>
#import "WKCAlbum.h"
#import "WKCAlbumCacheManager.h"
#import "WKCAlbumParams.h"

/**
  相册权限
  @enum WKCAlbumPremissionStatusAuthorized 没权限
  @enum WKCAlbumPremissionStatusAuthorized   有权限
 */
typedef NS_ENUM(NSInteger, WKCAlbumPremissionStatus) {
    WKCAlbumPremissionStatusUnAuthorized = 0,
    WKCAlbumPremissionStatusAuthorized   = 1
};

typedef void(^WKCAlbumPremissionHandle)(WKCAlbumPremissionStatus status);
typedef void(^WKCAlbumRequestHandle)(NSArray <WKCAlbum *> * albums, WKCAlbumPremissionStatus status);
typedef void(^WKCAlbumSaveHandle)(BOOL isSuccess, WKCAlbumPremissionStatus status);

@interface WKCAlbumManager : NSObject

/**
  相册集合
 */
@property (nonatomic, strong, readonly) NSArray <WKCAlbum *> * albums;

/**
  请求的数据类型
 */
@property (nonatomic, assign) WKCAlbumRequstType requstType;

/**
 单例对象
 */
+ (WKCAlbumManager *)shared;

/**
 询问相册读取权限(不用单独调用,requst时自动调用)
 @param handle 回调
 */
+ (void)askAlbumPremissionHandle:(WKCAlbumPremissionHandle)handle;


/**
 请求相册数据
 @param handle 回调
 */
- (void)requstAlbumDataHandle:(WKCAlbumRequestHandle)handle;


/**
  保存照片(UIImage)到自定义相册薄
  @param image  照片
  @param title  自定义相册薄名
  @param handle 回调
 */
- (void)saveToAlbumWithImage:(UIImage *)image
             collectionTitle:(NSString *)title
                      handle:(WKCAlbumSaveHandle)handle;

/**
 保存照片(UIImage)到系统
 @param image  照片
 @param handle 回调
 */
- (void)saveToSystemAlbumWithImage:(UIImage *)image
                            handle:(WKCAlbumSaveHandle)handle;

/**
 保存照片(NSURL)到自定义相册薄
 @param url    照片地址
 @param title  自定义相册薄名
 @param handle 回调
 */
- (void)saveToAlbumWithImageUrl:(NSURL *)url
                collectionTitle:(NSString *)title
                         handle:(WKCAlbumSaveHandle)handle;

/**
 保存照片(NSURL)到系统
 @param url    照片地址
 @param handle 回调
 */
- (void)saveToSystemAlbumWithImageUrl:(NSURL *)url
                               handle:(WKCAlbumSaveHandle)handle;

/**
 保存视频(NSURL)到自定义相册薄
 @param url    照片地址
 @param title  自定义相册薄名
 @param handle 回调
 */
- (void)saveToAlbumWithVideoUrl:(NSURL *)url
                collectionTitle:(NSString *)title
                         handle:(WKCAlbumSaveHandle)handle;

/**
 保存视频(NSURL)到系统
 @param url    照片地址
 @param handle 回调
 */
- (void)saveToSystemAlbumWithVideoUrl:(NSURL *)url
                               handle:(WKCAlbumSaveHandle)handle;

@end
