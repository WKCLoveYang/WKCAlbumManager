//
//  WKCAlbumManager.m
//  dddd
//
//  Created by wkcloveYang on 2019/7/30.
//  Copyright © 2019 wkcloveYang. All rights reserved.
//

#import "WKCAlbumManager.h"


NSString * const WKCAlbumNotificationPremissionYES = @"com.premission.yes";
NSString * const WKCAlbumNotificationPremissionNO  = @"com.premission.no";

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

+ (void)askAlbumPremission
{
    NSString * premissionSaveKey = @"album.premission.key";
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (status == PHAuthorizationStatusRestricted || status == PHAuthorizationStatusDenied) {
                [NSNotificationCenter.defaultCenter postNotificationName:WKCAlbumNotificationPremissionNO object:nil];
            } else {
                if (![NSUserDefaults.standardUserDefaults boolForKey:premissionSaveKey]) {
                    [NSUserDefaults.standardUserDefaults setBool:YES forKey:premissionSaveKey];
                    [NSNotificationCenter.defaultCenter postNotificationName:WKCAlbumNotificationPremissionYES object:nil];
                }
            }
        });
    }];
}


- (void)requstAlbumDataHandle:(void(^)(NSArray <WKCAlbum *> * albums))handle
{
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(1);
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        NSArray *albums = [self getAlbums];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.albums = albums;
            dispatch_semaphore_signal(semaphore);
            if (handle) {
                handle(albums);
            }
        });
    });
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

@end
