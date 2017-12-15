//
//  ToastManage.h
//  WLToast
//
//  Created by 张子豪 on 2017/12/14.
//  Copyright © 2017年 张子豪. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ToastManage : NSObject


/**
 默认top 默认背景渐变 默认文字颜色

 @param title 文字内容
 */
+ (void)showTopToastWith:(NSString *)title;


/**
 定制top toast设置左边图形以及字体颜色
 
 @param title 文字内容
 @param img 左边图片
 */
+ (void)showTopToastWith:(NSString *)title leftImg:(UIImage *)img titleColor:(UIColor *)color;

/**
 定制top toast背景渐变色设置

 @param title 文字内容
 @param colors 渐变色数组
 */
+ (void)showTopToastWith:(NSString *)title colors:(NSArray *)colors;


/**
 定制top toast背景色修改
 
 @param title 文字内容
 @param color 背景色
 */
+ (void)showTopToastWith:(NSString *)title color:(UIColor *)color;


/**
 定制top

 @param title  文字内容
 @param colors 渐变色背景
 @param img    左边图
 @param color  文字颜色
 */
+ (void)showTopToastWith:(NSString *)title colors:(NSArray *)colors leftImg:(UIImage *)img titleColor:(UIColor *)color;



/**
 默认center

 @param title 文字内容
 */
+ (void)showCenterToastWith:(NSString *)title;


/**
 定制center toast

 @param title 文字内容
 @param starY 起始坐标Y
 */
+ (void)showCenterToastWith:(NSString *)title starY:(CGFloat)starY;



+ (void)dismiss;


@end
