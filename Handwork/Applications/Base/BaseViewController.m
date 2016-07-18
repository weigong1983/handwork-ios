//
//  BaseViewController.m
//  Handwork
//
//  Created by ios on 15-4-29.
//  Copyright (c) 2015年 周文超. All rights reserved.
//

#import "BaseViewController.h"
#import "VoiceConverter.h"
#import "FileTools.h"


@interface BaseViewController ()<UIAlertViewDelegate,UIGestureRecognizerDelegate>
{
     NSString* tourists;
}

@property (nonatomic, weak)	UIView* scrollableView;
@property (assign, nonatomic) float lastContentOffset;
@property (strong, nonatomic) UIPanGestureRecognizer* panGesture;
@property (strong, nonatomic) UIView* overlay;
@property (assign, nonatomic) BOOL isCollapsed;
@property (assign, nonatomic) BOOL isExpanded;

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = RGB_MAKE(237, 237, 237);
    // Do any additional setup after loading the view from its nib.
}

-(NSString*)s_writeToFile:(NSString*)s
{
    NSString *urlStr =s;
    
    NSURL *url = [[NSURL alloc]initWithString:urlStr];
    
    NSData * audioData = [NSData dataWithContentsOfURL:url];
    
    //将数据保存到本地指定位置
    NSString *docDirPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    NSString *filePath = [NSString stringWithFormat:@"%@/%@.amr", docDirPath , @"record"];
    
    if ([FileTools fileExistsAtPath:filePath]) {
        UILog(@"不用解压");
    }
    else
    {
        if ([audioData writeToFile:filePath atomically:YES]) {
            //[MBProgressHUD hideHUDForView:self.view animated:NO];
            
            //fileURL = [NSURL fileURLWithPath:filePath];
            UILog(@"解压成功 %@",filePath);
            //self.model.s_voicepath = filePath;
        }
    }
    
    
    
    //UILog(@"原来! docDirPath = %@",docDirPath);
    
    //UILog(@"写入成功! conversion = %@",conversion);
    
    return filePath;
}



- (void)followScrollView:(UIView*)scrollableView
{
    self.scrollableView = scrollableView;
    
    self.panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    [self.panGesture setMaximumNumberOfTouches:1];
    
    [self.panGesture setDelegate:self];
    [self.scrollableView addGestureRecognizer:self.panGesture];
    
    /* The navbar fadeout is achieved using an overlay view with the same barTintColor.
     this might be improved by adjusting the alpha component of every navbar child */
    
    CGRect frame = self.navigationController.navigationBar.frame;
    
    frame.origin = CGPointZero;
    
    self.overlay = [[UIView alloc] initWithFrame:frame];
    
    if (!self.navigationController.navigationBar.barTintColor)
    {
        //NSLog(@"[%s]: %@", __func__, @"Warning: no bar tint color set");
    }
    [self.overlay setBackgroundColor:self.navigationController.navigationBar.barTintColor];
    [self.overlay setUserInteractionEnabled:NO];
    [self.navigationController.navigationBar addSubview:self.overlay];
    [self.overlay setAlpha:0];
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

- (void)handlePan:(UIPanGestureRecognizer*)gesture
{
    CGPoint translation = [gesture translationInView:[self.scrollableView superview]];
    
    float delta = self.lastContentOffset - translation.y;
    self.lastContentOffset = translation.y;
    
    CGRect frame;
    
    if (delta > 0) {
        if (self.isCollapsed) {
            return;
        }
        
        frame = self.navigationController.navigationBar.frame;
        
        //UILabel *t = (UILabel*)self.navigationController.navigationItem.titleView;
        
        
        
        
        if (frame.origin.y - delta < -24) {
            delta = frame.origin.y + 24;
            //t.alpha = 0;
        }
        
        frame.origin.y = MAX(-24, frame.origin.y - delta);
        self.navigationController.navigationBar.frame = frame;
        
        if (frame.origin.y == -24) {
            self.isCollapsed = YES;
            self.isExpanded = NO;
        }
        
        [self updateSizingWithDelta:delta];
        
        // Keeps the view's scroll position steady until the navbar is gone
        if ([self.scrollableView isKindOfClass:[UIScrollView class]]) {
            [(UIScrollView*)self.scrollableView setContentOffset:CGPointMake(((UIScrollView*)self.scrollableView).contentOffset.x, ((UIScrollView*)self.scrollableView).contentOffset.y - delta)];
        }
    }
    
    if (delta < 0) {
        if (self.isExpanded) {
            return;
        }
        
        frame = self.navigationController.navigationBar.frame;
        
        if (frame.origin.y - delta > 20) {
            delta = frame.origin.y - 20;
        }
        frame.origin.y = MIN(20, frame.origin.y - delta);
        self.navigationController.navigationBar.frame = frame;
        
        if (frame.origin.y == 20) {
            self.isExpanded = YES;
            self.isCollapsed = NO;
        }
        
        [self updateSizingWithDelta:delta];
    }
    
    if ([gesture state] == UIGestureRecognizerStateEnded) {
        // Reset the nav bar if the scroll is partial
        self.lastContentOffset = 0;
        [self checkForPartialScroll];
    }
}

- (void)checkForPartialScroll
{
    CGFloat pos = self.navigationController.navigationBar.frame.origin.y;
    
    // Get back down
    if (pos >= -2) {
        [UIView animateWithDuration:0.2 animations:^{
            CGRect frame;
            frame = self.navigationController.navigationBar.frame;
            CGFloat delta = frame.origin.y - 20;
            frame.origin.y = MIN(20, frame.origin.y - delta);
            self.navigationController.navigationBar.frame = frame;
            
            self.isExpanded = YES;
            self.isCollapsed = NO;
            
            [self updateSizingWithDelta:delta];
            
            // This line needs tweaking
            // [self.scrollView setContentOffset:CGPointMake(self.scrollView.contentOffset.x, self.scrollView.contentOffset.y - delta) animated:YES];
        }];
    } else {
        // And back up
        [UIView animateWithDuration:0.2 animations:^{
            CGRect frame;
            frame = self.navigationController.navigationBar.frame;
            CGFloat delta = frame.origin.y + 24;
            frame.origin.y = MAX(-24, frame.origin.y - delta);
            self.navigationController.navigationBar.frame = frame;
            
            self.isExpanded = NO;
            self.isCollapsed = YES;
            
            [self updateSizingWithDelta:delta];
        }];
    }
}

- (void)updateSizingWithDelta:(CGFloat)delta
{
    CGRect frame = self.navigationController.navigationBar.frame;
    
    float alpha = (frame.origin.y + 24) / frame.size.height;
    [self.overlay setAlpha:1 - alpha];
    self.navigationController.navigationBar.tintColor = [self.navigationController.navigationBar.tintColor colorWithAlphaComponent:alpha];
    
    frame = self.scrollableView.superview.frame;
    frame.origin.y = self.navigationController.navigationBar.frame.origin.y + self.navigationController.navigationBar.frame.size.height;
    frame.size.height = frame.size.height + delta;
    self.scrollableView.superview.frame = frame;
    
    // Changing the layer's frame avoids UIWebView's glitchiness
    frame = self.scrollableView.layer.frame;
    frame.size.height += delta;
    self.scrollableView.layer.frame = frame;
}

/**
 * 判断是否游客访问模式
 */
-(BOOL)IS_Guest
{
    NSUserDefaults* USER = [NSUserDefaults standardUserDefaults];
    
    NSString* s = @"guest";
    
    if ([s isEqualToString:[USER objectForKey:API_TOURISTS]])
    {
        return YES;
    }
    return NO;
}


/**
 * 判断是否游客访问模式
 */
-(BOOL)Check_Guest
{
    if ([self IS_Guest])
    {
        //ALERT_OK(@"你是游客请先注册!");
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"温馨提示!" message:@"您当前是游客身份，立即注册成为会员？" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
        [alert show];
        return YES;
    }
    return NO;
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==0) {
        NSUserDefaults* userfaulst = [NSUserDefaults standardUserDefaults];
        BOOL fire = NO;
        [userfaulst setBool:fire forKey:Remember];
        UILog(@"%d",fire);
        [[NSNotificationCenter defaultCenter] postNotificationName:@"login" object:nil];
    }
    
    //UILog(@"%d",buttonIndex);
}
//异地登录
-(void)isDistance:(NSInteger)code
{
    
    
    //UILog(@"++++++++++++    %d",code);
    if (code!=1)
    {
        if (code==STATUS_INVALID)
        {
            NSUserDefaults* userfaulst = [NSUserDefaults standardUserDefaults];
            BOOL fire = NO;
            [userfaulst setBool:fire forKey:Remember];
            UILog(@"%d",fire);
            
            [TipsHud ShowTipsHud:@"此账号在异地登陆，请重新登录!"  :self.view];
            [self performSelector:@selector(reLogin) withObject:nil afterDelay:1.0f];
            return ;
        }
        
        
        else
        {
            //ALERT_OK(@"异常错误!");
            return;
        }
        
        return;
    }
}

// 重新登陆
-(void)reLogin
{
   [[NSNotificationCenter defaultCenter] postNotificationName:@"login" object:nil];
}


-(BOOL)isUidToString:(NSString*)uid
{
    NSUserDefaults* userdefaults = [NSUserDefaults standardUserDefaults];
    NSString* s_uid =  [userdefaults objectForKey:API_UID];
    
    
    UILog(@"uid %@\n uid%@",s_uid,uid);
    if ([s_uid isEqualToString:uid])
    {
        
        return YES;
    }
    else
    {
        return NO;
    }
    
}

- (BOOL) isBlankString:(NSString *)string {
    if (string == nil || string == NULL){
        return YES;
    }
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
        return YES;
    }
    return NO;
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
