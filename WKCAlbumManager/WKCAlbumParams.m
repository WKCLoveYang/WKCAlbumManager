//
//  WKCAlbumParams.m
//  ABC
//
//  Created by wkcloveYang on 2019/8/21.
//  Copyright © 2019 wkcloveYang. All rights reserved.
//

#import "WKCAlbumParams.h"

@interface WKCAlbumParams()

@property (nonatomic, strong) PHImageRequestOptions * imageOptions;
@property (nonatomic, strong) PHImageRequestOptions * iCloudOptions;
@property (nonatomic, strong) PHVideoRequestOptions * videoPtions;
@property (nonatomic, strong) PHLivePhotoRequestOptions * livePhotoOptions;

@property (nonatomic, strong) PHCachingImageManager * imageManager;

@end

@implementation WKCAlbumParams

+ (WKCAlbumParams *)shared
{
    static WKCAlbumParams * instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[WKCAlbumParams alloc] init];
    });
    
    return instance;
}

- (PHImageRequestOptions *)imageOptions
{
    if (!_imageOptions) {
        _imageOptions = [[PHImageRequestOptions alloc] init];
        _imageOptions.networkAccessAllowed = YES;
        _imageOptions.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
    }
    
    return _imageOptions;
}

- (PHImageRequestOptions *)iCloudOptions
{
    if (!_iCloudOptions) {
        _iCloudOptions = [[PHImageRequestOptions alloc] init];
        _iCloudOptions.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
        _iCloudOptions.resizeMode = PHImageRequestOptionsResizeModeFast;
    }
    
    return _iCloudOptions;
}

- (PHVideoRequestOptions *)videoPtions
{
    if (!_videoPtions) {
        _videoPtions = PHVideoRequestOptions.new;
        _videoPtions.networkAccessAllowed = YES;
    }
    return _videoPtions;
}

- (PHLivePhotoRequestOptions *)livePhotoOptions
{
    if (!_livePhotoOptions) {
        _livePhotoOptions = [[PHLivePhotoRequestOptions alloc] init];
        _livePhotoOptions.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
        _livePhotoOptions.networkAccessAllowed = YES;
    }
    
    return _livePhotoOptions;
}

- (PHCachingImageManager *)imageManager
{
    if (!_imageManager) {
        _imageManager = [[PHCachingImageManager alloc] init];
    }
    
    return _imageManager;
}

@end
