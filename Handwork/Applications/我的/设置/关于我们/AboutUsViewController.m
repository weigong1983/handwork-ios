//
//  AboutUsViewController.m
//  Handwork
//
//  Created by ios on 15-5-4.
//  Copyright (c) 2015年 周文超. All rights reserved.
//

#import "AboutUsViewController.h"
#import "TermsServiceViewController.h"
#import "WelcomeViewController.h"
#import "StringUtils.h"

@interface AboutUsViewController ()
@property (strong, nonatomic) IBOutlet UILabel *version_label;
@property (strong, nonatomic) IBOutlet UILabel *label2;
@property (strong, nonatomic) IBOutlet UILabel *label1;
@property (strong, nonatomic) IBOutlet UILabel *label3;
@property (strong, nonatomic) IBOutlet UIView *lineV;

@end

@implementation AboutUsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.label3.textColor = colorToString(@"#999999");
    self.label3.font = [UIFont systemFontOfSize:14];
    self.title = @"关于我们";
    self.label2.textColor = colorToString(@"#333333");
    self.label1.textColor = colorToString(@"#333333");
    self.version_label.textColor = colorToString(@"#999999");
    self.version_label.text = [NSString stringWithFormat:@"V %@", [StringUtils getAppVersion]];
    
    
    self.lineV.backgroundColor = colorToString(@"#dddddd");
    // Do any additional setup after loading the view from its nib.
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
}

- (IBAction)btn_click:(UIButton *)sender {
    //UILog(@"%ld",sender.tag);
    if (sender.tag==1) {
        TermsServiceViewController* vc = [[TermsServiceViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    if (sender.tag==0) {
        WelcomeViewController* vc = [[WelcomeViewController alloc]init];
        vc.isFisrtLaunch = false;
        [self.navigationController pushViewController:vc animated:YES];
    }
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
