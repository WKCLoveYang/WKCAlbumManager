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
#import "WKCCacheManager.h"
#import "WKCAlbumParams.h"

/**权限开*/
UIKIT_EXTERN NSString * const WKCAlbumNotificationPremissionYES;
/**权限关*/
UIKIT_EXTERN NSString * const WKCAlbumNotificationPremissionNO;


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
 询问相册权限
 */
+ (void)askAlbumPremission;


/**
 请求相册数据
 @param handle 回调
 */
- (void)requstAlbumDataHandle:(void(^)(NSArray <WKCAlbum *> * albums))handle;



@end
