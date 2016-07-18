//
//  PublishedWorksViewController.m
//  Handwork
//
//  Created by apple on 15-5-9.
//  Copyright (c) 2015年 周文超. All rights reserved.
//

#import "PublishedWorksViewController.h"

@interface PublishedWorksViewController ()
@property (strong, nonatomic) IBOutlet UILabel *label1;
@property (strong, nonatomic) IBOutlet UILabel *label2;

@end

@implementation PublishedWorksViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"发表作品";
//    self.label1.textColor = colorToString(@"#333333");
//    self.label2.textColor = colorToString(@"#333333");
    // Do any additional setup after loading the view from its nib.
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
