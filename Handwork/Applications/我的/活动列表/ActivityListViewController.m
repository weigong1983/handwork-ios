//
//  ActivityListViewController.m
//  Handwork
//
//  Created by ios on 15-5-4.
//  Copyright (c) 2015年 周文超. All rights reserved.
//

#import "ActivityListViewController.h"
#import "ActivityTableViewCell.h"
#import "EventDetails.h"
@interface ActivityListViewController ()
{
    NSMutableArray* dataArr;
    NSInteger page;
    NSInteger hasMore;
}
@property (strong, nonatomic) IBOutlet UITableView *myTableView;

@end

@implementation ActivityListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"活动";
    
    dataArr =[[NSMutableArray alloc]init];
    
    [self loadData];
    
    [self setupRefresh];
    // Do any additional setup after loading the view from its nib.
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
    
    
    [self loadData];
    
    // 2.2秒后刷新表格UI
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 刷新表格
        //[self.myTableView reloadData];
        
        // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
        [self.myTableView headerEndRefreshing];
    });
}

-(void)footerRereshing
{
    if (hasMore==0) {
        //ALERT_OK(@"已经是全部数据了");
        [TipsHud ShowTipsHud:@"没有更多数据了" :self.view];
        [self.myTableView footerEndRefreshing];
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
-(void)loadData
{
    NSMutableDictionary* submitData = [NSMutableDictionary dictionary];
    
    //NSUserDefaults* user = [NSUserDefaults standardUserDefaults];
    NSString* s_page = [NSString stringWithFormat:@"%ld",(long)page];
    [submitData setValue:s_page forKey:@"page"];
    
    //UILog(@"UID -> %@",[user objectForKey:API_UID]);  getUpclicks getWorksUpclicks
    //NSString* url = [NSString stringWithFormat:@"Activity/activityIndex"];
    NSString* url = [NSString stringWithFormat:@"Activity/getJoinActs"];
    ASIHTTPRequest* request = [HttpRequest requestPost:url Dic:nil authorization:YES];
    
    
    __weak typeof (ASIHTTPRequest)* request_weak = request;
    
    [request setCompletionBlock:^{
        NSDictionary* dic = [[request_weak responseString]objectFromJSONString];
        
        [MBProgressHUD hideHUDForView:self.view animated:NO];
        
        int status = [[dic objectForKey:@"status"]intValue];
        [self isDistance:status];
        if (status!=1) {
            return ;
        }
        NSDictionary* data = [dic objectForKey:@"data"];
        NSArray* infos = [data objectForKey:@"infos"];
        hasMore = [[data objectForKey:@"hasMore"]intValue];
        //UILog(@"data--> %@",data);
        if (![infos isEqual:[NSNull null]] && [infos count]!=0)
        {
            NSInteger count = infos.count;
            for ( int i=0 ; i<count; i++) {
                
                NSDictionary* d = [infos objectAtIndex:i];
                
                DataModel* model = [[DataModel alloc]init];
                
                if (!strIsEmpty([d objectForKey:@"address"])) {
                    model.s_address = [d objectForKey:@"address"];
                }
                if (!strIsEmpty([d objectForKey:@"title"])) {
                    model.s_title = [d objectForKey:@"title"];
                }
                if (!strIsEmpty([d objectForKey:@"s_image"])) {
                    model.s_image_small = [d objectForKey:@"s_image"];
                }
                if (!strIsEmpty([d objectForKey:@"id"])) {
                    model.s_mgid = [d objectForKey:@"id"];
                }
                if (!strIsEmpty([d objectForKey:@"createtime"])) {
                    
                    int i_time = [[d objectForKey:@"createtime"]intValue];
                    NSString* s_time = [NSString stringWithFormat:@"时间:%@",[StringUtil getMS:i_time setDateFormat:@"yyyy-MM-dd HH:mm:ss"]];
                    model.s_createtime = s_time;
                }
                [dataArr addObject:model];
            }
            [self.myTableView reloadData];
        }
        //pagecount = [[data objectForKey:@"pagecount"]intValue];
        //NSString* info = [NSString stringWithFormat:@"%@",[dic objectForKey:@"info"]];
        //ALERT_OK(info);
        UILog(@"通知dict %@",dic);
        
    }];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES withText:@"正在加载" detailText:nil];
    [request_weak startAsynchronous];
}

#pragma mark UITabViewDataSource
-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
//设置Section的Header
//-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
//    
//    NSString *result = @"Section 0 Header";
//    
//    return result;
//}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return dataArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString* Identifier = @"cell";
    
    ActivityTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:Identifier];
    
    if (cell == nil)
    {
        NSArray * nibViews  =[[NSBundle mainBundle] loadNibNamed:@"ActivityTableViewCell" owner:self options:nil];
        cell= (ActivityTableViewCell*)[nibViews objectAtIndex:0];
    }
    if (dataArr.count!=0) {
        DataModel* model = [dataArr objectAtIndex:indexPath.row];
        cell.label1.text  = model.s_title;
        cell.label2.text  = model.s_address;
        [cell.left_image setImageWithURL:[NSURL URLWithString:model.s_image_small] placeholderImage:nil];
        
        cell.label3.text = model.s_createtime;
        
        UIView* line = [[UIView alloc]init];
        line.frame = CGRectMake(0, cell.height-1, _Screen_Width, 1);
        line.backgroundColor = RGB_MAKE(234, 234, 234);
        [cell.contentView addSubview:line];
    }
    //cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}




-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    ActivityTableViewCell *cell = (ActivityTableViewCell*)[self tableView:self.myTableView cellForRowAtIndexPath:indexPath];
    return cell.height;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (dataArr.count!=0) {
        DataModel* model = [dataArr objectAtIndex:indexPath.row];
        EventDetails* vc = [[EventDetails alloc]init];
        vc.mgid = model.s_mgid;
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
