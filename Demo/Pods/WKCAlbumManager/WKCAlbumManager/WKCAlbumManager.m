//
//  WKCAlbumManager.m
//  dddd
//
//  Created by wkcloveYang on 2019/7/30.
//  Copyright © 2019 wkcloveYang. All rights reserved.
//

#import "WKCAlbumManager.h"

NSString * const WKCAlbumPhotoChangedNotification = @"album.photo.notification";
NSString * const WKCAlbumVideoChangedNotification = @"album.video.notification";

@interface WKCAlbumManager()

@property (nonatomic, strong) NSArray <WKCAlbum *>* albums;
@property (nonatomic, strong) NSArray <WKCVideo *> * videos;

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

- (void)premissionHandle:(void (^)(WKCAlbumManager * manager, BOOL isPremissioned))handle
{
    NSString * premissionSaveKey = @"album.premission.key";
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (handle) {
                if (status == PHAuthorizationStatusRestricted || status == PHAuthorizationStatusDenied) {
                    handle(self, NO);
                } else {
                    if (![NSUserDefaults.standardUserDefaults boolForKey:premissionSaveKey]) {
                        handle(self, YES);
                        [NSUserDefaults.standardUserDefaults setBool:YES forKey:premissionSaveKey];
                    }
                }
            }
        });
    }];
}


- (void)requestPhotoData
{
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(1);
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        NSArray *albums = [self getAlbums];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.albums = albums;
            [NSNotificationCenter.defaultCenter postNotificationName:WKCAlbumPhotoChangedNotification object:nil];
            dispatch_semaphore_signal(semaphore);
        });
    });
}


- (NSArray <WKCAlbum *>*)getAlbums
{
    PHFetchResult<PHAssetCollection *> * collections = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum
                                                                                                subtype:PHAssetCollectionSubtypeAny
                                                                                                options:nil];
    
    NSMutableArray <WKCAlbum *>* albums = [NSMutableArray array];
    
    for (PHAssetCollection * collection in collections) {
        WKCAlbum * album = [[WKCAlbum alloc] initWithCollection:collection];
        [album fetchPhotos];
        if (album.photos.count != 0) {
            [albums addObject:album];
        }
    }
    
    return [albums sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        WKCAlbum * album1 = (WKCAlbum *)obj1;
        WKCAlbum * album2 = (WKCAlbum *)obj2;
        return album1.photos.count < album2.photos.count;
    }];
}



- (void)requestVideoData
{
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(1);
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        NSArray *videos = [self getVideos];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.videos = videos;
            [NSNotificationCenter.defaultCenter postNotificationName:WKCAlbumVideoChangedNotification object:nil];
            dispatch_semaphore_signal(semaphore);
        });
    });
}

- (NSArray <WKCVideo *>*)getVideos
{
    PHFetchOptions * options = [[PHFetchOptions alloc] init];
    options.sortDescriptors = @[[[NSSortDescriptor alloc] initWithKey:@"creationDate" ascending:NO]];
    
    PHFetchResult <PHAsset *>* fetchResults = [PHAsset fetchAssetsWithMediaType:PHAssetMediaTypeVideo options:options];
    
    NSMutableArray <WKCVideo *>* array = [NSMutableArray array];
    
    for (PHAsset * asset in fetchResults) {
        [array addObject:[[WKCVideo alloc] initWithAsset:asset]];
    }
    
    return array;
}

@end
