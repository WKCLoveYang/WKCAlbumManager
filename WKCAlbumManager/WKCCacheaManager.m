//
//  WKCCacheaManager.m
//  ABC
//
//  Created by wkcloveYang on 2019/8/19.
//  Copyright © 2019 wkcloveYang. All rights reserved.
//

#import "WKCCacheaManager.h"

@interface WKCCacheaManager()

@property (nonatomic, strong) NSCache * cache;

@end

@implementation WKCCacheaManager

+ (WKCCacheaManager *)shared
{
    static WKCCacheaManager * instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[WKCCacheaManager alloc] init];
    });
    
    return instance;
}

- (NSCache *)cache
{
    if (!_cache) {
        _cache = [[NSCache alloc] init];
        _cache.countLimit = 300;
    }
    
    return _cache;
}

- (void)saveImage:(UIImage *)image atKey:(id)key
{
    if (!image || !key) return;
    [self.cache setObject:image forKey:key];
}

- (UIImage *)readImageAtKey:(id)key
{
    return [self.cache objectForKey:key];
}

@end
