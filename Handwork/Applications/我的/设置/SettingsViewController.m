//
//  SettingsViewController.m
//  Handwork
//
//  Created by ios on 15-5-4.
//  Copyright (c) 2015年 周文超. All rights reserved.
//

#import "SettingsViewController.h"
#import "PersonalDataViewController.h"
#import "ModifyPasswordViewController.h"
#import "AboutUsViewController.h"
#import "RegisteredViewController.h"
#import "LoginViewController.h"
#import "ShareAppViewController.h"

@interface SettingsViewController ()
{
   
}
@property (strong, nonatomic) IBOutlet UIView *line_v1;
@property (strong, nonatomic) IBOutlet UIView *line_v2;
@property (strong, nonatomic) IBOutlet UIView *line_v3;
@property (strong, nonatomic) IBOutlet UIView *line_v4;

@property (strong, nonatomic) IBOutlet UIButton *loginOut;

@end

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"设置";
    self.line_v1.layer.borderWidth = 1;
    self.line_v1.layer.borderColor = [colorToString(@"#dddddd")CGColor];
//    self.line_v2.layer.borderWidth = 1;
//    self.line_v2.layer.borderColor = [colorToString(@"#dddddd")CGColor];
//
//    self.line_v3.backgroundColor = colorToString(@"#dddddd");
    
    self.line_v4.layer.borderWidth = 1;
    self.line_v4.layer.borderColor = [colorToString(@"#dddddd")CGColor];
    
    self.loginOut.layer.borderWidth = 1;
    self.loginOut.layer.borderColor = [colorToString(@"#dddddd")CGColor];
    
    
//    if ([self IS_Guest]) {
//        [self.loginOut setTitle:@"马上注册会员" forState:UIControlStateNormal];
//    }
//    else
    {
        [self.loginOut setTitle:@"退出登录" forState:UIControlStateNormal];
    }
    // Do any additional setup after loading the view from its nib.
}
- (IBAction)btn_click:(id)sender
{
    UIButton* btn =sender;
    //UILog(%ld%d",btn.tag);
    if (btn.tag==0) {
        PersonalDataViewController* vc = [[PersonalDataViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if (btn.tag==1) {
        
        if ([self Check_Guest]) {
            //[TipsHud ShowTipsHud:@"游客无操作权限，请先注册账号!" :self.view];
            return;
        }
        
        ModifyPasswordViewController* vc =[[ModifyPasswordViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if (btn.tag==2) { // 分享软件
        ShareAppViewController* vc = [[ShareAppViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if (btn.tag==3) { // 关于我们
        AboutUsViewController* vc = [[AboutUsViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if (btn.tag==4) {
        
//        if ([self IS_Guest])
//        {
//            //[[NSNotificationCenter defaultCenter] postNotificationName:@"registered" object:nil];
//            LoginViewController* vc = [[LoginViewController alloc]init];
//            vc.canAutoLogin = false;
//            [self.navigationController pushViewController:vc animated:YES];
//        }
//        else
        {
            NSUserDefaults* userfaulst = [NSUserDefaults standardUserDefaults];
            BOOL fire = NO;
            [userfaulst setBool:fire forKey:Remember];
            UILog(@"%d",fire);
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"login" object:nil];
            
//            LoginViewController* vc = [[LoginViewController alloc]init];
//            [self.navigationController pushViewController:vc animated:YES];
        }
        
    }
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
