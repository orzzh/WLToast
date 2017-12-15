//
//  ViewController.m
//  WLToast
//
//  Created by 张子豪 on 2017/12/14.
//  Copyright © 2017年 张子豪. All rights reserved.
//

#import "ViewController.h"
#import "ToastManage.h"
#import "UIView+GradientBgColor.h"

#define RGB_COLOR(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]

@interface ViewController ()
{
    CGFloat orginY;
}
@property (weak, nonatomic) IBOutlet UILabel *valuelbl;
@property (weak, nonatomic) IBOutlet UIButton *colorView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self.colorView setGradientBgColorWithColors:@[RGB_COLOR(245, 41, 125),RGB_COLOR(237, 202, 70)] locations:@[@0.,@1.0] startPoint:CGPointMake(0, 0) endPoint:CGPointMake(1, 0)];
    orginY =0;
}

#pragma mark - 默认
- (IBAction)topAct:(id)sender {
    [ToastManage showTopToastWith:@"请检查网络"];
}

#pragma mark - 有图
- (IBAction)topActTwo:(id)sender {
//    [ToastManage showTopToastWith:@"请检查网络" color:[UIColor blackColor]];
    [ToastManage showTopToastWith:@"请检查网络" leftImg:[UIImage imageNamed:@"11111"] titleColor:[UIColor whiteColor]];
}

#pragma mark - 改变渐变背景
- (IBAction)chanageTop:(id)sender {
    [ToastManage showTopToastWith:@"请检查网络" colors:@[RGB_COLOR(245, 41, 125),RGB_COLOR(237, 202, 70)] leftImg:[UIImage imageNamed:@"11111"]  titleColor:[UIColor whiteColor]];
}

#pragma mark - 提示
- (IBAction)tipAct:(id)sender {
    
    if (orginY == 0) {
        [ToastManage showCenterToastWith:@"请输入账号密码"];
        return;
    }
    [ToastManage showCenterToastWith:@"发布失败，请检查网络" starY:orginY];
}


- (IBAction)valueChanage:(id)sender {
    UISlider *slider = (UISlider *)sender;
   orginY = slider.value * 500;
    self.valuelbl.text = [NSString stringWithFormat:@"%.f",orginY];
}



- (void)viewWillDisappear:(BOOL)animated{
//    [ToastManage dismiss];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
