//
//  WKCPhoto.m
//  dddd
//
//  Created by wkcloveYang on 2019/7/30.
//  Copyright © 2019 wkcloveYang. All rights reserved.
//

#import "WKCPhoto.h"
#import "WKCCacheaManager.h"

@interface WKCPhoto()

@property (nonatomic, strong) PHAsset * asset;
@property (nonatomic, strong) PHImageRequestOptions * options;

@end

@implementation WKCPhoto

- (instancetype)initWithAsset:(PHAsset *)asset
{
    if (self = [super init]) {
        _asset = asset;
    }
    
    return self;
}

- (PHImageRequestOptions *)options
{
    if (!_options) {
        _options = [[PHImageRequestOptions alloc] init];
        _options.networkAccessAllowed = YES;
        _options.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
    }
    
    return _options;
}

- (void)fetchThumbAtSize:(CGSize )size handle:(void(^)(UIImage * photo))handle
{
    UIImage * cacheImage = [WKCCacheaManager.shared readImageAtKey:_asset];
    if (cacheImage) {
        if (handle) {
            handle(cacheImage);
        }
    } else {
        __weak typeof(self)weakSelf = self;
        [PHImageManager.defaultManager requestImageForAsset:_asset targetSize:CGSizeMake(size.width * UIScreen.mainScreen.scale, size.height * UIScreen.mainScreen.scale) contentMode:PHImageContentModeDefault options:self.options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [WKCCacheaManager.shared saveImage:result
                                             atKey:weakSelf.asset];
                if (handle) {
                    handle(result);
                }
            });
        }];
    }
    
}

- (void)fetchPhoto:(void(^)(UIImage * photo))handle
{
    [PHImageManager.defaultManager requestImageForAsset:_asset targetSize:CGSizeMake(_asset.pixelWidth, _asset.pixelHeight) contentMode:PHImageContentModeDefault options:self.options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (handle) {
                handle(result);
            }
        });
    }];
}

@end
