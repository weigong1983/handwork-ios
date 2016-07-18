//
//  ModifyViewController.m
//  Handwork
//
//  Created by ios on 15-5-4.
//  Copyright (c) 2015年 周文超. All rights reserved.
//

#import "ModifyViewController.h"

@interface ModifyViewController ()
@property (strong, nonatomic) IBOutlet UITextField *imput_textField;
@property (strong, nonatomic) IBOutlet UIButton *save_btn;
@property (strong, nonatomic) IBOutlet UIView *bg_view;

@end

@implementation ModifyViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = self.s_type;
    
    self.imput_textField.text =self.dataName;
    
    self.imput_textField.textColor = colorToString(@"333333");
    self.save_btn.layer.masksToBounds =YES;
    self.save_btn.layer.borderWidth=1;
    self.save_btn.layer.borderColor = [colorToString(@"#dddddd") CGColor];
    
    [self.save_btn setTitleColor:colorToString(@"#333333") forState:UIControlStateNormal];
    
    self.bg_view.layer.masksToBounds =YES;
    self.bg_view.layer.borderWidth=1;
    self.bg_view.layer.borderColor = [colorToString(@"#dddddd") CGColor];
    
    
    // Do any additional setup after loading the view from its nib.
}
- (IBAction)sava_click:(UIButton *)sender {
    
    if (self.imput_textField.text.length) {
        [self setUserInfo];
    }
    else
    {
        ALERT_OK(@"内容不能为空!");
    }
}

-(void)setUserInfo
{
    
    NSMutableDictionary* submit = [NSMutableDictionary dictionary];
    UILog(@"submit %@",self.s_type1);
    //return;
    [submit setValue:self.imput_textField.text forKey:self.s_type1];
    if (self.vc) {
        
        if ([self.s_type1 isEqualToString:@"realname"]) {
            NSUserDefaults* userfaulst = [NSUserDefaults standardUserDefaults];
            [userfaulst setObject:self.imput_textField.text forKey:LOCAL_NICKNAME];
        }
        else
        {
            self.vc.association = self.imput_textField.text;
        }
        
        self.vc.isRefresh = YES;
        [self performSelector:@selector(back) withObject:nil afterDelay:1.0f];
        return;
    }
    
    
    [submit setValue:@"2" forKey:@"isauth"];
    
    //UILog(@"submit %@",self.s_type1);
    NSString* url = [NSString stringWithFormat:@"Account/setUserInfo"];
    
    ASIHTTPRequest* request = [HttpRequest requestPost:url Dic:submit authorization:YES];
    __weak typeof (ASIHTTPRequest)* request_weak = request;
    
    [request setCompletionBlock:^{
        NSDictionary* dic = [[request_weak responseString]objectFromJSONString];
        
        [MBProgressHUD hideHUDForView:self.view animated:NO];
        int status = [[dic objectForKey:@"status"]intValue];
        [self isDistance:status];
        if (status!=1) {
            return ;
        }
        
        NSString* info = [NSString stringWithFormat:@"%@",[dic objectForKey:@"info"]];
        //ALERT_OK(info);
        [TipsHud ShowTipsHud:info :self.view];
        self.vc.isRefresh = YES;
        [self performSelector:@selector(back) withObject:nil afterDelay:1.0f];
        //[self loadData];
    }];
   [MBProgressHUD showHUDAddedTo:self.view animated:YES withText:@"正在修改" detailText:nil];
    [request_weak startAsynchronous];
}

-(void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.imput_textField resignFirstResponder];
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
