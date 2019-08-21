//
//  WKCDetailCell.m
//  Demo
//
//  Created by wkcloveYang on 2019/8/19.
//  Copyright © 2019 wkcloveYang. All rights reserved.
//

#import "WKCDetailCell.h"
#import <Masonry.h>
#import "WKCCircleProgressView.h"

@interface WKCDetailCell()

@property (nonatomic, strong) UIImageView * iconImageView;
@property (nonatomic, strong) UIImageView * iCloudImageView;
@property (nonatomic, strong) WKCCircleProgressView * progressView;

@end

@implementation WKCDetailCell

+ (CGSize)itemSize
{
    CGFloat width = floor((UIScreen.mainScreen.bounds.size.width - 2 * 2) / 3.0);
    return CGSizeMake(width, width);
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        [self.contentView addSubview:self.iconImageView];
        [self.contentView addSubview:self.iCloudImageView];
        [self.contentView addSubview:self.progressView];
        
        [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView);
        }];
        [self.iCloudImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.bottom.equalTo(self.contentView).offset(-5);
        }];
        [self.progressView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView);
        }];
    }
    
    return self;
}

- (UIImageView *)iconImageView
{
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] init];
        _iconImageView.contentMode = UIViewContentModeScaleAspectFill;
        _iconImageView.layer.masksToBounds = YES;
    }
    
    return _iconImageView;
}

- (UIImageView *)iCloudImageView
{
    if (!_iCloudImageView) {
        _iCloudImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_iCloud"]];
        _iCloudImageView.hidden = YES;
    }
    
    return _iCloudImageView;
}

- (WKCCircleProgressView *)progressView
{
    if (!_progressView) {
        _progressView = [[WKCCircleProgressView alloc] init];
        _progressView.backgroundColor = [UIColor.blackColor colorWithAlphaComponent:0.7];
        _progressView.strokeWidth = 6;
        _progressView.startColor = UIColor.whiteColor;
        _progressView.endColor = UIColor.whiteColor;
        _progressView.radius = WKCDetailCell.itemSize.width / 4.0;
        _progressView.startAngle = -90;
        _progressView.reduceAngle = 0;
        _progressView.roundStyle = YES;
        _progressView.colorGradient = NO;
        _progressView.showProgressText = NO;
        _progressView.increaseFromLast = YES;
        _progressView.hidden = YES;
    }
    
    return _progressView;
}

- (void)setICloudProgress:(CGFloat)iCloudProgress
{
    _iCloudProgress = iCloudProgress;
    self.progressView.hidden = NO;
    self.progressView.progress = iCloudProgress;
    if (iCloudProgress >= 1.0) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self endProgress];
        });
    }
}

- (void)endProgress
{
    self.progressView.progress = 0.0;
    self.progressView.hidden = YES;
}

@end
