//
//  TermsServiceViewController.m
//  Handwork
//
//  Created by ios on 15-5-6.
//  Copyright (c) 2015年 周文超. All rights reserved.
//

#import "TermsServiceViewController.h"
#import "API.h"

@interface TermsServiceViewController ()
@property (strong, nonatomic) IBOutlet UIWebView *webView;

@end


@implementation TermsServiceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"服务条款";
    
//    self.textView.textColor = colorToString(@"#666666");
//    self.textView.font = [UIFont systemFontOfSize:14];
    // Do any additional setup after loading the view from its nib.
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
    NSString *urlString = [NSString stringWithFormat:@"%@%@", URL_SERVICE_TERM_BASE, token];
    NSURL *url = [[NSURL alloc] initWithString:urlString];
    [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
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
