//
//  WKCPhoto.h
//  dddd
//
//  Created by wkcloveYang on 2019/7/30.
//  Copyright © 2019 wkcloveYang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>

@interface WKCPhoto : NSObject

- (instancetype)initWithAsset:(PHAsset *)asset;

- (void)ftechPhoto:(void(^)(UIImage * photo))handle; // 获取照片

@end
