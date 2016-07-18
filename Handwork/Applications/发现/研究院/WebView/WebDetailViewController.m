

//
//  WebDetailViewController.m
//  Handwork
//
//  Created by ios on 15-5-25.
//  Copyright (c) 2015年 周文超. All rights reserved.
//

#import "WebDetailViewController.h"

@interface WebDetailViewController ()
@property (strong, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation WebDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //UILog(@"url--------?> %@",self.url);
    
    

    
    NSURL *urlBai=[NSURL URLWithString:self.url];
    
    NSURLRequest  *request=[NSURLRequest requestWithURL:urlBai];
    
    [self.webView loadRequest:request];
    
    
   // [self.webView loadHTMLString:self.url baseURL:nil];
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
