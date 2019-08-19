//
//  WKCCacheaManager.h
//  ABC
//
//  Created by wkcloveYang on 2019/8/19.
//  Copyright © 2019 wkcloveYang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface WKCCacheaManager : NSObject

+ (WKCCacheaManager *)shared;

- (void)saveImage:(UIImage *)image atKey:(id)key;
- (UIImage *)readImageAtKey:(id)key;

@end

