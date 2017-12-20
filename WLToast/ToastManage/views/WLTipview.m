//
//  WLTipview.m
//  WLToast
//
//  Created by 张子豪 on 2017/12/14.
//  Copyright © 2017年 张子豪. All rights reserved.
//

#import "WLTipview.h"
#import "UIView+GradientBgColor.h"

static WLTipview *_tipview;

#define TOAST_HEIGHT     50         //高
#define STAY_SECOND      3          //显示时间
#define ANIMATION_SECOND 0.2        //动画时间
#define PADING           32         //文字左边pading
#define MAX_WIDTH        [UIScreen mainScreen].bounds.size.width-50        //最大宽度
#define RGB_COLOR(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]

@interface WLTipview()

@property (nonatomic,assign)BOOL haveBorder;
@property (nonatomic,assign)BOOL isShow;

@property (nonatomic,assign)CGPoint centerTemp;
@property (nonatomic,assign)int borderHeight;
@property (nonatomic,assign)int topMargin;

@property (nonatomic,strong)UILabel *titleLbl;

@end
@implementation WLTipview

+ (void)showTipWithTitle:(NSString *)title{
    [WLTipview checkTip:title];
    [WLTipview showTip];
    [WLTipview addGes];
}

+ (void)showTipWithTitle:(NSString *)title starY:(CGFloat)starY{
    [WLTipview checkTip:title];
    [WLTipview fixOrginY:starY];
    [WLTipview showTip];
    [WLTipview addGes];
}

+ (void)dismiss{
    [WLTipview hidnTip];
}


#pragma  mark - private

+ (instancetype)shareTipview{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _tipview = [[WLTipview alloc]init];
    });
    return _tipview;
}


- (instancetype)init{
    self = [super init];
    if (self) {
        _isShow = NO;
        _haveBorder = NO;
        _borderHeight = 0;
        _topMargin = [UIScreen mainScreen].bounds.size.height>=812 ? 88:64;
        self.layer.cornerRadius = 5;
        self.layer.masksToBounds = YES;
        self.backgroundColor = RGB_COLOR(41,41,41);
        [self addSubview:self.titleLbl];
        [self addObserver];
    }
    return self;
}


//当键盘出现
- (void)keyboardWillShow:(NSNotification *)notification
{
    _haveBorder = YES;
    //获取键盘的高度
    NSDictionary *userInfo = [notification userInfo];
    NSValue *value = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [value CGRectValue];
    int height = keyboardRect.size.height;
    WLTipview *tip = [WLTipview shareTipview];
    tip.borderHeight = height;
    if (_isShow) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:0.3 animations:^{
                tip.center = CGPointMake( [UIScreen mainScreen].bounds.size.width/2,  [UIScreen mainScreen].bounds.size.height/2-height/2+tip.topMargin);
            }];
        });
    }
}

//当键退出
- (void)keyboardWillHide:(NSNotification *)notification
{
    _haveBorder = NO;
    //获取键盘的高度
    NSDictionary *userInfo = [notification userInfo];
    NSValue *value = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [value CGRectValue];
    int height = keyboardRect.size.height;
    WLTipview *tip = [WLTipview shareTipview];
    tip.borderHeight = height;
    if (_isShow) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:0.3 animations:^{
                tip.center = tip.centerTemp;
            }];
        });
    }
}

- (void)addObserver{
    //监听当键盘将要出现时
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    //监听当键将要退出时
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];

}

+ (void)checkTip:(NSString *)title{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hidnTip) object:@"hidnTip"];
    CGSize size = [WLTipview calWidthWithNSString:title];
    CGFloat width = size.width >= MAX_WIDTH ? MAX_WIDTH :size.width;
    WLTipview *tip = [WLTipview shareTipview];
    tip.layer.transform = CATransform3DMakeScale(1, 1, 1);
    tip.titleLbl.text = [NSString stringWithFormat:@"%@",title];
    tip.titleLbl.frame = CGRectMake(PADING/2,14, width, size.height);
    tip.frame = CGRectMake(0, 0, width+PADING, size.height+28);
    tip.center = CGPointMake([UIScreen mainScreen].bounds.size.width/2, [UIScreen mainScreen].bounds.size.height/2);
}

+ (void)fixOrginY:(CGFloat)starY{
    WLTipview *tip = [WLTipview shareTipview];
    tip.frame = CGRectMake([UIScreen mainScreen].bounds.size.width/2-tip.frame.size.width/2, starY, tip.frame.size.width, tip.frame.size.height);
}

+ (void)showTip{
    WLTipview *tip = [WLTipview shareTipview];
    tip.layer.transform = CATransform3DScale(tip.layer.transform, 0, 0, 0);
    tip.alpha = 0;
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:tip];
    [UIView animateWithDuration:ANIMATION_SECOND animations:^{
        tip.layer.transform = CATransform3DIdentity;
        tip.alpha = 1;
    }completion:^(BOOL finished) {
        [WLTipview performSelector:@selector(hidnTip) withObject:@"hidnTip" afterDelay:STAY_SECOND];
    }];
    
    tip.centerTemp =  tip.center;
    if (tip.haveBorder) {
        tip.center = CGPointMake( [UIScreen mainScreen].bounds.size.width/2,  [UIScreen mainScreen].bounds.size.height/2-tip.borderHeight/2+tip.topMargin);
    }
    tip.isShow = YES;
}

//添加手势
+ (void)addGes{
    WLTipview *tip = [WLTipview shareTipview];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hidnTip)];
    [tip addGestureRecognizer:tap];
}

//取消
+ (void)hidnTip{
    WLTipview *tip = [WLTipview shareTipview];
    if (tip.alpha != 1) {return;}
    [UIView animateWithDuration:ANIMATION_SECOND animations:^{
        tip.layer.transform = CATransform3DScale(tip.layer.transform, 0, 0, 0);
        tip.alpha = 0;
    }completion:^(BOOL finished) {
        [tip removeFromSuperview];
    }];
    tip.isShow = NO;
}

//计算文本宽
+ (CGSize)calWidthWithNSString:(NSString *)str{
    CGSize infoSize = CGSizeMake(MAX_WIDTH, 1000);
    NSDictionary *dic = @{NSFontAttributeName:[UIFont fontWithName:@"PingFangSC-Regular" size:16]};
    CGRect rect =   [str boundingRectWithSize:infoSize options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:dic context:nil];
    return rect.size;
}

- (UILabel *)titleLbl{
    if (!_titleLbl) {
        _titleLbl = [[UILabel alloc]init];
        _titleLbl.textColor = [UIColor whiteColor];
        _titleLbl.font = [UIFont fontWithName:@"PingFangSC-Regular" size:16];
        _titleLbl.center = self.center;
        _titleLbl.numberOfLines = 0;
    }
    return _titleLbl;
}

@end
