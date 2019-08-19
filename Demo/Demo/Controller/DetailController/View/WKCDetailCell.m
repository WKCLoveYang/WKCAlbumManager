//
//  WKCDetailCell.m
//  Demo
//
//  Created by wkcloveYang on 2019/8/19.
//  Copyright © 2019 wkcloveYang. All rights reserved.
//

#import "WKCDetailCell.h"
#import <Masonry.h>

@interface WKCDetailCell()

@property (nonatomic, strong) UIImageView * iconImageView;

@end

@implementation WKCDetailCell

+ (CGSize)itemSize
{
    CGFloat width = floor((UIScreen.mainScreen.bounds.size.width - 8 * 2 - 2 * 2) / 3.0);
    return CGSizeMake(width, width);
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        [self.contentView addSubview:self.iconImageView];
        [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
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

@end
