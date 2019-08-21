//
//  WKCAlbumItem.m
//  ABC
//
//  Created by wkcloveYang on 2019/8/19.
//  Copyright © 2019 wkcloveYang. All rights reserved.
//

#import "WKCAlbumItem.h"
#import "WKCAlbumParams.h"

@interface WKCAlbumItem()

@property (nonatomic, strong) PHAsset * asset;
@property (nonatomic, assign) PHImageRequestID requestId;

@end

@implementation WKCAlbumItem

- (instancetype)initWithAsset:(PHAsset *)asset
{
    if (self = [super init]) {
        _asset = asset;
    }
    
    return self;
}


- (WKCAlbumItemType)type
{
    if (_asset.mediaType == PHAssetMediaTypeImage) {
        if (@available(iOS 11.0, *)) {
            return _asset.playbackStyle == PHAssetPlaybackStyleImage ? WKCAlbumItemTypeImage : WKCAlbumItemTypeGif;
        } else {
            return WKCAlbumItemTypeImage;
        }
    } else if (_asset.mediaType == PHAssetMediaTypeVideo) {
        return WKCAlbumItemTypeVideo;
    } else if (_asset.mediaType == PHAssetMediaTypeAudio) {
        return WKCAlbumItemTypeAudio;
    } else {
        return WKCAlbumItemTypeLivePhoto;
    }
}


- (void)fetchImageThumbAtSize:(CGSize )size
                       handle:(WKCAlbumImageHandle)handle
{
    [self fetchImageAtSize:CGSizeMake(size.width * UIScreen.mainScreen.scale, size.height * UIScreen.mainScreen.scale) option:WKCAlbumParams.shared.imageOptions handle:^(UIImage *image, NSDictionary *info) {
        if (handle) {
            handle(image, info);
        }
    }];
}

- (void)fetchImageHandle:(WKCAlbumImageHandle)handle
{
    [self fetchImageAtSize:PHImageManagerMaximumSize
                    option:WKCAlbumParams.shared.imageOptions
                    handle:handle];
}

- (void)fetchImageWithiCloudAnalyseHandle:(WKCAlbumiCloudHandle)handle
{
    [self fetchImageAtSize:PHImageManagerMaximumSize
                    option:WKCAlbumParams.shared.iCloudOptions
                    handle:^(UIImage *image, NSDictionary *info) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            if (handle) {
                                handle([info[PHImageResultIsInCloudKey] boolValue]);
                            }
                        });
                    }];
}

- (void)fetchImageOption:(PHImageRequestOptions *)option
                  handle:(WKCAlbumImageHandle)handle
{
    [self fetchImageAtSize:PHImageManagerMaximumSize
                    option:option
                    handle:handle];
}

- (void)fetchImageAtSize:(CGSize)size
                  option:(PHImageRequestOptions *)option
                  handle:(WKCAlbumImageHandle)handle
{
    self.requestId = [WKCAlbumParams.shared.imageManager requestImageForAsset:_asset targetSize:size contentMode:PHImageContentModeDefault options:option resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (handle) {
                handle(result, info);
            }
        });
    }];
}

- (void)fetchImageOrGifDataHandle:(WKCAlbumImageDataHandle)handle
{
    self.requestId = [WKCAlbumParams.shared.imageManager requestImageDataForAsset:_asset options:WKCAlbumParams.shared.imageOptions resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (handle) {
                handle(imageData, info);
            }
        });
    }];
}




- (void)fetchVideoThumbnailAtSize:(CGSize)size
                           handle:(WKCAlbumImageHandle)handle
{
    [self fetchImageThumbAtSize:size
                         handle:handle];
}

- (void)fetchVideoAVAsset:(WKCAlbumVideoAssetHandle)handle
{
    self.requestId = [WKCAlbumParams.shared.imageManager requestAVAssetForVideo:_asset options:WKCAlbumParams.shared.videoPtions resultHandler:^(AVAsset * _Nullable asset, AVAudioMix * _Nullable audioMix, NSDictionary * _Nullable info) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (handle) {
                handle(asset, audioMix, info);
            }
        });
    }];
}

- (void)fetchVideoPlayerItem:(WKCAlbumVideoAVItemHandle)handle
{
    self.requestId = [WKCAlbumParams.shared.imageManager requestPlayerItemForVideo:_asset options:WKCAlbumParams.shared.videoPtions resultHandler:^(AVPlayerItem * _Nullable playerItem, NSDictionary * _Nullable info) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (handle) {
                handle(playerItem, info);
            }
        });
    }];
}




- (void)fetchLivePhoto:(WKCAlbumLivePhotoHandle)handle
{
    self.requestId = [WKCAlbumParams.shared.imageManager requestLivePhotoForAsset:_asset targetSize:CGSizeMake(_asset.pixelWidth, _asset.pixelHeight) contentMode:PHImageContentModeDefault options:WKCAlbumParams.shared.livePhotoOptions resultHandler:^(PHLivePhoto * _Nullable livePhoto, NSDictionary * _Nullable info) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (handle) {
                handle(livePhoto, info);
            }
        });
    }];
}

@end
