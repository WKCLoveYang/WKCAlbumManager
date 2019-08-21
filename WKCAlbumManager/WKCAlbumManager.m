//
//  WKCAlbumManager.m
//  dddd
//
//  Created by wkcloveYang on 2019/7/30.
//  Copyright © 2019 wkcloveYang. All rights reserved.
//

#import "WKCAlbumManager.h"

/**
  保存类型
  @enum WKCAlbumSaveTypeImage    图片
  @enum WKCAlbumSaveTypeImageUrl 图片地址
  @enum WKCAlbumSaveTypeVideoUrl 视频地址
 */
typedef NS_ENUM(NSInteger, WKCAlbumSaveType) {
    WKCAlbumSaveTypeImage    = 0,
    WKCAlbumSaveTypeImageUrl = 1,
    WKCAlbumSaveTypeVideoUrl = 2
};

@interface WKCAlbumManager()

@property (nonatomic, strong) NSArray <WKCAlbum *> * albums;

@end

@implementation WKCAlbumManager

+ (WKCAlbumManager *)shared
{
    static WKCAlbumManager * instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[WKCAlbumManager alloc] init];
    });
    
    return instance;
}

+ (void)askAlbumPremissionHandle:(WKCAlbumPremissionHandle)handle
{
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (status == PHAuthorizationStatusRestricted || status == PHAuthorizationStatusDenied) {
                if (handle) {
                    handle(WKCAlbumPremissionStatusUnAuthorized);
                }
            } else {
                if (handle) {
                    handle(WKCAlbumPremissionStatusAuthorized);
                }
            }
        });
    }];
}




- (void)requstAlbumDataHandle:(WKCAlbumRequestHandle)handle
{
    [WKCAlbumManager askAlbumPremissionHandle:^(WKCAlbumPremissionStatus status) {
        if (status == WKCAlbumPremissionStatusAuthorized) {
            dispatch_semaphore_t semaphore = dispatch_semaphore_create(1);
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
                NSArray *albums = [self getAlbums];
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.albums = albums;
                    dispatch_semaphore_signal(semaphore);
                    if (handle) {
                        handle(albums, WKCAlbumPremissionStatusAuthorized);
                    }
                });
            });
        } else {
            if (handle) {
                handle(nil, WKCAlbumPremissionStatusUnAuthorized);
            }
        }
    }];
}


- (NSArray <WKCAlbum *>*)getAlbums
{
    PHFetchResult<PHAssetCollection *> * collections = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum
                                                                                                subtype:PHAssetCollectionSubtypeAlbumRegular
                                                                                                options:nil];
    
    NSMutableArray <WKCAlbum *>* albums = [NSMutableArray array];
    
    for (PHAssetCollection * collection in collections) {
        WKCAlbum * album = [[WKCAlbum alloc] initWithCollection:collection requstType:self.requstType];
        [album fetchItems];
        if (album.items && album.items.count != 0) {
            [albums addObject:album];
        }
    }
    
    return [albums sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        WKCAlbum * album1 = (WKCAlbum *)obj1;
        WKCAlbum * album2 = (WKCAlbum *)obj2;
        return album1.items.count < album2.items.count;
    }];
}




- (void)saveToSystemAlbumWithVideoUrl:(NSURL *)url
                               handle:(WKCAlbumSaveHandle)handle
{
    [self saveToAlbumWithVideoUrl:url
                  collectionTitle:nil
                           handle:handle];
}

- (void)saveToAlbumWithVideoUrl:(NSURL *)url
                collectionTitle:(NSString *)title
                         handle:(WKCAlbumSaveHandle)handle
{
    [self saveToAlbumWithType:WKCAlbumSaveTypeVideoUrl
                       params:url
              collectionTitle:title
                       handle:handle];
}

- (void)saveToSystemAlbumWithImageUrl:(NSURL *)url
                               handle:(WKCAlbumSaveHandle)handle
{
    [self saveToAlbumWithImageUrl:url
                  collectionTitle:nil
                           handle:handle];
}

- (void)saveToAlbumWithImageUrl:(NSURL *)url
                collectionTitle:(NSString *)title
                         handle:(WKCAlbumSaveHandle)handle
{
    [self saveToAlbumWithType:WKCAlbumSaveTypeImageUrl
                       params:url
              collectionTitle:title
                       handle:handle];
}

- (void)saveToSystemAlbumWithImage:(UIImage *)image
                            handle:(WKCAlbumSaveHandle)handle
{
    [self saveToAlbumWithImage:image
               collectionTitle:nil
                        handle:handle];
}

- (void)saveToAlbumWithImage:(UIImage *)image
             collectionTitle:(NSString *)title
                      handle:(WKCAlbumSaveHandle)handle
{
    [self saveToAlbumWithType:WKCAlbumSaveTypeImage
                       params:image
              collectionTitle:title
                       handle:handle];
}

- (void)saveToAlbumWithType:(WKCAlbumSaveType)type
                     params:(id)params
            collectionTitle:(NSString *)title
                     handle:(WKCAlbumSaveHandle)handle
{
    [WKCAlbumManager askAlbumPremissionHandle:^(WKCAlbumPremissionStatus status) {
        if (status == WKCAlbumPremissionStatusAuthorized) {
            __block NSString * assetId = nil;
            [PHPhotoLibrary.sharedPhotoLibrary performChanges:^{
                switch (type) {
                    case WKCAlbumSaveTypeImage:
                    {
                        assetId = [PHAssetCreationRequest creationRequestForAssetFromImage:params].placeholderForCreatedAsset.localIdentifier;
                    }
                        break;
                    
                    case WKCAlbumSaveTypeImageUrl:
                    {
                        assetId = [PHAssetCreationRequest creationRequestForAssetFromImageAtFileURL:params].placeholderForCreatedAsset.localIdentifier;
                    }
                        break;
                        
                    case WKCAlbumSaveTypeVideoUrl:
                    {
                        assetId = [PHAssetCreationRequest creationRequestForAssetFromVideoAtFileURL:params].placeholderForCreatedAsset.localIdentifier;
                    }
                        break;
                        
                    default:
                        break;
                }
                
            } completionHandler:^(BOOL success, NSError * _Nullable error) {
                
                if (error) {
                    if (handle) {
                        handle(NO, WKCAlbumPremissionStatusAuthorized);
                    }
                    
                    return;
                }
                
                // 没有title,则创建在系统
                if (!title || title.length == 0) {
                    if (handle) {
                        handle(success, WKCAlbumPremissionStatusAuthorized);
                    }
                } else {
                    // 读取或创建相册
                    PHAssetCollection * collection = [self  createCollectionWithTitle:title];
                    
                    [PHPhotoLibrary.sharedPhotoLibrary performChanges:^{
                        PHAssetCollectionChangeRequest * request = [PHAssetCollectionChangeRequest changeRequestForAssetCollection:collection];
                        PHAsset * asset = [PHAsset fetchAssetsWithLocalIdentifiers:@[assetId] options:nil].firstObject;
                        [request addAssets:@[asset]];
                    } completionHandler:^(BOOL success, NSError * _Nullable error) {
                        if (handle) {
                            handle(success, WKCAlbumPremissionStatusAuthorized);
                        }
                    }];
                }
            }];
        } else {
            if (handle) {
                handle(NO, WKCAlbumPremissionStatusUnAuthorized);
            }
        }
    }];
}


- (PHAssetCollection *)createCollectionWithTitle:(NSString *)title
{
    // 查询是否已经创建过
    PHFetchResult <PHAssetCollection *> *collectionResult = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    for (PHAssetCollection * collection in collectionResult) {
        if ([collection.localizedTitle isEqualToString:title]) {
            return collection;
        }
    }
    
    __block NSString *collectionId = nil;
    [PHPhotoLibrary.sharedPhotoLibrary performChangesAndWait:^{
        collectionId = [PHAssetCollectionChangeRequest creationRequestForAssetCollectionWithTitle:title].placeholderForCreatedAssetCollection.localIdentifier;
    } error:nil];
    
    return [PHAssetCollection fetchAssetCollectionsWithLocalIdentifiers:@[collectionId] options:nil].firstObject;
}

@end
