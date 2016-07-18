//
//  HomePageViewController.m
//  Handwork
//
//  Created by ios on 15-4-29.
//  Copyright (c) 2015年 周文超. All rights reserved.
//

#import "HomePageViewController.h"
#import "HomeTableViewCell.h"
#import "EventDetails.h"
#import "WorkDetailsViewController.h"
#import "savingAndCommentsList.h"
#import "MyHomeViewController.h"

#import "DataModel.h"
#import "AdvertisingColumn.h"
#import "UIImageView+WebCache.h"
#import "XHImageViewer.h"
#import "Photo.h"
#import "ASIFormDataRequest.h"


#import "UITabBarController+hidable.h"
#import "RNFullScreenScroll.h"
#import "UIViewController+RNFullScreenScroll.h"

@interface HomePageViewController ()<AdvertisingColumnDelegate,XHImageViewerDelegate>
{
    NSMutableArray* savingArr;
    NSMutableArray* upclickcountArr;
    NSMutableArray* dataArr;
    
    NSMutableArray* activityArr;
    AdvertisingColumn* _headerView;
    NSArray* imgArray;
    
    NSMutableArray* mgidArr;
    
    __weak IBOutlet UIButton *top_btn;
    BOOL updataRowAndAll;
    
    NSInteger page;
    NSInteger hasMore;
    FeThreeDotGlow* _threeDot;
    
    NSString *trackViewURL;
    
}
@property (strong, nonatomic) IBOutlet UITableView *myTableView;

@end

@implementation HomePageViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
//    return;
    top_btn.layer.cornerRadius = 5;
    top_btn.layer.masksToBounds = YES;
    top_btn.layer.borderColor = [[UIColor whiteColor]CGColor];
    top_btn.layer.borderWidth = 1;
    
//    [self.myTableView setTop:-20];
//    [self.myTableView setHeight:self.myTableView.height+20];
    
    self.fullScreenScroll = [[RNFullScreenScroll alloc] initWithViewController:self scrollView:self.myTableView];
    
    //[self.navigationController.navigationBar setTranslucent:NO];
    //[self followScrollView:self.scrollView];
    [self.navigationController.navigationBar setBarTintColor:RGB_MAKE(192, 6, 2)];
    //[self followScrollView:self.myTableView];
    
    self.isRefresh = YES;
    
    savingArr = [[NSMutableArray alloc]init];
    dataArr = [[NSMutableArray alloc]init];
    mgidArr = [[NSMutableArray alloc]init];
    
    [self.myTableView setBackgroundColor:[UIColor clearColor]];
    activityArr = [[NSMutableArray alloc]init];
    upclickcountArr = [[NSMutableArray alloc]init];
    _headerView = [[AdvertisingColumn alloc]initWithFrame:CGRectMake(0,0,_Screen_Width, 128 + PADDING_BOTTOM)];
    _headerView.backgroundColor = [UIColor blackColor];
    _headerView.delegate =self;
    
    [self getTopactivity];
    
    [self setupRefresh];
    // Do any additional setup after loading the view from its nib.
    
    
    // 检测版本更新
    [self checkVersion];
    
    //self.view.backgroundColor = [UIColor redColor];
}

/*
 * 检测APP版本更新
 */
-(void)checkVersion
{
    ASIFormDataRequest* request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:APPSTORE_URL]];
    __weak typeof(ASIHTTPRequest)* weak_request = request;
    [weak_request setCompletionBlock:^{
        NSDictionary* resultDic = [[weak_request responseString] objectFromJSONString];
        
        NSArray *infoArray = [resultDic objectForKey:@"results"];
        if (infoArray.count > 0) {
            
            NSDictionary* releaseInfo =[infoArray objectAtIndex:0];
            NSString* appStoreVersion = [releaseInfo objectForKey:@"version"];
            NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
            NSString *currentVersion = [infoDic objectForKey:@"CFBundleShortVersionString"];
            
            NSArray *curVerArr = [currentVersion componentsSeparatedByString:@"."];
            NSArray *appstoreVerArr = [appStoreVersion componentsSeparatedByString:@"."];
            BOOL needUpdate = NO;
            //比较版本号大小
            int maxv = (int)MAX(curVerArr.count, appstoreVerArr.count);
            int cver = 0;
            int aver = 0;
            for (int i = 0; i < maxv; i++) {
                if (appstoreVerArr.count > i) {
                    aver = [NSString stringWithFormat:@"%@",appstoreVerArr[i]].intValue;
                }
                else{
                    aver = 0;
                }
                if (curVerArr.count > i) {
                    cver = [NSString stringWithFormat:@"%@",curVerArr[i]].intValue;
                }
                else{
                    cver = 0;
                }
                if (aver > cver) {
                    needUpdate = YES;
                    break;
                }
            }
            
            trackViewURL = [[NSString alloc] initWithString:[releaseInfo objectForKey:@"trackViewUrl"]];//trackViewURL临时变量存储app下载地址，可以让app跳转到appstore

            // 当前是蒲公英渠道版本&&开启了测试版检测开关，提示用户到苹果应用商店升级新版本
            if ([CURRENT_CHANNEL_ID isEqualToString:CHANNEL_PGYER]
                && CHECK_TEST_VERSION == 1)
            {
                UIAlertView* alertview =[[UIAlertView alloc] initWithTitle:@"版本提示" message:[NSString stringWithFormat:@"您当前使用的是内测版本，请前往苹果应用商店升级官方正式版本？"] delegate:self cancelButtonTitle:@"下次再说" otherButtonTitles:@"马上升级", nil];
                [alertview show];
                return ;
            }
            
            // 当前是苹果商店正式版本，提示更新
            if ([CURRENT_CHANNEL_ID isEqualToString:CHANNEL_APPSTORE])
            {
                //如果有可用的更新
                if (needUpdate){
                    UIAlertView* alertview =[[UIAlertView alloc] initWithTitle:@"版本升级" message:[NSString stringWithFormat:@"发现新版本，是否升级？"] delegate:self cancelButtonTitle:@"暂不升级" otherButtonTitles:@"马上升级", nil];
                    [alertview show];
                }
            }
        }
    }];
    
    [weak_request startAsynchronous];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1){
        UIApplication *application = [UIApplication sharedApplication];
        [application openURL:[NSURL URLWithString:trackViewURL]];
    }
}



- (void)setupRefresh
{
    // 1.下拉刷新(进入刷新状态就会调用self的headerRereshing)
    [self.myTableView addHeaderWithTarget:self action:@selector(headerRereshing)];
    //#warning 自动刷新(一进入程序就下拉刷新)
    //       [self.myTableView headerBeginRefreshing];
    
    // 2.上拉加载更多(进入刷新状态就会调用self的footerRereshing)
    [self.myTableView addFooterWithTarget:self action:@selector(footerRereshing)];
    
    // 设置文字(也可以不设置,默认的文字在MJRefreshConst中修改)
    self.myTableView.headerPullToRefreshText = @"下拉刷新";
    self.myTableView.headerReleaseToRefreshText = @"松开刷新";
    self.myTableView.headerRefreshingText = @"正在刷新...";
    
    self.myTableView.footerPullToRefreshText = @"上拉加载更多数据";
    self.myTableView.footerReleaseToRefreshText = @"松开加载更多数据";
    self.myTableView.footerRefreshingText = @"加载中...";
}
-(void)headerRereshing
{

    page = 0;
    
    [dataArr removeAllObjects];
    [upclickcountArr removeAllObjects];
    [savingArr removeAllObjects];
    
    [self loadData];

    // 2.2秒后刷新表格UI
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 刷新表格
        //[self.myTableView reloadData];
        
        // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
        [self.myTableView headerEndRefreshing];
    });
}

-(void)backToTop
{
    [self.myTableView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:YES];
}


-(void)footerRereshing
{
    if (hasMore==0) {
        //ALERT_OK(@"已经是全部数据了");
        [TipsHud ShowTipsHud:@"回到第一个作品" :self.view];
        [self.myTableView footerEndRefreshing];
        [self performSelector:@selector(backToTop) withObject:nil afterDelay:1.5];
    }
    else
    {
        page +=1;
        //UILog(@"dataArr--> %lu  page%ld",(unsigned long)dataArr.count,(long)page);
        //UILog(@"hasMore %ld",(long)hasMore);
        //[self initDataAndSort:@"99" andFirstload:@"1" andstyle:@"01"];
        [self loadData];
        // 2.2秒后刷新表格UI
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            // 刷新表格
            //[self.myTableView reloadData];
            
            // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
            [self.myTableView footerEndRefreshing];
            
        });
    }
}

-(void)TestApi
{
    NSString* url = [NSString stringWithFormat:@"Works/getWorksUpclicks"];
    
    
    ASIHTTPRequest* request = [HttpRequest requestPost:url Dic:nil authorization:YES];
    
    __weak typeof (ASIHTTPRequest)* request_weak = request;
    
    [request setCompletionBlock:^{
        NSDictionary* dic = [[request_weak responseString]objectFromJSONString];
        int status = [[dic objectForKey:@"status"]intValue];
        
        if (status!=0)
        {
            NSString* info =[NSString stringWithFormat:@"%@",[dic objectForKey:@"info"]];
            ALERT_OK(info);
        }
        //UILog(@"获得-> %@",dic);
        
    }];
    [request_weak startAsynchronous];
}


-(void)getTopactivity
{
    NSString* url = [NSString stringWithFormat:@"%@/%@",[HttpRequest urlModule:2],[HttpRequest urlWithIndex:2]];
    ASIHTTPRequest* request = [HttpRequest requestPost:url Dic:nil authorization:YES];
    
    __weak typeof (ASIHTTPRequest)* request_weak = request;
    
    [request setCompletionBlock:^{
        NSDictionary* dic = [[request_weak responseString]objectFromJSONString];
        //UILog(@"获得-> %@",dic);
        NSInteger status = [[dic objectForKey:@"status"]intValue];
        
        [self isDistance:status];
        
        if (status!=1){
            NSString* info = [NSString stringWithFormat:@"%@",[dic objectForKey:@"info"]];
            //ALERT_OK(info);
            return ;
        }
        [MBProgressHUD hideHUDForView:self.view animated:NO];
        NSDictionary* data = [dic objectForKey:@"data"];
        
        NSArray* infos = [data objectForKey:@"infos"];
        
        [mgidArr removeAllObjects];
        [activityArr removeAllObjects];
        if (infos.count!=0) {
            
            NSInteger count = infos.count;
            
            for (int i=0; i<count; i++){
                NSDictionary* d = [infos objectAtIndex:i];
                //DataModel* model = [[DataModel alloc]init];
                if (!strIsEmpty([d objectForKey:@"m_image"])) {
                    //model.s_image =[NSString stringWithFormat:@"%@",[d objectForKey:@"image"]];
                    NSString* s = [NSString stringWithFormat:@"%@",[d objectForKey:@"m_image"]];
                    [activityArr addObject:s];
                };
                
                if (!strIsEmpty([d objectForKey:@"id"])) {
                    //model.s_image =[NSString stringWithFormat:@"%@",[d objectForKey:@"image"]];
                    NSString* s = [NSString stringWithFormat:@"%@",[d objectForKey:@"id"]];
                    [mgidArr addObject:s];
                };
               
            }
        }
        if (activityArr.count!=0)
        {
            [_headerView setArray:activityArr];
            self.myTableView.tableHeaderView = _headerView;
        }
        
    }];
    
 
    [MBProgressHUD showHUDAddedTo:self.view animated:YES withText:@"正在加载" detailText:nil];
    
    [request_weak startAsynchronous];
}


-(void)loadData
{
    NSMutableDictionary* submitData = [NSMutableDictionary dictionary];
    
    //NSUserDefaults* user = [NSUserDefaults standardUserDefaults];
    NSString* s_page = [NSString stringWithFormat:@"%ld",(long)page];
    [submitData setValue:s_page forKey:@"page"];
    
    //UILog(@"UID -> %@",[user objectForKey:API_UID]);
    NSString* url = [NSString stringWithFormat:@"%@/%@",[HttpRequest urlModule:1],[HttpRequest urlWithIndex:1]];
   
    ASIHTTPRequest* request = [HttpRequest requestPost:url Dic:submitData authorization:YES];
    
    
    __weak typeof (ASIHTTPRequest)* request_weak = request;
    
    [request setCompletionBlock:^{
        
        NSDictionary* dic = [[request_weak responseString]objectFromJSONString];
        //[MBProgressHUD hideHUDForView:self.view animated:NO];
        
        int status = [[dic objectForKey:@"status"]intValue];
        
        //[self isDistance:status];
        [self isDistance:status];
        if (status!=1) {
            
            return ;
        }
        
        
        
        NSDictionary* data = [dic objectForKey:@"data"];
        
        
        hasMore = [[data objectForKey:@"hasMore"]intValue];
        //UILog(@"获得-> %@",dic);
        
        NSArray* infos = [data objectForKey:@"infos"];
        
        if (infos.count!=0)
        {
            NSInteger count = infos.count;
            for (int i=0; i<count; i++) {
                NSDictionary* d = [infos objectAtIndex:i];
                DataModel* model = [[DataModel alloc]init];
                
                if (![self isBlankString:[d objectForKey:@"gdname"]]) {
                    model.s_gdname =[NSString stringWithFormat:@"%@",[d objectForKey:@"gdname"]];
                };
                if (![self isBlankString:[d objectForKey:@"nickname"]]) {
                    model.s_nickname =[NSString stringWithFormat:@"%@",[d objectForKey:@"nickname"]];
                };
                if (![self isBlankString:[d objectForKey:@"s_photo"]]) {
                    model.s_photo =[NSString stringWithFormat:@"%@",[d objectForKey:@"s_photo"]];
                };
                
                if (![self isBlankString:[d objectForKey:@"gdview"]]) {
                    model.s_gdview =[NSString stringWithFormat:@"%@",[d objectForKey:@"gdview"]];
                };
                if (![self isBlankString:[d objectForKey:@"remsgcount"]]) {
                    model.s_remsgcount =[NSString stringWithFormat:@"%@",[d objectForKey:@"remsgcount"]];
                };
                if (![self isBlankString:[d objectForKey:@"upclickcount"]]) {
                    model.s_upclickcount =[NSString stringWithFormat:@"%@",[d objectForKey:@"upclickcount"]];
                    [upclickcountArr addObject:model.s_upclickcount];
                };
                
                if (![self isBlankString:[d objectForKey:@"m_image"]]) {
                    model.s_image =[NSString stringWithFormat:@"%@",[d objectForKey:@"m_image"]];
                    
                };
                
                // 填充色
                if (![self isBlankString:[d objectForKey:@"color"]]) {
                    model.fillColor =[NSString stringWithFormat:@"%@",[d objectForKey:@"color"]];
                    
                    
                };
                
                if (![self isBlankString:[d objectForKey:@"mgid"]]) {
                    model.s_mgid =[NSString stringWithFormat:@"%@",[d objectForKey:@"mgid"]];
                };
                
                if ([d objectForKey:@"isupclick"]!=nil) {
                    model.s_isupclick =[NSString stringWithFormat:@"%@",[d objectForKey:@"isupclick"]];
                    [savingArr addObject:model.s_isupclick];
                };
                if ([d objectForKey:@"uid"]!=nil) {
                    model.s_uid =[NSString stringWithFormat:@"%@",[d objectForKey:@"uid"]];
                    
                };
                
                [dataArr addObject:model];
            }
        
        }
         //return;
        [self.myTableView reloadData];
        //            UILog(@"dataArr %d",dataArr.count);
        //            UILog(@"savingArr%d",savingArr.count);
        //            UILog(@"upclickcountArr%d",upclickcountArr.count);
    }];
    
    //[MBProgressHUD showHUDAddedTo:self.view animated:YES withText:@"正在加载" detailText:nil];
    [request_weak startAsynchronous];
    
    
    //[MBProgressHUD showHUDAddedTo:self.view animated:YES withText:@"正在加载" detailText:nil];
 
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
-(void)didClickPage:(AdvertisingColumn *)view atIndex:(NSInteger)index
{
 
//    XHImageViewer *imageViewer = [[XHImageViewer alloc] init];
//    imageViewer.delegate = self;
//    [imageViewer showWithImageViews:view.ImageArr selectedView:[view.ImageArr objectAtIndex:index]];
    //UILog(@"%d",index);
    EventDetails* vc = [[EventDetails alloc]init];
    vc.mgid = [mgidArr objectAtIndex:index];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
    
}


#pragma mark UITabViewDataSource
-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //UILog(@"tableViewData :  %d",tableViewData.count);
    if (dataArr.count==0) {
        return 1;
    }
    else
    {
        return dataArr.count;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString* tableCell = @"cell";
    HomeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:tableCell];
    if (cell == nil)
    {
        NSArray * nibViews  =[[NSBundle mainBundle] loadNibNamed:@"HomeTableViewCell" owner:self options:nil] ;
        cell= [nibViews objectAtIndex:0];
        
    }
  
    
    if (dataArr.count!=0) {
        
        DataModel* model = [dataArr objectAtIndex:indexPath.row];
        
        cell.productname_label.text = model.s_gdname;
        cell.username_label.text = model.s_nickname;
        
        cell.praise_count.text = [upclickcountArr objectAtIndex:indexPath.row];
        
        cell.comments_count.text = model.s_remsgcount;
        [cell.headImage setImageWithURL:[NSURL URLWithString:model.s_photo] placeholderImage:[UIImage imageNamed:@"默认头像.png"]];
        
        cell.headImage.backgroundColor = [UIColor clearColor];
        [cell.image_bg setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"默认.jpg"]]];
        
        [cell.image_bg setImageWithURL:[NSURL URLWithString:model.s_image] placeholderImage:[Photo imageWithColorString:model.fillColor]];
        //[cell.image_bg setImageWithURL:[NSURL URLWithString:model.s_image] placeholderImage:[UIImage imageNamed:@"默认.jpg"]];
        
        //UILog(@"model.s_photo %@",model.s_photo);
        [cell.certification_image setLeft:cell.username_label.text.length*14+cell.username_label.left+10];
        
        [cell.collection_btn addTarget:self action:@selector(savingclick:) forControlEvents:UIControlEventTouchUpInside];
        cell.collection_btn.tag = indexPath.row;
        
        cell.collection_small_btn.tag = indexPath.row;
        cell.browse_btn.tag = indexPath.row;
        
        [cell.browse_btn addTarget:self action:@selector(browse:) forControlEvents:UIControlEventTouchUpInside];
        
        [cell.collection_small_btn addTarget:self action:@selector(savinglist:) forControlEvents:UIControlEventTouchUpInside];
        
        //cell.textLabel.text = [NSString stringWithFormat:@"%ld",(long)indexPath.row];
        
        // UILog(@"model.s_isupclick: %@",model.s_isupclick);
        if ([[savingArr objectAtIndex:indexPath.row] isEqualToString:@"1"])
        {
            [cell.collection_btn setImage:[UIImage imageNamed:@"赞高亮.png"] forState:UIControlStateNormal];
        }
        else
        {
            [cell.collection_btn setImage:[UIImage imageNamed:@"赞默认.png"] forState:UIControlStateNormal];
        }
        
        cell.workDetails_btn.tag = indexPath.row;
        [cell.workDetails_btn addTarget:self action:@selector(workDetails_click:) forControlEvents:UIControlEventTouchUpInside];
        
        
        CGFloat yOffset = ((self.myTableView.contentOffset.y - cell.frame.origin.y) / IMAGE_HEIGHT) * IMAGE_OFFSET_SPEED;
        cell.imageOffset = CGPointMake(0.0f, yOffset);
        
        
    }
    if (dataArr.count==0) {
        cell.height = 0;
    }
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    HomeTableViewCell *cell = (HomeTableViewCell*)[self tableView:self.myTableView cellForRowAtIndexPath:indexPath];
    //UILog(@"cell.height %0.0f",cell.height);

    return cell.frame.size.height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    
    if (indexPath.section==0)
    {
        
        
        //UILog(@"delta %f",delta);
        
       DataModel* model = [dataArr objectAtIndex:indexPath.row];
        
        MyHomeViewController* vc = [[MyHomeViewController alloc]init];
        
        vc.uid = model.s_uid;
        
        vc.hidesBottomBarWhenPushed = YES;
        
        [self.navigationController pushViewController:vc animated:YES];
    }
}

-(void)browse:(UIButton*)sender
{
    //UILog(@"browse:%ld",sender.tag);
    savingAndCommentsList* vc = [[savingAndCommentsList alloc]init];
    DataModel* model = [dataArr objectAtIndex:sender.tag];
    vc.mgid = model.s_mgid;
    vc.title = @"评论过的人";
    vc.hidesBottomBarWhenPushed = YES;
    vc.type = @"1";
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)savinglist:(UIButton*)sender
{
    //UILog(@"savingli%ld%d(long)",sender.tag);
    savingAndCommentsList* vc = [[savingAndCommentsList alloc]init];
    DataModel* model = [dataArr objectAtIndex:sender.tag];
    vc.mgid = model.s_mgid;
    vc.title = @"赞过的人";
    vc.hidesBottomBarWhenPushed = YES;
    vc.type = @"0";
    [self.navigationController pushViewController:vc animated:YES];
}

//点攒处理
-(void)savingclick:(UIButton*)sender
{

//    if ([self Check_Guest]) {
//        return;
//    }
    
    DataModel* model =  [dataArr objectAtIndex:sender.tag];
    
    NSString* s = nil;
    
    if ([[savingArr objectAtIndex:sender.tag] isEqualToString:@"0"]) {
        s=@"upClick";
    }
    else
    {
        s=@"cancelUpclick";
    }
    page = 0;
    
    NSString* url =  [NSString stringWithFormat:@"Works/%@",s];
    NSMutableDictionary* dic = [NSMutableDictionary dictionary];
    [dic setValue:model.s_mgid forKey:@"id"];
    
    ASIHTTPRequest* request = [HttpRequest requestPost:url Dic:dic authorization:YES];
    __weak typeof(ASIHTTPRequest)* weak_request = request;
    
    [weak_request setCompletionBlock:^{
        
        NSDictionary* dict = [[weak_request responseString] objectFromJSONString];
        
        int status = [[dict objectForKey:@"status"]intValue];
        
        if (status!=1)
        {
            NSString* info = [NSString stringWithFormat:@"%@",[dict objectForKey:@"info"]];
            ALERT_OK(info);
            UILog(@"%@",info);
            return ;
        }
      
        
        BOOL boo = [[savingArr objectAtIndex:sender.tag]boolValue];
        
        int count = [[upclickcountArr objectAtIndex:sender.tag]intValue];
        
        //UILog(@"%d",boo);
        if (boo)
        {
            boo = NO;
            NSString * s_bool = [NSString stringWithFormat:@"%d",boo];
            [savingArr setObject:s_bool atIndexedSubscript:sender.tag];
            count -=1;
            NSString* S = [NSString stringWithFormat:@"%d",count];
            [upclickcountArr setObject:S atIndexedSubscript:sender.tag];
        }
        else
        {
            boo = YES;
            NSString * s_bool = [NSString stringWithFormat:@"%d",boo];
            [savingArr setObject:s_bool atIndexedSubscript:sender.tag];
            count +=1;
            NSString* S = [NSString stringWithFormat:@"%d",count];
            [upclickcountArr setObject:S atIndexedSubscript:sender.tag];
        }
        NSIndexPath *indexPath=[NSIndexPath indexPathForRow:sender.tag inSection:0];
        [self.myTableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
        
        
        for(HomeTableViewCell *view in self.myTableView.visibleCells) {
            CGFloat yOffset = ((self.myTableView.contentOffset.y - view.frame.origin.y) / IMAGE_HEIGHT) * IMAGE_OFFSET_SPEED;
            view.imageOffset = CGPointMake(0.0f, yOffset);
            //view.
            
        }
       // [self.myTableView reloadData];
    }];
    
    [weak_request startAsynchronous];
}


-(void)workDetails_click:(UIButton*)sender
{
    WorkDetailsViewController* vc = [[WorkDetailsViewController alloc]init];
    vc.vc = self;
    DataModel* model = [dataArr objectAtIndex:sender.tag];
    vc.mgid = model.s_mgid;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark 定时滚动scrollView
-(void)viewDidAppear:(BOOL)animated{
    //显示窗口
    [super viewDidAppear:animated];
    //[self followScrollView:self.myTableView];
    if (self.isRefresh)
    {
        [self loadData];
        self.isRefresh = NO;
    }
    
    //[self.myTableView reloadData];
    //    [NSThread sleepForTimeInterval:3.0f];//睡眠，所有操作都不起作用
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_headerView openTimer];//开启定时器
    });
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    [self.navigationController setNavigationBarHidden:YES];
//    self.navigationController.navigationBar.alpha = 0.0f;
 
    
    [MobClick beginLogPageView:@"PageOne"];
}


-(void)viewWillDisappear:(BOOL)animated{//将要隐藏窗口  setModalTransitionStyle=UIModalTransitionStyleCrossDissolve时是不隐藏的，故不执行
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO];
//    CGRect frame;
//    frame = self.navigationController.navigationBar.frame;
//    CGFloat delta = frame.origin.y - 20;
//    frame.origin.y = MIN(20, frame.origin.y - delta);
//    self.navigationController.navigationBar.frame = frame;
//    [self updateSizingWithDelta:delta];
//    [self checkForPartialScroll];
    
    [MobClick endLogPageView:@"PageOne"];
    if (_headerView.totalNum>1) {
        [_headerView closeTimer];//关闭定时器
    }
}
#pragma mark - scrollView也是适用于tableView的cell滚动 将开始和将要结束滚动时调用
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [_headerView closeTimer];//关闭定时器
}
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset{
    if (_headerView.totalNum>1) {
        [_headerView openTimer];//开启定时器
    }
}


- (void)tapHandle:(UITapGestureRecognizer *)tap {
    XHImageViewer *imageViewer = [[XHImageViewer alloc] init];
    imageViewer.delegate = self;
    [imageViewer showWithImageViews:activityArr selectedView:(UIImageView *)tap.view];
}

#pragma mark - XHImageViewerDelegate

- (void)imageViewer:(XHImageViewer *)imageViewer willDismissWithSelectedView:(UIImageView *)selectedView {
    //NSInteger index = [imgArray indexOfObject:selectedView];
    //NSLog(@"index : %d", index);
    //imageViewer.pagecontrol.currentPage = index;
}





//#pragma mark - UIScrollViewdelegate methods
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    for(HomeTableViewCell *view in self.myTableView.visibleCells)
    {
        CGFloat yOffset = ((self.myTableView.contentOffset.y - view.frame.origin.y) / IMAGE_HEIGHT) * IMAGE_OFFSET_SPEED;
        view.imageOffset = CGPointMake(0.0f, yOffset);
        //view.
        
    }
    if (self.myTableView==scrollView) {
        CGFloat yOffset = self.myTableView.contentOffset.y;
        if (yOffset>150) {
            top_btn.hidden = NO;
        }
        else
        {
            top_btn.hidden = YES;
        }
        //UILog(@"yOffset %f",yOffset);
    }

}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)click_top:(UIButton *)sender {
    
     [self.myTableView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:YES];
    
}

@end
