//
//  UIView+Alert.m
//  ddasd
//
//  Created by WeiKunChao on 2019/5/10.
//  Copyright © 2019 SecretLisa. All rights reserved.
//

#import "UIView+Alert.h"
#import <objc/runtime.h>


static NSString * const UIViewAlertCustomBackgroundColorKey = @"wkc.custom.backgroundColor";
static NSString * const UIViewAlertAnimationTypeKey = @"wkc.animation.type";
static NSString * const UIViewAlertBlurTypeKey = @"wkc.blur";
static NSString * const UIViewAlertCloseTouchKey = @"wkc.close.touch";
static NSString * const UIViewAlertWillShowBlock = @"wkc.alert.will.show";
static NSString * const UIViewAlertDidShowBlock = @"wkc.alert.did.show";
static NSString * const UIViewAlertWillCloseBlock = @"wkc.alert.will.close";
static NSString * const UIViewAlertDidCloseBlock = @"wkc.alert.did.close";

UIView * _contentView;
UIView * _customBackgroundView;
UIVisualEffectView * _blurView;
BOOL _isAlertShowing;

@implementation UIView (Alert)

- (void)setCustomBackgroundColor:(UIColor *)customBackgroundColor
{
    objc_setAssociatedObject(self, &UIViewAlertCustomBackgroundColorKey, customBackgroundColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIColor *)customBackgroundColor
{
    return objc_getAssociatedObject(self, &UIViewAlertCustomBackgroundColorKey);
}

- (void)setAnimationType:(UIViewAlertAnimationType)animationType
{
    objc_setAssociatedObject(self, &UIViewAlertAnimationTypeKey, @(animationType), OBJC_ASSOCIATION_ASSIGN);
}

- (UIViewAlertAnimationType)animationType
{
    return [objc_getAssociatedObject(self, &UIViewAlertAnimationTypeKey) integerValue];
}

- (void)setBlurType:(UIViewAlertBlurType)blurType
{
    objc_setAssociatedObject(self, &UIViewAlertBlurTypeKey, @(blurType), OBJC_ASSOCIATION_ASSIGN);
}

- (UIViewAlertBlurType)blurType
{
    return [objc_getAssociatedObject(self, &UIViewAlertBlurTypeKey) integerValue];
}

- (void)setCloseTouchEnable:(BOOL)closeTouchEnable
{
    objc_setAssociatedObject(self, &UIViewAlertCloseTouchKey, @(closeTouchEnable), OBJC_ASSOCIATION_ASSIGN);
}

- (BOOL)closeTouchEnable
{
    return [objc_getAssociatedObject(self, &UIViewAlertCloseTouchKey) boolValue];
}

- (BOOL)isAlertShowing
{
    return _isAlertShowing;
}

- (void)setWillShowBlock:(UIViewAlertCompletionBlock)willShowBlock
{
    objc_setAssociatedObject(self, &UIViewAlertWillShowBlock, willShowBlock, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIViewAlertCompletionBlock)willShowBlock
{
    return objc_getAssociatedObject(self, &UIViewAlertWillShowBlock);
}

- (void)setDidShowBlock:(UIViewAlertCompletionBlock)didShowBlock
{
    objc_setAssociatedObject(self, &UIViewAlertDidShowBlock, didShowBlock, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIViewAlertCompletionBlock)didShowBlock
{
   return objc_getAssociatedObject(self, &UIViewAlertDidShowBlock);
}

- (void)setWillCloseBlock:(UIViewAlertCompletionBlock)willCloseBlock
{
   objc_setAssociatedObject(self, &UIViewAlertWillCloseBlock, willCloseBlock, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIViewAlertCompletionBlock)willCloseBlock
{
    return objc_getAssociatedObject(self, &UIViewAlertWillCloseBlock);
}

- (void)setDidCloseBlock:(UIViewAlertCompletionBlock)didCloseBlock
{
    objc_setAssociatedObject(self, &UIViewAlertDidCloseBlock, didCloseBlock, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIViewAlertCompletionBlock)didCloseBlock
{
    return objc_getAssociatedObject(self, &UIViewAlertDidCloseBlock);
}


#pragma mark -弹出、弹回
- (void)show
{
    if (self.willShowBlock) {
        self.willShowBlock();
    }
    _isAlertShowing = YES;
    
    UIWindow * window = UIApplication.sharedApplication.windows.firstObject;
    
    // 剔除已显示的
    for (UIView * sub in window.subviews) {
        if ([sub isKindOfClass:self.class]) {
            [sub removeFromSuperview];
        }
    }
    
    _contentView = [[UIView alloc] initWithFrame:UIScreen.mainScreen.bounds];
    [window addSubview:_contentView];
    
    // blur类型为none,设置主体背景色
    if (self.blurType == UIViewAlertBlurTypeNone)
    {
        _customBackgroundView = [[UIView alloc] initWithFrame:_contentView.bounds];
        _customBackgroundView.backgroundColor = self.customBackgroundColor;
        [_contentView addSubview:_customBackgroundView];
    }
    else
    {
        // 模糊视图
        _blurView = [[UIVisualEffectView alloc] initWithFrame:_contentView.bounds];
        UIBlurEffect * effet = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        
        if (self.blurType == UIViewAlertBlurTypeLight)
        {
            effet = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        }
        else if (self.blurType == UIViewAlertBlurTypeExtralight)
        {
            effet = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
        }
        else if (self.blurType == UIViewAlertBlurTypeDark)
        {
            effet = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
        }
        
        // 设置模糊, 添加到主体视图
        _blurView.effect = effet;
        [_contentView addSubview:_blurView];
    }
    
    // 主视图添加self
    [_contentView addSubview:self];
    
    _blurView.layer.opacity = 0.0;
    _customBackgroundView.layer.opacity = 0.0;
    self.layer.opacity = 0.0;
    
    switch (self.animationType)
    {
        case UIViewAlertAnimationTypeAlert:
        {
            // 移到中心
            self.center = _contentView.center;
            
            self.transform = CGAffineTransformMakeScale(1.1, 1.1);

            [UIView animateWithDuration:0.3
                             animations:^{
                                 _blurView.layer.opacity = 1.0;
                                 _customBackgroundView.layer.opacity = 1.0;
                                 self.layer.opacity = 1.0;
                                 self.transform = CGAffineTransformIdentity;
                             }
                             completion:^(BOOL finished) {
                                 if (self.didShowBlock) {
                                     self.didShowBlock();
                                 }
                             }];
        }
            break;
            
        case UIViewAlertAnimationTypeBottom:
        {
            // 重置坐标
            self.frame = CGRectMake(self.frame.origin.x,
                                    CGRectGetMaxY(_contentView.frame),
                                    self.frame.size.width,
                                    self.frame.size.height);
            [UIView animateWithDuration:0.3
                             animations:^{
                                 _blurView.layer.opacity = 1.0;
                                 _customBackgroundView.layer.opacity = 1.0;
                                 self.layer.opacity = 1.0;
                                 self.transform = CGAffineTransformMakeTranslation(0, -self.frame.size.height);
                             }
                             completion:^(BOOL finished) {
                                 if (self.didShowBlock) {
                                     self.didShowBlock();
                                 }
                             }];
        }
            break;
            
        case UIViewAlertAnimationTypeTop:
        {
            // 重置坐标
            self.frame = CGRectMake(self.frame.origin.x,
                                    -self.frame.size.height,
                                    self.frame.size.width,
                                    self.frame.size.height);
            [UIView animateWithDuration:0.3
                             animations:^{
                                 _blurView.layer.opacity = 1.0;
                                 _customBackgroundView.layer.opacity = 1.0;
                                 self.layer.opacity = 1.0;
                                 self.transform = CGAffineTransformMakeTranslation(0, self.frame.size.height);
                             }
                             completion:^(BOOL finished) {
                                 if (self.didShowBlock) {
                                     self.didShowBlock();
                                 }
                             }];
        }
            break;
            
        case UIViewAlertAnimationTypeLeft:
        {
            // 重置坐标
            self.frame = CGRectMake(-self.frame.size.width,
                                    self.frame.origin.y,
                                    self.frame.size.width,
                                    self.frame.size.height);
            [UIView animateWithDuration:0.3
                             animations:^{
                                 _blurView.layer.opacity = 1.0;
                                 _customBackgroundView.layer.opacity = 1.0;
                                 self.layer.opacity = 1.0;
                                 self.transform = CGAffineTransformMakeTranslation(self.frame.size.width, 0);
                             }
                             completion:^(BOOL finished) {
                                 if (self.didShowBlock) {
                                     self.didShowBlock();
                                 }
                             }];
        }
            break;
            
        case UIViewAlertAnimationTypeRight:
        {
            // 重置坐标
            self.frame = CGRectMake(CGRectGetMaxX(_contentView.frame),
                                    self.frame.origin.y,
                                    self.frame.size.width,
                                    self.frame.size.height);
            [UIView animateWithDuration:0.3
                             animations:^{
                                 _blurView.layer.opacity = 1.0;
                                 _customBackgroundView.layer.opacity = 1.0;
                                 self.layer.opacity = 1.0;
                                 self.transform = CGAffineTransformMakeTranslation(-self.frame.size.width, 0);
                             }
                             completion:^(BOOL finished) {
                                 if (self.didShowBlock) {
                                     self.didShowBlock();
                                 }
                             }];
        }
            break;
            
        default:
            break;
    }
    
    // 边界点击弹回
    if (self.closeTouchEnable)
    {
        UIButton * touchButton = [[UIButton alloc] initWithFrame:_contentView.bounds];
        [touchButton addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchUpInside];
        [_contentView insertSubview:touchButton belowSubview:self];
    }
}

- (void)close
{
    if (self.willCloseBlock) {
        self.willCloseBlock();
    }
    
    switch (self.animationType)
    {
        case UIViewAlertAnimationTypeAlert:
        {
            [UIView animateWithDuration:0.3
                             animations:^{
                                 _blurView.layer.opacity = 0.0;
                                 _customBackgroundView.layer.opacity = 0.0;
                                 self.layer.opacity = 0.0;
                                 self.transform = CGAffineTransformMakeScale(0.95, 0.95);
                             }
                             completion:^(BOOL finished) {
                                 [_contentView removeFromSuperview];
                                 _blurView = nil;
                                 _customBackgroundView = nil;
                                 _contentView = nil;
            
                                 if (self.didCloseBlock) {
                                     self.didCloseBlock();
                                 }
                                 _isAlertShowing = NO;
                             }];
        }
            break;

        default:
        {
            [UIView animateWithDuration:0.3
                             animations:^{
                                 _blurView.layer.opacity = 0.0;
                                 _customBackgroundView.layer.opacity = 0.0;
                                 self.layer.opacity = 0.0;
                                 self.transform = CGAffineTransformIdentity;
                             }
                             completion:^(BOOL finished) {
                                 [_contentView removeFromSuperview];
                                 _blurView = nil;
                                 _customBackgroundView = nil;
                                 _contentView = nil;
                                 
                                 if (self.didCloseBlock) {
                                     self.didCloseBlock();
                                 }
                                 _isAlertShowing = NO;
                             }];
        }
            break;
    }
}

@end
