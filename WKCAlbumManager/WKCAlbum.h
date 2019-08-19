//
//  WKCAlbum.h
//  dddd
//
//  Created by wkcloveYang on 2019/7/30.
//  Copyright © 2019 wkcloveYang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WKCPhoto.h"

@interface WKCAlbum : NSObject

// 图片数组
@property (nonatomic, strong, readonly) NSArray <WKCPhoto *>* photos;
@property (nonatomic, strong, readonly) PHAssetCollection * collection;

- (instancetype)initWithCollection:(PHAssetCollection *)collection;

- (void)fetchPhotos;

@end

