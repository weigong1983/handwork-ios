//
//  LoginViewController.h
//  CraftWork
//
//  Created by ios on 15-4-28.
//  Copyright (c) 2015年 周文超. All rights reserved.
//


#import "BaseViewController.h"
@interface LoginViewController : BaseViewController
@property (nonatomic)BOOL canAutoLogin; // 是否允许自动登录（游客模式下引导登录不需要自动登录）
@end
