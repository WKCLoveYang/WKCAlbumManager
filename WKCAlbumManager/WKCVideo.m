//
//  WKCVideo.m
//  dddd
//
//  Created by wkcloveYang on 2019/7/30.
//  Copyright © 2019 wkcloveYang. All rights reserved.
//

#import "WKCVideo.h"

@interface WKCVideo()

@property (nonatomic, strong) PHAsset * asset;
@property (nonatomic, assign) PHImageRequestID durationRequestID;
@property (nonatomic, assign) double duration;
@property (nonatomic, strong) PHVideoRequestOptions * videoPtions;
@property (nonatomic, strong) PHImageRequestOptions * imageOptions;

@end

@implementation WKCVideo

- (instancetype)initWithAsset:(PHAsset *)asset
{
    if (self = [super init]) {
        _asset = asset;
    }
    
    return self;
}

- (PHVideoRequestOptions *)videoPtions
{
    if (!_videoPtions) {
        _videoPtions = PHVideoRequestOptions.new;
        _videoPtions.networkAccessAllowed = YES;
    }
    return _videoPtions;
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

- (void)fetchThumbnailHandle:(void(^)(UIImage * image))handle
{
    CGSize targetSize = CGSizeMake(_asset.pixelWidth, _asset.pixelHeight);
    
    [PHImageManager.defaultManager requestImageForAsset:_asset targetSize:targetSize contentMode:PHImageContentModeAspectFill options:self.imageOptions resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (handle) {
                handle(result);
            }
        });
    }];
}

- (void)fetchAVAsset:(void(^)(AVAsset * asset))handle
{
    [PHImageManager.defaultManager requestAVAssetForVideo:_asset options:self.videoPtions resultHandler:^(AVAsset * _Nullable asset, AVAudioMix * _Nullable audioMix, NSDictionary * _Nullable info) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (handle) {
                handle(asset);
            }
        });
    }];
}

- (void)fetchPlayerItem:(void(^)(AVPlayerItem * item))handle
{
    [PHImageManager.defaultManager requestPlayerItemForVideo:_asset options:self.videoPtions resultHandler:^(AVPlayerItem * _Nullable playerItem, NSDictionary * _Nullable info) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (handle) {
                handle(playerItem);
            }
        });
    }];
}

@end
