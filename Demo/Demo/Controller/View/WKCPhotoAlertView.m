//
//  WKCPhotoAlertView.m
//  Demo
//
//  Created by wkcloveYang on 2019/8/19.
//  Copyright © 2019 wkcloveYang. All rights reserved.
//

#import "WKCPhotoAlertView.h"
#import <Masonry.h>

@interface WKCPhotoAlertView()

@property (nonatomic, strong) YYAnimatedImageView * imageView;

@end

@implementation WKCPhotoAlertView

+ (void)showWithImage:(YYImage *)image
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        WKCPhotoAlertView * alertView = [[WKCPhotoAlertView alloc] init];
        alertView.imageView.image = image;
        [alertView show];
    });
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:CGRectMake(0, 0, UIScreen.mainScreen.bounds.size.width - 15 * 2, UIScreen.mainScreen.bounds.size.height - 200)]) {
        
        self.animationType = UIViewAlertAnimationTypeAlert;
        self.blurType = UIViewAlertBlurTypeDark;
        self.closeTouchEnable = YES;
        
        self.layer.cornerRadius = 8;
        self.layer.masksToBounds = YES;
        
        [self addSubview:self.imageView];
        
        [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
    }
    
    return self;
}

- (YYAnimatedImageView *)imageView
{
    if (!_imageView) {
        _imageView = [[YYAnimatedImageView alloc] init];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    
    return _imageView;
}

@end
