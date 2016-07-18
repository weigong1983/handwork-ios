//
//  SavingViewController.m
//  Handwork
//
//  Created by ios on 15-5-4.
//  Copyright (c) 2015年 周文超. All rights reserved.
//

#import "SavingViewController.h"
#import "HomeTableViewCell.h"
#import "WorkDetailsViewController.h"
#import "savingAndCommentsList.h"
#import "MyHomeViewController.h"
#import "Photo.h"

@interface SavingViewController ()
{
    NSMutableArray* dataArr;
    
    NSInteger page;
    NSInteger hasMore;
    UILabel* label;
}
@property (strong, nonatomic) IBOutlet UITableView *myTableView;

@end

@implementation SavingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    dataArr = [[NSMutableArray alloc]init];
    self.title = @"赞";
    
    label = [[UILabel alloc]init];
    label.text = @"暂无数据!";
    [self.view addSubview:label];
    label.textAlignment = NSTextAlignmentCenter;
    label.frame = CGRectMake(_Screen_Width/2-100, 10, 200, 20);
    
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
    //NSMutableDictionary* submitData = [NSMutableDictionary dictionary];
    
    //NSUserDefaults* user = [NSUserDefaults standardUserDefaults];
    //[submitData setValue:@"0" forKey:@"page"];
    NSString* url = [NSString stringWithFormat:@"Works/getUpclicks"];
    
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
        hasMore = [[data objectForKey:@"hasMore"]intValue];
        UILog(@"获得-> %@",dic);
        
        NSArray* infos = [data objectForKey:@"infos"];
        
        [dataArr removeAllObjects];
        
        if (infos.count!=0)
        {
            
            //[dataArr removeAllObjects];
            NSInteger count = infos.count;
            
            for (int i=0; i<count; i++) {
                NSDictionary* d = [infos objectAtIndex:i];
                
                NSDictionary* author = [d objectForKey:@"author"];
                
                DataModel* model = [[DataModel alloc]init];
                
                if (!strIsEmpty([d objectForKey:@"gdname"])) {
                    model.s_gdname =[NSString stringWithFormat:@"%@",[d objectForKey:@"gdname"]];
                };
                if (!strIsEmpty([author objectForKey:@"nickname"])) {
                    model.s_nickname =[NSString stringWithFormat:@"%@",[author objectForKey:@"nickname"]];
                };
                if (!strIsEmpty([author objectForKey:@"s_photo"])) {
                    model.s_photo =[NSString stringWithFormat:@"%@",[author objectForKey:@"s_photo"]];
                };
                
                
                if (!strIsEmpty([d objectForKey:@"gdview"])) {
                    model.s_gdview =[NSString stringWithFormat:@"%@",[d objectForKey:@"gdview"]];
                };
                
                if (!strIsEmpty([d objectForKey:@"remsgcount"])) {
                    model.s_remsgcount =[NSString stringWithFormat:@"%@",[d objectForKey:@"remsgcount"]];
                };
                if (!strIsEmpty([d objectForKey:@"upclickcount"])) {
                    model.s_upclickcount =[NSString stringWithFormat:@"%@",[d objectForKey:@"upclickcount"]];
                };
                
                if (!strIsEmpty([d objectForKey:@"m_image"])) {
                    model.s_image =[NSString stringWithFormat:@"%@",[d objectForKey:@"m_image"]];
                    
                    
                };
                if (!strIsEmpty([d objectForKey:@"mgid"])) {
                    model.s_mgid =[NSString stringWithFormat:@"%@",[d objectForKey:@"mgid"]];
                };
                
                if (!strIsEmpty([d objectForKey:@"iscollect"])) {
                    model.s_iscollect =[NSString stringWithFormat:@"%@",[d objectForKey:@"iscollect"]];
                    
                };
                
                // 填充色
                if (!strIsEmpty([d objectForKey:@"color"]))  {
                    model.fillColor =[NSString stringWithFormat:@"%@",[d objectForKey:@"color"]];
                };
                
                [dataArr addObject:model];
            }
            
           
            
        }
         [self.myTableView reloadData];
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
    if (dataArr.count==0){
        return 1;
    }
    else
    {
        return dataArr.count;
    }
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString* Identifier = @"cell";
    
    HomeTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:Identifier];
    
    if (cell == nil)
    {
        NSArray * nibViews  =[[NSBundle mainBundle] loadNibNamed:@"HomeTableViewCell" owner:self options:nil];
        cell= (HomeTableViewCell*)[nibViews objectAtIndex:0];
    }
    if (dataArr.count!=0) {
        
        DataModel* model = [dataArr objectAtIndex:indexPath.row];
        
        cell.productname_label.text = model.s_gdname;
        cell.username_label.text = model.s_nickname;
        cell.praise_count.text = model.s_upclickcount;
        cell.comments_count.text = model.s_remsgcount;
        [cell.headImage setImageWithURL:[NSURL URLWithString:model.s_photo] placeholderImage:[UIImage imageNamed:@"默认头像.png"]];
        cell.headImage.backgroundColor = [UIColor clearColor];
        NSString* img_url = [NSString stringWithFormat:@"%@",model.s_image];
        [cell.image_bg setImageWithURL:[NSURL URLWithString:img_url] placeholderImage:[Photo imageWithColorString:model.fillColor]];
        //UILog(@"model.s_photo %@",img_url);
        [cell.certification_image setLeft:cell.username_label.text.length*14+cell.username_label.left+10];
        
        [cell.collection_btn addTarget:self action:@selector(savingclick:) forControlEvents:UIControlEventTouchUpInside];
        cell.collection_btn.tag = indexPath.row;
        
        cell.collection_small_btn.tag = indexPath.row;
        cell.browse_btn.tag = indexPath.row;
        
        [cell.browse_btn addTarget:self action:@selector(browse:) forControlEvents:UIControlEventTouchUpInside];
        
        [cell.collection_small_btn addTarget:self action:@selector(savinglist:) forControlEvents:UIControlEventTouchUpInside];
        
        //cell.textLabel.text = [NSString stringWithFormat:@"%ld",(long)indexPath.row];
         [cell.collection_btn setImage:[UIImage imageNamed:@"赞高亮.png"] forState:UIControlStateNormal];
        
//        if ([model.s_iscollect isEqualToString:@"0"])
//        {
//            [cell.collection_btn setImage:[UIImage imageNamed:@"点赞.png"] forState:UIControlStateNormal];
//        }
//        else
//        {
//            [cell.collection_btn setImage:[UIImage imageNamed:@"(数据)点赞.png"] forState:UIControlStateNormal];
//        }
        cell.workDetails_btn.tag = indexPath.row;
        [cell.workDetails_btn addTarget:self action:@selector(workDetails_click:) forControlEvents:UIControlEventTouchUpInside];
        self.myTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        label.hidden = YES;
    }
    if (dataArr.count==0){
        self.myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
       [cell setHeight:0];
        label.hidden = NO;
    }
    
    //cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}




-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    HomeTableViewCell *cell = (HomeTableViewCell*)[self tableView:self.myTableView cellForRowAtIndexPath:indexPath];
    return cell.height;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    MyHomeViewController* vc = [[MyHomeViewController alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
    //EventDetails* vc = [[EventDetails alloc]init];
    //[self.navigationController pushViewController:vc animated:YES];
}

-(void)workDetails_click:(UIButton*)sender
{
    WorkDetailsViewController* vc = [[WorkDetailsViewController alloc]init];
    
    DataModel* model = [dataArr objectAtIndex:sender.tag];
    vc.mgid = model.s_mgid;
    
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

//点攒处理
-(void)savingclick:(UIButton*)sender
{
   
    NSMutableDictionary* dic = [NSMutableDictionary dictionary];
           NSString* url =  [NSString stringWithFormat:@"Works/cancelUpclick"];
    
    if (dataArr.count!=0)
    {
        DataModel* model =  [dataArr objectAtIndex:sender.tag];
        [dic setValue:model.s_mgid forKey:@"id"];
    }
    if (dataArr.count==0) {
        //[self.myTableView reloadData];
    }
    
    
    ASIHTTPRequest* request = [HttpRequest requestPost:url Dic:dic authorization:YES];
    __weak typeof(ASIHTTPRequest)* weak_request = request;
    
    [weak_request setCompletionBlock:^{
        
        NSDictionary* dict = [[weak_request responseString] objectFromJSONString];
        
        int status = [[dict objectForKey:@"status"]intValue];
        
        if (status!=1)
        {
            NSString* info = [NSString stringWithFormat:@"%@",[dict objectForKey:@"info"]];
            ALERT_OK(info);
            //UILog(@"%@",info);
            return ;
        }
        
        //NSString* info = [NSString stringWithFormat:@"%@",[dict objectForKey:@"info"]];
        //ALERT_OK(info);
        page = 0;
        
        [self loadData];
    }];
    
    [weak_request startAsynchronous];
}


-(void)browse:(UIButton*)sender
{
    //UILog(@"browse:%ld",sender.tag);
    savingAndCommentsList* vc = [[savingAndCommentsList alloc]init];
    vc.title = @"评论过的人";
    vc.hidesBottomBarWhenPushed = YES;
    vc.type = @"1";
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)savinglist:(UIButton*)sender
{
    //UILog(@"savingli%ld%d(long)",sender.tag);
    savingAndCommentsList* vc = [[savingAndCommentsList alloc]init];
    vc.title = @"赞过的人";
    vc.hidesBottomBarWhenPushed = YES;
    vc.type = @"0";
    [self.navigationController pushViewController:vc animated:YES];
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
