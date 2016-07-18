//
//  PersonalProfile.m
//  Handwork
//
//  Created by ios on 15-6-15.
//  Copyright (c) 2015年 周文超. All rights reserved.
//

#import "PersonalProfile.h"

@interface PersonalProfile ()
@property (strong, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation PersonalProfile

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //UILog(@"self.url %@",self.url);
    
    // Do any additional setup after loading the view from its nib.
}
-(void)loadData
{
    NSURL* url_url = [NSURL URLWithString:self.url];
    
    NSURLRequest* request = [NSURLRequest requestWithURL:url_url];
    
    [self.webView loadRequest:request];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)dealloc
{
    self.webView = nil;
    
    UILog(@"delloc");
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
