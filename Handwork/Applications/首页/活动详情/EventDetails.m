//
//  EventDetails.m
//  Handwork
//
//  Created by ios on 15-5-2.
//  Copyright (c) 2015年 周文超. All rights reserved.
//

#import "EventDetails.h"
#import "API.h"

@interface EventDetails ()
{
    NSInteger  isJoin;
}
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UILabel *addresslabel;
@property (strong, nonatomic) IBOutlet UIImageView *scanningImage;
@property (strong, nonatomic) IBOutlet UILabel *titlelabel;
@property (strong, nonatomic) IBOutlet UIImageView *conten_image;
@property (strong, nonatomic) IBOutlet UILabel *timelabel;
@property (strong, nonatomic) IBOutlet UILabel *Host_units;
@property (strong, nonatomic) IBOutlet UILabel *communication_time;
@property (strong, nonatomic) IBOutlet UILabel *commnuication_time1;
@property (strong, nonatomic) IBOutlet UIButton *sign_up_btn;
@property (strong, nonatomic) IBOutlet UIView *sign_up_View;

@property (strong, nonatomic) IBOutlet UILabel *addresslabel1;

@property (strong, nonatomic) IBOutlet UIWebView *webView;
@end

@implementation EventDetails

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"活动详情";
//    self.titlelabel.textColor = colorToString(@"#333333");
//    self.timelabel.textColor = colorToString(@"#999999");
//    
//    self.Host_units.textColor = colorToString(@"#666666");
//    
//    
//    self.communication_time.textColor = colorToString(@"#666666");
//    self.commnuication_time1.textColor = colorToString(@"#666666");
//    
//    self.addresslabel1.textColor = colorToString(@"#666666");
//    self.addresslabel.textColor = colorToString(@"#666666");
//    
//    if (_Screen_Height==480){
//        [self.scanningImage setTop:self.addresslabel.bottom+194];
//        [self.scrollView setContentSize:CGSizeMake(0, self.scrollView.height+30)];
//    }
//    self.sign_up_btn.layer.masksToBounds = YES;
//    self.sign_up_btn.layer.cornerRadius = 5;
//    
//    self.sign_up_btn.backgroundColor = colorToString(@"#f6b530");
//    self.sign_up_View.backgroundColor = colorToString(@"#f6f6f6");
//    self.sign_up_View.layer.borderColor = [colorToString(@"#d9d9d9")CGColor];
//    self.sign_up_View.layer.borderWidth= 1;
//    
//    [self loadData];
    NSUserDefaults* user = [NSUserDefaults standardUserDefaults];
    NSString* token = [user objectForKey:API_TOKEN];
    NSString* s_url = [NSString stringWithFormat:@"%@?token=%@&atid=%@", URL_ACT_DETAIL_BASE, token, self.mgid];
    NSURL* url = [NSURL URLWithString:s_url];
    NSURLRequest* request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
    // Do any additional setup after loading the view from its nib.
}
-(void)loadData
{
    NSMutableDictionary* submitData = [NSMutableDictionary dictionary];
    
    //NSUserDefaults* user = [NSUserDefaults standardUserDefaults];
    [submitData setValue:self.mgid forKey:@"atid"];
    
    //UILog(@"UID -> %@",[user objectForKey:API_UID]);
    NSString* url = [NSString stringWithFormat:@"%@/%@",[HttpRequest urlModule:2],[HttpRequest urlWithIndex:4]];
    
    ASIHTTPRequest* request = [HttpRequest requestPost:url Dic:submitData authorization:YES];
    
    
    __weak typeof (ASIHTTPRequest)* request_weak = request;
    
    [request setCompletionBlock:^{
        NSDictionary* dic = [[request_weak responseString]objectFromJSONString];
        
        int status = [[dic objectForKey:@"status"]intValue];
        if (status!=1) {
            NSString* info = [NSString stringWithFormat:@"%@",[dic objectForKey:@"info"]];
            ALERT_OK(info);
            return ;
        }
        
        UILog(@"获得-> %@",dic);
        [MBProgressHUD hideHUDForView:self.view animated:NO];
        NSDictionary* data = [dic objectForKey:@"data"];
        NSDictionary* detail = [data objectForKey:@"detail"];
        
        
        if (!strIsEmpty([detail objectForKey:@"title"])) {
            self.titlelabel.text = [NSString stringWithFormat:@"%@",[detail objectForKey:@"title"]];
        }
        if (!strIsEmpty([detail objectForKey:@"createtime"])) {
            
            CGFloat f_time = [[detail objectForKey:@"createtime"]floatValue];
            
            NSString* s_time = [NSString stringWithFormat:@"%@",[StringUtil getMS:f_time setDateFormat:@"yyyy-MM-dd HH:mm:ss"]];
            
            self.timelabel.text = [NSString stringWithFormat:@"%@",s_time];
        }
        if (!strIsEmpty([detail objectForKey:@"image"])) {
            
            NSURL* URL = [NSURL URLWithString:[detail objectForKey:@"image"]];
            [self.conten_image setImageWithURL:URL placeholderImage:nil];
        }
        if (!strIsEmpty([detail objectForKey:@"address"])) {
            self.addresslabel.text = [NSString stringWithFormat:@"%@",[detail objectForKey:@"address"]];
            self.addresslabel.numberOfLines = 2;
            [self.addresslabel sizeToFit];
            // [self.addresslabel setTop:self.communication_time.bottom+5];
        }
        if (!strIsEmpty([detail objectForKey:@"startdatetime"])) {
            //[self.communication_time setTop:self.Host_units.bottom+5];
            self.communication_time.text = [NSString stringWithFormat:@"%@ 到 %@",[detail objectForKey:@"startdatetime"],[detail objectForKey:@"stopdatetime"]];
            self.communication_time.numberOfLines = 0;
            [self.communication_time sizeToFit];
        }
        if (!strIsEmpty([detail objectForKey:@"hostunit"])) {
            
            
            self.Host_units.text = [NSString stringWithFormat:@"举办单位:  %@",[detail objectForKey:@"hostunit"]];
            self.Host_units.numberOfLines = 0;
            [self.Host_units sizeToFit];
            
        }
        
        if ([data objectForKey:@"isJoin"]!=nil) {
            
            isJoin = [[data objectForKey:@"isJoin"]intValue];
            if (isJoin==0) {
                [self.sign_up_btn setTitle:@"我要报名" forState:UIControlStateNormal];
            }
            else
            {
                 [self.sign_up_btn setTitle:@"已报名" forState:UIControlStateNormal];
            }
        }
        
//        if (infos.count!=0)
//        {
//            NSInteger count = infos.count;
//            
//            for (int i=0; i<count; i++) {
//                NSDictionary* d = [infos objectAtIndex:i];
//                DataModel* model = [[DataModel alloc]init];
//                
//                if (!strIsEmpty([d objectForKey:@"gdname"])) {
//                };
//            }
//        }
    }];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES withText:@"加载中" detailText:nil];
    [request_weak startAsynchronous];
}
- (IBAction)joinActivity:(UIButton *)sender
{
    NSMutableDictionary* submitData = [NSMutableDictionary dictionary];
    
    //NSUserDefaults* user = [NSUserDefaults standardUserDefaults];
    [submitData setValue:self.mgid forKey:@"atid"];
    
    NSString* url = nil;
    if (isJoin==1) {
        url = [NSString stringWithFormat:@"Activity/cancelActivity"];
    }
    else
    {
       
        url = [NSString stringWithFormat:@"Activity/joinActivity"];
    }
    UILog(@"mgid -> %@",url);
    ASIHTTPRequest* request = [HttpRequest requestPost:url Dic:submitData authorization:YES];
    
    
    __weak typeof (ASIHTTPRequest)* request_weak = request;
    
    [request setCompletionBlock:^{
        NSDictionary* dic = [[request_weak responseString]objectFromJSONString];
        int status = [[dic objectForKey:@"status"]intValue];
        if (status!=1) {
            UILog(@"%@",dic);
            NSString* info = [NSString stringWithFormat:@"%@",[dic objectForKey:@"info"]];
            ALERT_OK(info);
            return ;
        }
        
        UILog(@"%@",dic);
        
        [self loadData];
        NSString* info = [NSString stringWithFormat:@"%@",[dic objectForKey:@"info"]];
        ALERT_OK(info);
    }];
    
    //[MBProgressHUD showHUDAddedTo:self.view animated:YES withText:@"正在登录" detailText:nil];
    [request_weak startAsynchronous];
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
