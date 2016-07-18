//
//  ModifyPasswordViewController.m
//  Handwork
//
//  Created by ios on 15-5-4.
//  Copyright (c) 2015年 周文超. All rights reserved.
//

#import "ModifyPasswordViewController.h"

@interface ModifyPasswordViewController ()
{
    UITextField* tempField;
}
@property (strong, nonatomic) IBOutlet UITextField *pass3;
@property (strong, nonatomic) IBOutlet UITextField *pass2;
@property (strong, nonatomic) IBOutlet UITextField *pass1;
@property (strong, nonatomic) IBOutlet UIView *view1;
@property (strong, nonatomic) IBOutlet UIView *view2;
@property (strong, nonatomic) IBOutlet UIView *view3;
@property (strong, nonatomic) IBOutlet UIButton *submit_btn;

@end

@implementation ModifyPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    if ([[[UIDevice currentDevice] systemVersion] floatValue]>=7.0) { // 判断是否是IOS7
//        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
//    }
    
    self.title = @"修改密码";
    self.view1.layer.borderWidth = 1;
    self.view1.layer.borderColor = [colorToString(@"#dddddd")CGColor];
    self.view2.layer.borderWidth = 1;
    self.view2.layer.borderColor = [colorToString(@"#dddddd")CGColor];
    self.view3.layer.borderWidth = 1;
    self.view3.layer.borderColor = [colorToString(@"#dddddd")CGColor];
    self.submit_btn.layer.borderWidth = 1;
    self.submit_btn.layer.borderColor = [colorToString(@"#dddddd")CGColor];
    
    [self.submit_btn setTitleColor:colorToString(@"#333333") forState:UIControlStateNormal];
    
    // Do any additional setup after loading the view from its nib.
}
- (IBAction)submit:(UIButton *)sender {
    
    if (self.pass1.text.length&& self.pass2.text.length && self.pass3.text.length) {
        if ([self.pass2.text isEqualToString:self.pass3.text]) {
            NSMutableDictionary* submit_dic = [NSMutableDictionary dictionary];
            [submit_dic setObject:self.pass1.text forKey:@"oldpwd"];
            [submit_dic setObject:self.pass2.text forKey:@"pwd"];
            NSString* url = [NSString stringWithFormat:@"Account/updatePwd"];
            
            ASIHTTPRequest* request = [HttpRequest requestPost:url Dic:submit_dic authorization:YES];
            
            
            __weak typeof (ASIHTTPRequest)* request_weak = request;
            
            [request setCompletionBlock:^{
                NSDictionary* dic = [[request_weak responseString]objectFromJSONString];
                
                [MBProgressHUD hideHUDForView:self.view animated:NO];
                
                int status = [[dic objectForKey:@"status"]intValue];
                if (status!=1) {
                    NSString* info = [NSString stringWithFormat:@"%@",[dic objectForKey:@"info"]];
                    ALERT_OK(info);
                    return ;
                }
                
                NSString* info = [NSString stringWithFormat:@"%@",[dic objectForKey:@"info"]];
                ALERT_OK(info);
                
                [self performSelector:@selector(back) withObject:nil afterDelay:2.5];
            }];
            [MBProgressHUD showHUDAddedTo:self.view animated:YES withText:@"正在修改..." detailText:nil];
            [request_weak startAsynchronous];
        }
        else
        {
            ALERT_OK(@"两次密码不一样!");
        }
    }
    else{
        ALERT_OK(@"旧密码或新密码不能为空!")
    }
}
-(void)back
{
    
    NSUserDefaults* userfaulst = [NSUserDefaults standardUserDefaults];
    BOOL fire = NO;
    [userfaulst setBool:fire forKey:Remember];
    [userfaulst setValue:@"" forKey:Remember_LOCALPss];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"login" object:nil];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [tempField resignFirstResponder];
}
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    tempField = textField;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
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
