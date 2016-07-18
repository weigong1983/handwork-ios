//
//  WelcomeViewController.m
//  Handwork
//
//  Created by ios on 15-4-29.
//  Copyright (c) 2015年 周文超. All rights reserved.
//

#import "WelcomeViewController.h"
#import "UIDevice+IdentifierAddition.h"

@interface WelcomeViewController ()<UIScrollViewDelegate>

@property (strong, nonatomic) IBOutlet UIScrollView *myScrollView;
@property (strong, nonatomic) IBOutlet UIPageControl *pagecontroll;

@property (strong, nonatomic) IBOutlet UIButton *btn;
@end

@implementation WelcomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)]) {
        // iOS 7
        [self prefersStatusBarHidden];
        [self performSelector:@selector(setNeedsStatusBarAppearanceUpdate)];
    }
    
    // 隐藏状态栏
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    
    UIScrollView* big_scrollView = [[UIScrollView alloc]init];
    big_scrollView.frame = (CGRect){0,0,_Screen_Width,_Screen_Height};
    big_scrollView.delegate = self;
    big_scrollView.pagingEnabled = YES;
    big_scrollView.showsHorizontalScrollIndicator = NO;
    big_scrollView.showsVerticalScrollIndicator = NO;
    big_scrollView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:big_scrollView];
    
    
    [self.navigationController setNavigationBarHidden:YES];
    NSArray* arrImage = @[@"启动页.jpg",@"启动页1.jpg",@"启动页2.jpg"];
    for (int i=0; i<arrImage.count; i++)
    {
        UIImageView* image = [[UIImageView alloc]init];
        [image setImage:[UIImage imageNamed:[arrImage objectAtIndex:i]]];
        image.frame = (CGRect){0+i*_Screen_Width,0,_Screen_Width,_Screen_Height};
        [big_scrollView addSubview:image];
    }
    [big_scrollView setContentSize:CGSizeMake(_Screen_Width*arrImage.count, 0)];
     self.pagecontroll.numberOfPages = arrImage.count;
    
    [self.view bringSubviewToFront:self.pagecontroll];
    [self.view bringSubviewToFront:self.btn];
    // Do any additional setup after loading the view from its nib.
}
- (IBAction)click:(UIButton *)sender {
//    [self.navigationController popViewControllerAnimated:YES];
    // 重新显示状态栏
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    
    //[self guestLogin:@"guest" pass:@"123456"];
    //[[NSNotificationCenter defaultCenter] postNotificationName:@"login" object:nil];
    NSString* s = nil;
    
    s = [[UIDevice currentDevice] uniqueDeviceIdentifier];
    if (_isFisrtLaunch) {
        
        [self guestLogin:s pass:nil isGuest:YES];
        
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}


-(void)guestLogin:(NSString*)username pass:(NSString*)pwd isGuest:(BOOL)guest
{
        NSMutableDictionary* dict = [NSMutableDictionary dictionary];
    
    if (guest) {
        [dict setObject:username forKey:@"appinfo"];
    }
    else
    {
        [dict setObject:username forKey:@"username"];
        [dict setObject:pwd forKey:@"password"];
    }
    
    UILog(@"dict--> %@",dict);
        NSString* url = [NSString stringWithFormat:@"Account/%@",[HttpRequest urlWithIndex:0]];
        ASIHTTPRequest* request = [HttpRequest requestPost:url Dic:dict authorization:NO];
        
        __weak typeof(ASIHTTPRequest) * request_weak = request;
        
        
        [request_weak setCompletionBlock:^{
            [MBProgressHUD hideHUDForView:self.view animated:NO];
            NSDictionary* dic = [[request_weak responseString]objectFromJSONString];
            
            NSInteger status = [[dic objectForKey:@"status"]intValue];
            if (status!=1) {
                
                //UILog(@"dict ===> %@",dic);
                [MBProgressHUD hideHUDForView:self.view animated:NO];
                NSString* info = [NSString stringWithFormat:@"%@",[dic objectForKey:@"info"]];
                ALERT_OK(info);
                return ;
            }
            //UILog(@"%@",dic);
            
            NSUserDefaults* userfaulst = [NSUserDefaults standardUserDefaults];
            NSDictionary* data = [dic objectForKey:@"data"];
            
            [userfaulst setValue:username forKey:Remember_LOCALUserName];
            [userfaulst setValue:pwd forKey:Remember_LOCALPss];
            
            BOOL first = YES;
            
            [userfaulst setBool:first forKey:Remember];
            //UILog(@"++1 %d",first);
            if ([data objectForKey:@"token"]!=nil) {
                [userfaulst setObject:[NSString stringWithFormat:@"%@",[data objectForKey:@"token"]] forKey:API_TOKEN];
                
                //NSLog(@"保存的Token  %@",[userfaulst objectForKey:@"token"]);
            }
            if ([data objectForKey:@"uid"]!=nil) {
                [userfaulst setObject:[NSString stringWithFormat:@"%@",[data objectForKey:@"uid"]]forKey:API_UID];
            }
            if (!strIsEmpty([data objectForKey:@"nickname"])) {
                [userfaulst setObject:[NSString stringWithFormat:@"%@",[data objectForKey:@"nickname"]]forKey:LOCAL_NICKNAME];
            }
            if (!strIsEmpty([data objectForKey:@"s_photo"])) {
                [userfaulst setObject:[NSString stringWithFormat:@"%@",[data objectForKey:@"s_photo"]]forKey:LOCAL_PHOTO];
            }
            
            if ([data objectForKey:@"secret"]!=nil) {
                [userfaulst setObject:[NSString stringWithFormat:@"%@",[data objectForKey:@"secret"]]forKey:API_SECRET];
                //NSLog(@"保存的API_SECRET  %@",[userfaulst objectForKey:@"secret"]);
            }
            if ([data objectForKey:@"isauth"]!=nil) {
                [userfaulst setObject:[NSString stringWithFormat:@"%@",[data objectForKey:@"isauth"]]forKey:API_ISAUTH];
                //NSLog(@"保存的API_SECRET  %@",[userfaulst objectForKey:@"secret"]);
            }
//            if ([data objectForKey:@"isauth"]!=nil) {
//                
//                //NSLog(@"保存的API_SECRET  %@",[userfaulst objectForKey:@"secret"]);
//            }
            NSString* isauth = [data objectForKey:@"isauth"];
            if ([isauth isEqualToString:@"3"]) {
                
            }
            else
            {
                [userfaulst setObject:[NSString stringWithFormat:@"%@", username]forKey:API_TOURISTS];
            }
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"home" object:nil];
        }];
        
        [request_weak setFailedBlock:^{
            
        }];
        
        [MBProgressHUD showHUDAddedTo:self.view animated:YES withText:@"正在加载" detailText:nil];
        [request_weak startAsynchronous];
}



- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSInteger page = scrollView.contentOffset.x/CGRectGetWidth(scrollView.frame);
    if (page==2) {
        self.btn.enabled = YES;
    }
    self.pagecontroll.currentPage = page;
}
//- (void)loadView {
//    [super loadView];
//    [self.navigationController setNavigationBarHidden:NO animated:YES];
//    return;
//}

- (BOOL)prefersStatusBarHidden
{
    return YES;//隐藏为YES，显示为NO
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
