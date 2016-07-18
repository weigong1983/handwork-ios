//
//  config.h
//  EndorsementNetwork
//
//  Created by ios on 15-1-30.
//  Copyright (c) 2015年 周文超. All rights reserved.
//

#ifndef EndorsementNetwork_config_h
#define EndorsementNetwork_config_h


#define ifUILog 1
#if ifUILog
#define UILog(format,...) printf("%s ->[第%d行] %s\n", __PRETTY_FUNCTION__, __LINE__,[[NSString stringWithFormat:format,##__VA_ARGS__] UTF8String])
#define UILog_Flag UILog(@"flag");
#else
#define UILog(...)
#define UILog_Flag
#endif

#define ALERT_OK(str) UIAlertView *warring = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:str delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil];[warring show]; warring.alpha=0.5;//[warring release] ;

#define ISNULL_STR(str) (str == nil || [@"" isEqualToString:str])

#define _release_(_obj_) if (_obj_) {[_obj_ release]; _obj_ = nil;}

#define _Documents_Path_ [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]
/** 判断设备是否IPHONE5 */
#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)

#define iPhone4s ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)

#define iPhone6 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? (CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size)) : NO)

#define iPhone6plus ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? (CGSizeEqualToSize(CGSizeMake(1125, 2001), [[UIScreen mainScreen] currentMode].size) || CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size)) : NO)

// 判断设备类型新方法
#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_RETINA ([[UIScreen mainScreen] scale] >= 2.0)

#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
#define SCREEN_MAX_LENGTH (MAX(SCREEN_WIDTH, SCREEN_HEIGHT))
#define SCREEN_MIN_LENGTH (MIN(SCREEN_WIDTH, SCREEN_HEIGHT))

#define IS_IPHONE_4_OR_LESS (IS_IPHONE && SCREEN_MAX_LENGTH < 568.0)
#define IS_IPHONE_5 (IS_IPHONE && SCREEN_MAX_LENGTH == 568.0)
#define IS_IPHONE_6 (IS_IPHONE && SCREEN_MAX_LENGTH == 667.0)
#define IS_IPHONE_6P (IS_IPHONE && SCREEN_MAX_LENGTH == 736.0)
// 判断设备类型新方法

#define RGB_MAKE(r,g,b)  [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:1.0f]
#define colorToString(str) [UIColor colorWithHexString:str]
#define strIsEmpty(str) ([str isKindOfClass:[NSNull class]] || str == nil || [str length]<1 ? YES : NO )
//沙盒
#define _Bundl_Path(A)      [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:A]
#define _Bundl_Path_(A,B)   [[NSBundle mainBundle] pathForResource:A ofType:B]
#define _Documents_Path(A)  [_Documents_Path_ stringByAppendingPathComponent:A]

//屏幕的宽度 高度
#define _Screen_Height      ([UIScreen mainScreen].bounds.size.height)
#define _Screen_Width       ([UIScreen mainScreen].bounds.size.width)

//屏幕的x,y坐标
#define _Screen_y           ([UIScreen mainScreen].bounds.origin.y)
#define _Screen_x           ([UIScreen mainScreen].bounds.origin.x)

//高清
#define _Hd_width           ([[UIScreen mainScreen] currentMode].size.width)
#define _Hd_height          ([[UIScreen mainScreen] currentMode].size.height)

//内容中心点
#define _Content_Height     ([UIScreen mainScreen].applicationFrame.size.height)
#define _Content_Width      ([UIScreen mainScreen].applicationFrame.size.width)

//屏幕的中心点
#define _Screen_Frame       (CGRectMake(0, 0 ,_Screen_Width,_Screen_Height))
#define _Screen_CenterX     _Screen_Width/2
#define _Screen_CenterY     _Screen_Height/2

#define _Content_Frame      (CGRectMake(0, 0 ,_Content_Width,_Content_Height))
#define _Content_CenterX    _Content_Width/2
#define _Content_CenterY    _Content_Height/2


/** 头像大小定义 */
#define AVATAR_WIDTH  120
#define AVATAR_HEIGHT 120
#define AVATAR_ROUND_PX 40

#define LOCAL_UID                      @"uid"               //用来判断是否可以删除 话题
#define LOCAL_PHOTO                    @"s_photo"             //头像
#define LOCAL_NICKNAME                 @"nickname"          //姓名
#define LOCAL_INTRODICE                @"introduce"         //个人签名
#define Remember_Password              @"remember_password" //记住密码
#define LOCAL_VOICEPATH                @"voicepath"

#define Remember_LOCALUserName         @"username" //记住用户名
#define Remember_LOCALPss              @"password" //记住密码
#define Remember                       @"Remember"
#define Remember_LOCALText             @"text"    //===


// ShareSDK常量定义
#define ShareSDK_AppKey @"8049b04d2a95"

// 新浪微博
#define SINA_WEIBO_AppKey @"1718620884"
#define SINA_WEIBO_AppSecret @"8630d236437e2facfa84952f2e902087"
#define SINA_WEIBO_RedirectUrl @"http://www.shouzuopin.com/"

#define Label_Font 17   //UICollectionViewDelegate,UICollectionViewDataSource

//// 腾讯微博
//#define tencent_WEIBO_AppKey      @"801307650"
//#define tencent_WEIBO_AppSecret   @"ae36f4ee3946e1cbb98d6965b0b2ff5c"
//#define tencent_WEIBO_RedirectUrl @"http://www.shouzuopin.com"

//// 微信
#define Wechat_WEIBO_AppKey      @"wx9959efb219938f88"
#define Wechat_WEIBO_AppSecret   @"658e753b1de7e34515ac91484e7add5e"
#define Wechat_WEIBO_RedirectUrl @"http://www.shouzuopin.com/"

// 友盟SDK
#define MobAppKey                @"5566cbfb67e58e2d9a004e91"
#define MobAppSecret             @"20eeb6807ced704d6f2e3e2889bc880b"

// 蒲公英SDK key
#define PGYER_AppID              @"50bc42c95b88cb4628649639e38dabfe"


// 渠道ID
#define CHANNEL_PGYER           @"pgyer"            // 蒲公英内测渠道
#define CHANNEL_APPSTORE        @"AppStore"         // 苹果应用商店渠道
#define CURRENT_CHANNEL_ID      CHANNEL_PGYER    // 当前渠道ID

#define CHECK_TEST_VERSION      0 // 蒲公英内测版本是否提示用户下载Appstore官方正式版本： 0不提示；1提示

// APP在苹果商店的下载地址
#define APPSTORE_URL      @"https://itunes.apple.com/cn/lookup?id=956787125"

#endif
