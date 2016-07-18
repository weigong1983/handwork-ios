//
//  TabBarController.m
//  Handwork
//
//  Created by ios on 15-4-29.
//  Copyright (c) 2015年 周文超. All rights reserved.
//

#import "TabBarController.h"

#import "MyViewController.h"
#import "FoundViewController.h"
#import "HomePageViewController.h"
#import "GZNavigationController.h"

#define BLUE_GREEN_COLOR @"#00C8D3"

@interface TabBarController ()

@end

@implementation TabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    HomePageViewController* vc = [[HomePageViewController alloc]init];
    GZNavigationController* nav = [[GZNavigationController alloc]initWithRootViewController:vc];
    [nav setNavigationBarHidden:NO];
    //vc.tabBarItem.imageInsets = UIEdgeInsetsMake(0, -10, -6, -10);
    vc.tabBarItem= [[UITabBarItem alloc]init];
    UIImage* vcImage = [UIImage imageNamed:@"首页-未点击"];
    UIImage* vcImage1 = [UIImage imageNamed:@"首页"];
    vc.tabBarItem.image = [vcImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    vc.tabBarItem.selectedImage = [vcImage1 imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    vc.title=@"首页";
    
    FoundViewController* vc1 = [[FoundViewController alloc]init];
    GZNavigationController* nav1 = [[GZNavigationController alloc]initWithRootViewController:vc1];
    [nav1 setNavigationBarHidden:NO];
    vc1.tabBarItem = [[UITabBarItem alloc]init];
    UIImage* vc1Image = [UIImage imageNamed:@"发现-未点击"];
    UIImage* vc1Image1 = [UIImage imageNamed:@"发现"];
    vc1.tabBarItem.image = [vc1Image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    vc1.tabBarItem.selectedImage = [vc1Image1 imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    vc1.title = @"发现";
    
    
    MyViewController* vc2 = [[MyViewController alloc]init];
    GZNavigationController* nav2 = [[GZNavigationController alloc]initWithRootViewController:vc2];
    [nav2 setNavigationBarHidden:NO];
    vc2.tabBarItem = [[UITabBarItem alloc]init];
    vc2.title = @"我的";
    UIImage* vc4Image = [UIImage imageNamed:@"我的-未点击"];
    UIImage* vc4Image1 = [UIImage imageNamed:@"我的"];
    vc2.tabBarItem.image = [vc4Image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    vc2.tabBarItem.selectedImage = [vc4Image1 imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    NSArray* vcArray = [[NSArray alloc]initWithObjects:nav,nav1,nav2,nil];
    
    self.viewControllers = vcArray;
    
    
    //设置选中图片颜色
    UIColor *COLOR = colorToString(@"#c00000");
    [[UITabBar appearance] setTintColor:COLOR];
    
    
    //[[UINavigationBar appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName, nil]];
    
    
    //设置字体大小
    //[[UITabBarItem appearance] setTitleTextAttributes: @{UITextAttributeFont:[UIFont systemFontOfSize:12.0],UITextAttributeTextShadowOffset:[NSValue valueWithUIOffset:UIOffsetZero]} forState:UIControlStateNormal];
    
    NSShadow *shadow = [[NSShadow alloc]init];
    //shadow.shadowOffset = UIOffsetZero;
    shadow.shadowColor = [UIColor whiteColor];
    
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:13],NSFontAttributeName,shadow,NSShadowAttributeName,nil] forState:UIControlStateNormal];
    
    
    //UIImage* tabBarBackground =[[UIImage imageNamed:@"tabbar.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0,0,0,0)];
    
    //[[UITabBar appearance] setBackgroundImage:tabBarBackground];
    
    
    
    //设置选择item的背景图片
    //UIImage * selectionIndicatorImage =[UIImage imageNamed:@"111.png"];
    //UIImage * selectionIndicatorImage =[[UIImage imageNamed:@"111.png"]resizableImageWithCapInsets:UIEdgeInsetsMake(0,0,0,0)];
    //[self imageWithColor:[UIColor blackColor] andSize:CGSizeMake(_Screen_Width, 49)];
    //[[UITabBar appearance] setSelectionIndicatorImage:selectionIndicatorImage];
    
    

    // Do any additional setup after loading the view from its nib.
//    CGRect frame = CGRectMake(0,0,_Screen_Width/3,49);
//    UIView *v = [[UIView alloc] initWithFrame:frame];
//    v.tag = 90;
    
    //以图片为平铺的颜色模板，初始化颜色
//    UIImage *img = [UIImage imageNamed:@"111.png"];
//    UIColor *color2 = [UIColor colorWithPatternImage:img];//[UIColor grayColor];
//    // 设置视图背景色
//    v.backgroundColor = color2;
//    // 将视图插入到选项卡栏底层
//    [self.tabBar insertSubview:v atIndex:0];
//    self.delegate = self;
//    self.tabBar.opaque = YES;
    
    // Do any additional setup after loading the view from its nib.
}

- (UIImage *)imageWithColor:(UIColor *)color andSize:(CGSize)size
{
    CGRect rect = CGRectMake(0, 0, size.width, size.height); //  <- Here
    // Create a 1 by 1 pixel context
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
    [color setFill];
    UIRectFill(rect);   // Fill it with your color
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
