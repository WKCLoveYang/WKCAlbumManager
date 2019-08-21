//
//  WKCAlbum.m
//  dddd
//
//  Created by wkcloveYang on 2019/7/30.
//  Copyright © 2019 wkcloveYang. All rights reserved.
//

#import "WKCAlbum.h"
#import "WKCAlbumParams.h"

@interface WKCAlbum()

@property (nonatomic, strong) NSArray <WKCAlbumItem *>* items;
@property (nonatomic, strong) PHAssetCollection * collection;
@property (nonatomic, assign) WKCAlbumRequstType type;

@end

@implementation WKCAlbum

- (instancetype)initWithCollection:(PHAssetCollection *)collection
                        requstType:(WKCAlbumRequstType)type
{
    if (self = [super init]) {
        _collection = collection;
        _type = type;
    }
    
    return self;
}


- (void)fetchItems
{
    NSMutableArray <WKCAlbumItem *>* array = [NSMutableArray array];
    
    // options nil 默认是按日期递增(同系统一样)
    PHFetchResult<PHAsset *> * itemFetchResult = [PHAsset fetchAssetsInAssetCollection:_collection options:nil];
    
    if (!itemFetchResult.count) return;
    
    for (PHAsset * obj in itemFetchResult) {
        
        switch (_type) {
            case WKCAlbumRequstTypeImageOnly:
            {
                // 只要静图
                if (@available(iOS 11.0, *)) {
                    if (obj.mediaType == PHAssetMediaTypeImage && obj.playbackStyle == PHAssetPlaybackStyleImage) {
                        [array addObject:[[WKCAlbumItem alloc] initWithAsset:obj]];
                    }
                } else {
                    if (obj.mediaType == PHAssetMediaTypeImage) {
                        [array addObject:[[WKCAlbumItem alloc] initWithAsset:obj]];
                    }
                }
            }
                break;
                
            case WKCAlbumRequstTypeImageAndGif:
            {
                if (obj.mediaType == PHAssetMediaTypeImage) {
                    [array addObject:[[WKCAlbumItem alloc] initWithAsset:obj]];
                }
            }
                break;
                
            case WKCAlbumRequstTypeLivePhotoOnly:
            {
                if (@available(iOS 11.0, *)) {
                    if (obj.playbackStyle == PHAssetPlaybackStyleLivePhoto) {
                        [array addObject:[[WKCAlbumItem alloc] initWithAsset:obj]];
                    }
                } else {
                    if (obj.mediaSubtypes == PHAssetMediaSubtypePhotoLive) {
                        [array addObject:[[WKCAlbumItem alloc] initWithAsset:obj]];
                    }
                }
            }
                break;
                
            case WKCAlbumRequstTypeImageAndGifAndLivePhoto:
            {
                if (@available(iOS 11.0, *)) {
                    if (obj.mediaType == PHAssetMediaTypeImage || obj.playbackStyle == PHAssetPlaybackStyleLivePhoto) {
                        [array addObject:[[WKCAlbumItem alloc] initWithAsset:obj]];
                    }
                } else {
                    if (obj.mediaType == PHAssetMediaTypeImage || obj.mediaSubtypes == PHAssetMediaSubtypePhotoLive) {
                        [array addObject:[[WKCAlbumItem alloc] initWithAsset:obj]];
                    }
                }
            }
                break;
                
           case WKCAlbumRequstTypeVideoOnly:
            {
                if (obj.mediaType == PHAssetMediaTypeVideo) {
                    [array addObject:[[WKCAlbumItem alloc] initWithAsset:obj]];
                }
            }
                break;
                
            case WKCAlbumRequstTypeAudioOnly:
            {
                if (obj.mediaType == PHAssetMediaTypeAudio) {
                    [array addObject:[[WKCAlbumItem alloc] initWithAsset:obj]];
                }
            }
                break;
                
            case WKCAlbumRequstTypeVideoAndAudio:
            {
                if (obj.mediaType == PHAssetMediaTypeVideo || obj.mediaType == PHAssetMediaTypeAudio) {
                    [array addObject:[[WKCAlbumItem alloc] initWithAsset:obj]];
                }
            }
                break;
                
            case WKCAlbumRequstTypeAll:
            {
                [array addObject:[[WKCAlbumItem alloc] initWithAsset:obj]];
            }
                break;
                
            default:
                break;
        }
        
    }
    
    // 按日期递减
    _items = [[array reverseObjectEnumerator] allObjects];
}

- (WKCAlbumItem *)thumbItem
{
    return self.items.firstObject;
}

@end
