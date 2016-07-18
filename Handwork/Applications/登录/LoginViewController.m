//
//  LoginViewController.m
//  CraftWork
//
//  Created by ios on 15-4-28.
//  Copyright (c) 2015年 周文超. All rights reserved.
//

#import "LoginViewController.h"
#import "RegisteredViewController.h"
#import "ForgotPassword.h"
#import "UIDevice+IdentifierAddition.h"
#import "ASIHTTPRequest.h"
#import "HttpRequest.h"
#import "MBProgressHUD.h"
@interface LoginViewController ()<UIAlertViewDelegate>
{
    UITextField* tempText;
    
}
@property (strong, nonatomic) IBOutlet UIButton *registered;
@property (strong, nonatomic) IBOutlet UITextField *phoneNumber;
@property (strong, nonatomic) IBOutlet UITextField *password;
@property (strong, nonatomic) IBOutlet UIButton *login_btn;
@property (strong, nonatomic) IBOutlet UIButton *forget_btn;
@property (strong, nonatomic) IBOutlet UIView *v1;
@property (strong, nonatomic) IBOutlet UIView *v2;

@property (strong, nonatomic) IBOutlet UIView *navView;
@property (strong, nonatomic) FeThreeDotGlow *threeDot;
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navView.layer.borderWidth = 1;
    self.navView.layer.borderColor = [RGB_MAKE(234, 234, 234)CGColor];
    
    // 显示系统状态栏
    [[UIApplication sharedApplication] setStatusBarHidden:NO];

    if ([[[UIDevice currentDevice] systemVersion] floatValue]>=7.0)
    { // 判断是否是IOS7
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
    }
    // 1.取出设置主题的对象
//    UINavigationBar *navBar = [UINavigationBar appearance];
//    [navBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    
    // Do any additional setup after loading the view from its nib.
    self.title = @"登录";
    self.view.backgroundColor =[UIColor whiteColor];
    //[MBProgressHUD showHUDAddedTo:self.view animated:YES withText:@"正在登录" detailText:nil];

    [self initView];
    
    NSUserDefaults* userfaulst = [NSUserDefaults standardUserDefaults];
    //UILog(@"%@",[userfaulst objectForKey:Remember]);
    if ([[userfaulst objectForKey:Remember]intValue]==1 && _canAutoLogin)
    {
       
        
        NSString* isauth = [userfaulst objectForKey:API_ISAUTH];
        if ([isauth isEqualToString:@"3"]){
            self.phoneNumber.text = @"";
            
            NSString* s = nil;
            
            s = [[UIDevice currentDevice] uniqueDeviceIdentifier];
            
            [self login:s pass:@"123" isGuest:YES];
        }
        else
        {
            //UILog(@"自动登录");
            self.phoneNumber.text =  [userfaulst objectForKey:Remember_LOCALUserName];
            self.password.text  = [userfaulst objectForKey:Remember_LOCALPss];
            // 13535308748  123
            [self login:self.phoneNumber.text pass:self.password.text isGuest:NO];
        }
    }
    else
    {
        //UILog(@"手动登录");
        
        if ([userfaulst objectForKey:Remember_LOCALUserName])
        {
            self.phoneNumber.text =  [userfaulst objectForKey:Remember_LOCALUserName];
            self.password.text  = [userfaulst objectForKey:Remember_LOCALPss];
            
        }
    }
}
-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
   
//    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    // 1.取出设置主题的对象
//    UINavigationBar *navBar = [UINavigationBar appearance];
//    [navBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
}

-(void)viewWillAppear:(BOOL)animated
{
    // 判断是否清空密码输入框
    NSUserDefaults* userfaulst = [NSUserDefaults standardUserDefaults];
    NSString *rememberPassword = [userfaulst objectForKey:Remember_LOCALPss];
    if (strIsEmpty(rememberPassword))
    {
        self.password.text = @"";
    }
    NSString* isauth = [userfaulst objectForKey:API_ISAUTH];
    if ([isauth isEqualToString:@"3"]){
        self.phoneNumber.text = @"";
        self.password.text = @"";
    }
}

-(void)initView
{
    self.login_btn.layer.borderWidth = 1;
    self.login_btn.layer.borderColor = [colorToString(@"#dddddd")CGColor];
    self.login_btn.layer.masksToBounds = YES;
    //self.phoneNumber.textColor = colorToString(@"#dddddd");
    
    
    self.v1.layer.borderWidth = 1;
    self.v1.layer.borderColor = [colorToString(@"#dddddd")CGColor];
    self.v1.layer.masksToBounds = YES;
    
    self.v2.layer.borderWidth = 1;
    self.v2.layer.borderColor = [colorToString(@"#dddddd")CGColor];
    self.v2.layer.masksToBounds = YES;
    
    [self.registered setTitleColor:colorToString(@"#999999") forState:UIControlStateNormal];
    [self.forget_btn setTitleColor:colorToString(@"#5fb1f1") forState:UIControlStateNormal];
}

-(void)login:(NSString*)username pass:(NSString*)pwd isGuest:(BOOL)guest
{
    
    if (username.length&&pwd.length)
    {
        //[MBProgressHUD showHUDAddedTo:self.view animated:YES withText:@"正在登录..." detailText:nil];
        
        NSMutableDictionary* dict = [NSMutableDictionary dictionary];
        
        
        if (guest==YES) {
            [dict setObject:username forKey:@"appinfo"];
        }
        else
        {
            [dict setObject:username forKey:@"username"];
            [dict setObject:pwd forKey:@"password"];
        }
        NSString* url = [NSString stringWithFormat:@"Account/%@",[HttpRequest urlWithIndex:0]];
        
        ASIHTTPRequest* request = [HttpRequest requestPost:url Dic:dict authorization:NO];
        
        __weak typeof(ASIHTTPRequest) * request_weak = request;
        
        
        [request_weak setCompletionBlock:^{
            
            NSDictionary* dic = [[request_weak responseString]objectFromJSONString];
            
            NSInteger status = [[dic objectForKey:@"status"]intValue];
            if (status!=1) {
                
                //UILog(@"dict ===> %@",dic);
                [MBProgressHUD hideHUDForView:self.view animated:NO];
                NSString* info = [NSString stringWithFormat:@"%@",[dic objectForKey:@"info"]];
                ALERT_OK(info);
                return ;
            }
            //UILog(@"%@",dic);
            [MBProgressHUD hideHUDForView:self.view animated:NO];
            NSUserDefaults* userfaulst = [NSUserDefaults standardUserDefaults];
            NSDictionary* data = [dic objectForKey:@"data"];
            
            [userfaulst setValue:username forKey:Remember_LOCALUserName];
            [userfaulst setValue:pwd forKey:Remember_LOCALPss];
            
            BOOL first = YES;
            
            [userfaulst setBool:first forKey:Remember];
            //UILog(@"++1 %d",first);
            if ([data objectForKey:@"token"]!=nil) {
                [userfaulst setObject:[NSString stringWithFormat:@"%@",[data objectForKey:@"token"]] forKey:API_TOKEN];
                
                //NSLog(@"保存的Token  %@",[userfaulst objectForKey:@"token"]);
            }
            if ([data objectForKey:@"uid"]!=nil) {
                [userfaulst setObject:[NSString stringWithFormat:@"%@",[data objectForKey:@"uid"]]forKey:API_UID];
            }
            if (!strIsEmpty([data objectForKey:@"nickname"])) {
                [userfaulst setObject:[NSString stringWithFormat:@"%@",[data objectForKey:@"nickname"]]forKey:LOCAL_NICKNAME];
            }
            if (!strIsEmpty([data objectForKey:@"s_photo"])) {
                [userfaulst setObject:[NSString stringWithFormat:@"%@",[data objectForKey:@"s_photo"]]forKey:LOCAL_PHOTO];
            }
            if (!strIsEmpty([data objectForKey:@"voicepath"])) {
                [userfaulst setObject:[NSString stringWithFormat:@"%@",[data objectForKey:@"voicepath"]]forKey:LOCAL_VOICEPATH];
            }
            
            
            if ([data objectForKey:@"secret"]!=nil) {
                [userfaulst setObject:[NSString stringWithFormat:@"%@",[data objectForKey:@"secret"]]forKey:API_SECRET];
                //NSLog(@"保存的API_SECRET  %@",[userfaulst objectForKey:@"secret"]);
            }
            if ([data objectForKey:@"isauth"]!=nil) {
                [userfaulst setObject:[NSString stringWithFormat:@"%@",[data objectForKey:@"isauth"]]forKey:API_ISAUTH];
                //NSLog(@"保存的API_SECRET  %@",[userfaulst objectForKey:@"secret"]);
            }
            if ([data objectForKey:@"isauth"]!=nil) {
                
                //NSLog(@"保存的API_SECRET  %@",[userfaulst objectForKey:@"secret"]);
            }
            
            [userfaulst setObject:[NSString stringWithFormat:@"%@",self.phoneNumber.text]forKey:API_TOURISTS];
            
            
            [MBProgressHUD hideHUDForView:self.view animated:NO];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"home" object:nil];
            [self.navigationController setNavigationBarHidden:NO];
           
            //[self performSelector:@selector(onLoginFinish) withObject:nil afterDelay:1.2f];
        }];
        
        [request_weak setFailedBlock:^{
             [MBProgressHUD hideHUDForView:self.view animated:NO];
          
        }];
        
         [MBProgressHUD showHUDAddedTo:self.view animated:YES withText:@"正在登录..." detailText:nil];
        [request_weak startAsynchronous];
        
    }
    else
    {
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@" “您当前是游客身份，立即注册成为会员？”" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
        [alert show];
//        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"账号或密码不能为空!" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
//        [alert show];
    }
}

// 转圈圈提示
-(void)onLoginFinish
{
    [MBProgressHUD hideHUDForView:self.view animated:NO];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"home" object:nil];
    [self.navigationController setNavigationBarHidden:NO];
}


-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==0) {
        RegisteredViewController* vc = [[RegisteredViewController alloc]init];
        vc.s_type =[[NSString alloc]initWithFormat:@"login"];
        [self.navigationController pushViewController:vc animated:YES];
        
    }
    if (buttonIndex==1)
    {
        
        
        NSString* s = nil;
        
         s = [[UIDevice currentDevice] uniqueDeviceIdentifier];
        
        if (s!=nil) {
           
            [self login:s pass:@"123" isGuest:YES];
        }
        
    }
}
- (IBAction)btn_click:(UIButton *)sender
{
    //NSLog(@"%ld",(long)sender.tag);
    if(sender.tag==0)
    {
        [tempText resignFirstResponder];
        [self login:self.phoneNumber.text pass:self.password.text isGuest:NO];
    }
    if (sender.tag==1) {
        [self.navigationController setNavigationBarHidden:YES];
        RegisteredViewController* vc = [[RegisteredViewController alloc]init];
        vc.s_type =[[NSString alloc]initWithFormat:@"login"];
        [self.navigationController pushViewController:vc animated:YES];
    }
    if (sender.tag==2) {
        ForgotPassword* vc = [[ForgotPassword alloc]init];
        [self.navigationController setNavigationBarHidden:YES];
        [self.navigationController pushViewController:vc animated:YES];
    }
}
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    tempText = textField;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([self.phoneNumber isFirstResponder])
    {
        [self.password becomeFirstResponder];
    }
    else if([self.password isFirstResponder])
    {
        [self.password resignFirstResponder];
        
        [self login:self.phoneNumber.text pass:self.password.text isGuest:NO];
        
    }
    return YES;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [tempText resignFirstResponder];
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
