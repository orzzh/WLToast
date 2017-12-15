//
//  WLTipview.h
//  WLToast
//
//  Created by 张子豪 on 2017/12/14.
//  Copyright © 2017年 张子豪. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WLTipview : UIView

/**
 @param title 文字内容
 */
+ (void)showTipWithTitle:(NSString *)title;


/**
 @param title 文字内容
 @param starY 起始位置
 */
+ (void)showTipWithTitle:(NSString *)title starY:(CGFloat)starY;

+ (void)dismiss;


@end
