//
//  ProductionProcessViewController.m
//  Handwork
//
//  Created by ios on 15-5-5.
//  Copyright (c) 2015年 周文超. All rights reserved.
//

#import "ProductionProcessViewController.h"

@interface ProductionProcessViewController ()
@property (strong, nonatomic) IBOutlet UITextView *textView;
@property (strong, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation ProductionProcessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"作品制作流程";
//    self.textView.text = self.madeflowinfo;
//    self.textView.textColor = colorToString(@"#666666");
//    self.textView.font = [UIFont systemFontOfSize:14];
    // Do any additional setup after loading the view from its nib.
  //self.madeflowinfo
    NSURL *url = [[NSURL alloc] initWithString:self.madeflowinfo];
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
