//
//  WKCAlbumManager.h
//  dddd
//
//  Created by wkcloveYang on 2019/7/30.
//  Copyright © 2019 wkcloveYang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WKCVideo.h"
#import "WKCAlbum.h"

UIKIT_EXTERN NSString * const WKCAlbumPhotoChangedNotification;
UIKIT_EXTERN NSString * const WKCAlbumVideoChangedNotification;

@interface WKCAlbumManager : NSObject

// images
@property (nonatomic, strong, readonly) NSArray <WKCAlbum *>* albums;
// videos
@property (nonatomic, strong, readonly) NSArray <WKCVideo *> * videos;

+ (WKCAlbumManager *)shared;

- (void)premissionHandle:(void(^)(WKCAlbumManager * manager, BOOL isPremissioned))handle;
- (void)requestPhotoData; //获取静图数据
- (void)requestVideoData; //获取video数据

@end
