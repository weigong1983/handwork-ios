//
//  WelcomeViewController.h
//  Handwork
//
//  Created by ios on 15-4-29.
//  Copyright (c) 2015年 周文超. All rights reserved.
//

#import "BaseViewController.h"

@interface WelcomeViewController : BaseViewController
@property (nonatomic)BOOL isFisrtLaunch; // 判断是否第一次启动，如果首次启动结束后自动登录游客账号；如果关于页面进来则返回上一个页面
@end
