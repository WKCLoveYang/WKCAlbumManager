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

@interface WKCCacheManager : NSObject

/**
  单例对象
 */
+ (WKCCacheManager *)shared;

- (void)startCacheAssets:(NSArray <PHAsset *>*)assets
              targetSize:(CGSize)targetSize
                 options:(PHImageRequestOptions *)options;

- (void)stopCacheAssets;

@end

