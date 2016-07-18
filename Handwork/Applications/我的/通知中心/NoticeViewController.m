//
//  NoticeViewController.m
//  Handwork
//
//  Created by ios on 15-5-4.
//  Copyright (c) 2015年 周文超. All rights reserved.
//

#import "NoticeViewController.h"
#import "NoticeTableViewCell.h"
@interface NoticeViewController ()
{
    NSMutableArray* dataArr;
}
@property (strong, nonatomic) IBOutlet UITableView *myTableView;

@end

@implementation NoticeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    dataArr = [[NSMutableArray alloc]init];
    //getAllMessages
    self.title = @"通知";
    // Do any additional setup after loading the view from its nib.
    
    [self getAllMessages];
}
-(void)getAllMessages
{
    
    NSString* url = [NSString stringWithFormat:@"Messages/getAllMessages"];
    
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
        
        
        UILog(@"data %@",data);
        if (![infos isEqual:[NSNull null]]) {
            NSInteger count = infos.count;
            for ( int i=0 ; i<count; i++) {
                
                NSDictionary* d = [infos objectAtIndex:i];
                
                DataModel* model = [[DataModel alloc]init];
                
                if (!strIsEmpty([d objectForKey:@"createtime"])) {
                    model.s_createtime = [d objectForKey:@"createtime"];
                }
                if (!strIsEmpty([d objectForKey:@"title"])) {
                    model.s_title = [d objectForKey:@"title"];
                }
                if (!strIsEmpty([d objectForKey:@"s_photo"])) {
                    model.s_photo = [d objectForKey:@"s_photo"];
                }
                if (!strIsEmpty([d objectForKey:@"id"])) {
                    model.s_mgid = [d objectForKey:@"id"];
                }
                if (!strIsEmpty([d objectForKey:@"content"])) {
                    model.s_content = [d objectForKey:@"content"];
                }
                
                UILog(@"s_content--> %@",model.s_content);
                [dataArr addObject:model];
            }
            [self.myTableView reloadData];
        }
        //NSString* info = [NSString stringWithFormat:@"%@",[dic objectForKey:@"info"]];
        //ALERT_OK(info);
        //UILog(@"dict %@  pagecount:%d",dic,pagecount);
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
    
    return dataArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString* Identifier = @"cell";
    
    NoticeTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:Identifier];
    
    if (cell == nil)
    {
        NSArray * nibViews  =[[NSBundle mainBundle] loadNibNamed:@"NoticeTableViewCell" owner:self options:nil];
        cell= (NoticeTableViewCell*)[nibViews objectAtIndex:0];
    }
    if (dataArr.count!=0) {
        DataModel* model = [dataArr objectAtIndex:indexPath.row];
        NSURL* url  = [NSURL URLWithString:model.s_photo];
        [cell.i_image setImageWithURL:url placeholderImage:[UIImage imageNamed:@"默认头像.png"]];
        
        cell.time_label.text = model.s_createtime;
        
        cell.product_name.text = [NSString stringWithFormat:@"%@",model.s_content];
    }
    //cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}




-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NoticeTableViewCell *cell = (NoticeTableViewCell*)[self tableView:self.myTableView cellForRowAtIndexPath:indexPath];
    return cell.height;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //EventDetails* vc = [[EventDetails alloc]init];
    //[self.navigationController pushViewController:vc animated:YES];
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
