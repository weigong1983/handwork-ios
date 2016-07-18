//
//  GZNavigationController.m
//  EndorsementNetwork
//
//  Created by ios on 15-1-23.
//  Copyright (c) 2015年 周文超. All rights reserved.
//

#import "GZNavigationController.h"
// 判断是否为iOS7
#define iOS7 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)

@interface GZNavigationController ()

@end

@implementation GZNavigationController
+ (void)initialize
{
    
    
    // 1.取出设置主题的对象
    UINavigationBar *navBar = [UINavigationBar appearance];
    
    // 2.设置导航栏的背景图片
    NSString *navBarBg = nil;
    if (iOS7) { // iOS7
        navBarBg = @"top.png";
        navBar.tintColor = [UIColor whiteColor];
    } else { // 非iOS7
        navBarBg = @"top.png";
        //[UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleBlackOpaque;
        
        //[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
        //[[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    }
    
    [navBar setBackgroundImage:[UIImage imageNamed:navBarBg] forBarMetrics:UIBarMetricsDefault];
    //[navBar setBackgroundColor:[UIColor redColor]];
    
    //3.标题
    [[UINavigationBar appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName, nil]];
}
#pragma mark 控制状态栏的样式
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

















@end
