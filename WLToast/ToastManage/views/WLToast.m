//
//  WLToast.m
//  WLToast
//
//  Created by 张子豪 on 2017/12/14.
//  Copyright © 2017年 张子豪. All rights reserved.
//

#import "WLToast.h"
#import "UIView+GradientBgColor.h"

static WLToast *_toas;

#define TOAST_HEIGHT 40         //高
#define STAY_SECOND  3          //显示时间
#define ANIMATION_SECOND 0.5    //动画时间
#define PADING 40               //文字左边pading
#define TOAST_IMAGE_H 25        //left image高

#define RGB_COLOR(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]

@interface WLToast()

@property (nonatomic,strong)UILabel *titleLbl;
@property (nonatomic,strong)UIImageView *leftImg;

@end

@implementation WLToast

+ (void)showToastWithTitle:(NSString *)title{
    [WLToast checkTitle:title];
    [WLToast setLayerWithColors:nil];
    [WLToast showToast];
    [WLToast addGes];
}

+ (void)showToastWithTitle:(NSString *)title colors:(NSArray *)colors{
    [WLToast checkTitle:title];
    [WLToast setLayerWithColors:colors];
    [WLToast showToast];
    [WLToast addGes];
}

+ (void)showToastWithTitle:(NSString *)title color:(UIColor *)color{
    [WLToast checkTitle:title];
    [WLToast setBackgroundColor:color];
    [WLToast showToast];
    [WLToast addGes];
}


+ (void)setToastImage:(UIImage *)image{
    if(image == nil){return;}
    
    WLToast *toast = [WLToast shareToast];
    [toast addSubview:toast.leftImg];
    toast.leftImg.image = image;
    toast.leftImg.frame = CGRectMake(PADING/2,TOAST_HEIGHT/2 - TOAST_IMAGE_H/2, TOAST_IMAGE_H, TOAST_IMAGE_H);
}

+ (void)setToastTitleColor:(UIColor *)color{
    if(color == nil){return;}
    WLToast *toast = [WLToast shareToast];
    [toast addSubview:toast.leftImg];
    toast.titleLbl.textColor = color;
}

+ (void)setToastDeful{
    WLToast *toast = [WLToast shareToast];
    toast.titleLbl.textColor = RGB_COLOR(254, 238, 181);
    toast.leftImg.frame = CGRectMake(0, 0, 0, 0);
    toast.leftImg = nil;
    [toast.leftImg removeFromSuperview];
}

+ (void)dismiss{
    [WLToast hidnToast];
}


#pragma  mark - private

+ (instancetype)shareToast{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _toas = [[WLToast alloc]init];
    });
    return _toas;
}


- (instancetype)init{
    self = [super init];
    if (self) {
        self.layer.cornerRadius = 20;
        self.layer.masksToBounds = YES;
        [self addSubview:self.titleLbl];
    }
    return self;
}

+ (void)setLayerWithColors:(NSArray *)colors{
    WLToast *toast = [WLToast shareToast];
    NSArray *_colors = colors ? colors :@[RGB_COLOR(242, 140, 94),RGB_COLOR(237, 102, 70)];
    CAGradientLayer *layer = [toast getGradientBgColorWithColors:_colors locations:@[@0.,@1.0] startPoint:CGPointMake(0, 0) endPoint:CGPointMake(1, 0)];
    for (CAGradientLayer *la in toast.layer.sublayers) {
        if ([la isKindOfClass:[CAGradientLayer class]]) {
            [la removeFromSuperlayer];
            break;
        }
    }
    NSLog(@"111");
    [toast.layer insertSublayer:layer atIndex:0];
}

//赋值 计算宽
+ (void)checkTitle:(NSString *)title{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hidnToast) object:@"stopRecord"];
    CGFloat width = [WLToast calWidthWithNSString:title];
    WLToast *toast = [WLToast shareToast];
    toast.titleLbl.text = [NSString stringWithFormat:@"%@",title];
    
    //是否有图片
    if (toast.leftImg.frame.size.width == TOAST_IMAGE_H) {
        toast.titleLbl.frame = CGRectMake(TOAST_IMAGE_H, 0, width+PADING, TOAST_HEIGHT);
        toast.frame = CGRectMake(0, 0, width+PADING+TOAST_IMAGE_H, TOAST_HEIGHT);
    }else{
        toast.titleLbl.frame = CGRectMake(0, 0, width+PADING, TOAST_HEIGHT);
        toast.frame = CGRectMake(0, 0, width+PADING, TOAST_HEIGHT);
    }
    toast.center = CGPointMake([UIScreen mainScreen].bounds.size.width/2, -TOAST_HEIGHT/2);
}

//设置背景色
+ (void)setBackgroundColor:(UIColor *)color{
    WLToast *toast = [WLToast shareToast];
    for (CAGradientLayer *la in toast.layer.sublayers) {
        if ([la isKindOfClass:[CAGradientLayer class]]) {
            [la removeFromSuperlayer];
            break;
        }
    }
    toast.backgroundColor = color;
}

//添加手势
+ (void)addGes{
    WLToast *toast = [WLToast shareToast];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hidnToast)];
    [toast addGestureRecognizer:tap];
}

//显示
+ (void)showToast{
    WLToast *toast = [WLToast shareToast];
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:toast];
    CGFloat topHeight = [UIScreen mainScreen].bounds.size.height>=812 ? 64 : TOAST_HEIGHT;
    [UIView animateWithDuration:ANIMATION_SECOND animations:^{
        toast.frame = CGRectMake(toast.frame.origin.x, topHeight, toast.frame.size.width, TOAST_HEIGHT);
    }completion:^(BOOL finished) {
        [WLToast performSelector:@selector(hidnToast) withObject:@"stopRecord" afterDelay:STAY_SECOND];
    }];
}

//取消
+ (void)hidnToast{
    WLToast *toast = [WLToast shareToast];
    if (toast.frame.origin.y < 0) {return;}
    [UIView animateWithDuration:ANIMATION_SECOND animations:^{
        toast.frame = CGRectMake(toast.frame.origin.x, -TOAST_HEIGHT, toast.frame.size.width, TOAST_HEIGHT);
    }completion:^(BOOL finished) {
        [toast removeFromSuperview];
    }];
}

//计算文本宽
+ (CGFloat)calWidthWithNSString:(NSString *)str{
    CGSize size=[str sizeWithAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:15]}];
    return size.width;
}

- (UILabel *)titleLbl{
    if (!_titleLbl) {
        _titleLbl = [[UILabel alloc]init];
        _titleLbl.textAlignment = 1;
        _titleLbl.textColor = RGB_COLOR(254, 238, 181);
        _titleLbl.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
        _titleLbl.center = self.center;
    }
    return _titleLbl;
}

- (UIImageView *)leftImg{
    if (!_leftImg) {
        _leftImg = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
        _leftImg.contentMode = UIViewContentModeScaleToFill;
    }
    return _leftImg;
}
@end
