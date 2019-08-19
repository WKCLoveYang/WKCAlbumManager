//
//  WKCVideo.h
//  dddd
//
//  Created by wkcloveYang on 2019/7/30.
//  Copyright © 2019 wkcloveYang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <Photos/Photos.h>

@interface WKCVideo : NSObject

- (instancetype)initWithAsset:(PHAsset *)asset;


- (void)fetchThumbnailHandle:(void(^)(UIImage * image))handle; // 获取缩略图
- (void)fetchAVAsset:(void(^)(AVAsset * asset))handle; //获取AVAsset
- (void)fetchPlayerItem:(void(^)(AVPlayerItem * item))handle; //获取AVPlayerItem



@end

