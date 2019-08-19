//
//  UIImageView+CommonAlphaLoad.m
//  Demo
//
//  Created by wkcloveYang on 2019/8/19.
//  Copyright © 2019 wkcloveYang. All rights reserved.
//

#import "UIImageView+CommonAlphaLoad.h"

@implementation UIImageView (CommonAlphaLoad)

- (void)alphaLoadImage:(UIImage *)image
{
    if (self.image) {
        self.image = image;
        return;
    }
    
    self.layer.opacity = 0.0;
    self.image = image;
    __weak typeof(self)weakSelf = self;
    [UIView transitionWithView:self duration:1 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
        weakSelf.layer.opacity = 1.0;
    }completion:nil];
}

@end
