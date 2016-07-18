//
//  collectionViewController.m
//  Handwork
//
//  Created by ios on 15-5-5.
//  Copyright (c) 2015年 周文超. All rights reserved.
//

#import "collectionViewController.h"
#import "CollectionViewCell.h"
#import "WorkDetailsViewController.h"
#import "Photo.h"

@interface collectionViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>
{
    NSMutableArray* imgArr;
    UICollectionView* collection;
    NSInteger page;
    NSInteger hasMore;
}

@property (nonatomic) BOOL refresh;
@end

@implementation collectionViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    
    
//    return;
    self.refresh =  YES;
    
    imgArr = [[NSMutableArray alloc]init];
    
    self.title = @"热卖中";
    
    
    UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    flowLayout.headerReferenceSize = CGSizeMake(_Screen_Width, 0);//头部
    
    collection = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, _Screen_Width, _Screen_Height-64) collectionViewLayout:flowLayout];
    //中间距离
    flowLayout.minimumInteritemSpacing =2;
    
    //设置每一行之间的间距
    flowLayout.minimumLineSpacing = 2;
    
    //设置代理
    collection.delegate = self;
    collection.dataSource = self;
    [self.view addSubview:collection];
    //[collection registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:colleCell];
    //[collection setSectionInset:UIEdgeInsetsMake(-65.0f, 1.0f, 0.0f, 0.0f)];
    
    collection.backgroundColor = [UIColor clearColor];
    //注册cell和ReusableView（相当于头部）
    [collection registerClass:[CollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    
    [self setupRefresh];
}

- (void)setupRefresh
{
    // 1.下拉刷新(进入刷新状态就会调用self的headerRereshing)
    [collection addHeaderWithTarget:self action:@selector(headerRereshing)];
    //#warning 自动刷新(一进入程序就下拉刷新)
    //[self.myTableView headerBeginRefreshing];
    
    // 2.上拉加载更多(进入刷新状态就会调用self的footerRereshing)
    [collection addFooterWithTarget:self action:@selector(footerRereshing)];
    
    // 设置文字(也可以不设置,默认的文字在MJRefreshConst中修改)
    collection.headerPullToRefreshText = @"下拉刷新";
    collection.headerReleaseToRefreshText = @"松开刷新";
    collection.headerRefreshingText = @"正在刷新...";
    
    collection.footerPullToRefreshText = @"上拉加载更多数据";
    collection.footerReleaseToRefreshText = @"松开加载更多数据";
    collection.footerRefreshingText = @"加载中...";
}

-(void)headerRereshing
{
    
    page = 0;
    
    [imgArr removeAllObjects];
    
    
    [self loadData];
    
    // 2.2秒后刷新表格UI
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 刷新表格
        //[self.myTableView reloadData];
        
        // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
        [collection headerEndRefreshing];
    });
}

-(void)footerRereshing
{
    if (hasMore==0) {
        //ALERT_OK(@"已经是全部数据了");
        [TipsHud ShowTipsHud:@"没有更多数据了" :self.view];
        [collection footerEndRefreshing];
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
            [collection footerEndRefreshing];
            
        });
    }
    
}



-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (self.refresh) {
        [self loadData];
        self.refresh = NO;
    }
    
}
-(void)loadData
{
    NSString* url = [NSString stringWithFormat:@"Works/getAllWorks"];
    NSMutableDictionary* d = [NSMutableDictionary dictionary];
    NSString* s_page = [NSString stringWithFormat:@"%ld",(long)page];
    [d setObject:@"1" forKey:@"isCollect"];
    [d setObject:s_page forKey:@"page"];
    
    UILog(@": %@",d);
    
    ASIHTTPRequest* request = [HttpRequest requestPost:url Dic:d authorization:YES];
    
    __weak typeof (ASIHTTPRequest)* request_weak = request;
    
    [request setCompletionBlock:^{
        NSDictionary* dic = [[request_weak responseString]objectFromJSONString];
       
        [MBProgressHUD hideHUDForView:self.view animated:NO];
       // NSDictionary* data = [dic objectForKey:@"data"];
        UILog(@"获得-> %@",dic);
        
        int status = [[dic objectForKey:@"status"]intValue];
        if (status!=1) {
            NSString* info = [NSString stringWithFormat:@"%@",[dic objectForKey:@"info"]];
            ALERT_OK(info);
            return ;
        }
        
        NSDictionary* data =[dic objectForKey:@"data"];
        NSArray* infos = [data objectForKey:@"infos"];
        hasMore = [[data objectForKey:@"hasMore"]intValue];
        if (![infos isEqual:[NSNull null]]) {
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
                if (!strIsEmpty([d objectForKey:@"saleprice"])) {
                    model.s_saleprice = [d objectForKey:@"saleprice"];
                }
                if (!strIsEmpty([d objectForKey:@"marktype"])) {
                    model.s_marktype = [d objectForKey:@"marktype"];
                }
                
                if (!strIsEmpty([d objectForKey:@"s_image"])) {
                    model.s_image_small = [d objectForKey:@"s_image"];
                }
                // 填充色
                if (!strIsEmpty([d objectForKey:@"color"])) {
                    model.fillColor =[NSString stringWithFormat:@"%@",[d objectForKey:@"color"]];
                };
                
                if (!strIsEmpty([d objectForKey:@"mgid"])) {
                    model.s_mgid = [d objectForKey:@"mgid"];
                }
                [imgArr addObject:model];
            }
            [collection reloadData];
        }
        [MBProgressHUD hideHUDForView:self.view animated:NO];
    }];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES withText:@"正在加载" detailText:nil];
    
    [request_weak startAsynchronous];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -- UICollectionViewDataSource
//定义展示的UICollectionViewCell的个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return imgArr.count;
}
//定义展示的Section的个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identify = @"cell";
    CollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];
    [cell sizeToFit];
    if (!cell) {
        NSLog(@"无法创建CollectionViewCell时打印，自定义的cell就不可能进来了。");
    }
    
    //cell.backgroundColor = [self randomColor];
    //cell.imgView.image = [UIImage imageNamed:@"cat.png"];
    //cell.text.text = [NSString stringWithFormat:@"Cell %ld",indexPath.row];
    if (imgArr.count!=0) {
        DataModel* model = [imgArr objectAtIndex:indexPath.row];
        NSURL* URL = [NSURL URLWithString:model.s_image_small];
        [cell.imgView setImageWithURL:URL placeholderImage:[Photo imageWithColorString:model.fillColor]];
        
        if ([model.s_marktype isEqualToString:@"1"])
            cell.text.text = [NSString stringWithFormat:@"￥%@", model.s_saleprice];
        else
            cell.text.text = @"洽商";
    }
    
    
    cell.text.hidden = NO;
    cell.text.textColor = [UIColor whiteColor];
    cell.text.font = [UIFont boldSystemFontOfSize:15];
    cell.text.backgroundColor = [UIColor clearColor];
    return cell;
}

//头部显示的内容
//- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
//
//    UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:
//                                            UICollectionElementKindSectionHeader withReuseIdentifier:@"ReusableView" forIndexPath:indexPath];
//
//    [headerView addSubview:_headerView];//头部广告栏
//    return headerView;
//}
#pragma mark --UICollectionViewDelegateFlowLayout
//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    //边距占5*4=20 ，2个
    //图片为正方形，边长：(fDeviceWidth-20)/2-5-5 所以总高(fDeviceWidth-20)/2-5-5 +20+30+5+5 label高20 btn高30 边
    return CGSizeMake((_Screen_Width-6)/2,158);
}
//定义每个UICollectionView 的间距
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(2,2,2,2);
}
//定义每个UICollectionView 纵向的间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}
#pragma mark --UICollectionViewDelegate
//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    //    UICollectionViewCell * cell = (UICollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    //    cell.backgroundColor = [UIColor redColor];
    //NSLog(@"current: %d  选择%ld",current,(long)indexPath.row);
   
    WorkDetailsViewController* vc= [[WorkDetailsViewController alloc]init];
    DataModel* model = [imgArr objectAtIndex:indexPath.row];
    vc.mgid = model.s_mgid;
    [self.navigationController pushViewController:vc animated:YES];
}
//返回这个UICollectionView是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
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
