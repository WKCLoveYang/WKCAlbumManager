//
//  WKCMainListCell.h
//  Demo
//
//  Created by wkcloveYang on 2019/8/19.
//  Copyright © 2019 wkcloveYang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WKCMainListCell : UICollectionViewCell

@property (nonatomic, strong, readonly) UIImageView * iconImageView;
@property (nonatomic, strong, readonly) UILabel * titleLabel;
@property (nonatomic, strong, readonly) UILabel * countLabel;

+ (CGSize)itemSize;

@end

