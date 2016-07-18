//
//  ForgotPassword.m
//  Handwork
//
//  Created by apple on 15-5-8.
//  Copyright (c) 2015年 周文超. All rights reserved.
//

#import "ForgotPassword.h"
#import "IQKeyboardManager.h"

@interface ForgotPassword ()
{
    UITextField* tempField;
}
@property (strong, nonatomic) IBOutlet UITextField *phone;
@property (strong, nonatomic) IBOutlet UITextField *verfication;


@property (strong, nonatomic) IBOutlet UITextField *psss2;
@property (strong, nonatomic) IBOutlet UITextField *pass1;

@property (strong, nonatomic) IBOutlet UIView *v1;
@property (strong, nonatomic) IBOutlet UIView *v2;
@property (strong, nonatomic) IBOutlet UIView *v3;
@property (strong, nonatomic) IBOutlet UIView *v4;
@property (strong, nonatomic) IBOutlet UIButton *submit;
@property (strong, nonatomic) IBOutlet UIButton *getVerfication;
@property (strong, nonatomic) IBOutlet UIView *linev;
@property (strong, nonatomic) IBOutlet UIView *navView;

@end

@implementation ForgotPassword

- (IBAction)back:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navView.layer.borderWidth = 1;
    self.navView.layer.borderColor = [RGB_MAKE(234, 234, 234)CGColor];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.navigationController setNavigationBarHidden:YES];
    [self.getVerfication setTitleColor:colorToString(@"#999999") forState:UIControlStateNormal];
    [self.getVerfication setTitleColor:colorToString(@"#999999") forState:UIControlStateNormal];
    
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    
    self.title = @"快速注册";
    self.v1.layer.borderWidth = 1;
    self.v1.layer.borderColor = [colorToString(@"#dddddd") CGColor];
    
    self.v2.layer.borderWidth = 1;
    self.v2.layer.borderColor = [colorToString(@"#dddddd") CGColor];
    
    self.v3.layer.borderWidth = 1;
    self.v3.layer.borderColor = [colorToString(@"#dddddd") CGColor];
    
    self.v4.layer.borderWidth = 1;
    self.v4.layer.borderColor = [colorToString(@"#dddddd") CGColor];
    self.submit.layer.borderWidth = 1;
    self.submit.layer.borderColor = [colorToString(@"#dddddd") CGColor];
    [self.submit setTitleColor:colorToString(@"#999999") forState:UIControlStateNormal];
    
    [self.linev setBackgroundColor:colorToString(@"#dddddd")];
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    self.title = @"忘记密码";
    
    self.getVerfication.enabled = YES;
    // Do any additional setup after loading the view from its nib.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[IQKeyboardManager sharedManager] setShouldToolbarUsesTextFieldTintColor:YES];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[IQKeyboardManager sharedManager] setShouldToolbarUsesTextFieldTintColor:NO];
}
- (IBAction)btn_click:(UIButton *)sender {
    
    //UILog(@"%d",sender.tag);
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
    }}


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
        if (status!=1)
        {
            //UILog(@"dict ===> %@",dic);
            NSString* info = [NSString stringWithFormat:@"%@",[dic objectForKey:@"info"]];
            ALERT_OK(info);
            return ;
        }
        self.getVerfication.enabled = NO;
        NSString* info = [NSString stringWithFormat:@"%@",[dic objectForKey:@"info"]];
        
        ALERT_OK(info);
    }];

    [request_weak startAsynchronous];
}
-(void)s_register
{
    if (self.pass1.text.length &&self.phone.text.length &&self.verfication.text.length) {
        if ([self.pass1.text isEqualToString:self.psss2.text]) {
            NSMutableDictionary* dict = [NSMutableDictionary dictionary];
            [dict setObject:self.phone.text forKey:@"phone"];
            [dict setObject:self.verfication.text forKey:@"code"];
            [dict setObject:self.pass1.text forKey:@"password"];
            NSString* url = [NSString stringWithFormat:@"Account/forgetPassword"];
            ASIHTTPRequest* request = [HttpRequest requestPost:url Dic:dict authorization:NO];
            
            __weak typeof(ASIHTTPRequest) * request_weak = request;
            
            [request_weak setCompletionBlock:^{
                
                NSDictionary* dic = [[request_weak responseString]objectFromJSONString];
                NSInteger status = [[dic objectForKey:@"status"]intValue];
                if (status!=1)
                {
                    //UILog(@"dict ===> %@",dic);
                    NSString* info = [NSString stringWithFormat:@"%@",[dic objectForKey:@"info"]];
                    ALERT_OK(info);
                    return ;
                }
                
//                NSString* info = [NSString stringWithFormat:@"%@",[dic objectForKey:@"info"]];
                
                ALERT_OK(@"密码重置成功!");
                
                [self performSelector:@selector(back) withObject:nil afterDelay:1.0f];
            }];
            
            [request_weak startAsynchronous];
        }
        else
        {
            ALERT_OK(@"两次密码不一样!");
        }
    }
    else
    {
        ALERT_OK(@"手机,验证码或密码不能为空!");
    }
   
}

-(void)back
{
    // 清空密码
    NSUserDefaults* userfaulst = [NSUserDefaults standardUserDefaults];
    [userfaulst setValue:@"" forKey:Remember_LOCALPss];
    
    [self.navigationController popToRootViewControllerAnimated:YES];
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
