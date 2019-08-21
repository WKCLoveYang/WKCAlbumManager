//
//  WKCDetailCell.h
//  Demo
//
//  Created by wkcloveYang on 2019/8/19.
//  Copyright © 2019 wkcloveYang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WKCDetailCell : UICollectionViewCell

@property (nonatomic, strong, readonly) UIImageView * iconImageView;
@property (nonatomic, strong, readonly) UIImageView * iCloudImageView;

+ (CGSize)itemSize;

@end

