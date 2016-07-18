//
//  ArtisansViewController.m
//  Handwork
//
//  Created by ios on 15-5-5.
//  Copyright (c) 2015年 周文超. All rights reserved.
//

#import "ArtisansViewController.h"
#import "ArtisansTableViewCell.h"
#import "WorkDetailsViewController.h"

#import "MyHomeViewController.h"

#import "CustomButton.h"
#import "Photo.h"

@interface ArtisansViewController ()
{
    UIButton* temp_btn;
    NSMutableArray* classidArr;
    NSMutableArray* ArrMgid;
    NSMutableArray* dataArr;
    BOOL isRefresh;
    NSInteger selectIndex;
    NSInteger page;
    NSInteger hasMore;
    
    int loadDataMode; // 1: 切换分类；2：刷新；3. 加载更多
}
@property (strong, nonatomic) IBOutlet UIScrollView *menuScroll;
@property (strong, nonatomic) IBOutlet UITableView *myTableView;
@property (strong, nonatomic) IBOutlet UIScrollView *bigScroll;
@property (strong, nonatomic) IBOutlet UIButton *more_btn;
@property (strong, nonatomic) IBOutlet UIView *line_v;
@property (strong, nonatomic) IBOutlet UIView *line_v1;

@end

@implementation ArtisansViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    isRefresh = YES;
    loadDataMode = 1;
    dataArr = [[NSMutableArray alloc]init];
    ArrMgid = [[NSMutableArray alloc]init];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.line_v setBackgroundColor:colorToString(@"#dddddd")];
    self.title = @"工艺家";
    classidArr = [[NSMutableArray alloc]init];
    [self getAllClasses];
    
    [self setupRefresh];
    // Do any additional setup after loading the view from its nib.
}
-(void)getAllClasses
{
    NSString* url =  [NSString stringWithFormat:@"Find/getAllClasses"];
    
    //NSMutableDictionary* dic = [NSMutableDictionary dictionary];
    
    ASIHTTPRequest* request = [HttpRequest requestPost:url Dic:nil authorization:YES];
    
    __weak typeof(ASIHTTPRequest)* weak_request = request;
    
    [weak_request setCompletionBlock:^{
        
        NSDictionary* dict = [[weak_request responseString] objectFromJSONString];
        
        int status = [[dict objectForKey:@"status"]intValue];
        
        if (status!=1) {
            NSString* info = [NSString stringWithFormat:@"%@",[dict objectForKey:@"info"]];
            ALERT_OK(info);
            return ;
        }
        
        //UILog(@"dict %@",dict);
        //return;
        NSDictionary* data = [dict objectForKey:@"data"];
        
        NSArray* classes = [data objectForKey:@"classes"];
        
        NSInteger count = [classes count];
        if (![classes isEqual:[NSNull null]]) {
            for (int i=0; i<count; i++) {
                
                NSDictionary* classes_dic = [classes objectAtIndex:i];
                
                UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
                
                [btn setFrame:CGRectMake(i*80,0, 80, 45)];
                
                [btn setBackgroundImage:[UIImage imageNamed:@"白底.png"] forState:UIControlStateNormal];
                [btn setBackgroundImage:[UIImage imageNamed:@"底滑线.png"] forState:UIControlStateSelected];
                if (!strIsEmpty([classes_dic objectForKey:@"classname"])) {
                    [btn setTitle:[classes_dic objectForKey:@"classname"] forState:UIControlStateNormal];
                }
                
                [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                
                [btn setTitleColor:colorToString(@"#c00000") forState:UIControlStateHighlighted];
                
                [btn setTitleColor:colorToString(@"#c00000") forState:UIControlStateSelected];
                btn.tag = i;
                
                [btn addTarget:self action:@selector(btn_click:) forControlEvents:UIControlEventTouchUpInside];
                
                if (i==0) {
                    btn.selected = YES;
                    temp_btn = btn;
                }
                btn.adjustsImageWhenHighlighted = YES;
                
                [self.menuScroll addSubview:btn];
                if (!strIsEmpty([classes_dic objectForKey:@"classid"])) {
                    NSString* s_classID =[NSString stringWithFormat:@"%@",[classes_dic objectForKey:@"classid"]];
                    [classidArr addObject:s_classID];
                }
                
            }
            
            // 首次进入刷新默认工艺家列表
            [self headerRereshing];

        }
        
        
        [self.menuScroll setContentSize:CGSizeMake(80*count, 0)];
    }];
    
    [weak_request startAsynchronous];
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (isRefresh)
    {
        if (classidArr.count!=0) {
            loadDataMode = 2;
            [self getUserByClassid:[classidArr objectAtIndex:0]];
        }
        isRefresh = NO;
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
    loadDataMode = 2;
    [self getUserByClassid:[classidArr objectAtIndex:selectIndex]];
    
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
        page++;
        //UILog(@"dataArr--> %lu  page%ld",(unsigned long)dataArr.count,(long)page);
        //UILog(@"hasMore %ld",(long)hasMore);
        //[self initDataAndSort:@"99" andFirstload:@"1" andstyle:@"01"];
        
       // [self getUserByClassid:selectIndex];
        loadDataMode = 3;
        [self getUserByClassid:[classidArr objectAtIndex:selectIndex]];
        
        // 2.2秒后刷新表格UI
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            // 刷新表格
            //[self.myTableView reloadData];
            
            // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
            [self.myTableView footerEndRefreshing];
            [MBProgressHUD hideHUDForView:self.view animated:NO];
            
        });
    }
}

-(void)getUserByClassid:(NSString*)classid
{
    NSString* url =  [NSString stringWithFormat:@"Find/getUserByClassid"];
    
    NSMutableDictionary* dict = [NSMutableDictionary dictionary];
    [dict setValue:classid forKey:@"classid"];
    NSString* s_page  = [NSString stringWithFormat:@"%ld",(long)page];
    [dict setValue:s_page forKey:@"page"];
    
    UILog(@"dict--> %@",dict);
    ASIHTTPRequest* request = [HttpRequest requestPost:url Dic:dict authorization:YES];
    
    __weak typeof(ASIHTTPRequest)* weak_request = request;
    
    [weak_request setCompletionBlock:^{
        
        NSDictionary* dic = [[weak_request responseString] objectFromJSONString];
        
        int status = [[dic objectForKey:@"status"]intValue];
        [self isDistance:status];
        if (status!=1) {
            return ;
        }
        UILog(@"data %@",dic);
       
        NSDictionary* data = [dic objectForKey:@"data"];
        
        hasMore = [[data objectForKey:@"hasMore"]intValue];
        
        NSArray* infos = [data objectForKey:@"infos"];
        
        if (![infos isEqual:[NSNull null]]) {
            NSInteger count = [infos count];
            
            if (count!=0)
            {
                if (loadDataMode != 3) {  // 加载更多不要清空数据-魏工
                    [dataArr removeAllObjects];
                }
                
                for (int i=0; i<count; i++) {
                    NSDictionary* infos_dic = [infos objectAtIndex:i];
                    DataModel* model = [[DataModel alloc]init];
                    if (!strIsEmpty([infos_dic objectForKey:@"nickname"])) {
                        model.s_nickname = [infos_dic objectForKey:@"nickname"];
                    }
                    if (!strIsEmpty([infos_dic objectForKey:@"s_photo"])) {
                        model.s_photo = [infos_dic objectForKey:@"s_photo"];
                    }
                    if (!strIsEmpty([infos_dic objectForKey:@"realname"])) {
                        model.s_realname = [infos_dic objectForKey:@"realname"];
                    }
                    if (!strIsEmpty([infos_dic objectForKey:@"uid"])) {
                        model.s_uid = [infos_dic objectForKey:@"uid"];
                    }
                    
                    if (!strIsEmpty([infos_dic objectForKey:@"workscount"])) {
                        model.s_workscount = [infos_dic objectForKey:@"workscount"];
                    }
                    
                    // 作品数目为0不显示出来
                    if ([model.s_workscount integerValue] == 0)
                        continue ;
                    
                    //                if (!strIsEmpty([infos_dic objectForKey:@"mgid"])) {
                    //                    model.s_mgid = [infos_dic objectForKey:@"mgid"];
                    //                }
                    if (![[infos_dic objectForKey:@"worksinfo"] isEqual:[NSNull null]])
                    {
                        model.arr_worksinfo = [infos_dic objectForKey:@"worksinfo"];
                        
                        NSInteger count = model.arr_worksinfo.count;
                        
                        model.arr_mgid = [[NSMutableArray alloc]init];
                        for (int j=0; j<count; j++)
                        {
                            NSDictionary* c = [model.arr_worksinfo objectAtIndex:j];
                            //model.s_mgid = [c objectForKey:@"mgid"];
                            NSString* mgid = [c objectForKey:@"mgid"];
                            [model.arr_mgid addObject:mgid];
                        }
                    }
                    
                    
                    [dataArr addObject:model];
                }
                self.myTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
               [self.myTableView reloadData];
                
            }

        }
        else
        {
            [self.myTableView reloadData];
            self.myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        }
        [MBProgressHUD hideHUDForView:self.view animated:NO];
        }];
     [MBProgressHUD showHUDAddedTo:self.view animated:YES withText:@"正在加载..." detailText:nil];
    [weak_request startAsynchronous];
}




- (IBAction)more_click:(UIButton *)sender {
    
    CGPoint contentOffset =   self.menuScroll.contentOffset;
    
    CGSize  contentSize = self.menuScroll.contentSize;
    
    NSInteger windth = contentSize.width;
    //UILog(@"%0.0f",windth-self.menuScroll.width);
    //UILog(@"%0.0f",contentOffset.x);
    if (contentOffset.x>=windth-self.menuScroll.width)
    {
        return;
    }
    else
    {
       [self.menuScroll setContentOffset:CGPointMake(contentOffset.x+(contentSize.width/6), 0) animated:YES];
    }
    
    
    //UILog(@"%0.0ld",(long)windth);
    //UILog(@"%0.0f",contentOffset.x);
}


-(void)btn_click:(UIButton*)sender
{
    //UILog(@"%d",sender.tag);
    if (temp_btn.tag!=sender.tag) {
        temp_btn.selected = NO;
    }
    else
    {
        return;
    }
    
    NSInteger index = sender.tag;
    
    if (sender.tag==5) {
        index = 3;
    }
    if (sender.tag==4) {
        index = 2;
    }
    
    //UILog(@"%d",index);
    
    temp_btn = sender;
    
    temp_btn.selected = YES;
    [self.line_v1 setLeft:index*80];
    //UILog(@"%d",sender.tag);
    //UILog(@"--> %@",[classidArr objectAtIndex:sender.tag]);
    
    selectIndex = sender.tag;
    loadDataMode = 1;
    page = 0;
    [self getUserByClassid:[classidArr objectAtIndex:sender.tag]];
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
    return dataArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier = @"Cell";
    ArtisansTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil)
    {
        //cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        NSArray * nibViews  =[[NSBundle mainBundle] loadNibNamed:@"ArtisansTableViewCell" owner:self options:nil] ;
        cell= [nibViews objectAtIndex:0];
    }
//    if (dataArr.count==0) {
//        
//        UILabel* label = [[UILabel alloc]init];
//        label.text = @"暂无数据";
//        label.frame = CGRectMake(_Screen_Width/2-60/2, cell.height/2-10, 68, 20);
//        [cell.contentView addSubview:label];
//    }
    if (dataArr.count!=0)
    {
        
        DataModel* model = [dataArr objectAtIndex:indexPath.row];
        NSInteger count =model.arr_worksinfo.count;
        if (count!=0) {
            [cell setHeight:220];
            
            NSMutableArray *array = [NSMutableArray array];
            
            for (int i=0; i<count; i++)
            {
                NSDictionary* dic = [model.arr_worksinfo objectAtIndex:i];
                
                
               // UIImageView* image = [[UIImageView alloc]init];
                
                
                CustomButton* btn = [CustomButton buttonWithType:UIButtonTypeCustom];
                
                 [btn addTarget:self action:@selector(custom:) forControlEvents:UIControlEventTouchUpInside];
                [btn setValue:[NSNumber numberWithInt:i] forKey:@"column"];
                
                if (!strIsEmpty([dic objectForKey:@"s_image"]))
                    
                {
                    
                    NSString* url = [NSString stringWithFormat:@"%@",[dic objectForKey:@"s_image"]];
                    //UILog(@"URL %@",url);
                    //[image setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"默认头像.png"]];
                    UIImage *defaultImage;
                    if (!strIsEmpty([dic objectForKey:@"color"]))
                    {
                        defaultImage = [Photo imageWithColorString:[dic objectForKey:@"color"]];
                    }
                    else{
                        defaultImage = [UIImage imageNamed:@"默认1.jpg"];
                    }
                    
                    [btn setImageWithURL:[NSURL URLWithString:url] placeholderImage:defaultImage];
                }
                if (!strIsEmpty([dic objectForKey:@"mgid"]))
                {
                    [ArrMgid addObject:[dic objectForKey:@"mgid"]];
                }
             
                btn.frame = CGRectMake(i*130, 0, 120, 115);
                [cell.scrollView addSubview:btn];
                 [array addObject:btn];
            }
            [cell setValue:array forKey:@"buttons"];
        }
        
        
        [cell.scrollView setContentSize:CGSizeMake(count*130, 0)];
        cell.namelabel.text = model.s_nickname;
        [cell.img_certification setImage:[UIImage imageNamed:@"认证.png"]];
        [cell.img_certification setLeft:cell.namelabel.text.length*15+cell.namelabel.left+10];
        cell.label1.text = [NSString stringWithFormat:@"%@件作品",model.s_workscount];
//        [cell.workDetails_btn addTarget:self action:@selector(workDetails_btnclick:) forControlEvents:UIControlEventTouchUpInside];
//        cell.workDetails_btn.tag = indexPath.row;
        
        [cell.headImage setImageWithURL:[NSURL URLWithString:model.s_photo] placeholderImage:[UIImage imageNamed:@"默认头像.png"]];
    }
    
    //cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    //cell.selectionStyle = UITableViewCellSelectionStyleNone;
    //[[cell imageView] setImage:[self tripPhotoForRowAtIndexPath:indexPath]];
    //cell.textLabel.text = [NSString stringWithFormat:@"%d",indexPath.row];
    //UIImageView* image =(UIImageView*)[self.view viewWithTag:Head_Tag];
    
    //cell.label1.text = [self tripNameForRowAtIndexPath:indexPath];
    
    
    
    //[cell.imageView setImage:[self tripPhotoForRowAtIndexPath:indexPath]];
    //获取到里面的cell里面的3个图片按钮引用
    NSArray *imageButtons =cell.buttons;
    //设置UIImageButton里面的row属性
    [imageButtons setValue:[NSNumber numberWithInteger:indexPath.row] forKey:@"row"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //UILog(@"%ld",(long)indexPath.row);
//    WorkDetailsViewController* vc = [[WorkDetailsViewController alloc]init];
//    [self.navigationController pushViewController:vc animated:YES];
    
    MyHomeViewController* vc = [[MyHomeViewController alloc]init];
    DataModel* model = [dataArr objectAtIndex:indexPath.row];
    vc.uid = model.s_uid;
    [self.navigationController pushViewController:vc animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ArtisansTableViewCell *cell = (ArtisansTableViewCell*)[self tableView:self.myTableView cellForRowAtIndexPath:indexPath];
    
    //UILog(@"cell.height %0.0f",cell.height);
    
    return cell.frame.size.height;
}


//- (UIImage *)tripPhotoForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    switch (indexPath.row)
//    {
//        case 0:
//            return [UIImage imageNamed:@"surf1.png"];
//            break;
//        case 1:
//            return [UIImage imageNamed:@"surf2.png"];
//            break;
//        case 2:
//            return [UIImage imageNamed:@"surf3.png"];
//            break;
//    }
//    return nil;
//}
//
//- (NSString *)tripNameForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    switch (indexPath.row)
//    {
//        case 0:
//            return @"消息";
//            break;
//        case 1:
//            return @"关注";
//            break;
//        case 2:
//            return @"收藏";
//            break;
//        case 3:
//            return @"收藏";
//            break;
//        case 4:
//            return @"收藏";
//            break;
//    }
//    return @"-";
//}
//
//-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
//{
//    
//    return 15;
//}

//-(void)workDetails_btnclick:(UIButton*)sender
//{
//    //UILog(@"%ld",(long)indexPath.row);
//    WorkDetailsViewController* vc = [[WorkDetailsViewController alloc]init];
//    DataModel* model = [dataArr objectAtIndex:sender.tag];
//    vc.mgid =  model.s_mgid;
//    UILog(@"-> %@",model.s_mgid);
//    
//    [self.navigationController pushViewController:vc animated:YES];
//}


-(void)custom:(CustomButton*)button
{
    //UILog(@"%d  mgid %d",button.row,button.column);
    WorkDetailsViewController* vc = [[WorkDetailsViewController alloc]init];
    DataModel* model = [dataArr objectAtIndex:button.row];
    vc.mgid =  [model.arr_mgid objectAtIndex:button.column];
    //UILog(@"-> %@",vc.mgid);
    
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
