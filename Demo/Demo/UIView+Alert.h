//
//  UIView+Alert.h
//  ddasd
//
//  Created by WeiKunChao on 2019/5/10.
//  Copyright © 2019 SecretLisa. All rights reserved.
//

#import <UIKit/UIKit.h>

// 弹出模式
typedef NS_ENUM(NSInteger, UIViewAlertAnimationType) {
    /** 中心弹出*/
    UIViewAlertAnimationTypeAlert = 0,
    /** 底部弹出*/
    UIViewAlertAnimationTypeBottom,
    /** 顶部弹出*/
    UIViewAlertAnimationTypeTop,
    /** 左侧弹出*/
    UIViewAlertAnimationTypeLeft,
    /** 右侧弹出*/
    UIViewAlertAnimationTypeRight
};

// 模糊类型
typedef NS_ENUM(NSInteger, UIViewAlertBlurType) {
    /** 不要模糊, 此模式下, customBackgroundColor生效*/
    UIViewAlertBlurTypeNone = 0,
    /** 深白*/
    UIViewAlertBlurTypeExtralight,
    /** 浅白*/
    UIViewAlertBlurTypeLight,
    /** 黑色*/
    UIViewAlertBlurTypeDark
};

typedef void(^UIViewAlertCompletionBlock)(void);

@interface UIView (Alert)

// 自定义整体背景色
@property (nonatomic, strong) UIColor * customBackgroundColor;
// 弹出模式
@property (nonatomic, assign) UIViewAlertAnimationType animationType;
// 模糊样式
@property (nonatomic, assign) UIViewAlertBlurType blurType;
// 是否点击关闭
@property (nonatomic, assign) BOOL closeTouchEnable;
// 是否正在展示
@property (nonatomic, assign, readonly) BOOL isAlertShowing;
// 将要弹出
@property (nonatomic, copy) UIViewAlertCompletionBlock willShowBlock;
// 已经弹出
@property (nonatomic, copy) UIViewAlertCompletionBlock didShowBlock;
// 将要弹回
@property (nonatomic, copy) UIViewAlertCompletionBlock willCloseBlock;
// 已经弹回
@property (nonatomic, copy) UIViewAlertCompletionBlock didCloseBlock;

// 弹出
- (void)show;
// 弹回
- (void)close;

@end
