//
//  RegisteredViewController.m
//  Handwork
//
//  Created by apple on 15-5-8.
//  Copyright (c) 2015年 周文超. All rights reserved.
//

#import "RegisteredViewController.h"
#import "TermsServiceViewController.h"
#import "UIDevice+IdentifierAddition.h"
@interface RegisteredViewController ()
{
    UITextField* tempField;
    BOOL isSSCheckFlag; // 是否选中服务条款勾选框
}
@property (strong, nonatomic) IBOutlet UIButton *registerd_btn;
@property (strong, nonatomic) IBOutlet UIView *v1;
@property (strong, nonatomic) IBOutlet UIView *v2;
@property (strong, nonatomic) IBOutlet UIView *v3;
@property (strong, nonatomic) IBOutlet UIView *line;
@property (strong, nonatomic) IBOutlet UIButton *getValidation_btn;
@property (strong, nonatomic) IBOutlet UITextField *phone;
@property (strong, nonatomic) IBOutlet UITextField *code;
@property (strong, nonatomic) IBOutlet UITextField *pass;
@property (strong, nonatomic) IBOutlet UIView *navView;
@property (strong, nonatomic) IBOutlet UIButton *ssCheckbox; // 服务条款勾选框
@property (strong, nonatomic) IBOutlet UIButton *ssViewDetail; // 点击查看服务条款详情
@end

@implementation RegisteredViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   //[self.navigationController setNavigationBarHidden:YES];
    

    
    if ([self.s_type isEqualToString:@"login"]){
        UINavigationBar *navBar = [UINavigationBar appearance];
     
        navBar.tintColor = [UIColor whiteColor];
        
        NSString* s = @"top.png";
        [navBar setBackgroundImage:[UIImage imageNamed:s] forBarMetrics:UIBarMetricsDefault];
        
        if ([[[UIDevice currentDevice] systemVersion] floatValue]>=7.0)
        { // 判断是否是IOS7
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
        }
        
        [[UINavigationBar appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName, nil]];
        UIColor * color = [UIColor whiteColor];
        //这里我们设置的是颜色，还可以设置shadow等，具体可以参见api
        
        NSDictionary * dict=[NSDictionary dictionaryWithObject:color forKey:UITextAttributeTextColor];
        //大功告成
        self.navigationController.navigationBar.titleTextAttributes = dict;
        
        [self.navigationController setNavigationBarHidden:NO];
    }
 
    
    self.navView.layer.borderWidth = 1;
    self.navView.layer.borderColor = [RGB_MAKE(234, 234, 234)CGColor];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.getValidation_btn setTitleColor:colorToString(@"#999999") forState:UIControlStateNormal];
    
    // 服务条款勾选
    isSSCheckFlag = YES;
    [self updateSSCheckboxState];

    self.title = @"快速注册";
    self.v1.layer.borderWidth = 1;
    self.v1.layer.borderColor = [colorToString(@"#dddddd") CGColor];
    
    self.v2.layer.borderWidth = 1;
    self.v2.layer.borderColor = [colorToString(@"#dddddd") CGColor];
    
    self.v3.layer.borderWidth = 1;
    self.v3.layer.borderColor = [colorToString(@"#dddddd") CGColor];
    
    self.registerd_btn.layer.borderWidth = 1;
    self.registerd_btn.layer.borderColor = [colorToString(@"#dddddd") CGColor];
    [self.registerd_btn setTitleColor:colorToString(@"#999999") forState:UIControlStateNormal];
    
    [self.line setBackgroundColor:colorToString(@"#dddddd")];
    // Do any additional setup after loading the view from its nib.
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue]>=7.0)
    { // 判断是否是IOS7
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
    }
    [self.navigationController setNavigationBarHidden:YES];
}


-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

-(void)updateSSCheckboxState
{
    if (isSSCheckFlag) {
        [_ssCheckbox setBackgroundImage:[UIImage imageNamed:@"勾选.png"] forState:UIControlStateNormal];
    } else {
        [_ssCheckbox setBackgroundImage:[UIImage imageNamed:@"未勾选.png"] forState:UIControlStateNormal];
    }
}

// 同意服务条款勾选框点击事件处理
- (IBAction)onSSCheckBoxBtnClick:(UIButton *)sender {
    isSSCheckFlag = !isSSCheckFlag;
    [self updateSSCheckboxState];
}

// 查看《服务条款》按钮点击事件处理
- (IBAction)onSSViewDetailBtnClick:(UIButton *)sender
{
    TermsServiceViewController* vc = [[TermsServiceViewController alloc]init];
    UINavigationBar *navBar = [UINavigationBar appearance];
    [self.navigationController setNavigationBarHidden:NO];
    navBar.tintColor = [UIColor whiteColor];
    
    NSString* s = @"top.png";
    [navBar setBackgroundImage:[UIImage imageNamed:s] forBarMetrics:UIBarMetricsDefault];
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue]>=7.0)
    { // 判断是否是IOS7
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    }
    
    [[UINavigationBar appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName, nil]];
    UIColor * color = [UIColor whiteColor];
    //这里我们设置的是颜色，还可以设置shadow等，具体可以参见api
    NSDictionary * dict=[NSDictionary dictionaryWithObject:color forKey:UITextAttributeTextColor];
    //大功告成
    self.navigationController.navigationBar.titleTextAttributes = dict;
    
    [self.navigationController setNavigationBarHidden:NO];
  
    [self.navigationController pushViewController:vc animated:YES];
}


- (IBAction)back:(UIButton *)sender
{

    if ([self.s_type isEqualToString:@"login"]) {
        [self.navigationController setNavigationBarHidden:YES];
        [self.navigationController popViewControllerAnimated:YES];
      
    }
    
    else
    {
        UINavigationBar *navBar = [UINavigationBar appearance];
        [self.navigationController setNavigationBarHidden:NO];
        navBar.tintColor = [UIColor whiteColor];
        
        NSString* s = @"top.png";
        [navBar setBackgroundImage:[UIImage imageNamed:s] forBarMetrics:UIBarMetricsDefault];
        
        if ([[[UIDevice currentDevice] systemVersion] floatValue]>=7.0)
        { // 判断是否是IOS7
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
        }
        
        [[UINavigationBar appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName, nil]];
        
        UIColor * color = [UIColor whiteColor];
        //这里我们设置的是颜色，还可以设置shadow等，具体可以参见api
        NSDictionary * dict=[NSDictionary dictionaryWithObject:color forKey:UITextAttributeTextColor];
        //大功告成
        self.navigationController.navigationBar.titleTextAttributes = dict;
        [self.navigationController popViewControllerAnimated:YES];
    }

}

- (IBAction)btn_click:(UIButton *)sender {
    
    //UILog(@"%d",sender.tag);
    
    if (!isSSCheckFlag) {
        ALERT_OK(@"您未勾选同意手作品《服务条款》");
        return ;
    }
    
    if (sender.tag==0) {
        if (self.phone.text.length) {
            [self getCode:self.phone.text];
        }
        else
        {
            ALERT_OK(@"手机号码不能为空!");
        }
    }
    if (sender.tag==1) {
        [self s_register];
    }
}

-(void)getCode:(NSString*)phone
{
    
    NSMutableDictionary* dict = [NSMutableDictionary dictionary];
    [dict setObject:phone forKey:@"phone"];
    
   
    
    NSString* url = [NSString stringWithFormat:@"Account/getCode"];
    
    
    
    ASIHTTPRequest* request = [HttpRequest requestPost:url Dic:dict authorization:NO];
    
    __weak typeof(ASIHTTPRequest) * request_weak = request;
    
    [request_weak setCompletionBlock:^{
        
        NSDictionary* dic = [[request_weak responseString]objectFromJSONString];
        NSInteger status = [[dic objectForKey:@"status"]intValue];
        [MBProgressHUD hideHUDForView:self.view animated:NO];
        if (status!=1)
        {
            //UILog(@"dict ===> %@",dic);
            NSString* info = [NSString stringWithFormat:@"%@",[dic objectForKey:@"info"]];
            ALERT_OK(info);
            return ;
        }
        self.getValidation_btn.enabled = NO;
        NSString* info = [NSString stringWithFormat:@"%@",[dic objectForKey:@"info"]];
        
        ALERT_OK(info);
    }];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES withText:@"发送中..." detailText:nil];
    [request_weak startAsynchronous];
}
-(void)s_register
{
    if (self.pass.text.length &&self.phone.text.length &&self.code.text.length) {
        
        NSMutableDictionary* dict = [NSMutableDictionary dictionary];
        [dict setObject:self.phone.text forKey:@"phone"];
        [dict setObject:self.code.text forKey:@"code"];
        [dict setObject:self.pass.text forKey:@"password"];
        NSString* s = nil;
        
        s = [[UIDevice currentDevice] uniqueDeviceIdentifier];
        
        [dict setObject:s forKey:@"appinfo"];
        
        NSString* url = [NSString stringWithFormat:@"Account/register"];
        ASIHTTPRequest* request = [HttpRequest requestPost:url Dic:dict authorization:NO];
        
        __weak typeof(ASIHTTPRequest) * request_weak = request;
        
        [request_weak setCompletionBlock:^{
            
            NSDictionary* dic = [[request_weak responseString]objectFromJSONString];
            NSInteger status = [[dic objectForKey:@"status"]intValue];
            if (status!=1)
            {
                [MBProgressHUD hideHUDForView:self.view animated:NO];
                //UILog(@"dict ===> %@",dic);
                NSString* info = [NSString stringWithFormat:@"%@",[dic objectForKey:@"info"]];
                ALERT_OK(info);
                return ;
            }
            [MBProgressHUD hideHUDForView:self.view animated:NO];
            NSString* info = [NSString stringWithFormat:@"%@",[dic objectForKey:@"info"]];
            
            ALERT_OK(info);
            
            [self performSelector:@selector(back) withObject:nil afterDelay:1.5f];
        }];
           [MBProgressHUD showHUDAddedTo:self.view animated:YES withText:@"正在注册..." detailText:nil];
        [request_weak startAsynchronous];
        
    }
    else
    {
        ALERT_OK(@"手机,验证码或密码不能为空!");
    }
}
-(void)back
{
    //[self.navigationController popToRootViewControllerAnimated:YES];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    tempField = textField;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [tempField resignFirstResponder];
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
