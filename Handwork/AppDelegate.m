//
//  AppDelegate.m
//  Handwork
//
//  Created by ios on 15-4-29.
//  Copyright (c) 2015年 周文超. All rights reserved.
//

#import "AppDelegate.h"
#import "BaseViewController.h"
#import "LoginViewController.h"
#import "WelcomeViewController.h"
#import "TabBarController.h"
#import "RegisteredViewController.h"
#import <PgySDK/PgyManager.h>

#import "MobClick.h"


#import <ShareSDK/ShareSDK.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import "WXApi.h"
#import "WeiboSDK.h"


@interface AppDelegate ()

@property (strong, nonatomic) UIView *lunchView;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    
    self.window.backgroundColor = [UIColor whiteColor];
    if ([[[UIDevice currentDevice] systemVersion] floatValue]>=7.0) { // 判断是否是IOS7
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    }
    [self initShareSDK];
    
    // 当前是蒲公英渠道版本
    if ([CURRENT_CHANNEL_ID isEqualToString:CHANNEL_PGYER])
    {
        // 初始化蒲公英SDK
        [[PgyManager sharedPgyManager] startManagerWithAppId:PGYER_AppID];
        [[PgyManager sharedPgyManager] setEnableFeedback:NO]; // 关闭意见反馈
    }
    
    // 友盟统计SDK集成
    [MobClick startWithAppkey:MobAppKey reportPolicy:BATCH   channelId:CURRENT_CHANNEL_ID];
    
    
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    [MobClick setAppVersion:version];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(login) name:@"login" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(welcome) name:@"welcome" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(home) name:@"home" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(registered) name:@"registered" object:nil];
    NSUserDefaults* userdefaults = [NSUserDefaults standardUserDefaults];
    
    BOOL first = [[userdefaults objectForKey:@"first"]boolValue];
    
    if (first)
    {
        [self login];
    }
    else
    {
        first = YES;
        [userdefaults setBool:first forKey:@"first"];
        [self welcome];
        //[self login];
    }
  

    
    return YES;
}


-(void)initShareSDK
{
    [ShareSDK registerApp:ShareSDK_AppKey];//字符串api20为您的ShareSDK的AppKey
    
    //添加新浪微博应用 注册网址 http://open.weibo.com
    [ShareSDK connectSinaWeiboWithAppKey:SINA_WEIBO_AppKey
                               appSecret:SINA_WEIBO_AppSecret
                             redirectUri:SINA_WEIBO_RedirectUrl];
    
    
//    [ShareSDK connectSinaWeiboWithAppKey:@"568898243"
//                               appSecret:@"38a4f8204cc784f81f9f0daaf31e02e3"
//                             redirectUri:@"http://www.sharesdk.cn"
//                             weiboSDKCls:[WeiboSDK class]];
    
    //当使用新浪微博客户端分享的时候需要按照下面的方法来初始化新浪的平台 （注意：2个方法只用写其中一个就可以）
//    [ShareSDK  connectSinaWeiboWithAppKey:SINA_WEIBO_AppKey
//                                appSecret:SINA_WEIBO_AppSecret
//                              redirectUri:@"http://www.sharesdk.cn"
//                              weiboSDKCls:[WeiboSDK class]];
    

    //添加QQ空间应用  注册网址  http://connect.qq.com/intro/login/
    [ShareSDK connectQZoneWithAppKey:@"1104654128"
                           appSecret:@"77otXfKVVmLivg43"
                   qqApiInterfaceCls:[QQApiInterface class]
                     tencentOAuthCls:[TencentOAuth class]];
    
    //添加QQ应用  注册网址  http://mobile.qq.com/api/
    [ShareSDK connectQQWithQZoneAppKey:@"1104654128"
                     qqApiInterfaceCls:[QQApiInterface class]
                       tencentOAuthCls:[TencentOAuth class]];
//
//    //添加微信应用（注意：微信分享的初始化，下面是的初始化既支持微信登陆也支持微信分享，只用写其中一个就可以） 注册网址 http://open.weixin.qq.com
//    [ShareSDK connectWeChatWithAppId:@"wx4868b35061f87885"
//                           wechatCls:[WXApi class]];
//    //微信登陆的时候需要初始化
    [ShareSDK connectWeChatWithAppId:@"wx2a6f7af219828029"
                           appSecret:@"9d3737ab3f6d6c2118dd8a380c3a82ad"
                           wechatCls:[WXApi class]];
    
    //UILog(@"1104654128 :%@",[self hexStringFromString:@"1104654128"]);
    
}



- (BOOL)application:(UIApplication *)application
      handleOpenURL:(NSURL *)url
{
    return [ShareSDK handleOpenURL:url
                        wxDelegate:self];
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    return [ShareSDK handleOpenURL:url
                 sourceApplication:sourceApplication
                        annotation:annotation
                        wxDelegate:self];
}
//-(void)initlunchView
//{
//    self.lunchView = [[NSBundle mainBundle ]loadNibNamed:@"LaunchScreen" owner:nil options:nil][0];
//    
//    self.lunchView.frame = CGRectMake(0, 0,
//                                      self.window.screen.bounds.size.width, self.window.screen.bounds.size.height); [self.window addSubview:self.lunchView];
//    
//    UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 50, _Screen_Width, _Hd_height)];
//    NSString *str = @"启动页1136";
//    
//    imageV.image = [UIImage imageNamed:str];
//    
//    [self.lunchView addSubview:imageV];
//    [self.window bringSubviewToFront:self.lunchView];
//    
//    [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(removeLun) userInfo:nil repeats:NO];
//}
//-(void)removeLun {
//    
//    
//    
//    [self.lunchView removeFromSuperview];
//}
-(void)registered
{
    RegisteredViewController* vc = [[RegisteredViewController alloc]init];
    UINavigationController* nav = [[UINavigationController alloc]initWithRootViewController:vc];
    self.window.rootViewController = nav;
    [self.window makeKeyAndVisible];
}
-(void)login
{
    LoginViewController* vc = [[LoginViewController alloc]init];
    vc.canAutoLogin = true;
    UINavigationController* nav = [[UINavigationController alloc]initWithRootViewController:vc];
    [nav setNavigationBarHidden:YES];
    self.window.rootViewController = nav;
    [self.window makeKeyAndVisible];
}
-(void)welcome
{
    WelcomeViewController* vc = [[WelcomeViewController alloc]init];
    vc.isFisrtLaunch = true;
    UINavigationController* nav = [[UINavigationController alloc]initWithRootViewController:vc];
    [nav setNavigationBarHidden:YES];
    self.window.rootViewController = nav;
    [self.window makeKeyAndVisible];
}
-(void)home
{
    // 蒲公英内测版本更新检测
    if ([CURRENT_CHANNEL_ID isEqualToString:CHANNEL_PGYER])
        [[PgyManager sharedPgyManager] checkUpdate];
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue]>=7.0) { // 判断是否是IOS7
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    }
    
    TabBarController* vc = [[TabBarController alloc]init];
    
    self.window.rootViewController = vc;
    [self.window makeKeyAndVisible];
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
