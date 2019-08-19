//
//  WKCAlbum.m
//  dddd
//
//  Created by wkcloveYang on 2019/7/30.
//  Copyright © 2019 wkcloveYang. All rights reserved.
//

#import "WKCAlbum.h"

@interface WKCAlbum()

@property (nonatomic, strong) NSArray <WKCPhoto *>* photos;
@property (nonatomic, strong) PHAssetCollection * collection;

@end

@implementation WKCAlbum

- (instancetype)initWithCollection:(PHAssetCollection *)collection
{
    if (self = [super init]) {
        _collection = collection;
    }
    
    return self;
}


- (void)fetchPhotos
{
    NSMutableArray * array = [NSMutableArray array];
    
    PHFetchOptions * options = [[PHFetchOptions alloc] init];
    options.sortDescriptors = @[[[NSSortDescriptor alloc] initWithKey:@"creationDate" ascending:NO]];
    
    PHFetchResult<PHAsset *> * itemFetchResult = [PHAsset fetchAssetsInAssetCollection:_collection options:options];
    
    for (PHAsset * obj in itemFetchResult) {
        // 只要静图
        if (obj.mediaType == PHAssetMediaTypeImage) {
            [array addObject:[[WKCPhoto alloc] initWithAsset:obj]];
        }
    }
    
    _photos = array;
}

@end
