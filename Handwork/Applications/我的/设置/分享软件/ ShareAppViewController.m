//
//  TermsServiceViewController.m
//  Handwork
//
//  Created by ios on 15-5-6.
//  Copyright (c) 2015年 周文超. All rights reserved.
//

#import "ShareAppViewController.h"
#import "API.h"

@interface  ShareAppViewController ()
@property (strong, nonatomic) IBOutlet UIWebView *webView;

@end


@implementation ShareAppViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 添加分享按钮
    if ([CURRENT_CHANNEL_ID isEqualToString:CHANNEL_PGYER])
    {
        UIButton *shareBtn =[UIButton buttonWithType:UIButtonTypeCustom];
        [shareBtn setFrame:CGRectMake(0, 0, 25, 25)];
        [shareBtn setBackgroundImage:[UIImage imageNamed:@"title_share.png"] forState:UIControlStateNormal];
        [shareBtn addTarget:self action:@selector(doShare) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem * shareItemBtn = [[UIBarButtonItem alloc]initWithCustomView:shareBtn];
        self.navigationItem.rightBarButtonItem = shareItemBtn;
    }

    self.title = @"分享软件";
    NSURL *url = [[NSURL alloc] initWithString:URL_APP_DOWNLOAD];
    [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
}

// 分享软件
-(void)doShare
{
    // 分享内容文案： 我正在使用手作品App，它是国内领先的手工艺O2O平台。下载地址：http://app.shouzuopin.com/
    //[TipsHud ShowTipsHud:@"分享手作品App" :self.view];
    
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
