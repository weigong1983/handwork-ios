//
//  MyHomeViewController.m
//  Handwork
//
//  Created by ios on 15-5-4.
//  Copyright (c) 2015年 周文超. All rights reserved.
//

#import "MyHomeViewController.h"
#import "CollectionViewCell.h"
#import "PublishedWorksViewController.h"
#import "WorkDetailsViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "UIImage+WTExtension.h"
#import "Photo.h"

#import "PersonalHomePage.h"
#import "PersonalProfile.h"
//#import "collectionViewController.h"
#import "PersonalWorks.h"
#define UIImageNamed(imageName) [[UIImage imageNamed:[NSString stringWithFormat:@"%@", imageName]] imageWithRenderingMode:UIImageRenderingModeAutomatic]


@interface MyHomeViewController ()<PersonalWorksDelegate>
{
    NSArray* arr_btn;
//    UICollectionView* collection_works; // 所有作品
//    UICollectionView* collection; // 收藏
    NSInteger currentPage; // 0: 主页；1：简介；2：作品；3： 收藏
//    NSMutableArray* imgArr;
//    UILabel* l_address;
//    UIImageView* headImage;
//    UIImageView* img_level;
//    UILabel* l_mark;
//    UILabel* realname;
//    UIImageView* img_address;
//    UIButton* btn_voice;
//    UILabel* label;
////    NSInteger isCollect;
//    UIButton* recording;
//    UIView* bg_View;
//    UIView *recordTouchView;
    
    BOOL isRefresh;
}
//@property (strong, nonatomic) UIWebView* web;
@property (strong, nonatomic) DataModel* model;
//@property (strong, nonatomic) NSString* introduce_URL;
@property (strong, nonatomic) IBOutlet UIButton *home_btn;
@property (strong, nonatomic) IBOutlet UIView *line_v;
@property (strong, nonatomic) IBOutlet UIScrollView *scroll;
@property (strong, nonatomic) IBOutlet UIButton *Introduction_btn;
@property (strong, nonatomic) IBOutlet UIButton *works_btn;
@property (strong, nonatomic) IBOutlet UIButton *collection_btn;

@property (strong, nonatomic) UIButton* temp_btn;

@property (strong, nonatomic) PersonalHomePage* vcHomePage;
@property (strong, nonatomic) PersonalProfile* vcProfile;
@property (strong, nonatomic) PersonalWorks* vcWorks;
@property (strong, nonatomic) PersonalWorks* vcWorks2;
@end

@implementation MyHomeViewController

//static NSString *const colleCell = @"cellstr";

-(void)loadData
{
    self.model = [[DataModel alloc]init];
    //getCollects
    //getUpclicks
    ASIHTTPRequest* request = nil;
   
    NSString* url = nil;
    
    if (self.uid!=nil)
    {
       url  = [NSString stringWithFormat:@"Account/getOtherUserInfo"];
        NSMutableDictionary* submitData= [NSMutableDictionary dictionary];
        [submitData setValue:self.uid forKey:@"uid"];
        request = [HttpRequest requestPost:url Dic:submitData authorization:YES];
    }
    else
    {
        // peopleCard
        url = [NSString stringWithFormat:@"Account/getUserInfo"];
      request  = [HttpRequest requestPost:url Dic:nil authorization:YES];

    }
    
   
    __weak typeof (ASIHTTPRequest)* request_weak = request;
    
    [request setCompletionBlock:^{
        NSDictionary* dic = [[request_weak responseString]objectFromJSONString];
        
        int status = [[dic objectForKey:@"status"]intValue];
        [self isDistance:status];
        if (status!=1) {
            
            NSString* info = [NSString stringWithFormat:@"%@",[dic objectForKey:@"info"]];
            ALERT_OK(info)
            return ;
        }
        NSDictionary* data = [dic objectForKey:@"data"];
        //13500008324 123456
        //UILog(@" data-> %@",data);

        if (!strIsEmpty([data objectForKey:@"introduce"])) {
            self.vcProfile.url = [data objectForKey:@"introduce"];
            
            
        }
        
        if (!strIsEmpty([data objectForKey:@"photo"])) {
            self.model.s_photo= [data objectForKey:@"photo"];
        }
        
        if (!strIsEmpty([data objectForKey:@"province"]))
        {
            NSString* s_address = [NSString stringWithFormat:@"%@",[data objectForKey:@"province"]];
            
            if (!strIsEmpty([data objectForKey:@"city"])) {
                s_address = [NSString stringWithFormat:@"%@%@",[data objectForKey:@"province"],[data objectForKey:@"city"]];
            }
            if (!strIsEmpty([data objectForKey:@"district"])) {
                s_address = [NSString stringWithFormat:@"%@%@%@",[data objectForKey:@"province"],[data objectForKey:@"city"],[data objectForKey:@"district"]];
            }
            
            self.model.s_address =  s_address;
        }
        
        else{
        }
        
        if (!strIsEmpty([data objectForKey:@"nickname"])) {
            self.model.s_nickname = [data objectForKey:@"nickname"];
            self.title = self.model.s_nickname;
            
            if (!strIsEmpty([data objectForKey:@"signature"]))
            {
                self.model.s_signature = [data objectForKey:@"signature"];
            }
        }

        
        if (!strIsEmpty([data objectForKey:@"callname"])) {
            self.model.s_callname= [data objectForKey:@"callname"];
        }
        
        if (!strIsEmpty([data objectForKey:@"voicepath"])) {
            self.model.s_voicepath= [data objectForKey:@"voicepath"];
            
            
            //UILog(@"voicepath %@",[data objectForKey:@"voicepath"]);
        }
      
        if (!strIsEmpty([data objectForKey:@"voicetype"])) {
            self.model.s_voicetype =[data objectForKey:@"voicetype"];
        }
        
        self.vcHomePage.model = self.model;
        
        [self.vcHomePage loadData];
        
        [self.vcProfile loadData];
        
        [MBProgressHUD hideHUDForView:self.view animated:NO];
    }];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES withText:@"正在加载" detailText:nil];
    [request_weak startAsynchronous];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    CGRect frame = _scroll.frame;
    
    int width = frame.size.width;
    int height = frame.size.height;
    
    //UILog(@"height +++++ %d",height);
    //NSString* url = nil;
    {
       self.vcHomePage = [[PersonalHomePage alloc]init];
        
        if (self.uid!=nil) {
            self.vcHomePage.uid = self.uid;
        }

        self.vcHomePage.view.frame = CGRectMake(0, 0, width, height);
        [self.scroll addSubview:self.vcHomePage.view];
    }
    {
        self.vcProfile = [[PersonalProfile alloc]init];
        
        self.vcProfile.view.frame = CGRectMake(_Screen_Width, 0, width, height);
        [self.scroll addSubview:self.vcProfile.view];
    }
    
    {
        self.vcWorks = [[PersonalWorks alloc]init];
        self.vcWorks.uid = self.uid;
        self.vcWorks.delegate = self;
        self.vcWorks.isCollect = @"0";
        self.vcWorks.view.frame = CGRectMake(_Screen_Width*2, 0, width, height);
        self.vcWorks2.height =height;
       [self.scroll addSubview:self.vcWorks.view];
    }
    {
        self.vcWorks2 = [[PersonalWorks alloc]init];
        self.vcWorks2.uid = self.uid;
        self.vcWorks2.isCollect = @"1";
        
        self.vcWorks2.delegate =self;
        
        self.vcWorks2.view.frame = CGRectMake(_Screen_Width*3, 0, width, height);
        self.vcWorks2.height =height;
        [self.scroll addSubview:self.vcWorks2.view];
    }
    
    [self.scroll setContentSize:CGSizeMake(_Screen_Width*4,0)];

    arr_btn = [[NSArray alloc]initWithObjects:self.home_btn, self.Introduction_btn,self.works_btn,self.collection_btn,nil];
    
    isRefresh = YES;
 
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    if(isRefresh)
    {
        isRefresh = NO;
        
         [self loadData];
        
        
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{

}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{

    if ([scrollView isKindOfClass:[UIScrollView class]]) {
        CGFloat pageWidth = CGRectGetWidth(scrollView.frame);
        NSUInteger page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
        //self.myPageControl.currentPage = page;
        //NSLog(@"当前页面 = %d",page);
        [self effect:page];
    }
}

-(void)effect:(NSInteger)page
{
    // 记录当前标签页
    currentPage = page;
    
    if (self.temp_btn.tag!=page) {
        self.temp_btn.selected = NO;
    }
    else
    {
        return;
    }

    self.temp_btn = [arr_btn objectAtIndex:page];
    
    self.temp_btn.selected = YES;
    
    //[self.temp_btn setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
    
    [self.line_v setLeft:currentPage*(_Screen_Width/4)];
    
//    UILog(@"%ld",(long)page);
}
//-(UIColor *)randomColor{
//    static BOOL seed = NO;
//    if (!seed) {
//        seed = YES;
//        srandom(time(NULL));
//    }
//    CGFloat red = (CGFloat)random()/(CGFloat)RAND_MAX;
//    CGFloat green = (CGFloat)random()/(CGFloat)RAND_MAX;
//    CGFloat blue = (CGFloat)random()/(CGFloat)RAND_MAX;
//    return [UIColor colorWithRed:red green:green blue:blue alpha:1.0f];//alpha为1.0,颜色完全不透明
//}
- (IBAction)btn_click:(UIButton *)sender
{
    [self effect:sender.tag];
    //[self.scroll setContentOffset:CGPointMake((sender.tag)*_Screen_Width, 0)];
    [self.scroll setContentOffset:CGPointMake((sender.tag)*_Screen_Width,0) animated:YES];
}
-(void)didSelectItemAtIndexPath:(NSIndexPath *)indexPath andData:(NSArray*)dataArr
{
    WorkDetailsViewController* vc= [[WorkDetailsViewController alloc]init];
    DataModel* model = [dataArr objectAtIndex:indexPath.row];
    vc.mgid = model.s_mgid;
    [self.navigationController pushViewController:vc animated:YES];
    
}
-(void)dealloc
{
    self.model = nil;
    self.vcHomePage = nil;
    self.vcWorks = nil;
    self.vcProfile = nil;
    UILog(@"delloc");
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
