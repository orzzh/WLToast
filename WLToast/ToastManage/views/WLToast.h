//
//  WLToast.h
//  WLToast
//
//  Created by 张子豪 on 2017/12/14.
//  Copyright © 2017年 张子豪. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WLToast : UIView

/**
 @param title 内容
 */
+ (void)showToastWithTitle:(NSString *)title;

/**
 @param title 文字内容
 @param colors 背景渐变  颜色1向颜色2渐变
 */
+ (void)showToastWithTitle:(NSString *)title colors:(NSArray *)colors;

/**
 @param title 文字内容
 @param color 背景纯色
 */
+ (void)showToastWithTitle:(NSString *)title color:(UIColor *)color;

+ (void)setToastImage:(UIImage *)image;

+ (void)setToastTitleColor:(UIColor *)color;

+ (void)setToastDeful;

+ (void)dismiss;


@end
