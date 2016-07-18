//
//  MyViewController.m
//  Handwork
//
//  Created by ios on 15-4-29.
//  Copyright (c) 2015年 周文超. All rights reserved.
//

#import "MyViewController.h"
#import "MyHomeViewController.h"
#import "MyViewTableViewCell.h"
#import "SettingsViewController.h"
#import "ActivityListViewController.h"
#import "SavingViewController.h"
#import "NoticeViewController.h"
#import "PersonalDataViewController.h"
#import "CertificationViewController.h"
#import "TipsHud.h"
#import "RegisteredViewController.h"

#define Head_Tag 100
@interface MyViewController ()
{
    NSArray* titleArr;
    
    NSArray* imgArr;
    
    NSInteger noticeCount; // 通知数目
    NSInteger praise;      // 赞数目
    NSInteger all_activities; // 参与活动数目
    
    NSString* isauth;
}
@property (strong, nonatomic) IBOutlet UITableView *myTableView;

@end

@implementation MyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    return;
    titleArr = @[@"认证",@"赞",@"活动",@"通知",@"设置"];
    
    imgArr = @[@"个人-认证",@"收藏",@"个人-活动",@"消息",@"设置"];
    self.view.backgroundColor = colorToString(@"f6f6f6");
    self.myTableView.separatorColor = colorToString(@"#dddddd");
    
    
    
    //UILog(@"isauth1 %@",isauth);
    //[self.myTableView setSectionFooterHeight:10];
    //[self.myTableView setSectionHeaderHeight:10];
    // Do any additional setup after loading the view from its nib.
    
    
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    // 只需要读取基本信息即可，没必要获取列表数据
    [self getPeopleCard];
    
    //[self loadData];
    
    //[self getAllMessages];
    
    //[self getUpclicks];
}

// Account/peopleCard
-(void)getPeopleCard
{
        NSMutableDictionary* dict = [NSMutableDictionary dictionary];
        NSString* url = [NSString stringWithFormat:@"Account/peopleCard"];
        ASIHTTPRequest* request = [HttpRequest requestPost:url Dic:dict authorization:YES];
        
        __weak typeof(ASIHTTPRequest) * request_weak = request;
        
        
        [request_weak setCompletionBlock:^{
            
            NSDictionary* dic = [[request_weak responseString]objectFromJSONString];
            //[MBProgressHUD hideHUDForView:self.view animated:NO];
           
            NSInteger status = [[dic objectForKey:@"status"]intValue];
            
            [self isDistance:status];
            
            if (status!=1) {
                
                UILog(@"dict ===> %@",dic);
                NSString* info = [NSString stringWithFormat:@"%@",[dic objectForKey:@"info"]];
                //ALERT_OK(info);
                return ;
            }
            
            //UILog(@"++ %@",dic);
            
           
            // 读取点赞数、参加活动数、消息数
            NSDictionary* data = [dic objectForKey:@"data"];
            
            
            NSDictionary* userinfo = [data objectForKey:@"userinfo"];
            
            NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
            //isauth = [userDefaults objectForKey:API_ISAUTH];
            
            isauth = [NSString stringWithFormat:@"%d",[[userinfo objectForKey:@"isauth"]intValue]];
            
            [userDefaults setObject:isauth forKey:API_ISAUTH];
            
            NSString* s_photo =  [NSString stringWithFormat:@"%@",[userinfo objectForKey:@"s_photo"]];
            [userDefaults setObject:s_photo forKey:LOCAL_PHOTO];
            
            
            NSString* s_nickname =  [NSString stringWithFormat:@"%@",[userinfo objectForKey:@"nickname"]];
            [userDefaults setObject:s_nickname forKey:LOCAL_NICKNAME];
            
            
            if ([data objectForKey:@"upclickcount"] != nil) {
                praise = [[data objectForKey:@"upclickcount"] integerValue];
            }
            if ([data objectForKey:@"joinactcount"] != nil) {
                all_activities = [[data objectForKey:@"joinactcount"] integerValue];
            }
            if ([data objectForKey:@"totalmsg"] != nil) {
                noticeCount = [[data objectForKey:@"totalmsg"] integerValue];
            }
            
            // 刷新显示
            [self.myTableView reloadData];
        }];
        
        [request_weak setFailedBlock:^{
            //[MBProgressHUD hideHUDForView:self.view animated:NO];
           
        }];
  
    //[MBProgressHUD showHUDAddedTo:self.view animated:YES withText:@"正在加载" detailText:nil];
        [request_weak startAsynchronous];
}

#pragma mark UITabViewDataSource
-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //UILog(@"tableViewData :  %d",tableViewData.count);
    if (section==0) {
        return 1;
    }
    if (section==1) {
        return 1;
    }
    if (section==2) {
        return 3;
    }
    if (section==3) {
        return 1;
    }
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier = @"Cell";
    
    MyViewTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil)
    {
        //cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        NSArray * nibViews  =[[NSBundle mainBundle] loadNibNamed:@"MyViewTableViewCell" owner:self options:nil] ;
        cell= [nibViews objectAtIndex:0];
    }
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    //[[cell imageView] setImage:[self tripPhotoForRowAtIndexPath:indexPath]];
    //cell.textLabel.text = [NSString stringWithFormat:@"%d",indexPath.row];
    //UIImageView* image =(UIImageView*)[self.view viewWithTag:Head_Tag];
    
    //cell.label1.text = [self tripNameForRowAtIndexPath:indexPath];
    cell.label1.textColor = colorToString(@"#333333");
    cell.label2.textColor = colorToString(@"#999999");
    if (indexPath.section==0)
    {
        [cell setHeight:80];
        NSUserDefaults* userfaulst = [NSUserDefaults standardUserDefaults];
        
        NSString* url =  [userfaulst objectForKey:LOCAL_PHOTO];
        
        [cell.headImage setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"默认头像.png"]];
        
        
        cell.headImage.frame = CGRectMake(10, cell.height/2-30, 60, 60);
        cell.headImage.layer.masksToBounds = YES;
        cell.headImage.layer.cornerRadius = 30;
        
        // 游客账号提示注册会员
        if ([self IS_Guest]) {
            cell.label1.text = @"游客 (点击注册成为会员)";
        } else {
            cell.label1.text = [userfaulst objectForKey:LOCAL_NICKNAME];
        }
        
        
        [cell.label1 setTop:cell.height/2-10];
        [cell.label1 setWidth:200];
        [cell.label1 setLeft:cell.headImage.right+5];
        cell.label2.hidden = YES;
        
        UIButton* btn = [[UIButton alloc]init];
        [btn addTarget:self action:@selector(replace_picture) forControlEvents:UIControlEventTouchUpInside];
        
        btn.frame = cell.headImage.frame;
        [cell.contentView addSubview:btn];
    }
    if (indexPath.section==1)
    {
        // 游客账号隐藏认证栏
        if ([self IS_Guest])
            [cell setHeight:0];
        else
            [cell setHeight:45];
        
        cell.label1.text = [titleArr objectAtIndex:0];
        [cell.label1 setTop:cell.height/2-10];
        NSString* s= @"";
        [cell.headImage setImage:[UIImage imageNamed:[imgArr objectAtIndex:0]]];
        
        [cell.headImage setTop:cell.height/2-17/2];
          [cell.label2 setLeft:_Screen_Width-100];
        if ([isauth isEqualToString:@"0"])
        {
            s=@"认证成为工艺家,可发表作品";
            cell.label1.text =@"认证";
              [cell.label2 setLeft:_Screen_Width-204];
        }
        if ([isauth isEqualToString:@"1"])
        {
            s=@"认证工艺师";
            [cell.headImage setImage:[UIImage imageNamed:@"个人-主页"]];
            cell.label1.text =@"我的主页";
            [cell.label1 setWidth:80];
        }
        if ([isauth isEqualToString:@"2"])
        {
            s=@"认证中";
        }
        if ([isauth isEqualToString:@"3"])
        {
            s=@"";
            s=@"认证成为工艺家,可发表作品";
            [cell.label2 setLeft:_Screen_Width-204];
        }
        //cell.label2.backgroundColor = [UIColor redColor];
        cell.label2.text = [NSString stringWithFormat:@"%@",s];
        //UILog(@"+++ %d",cell.label2.left+cell.label2.text.length*15);
      
        //[cell.label2 setLeft:cell.label1.right+30];
        [cell.label2 setTop:cell.height/2-10];
        
    }
    
    if (indexPath.section==2)
    {
        //[cell setHeight:55];
        if (indexPath.row==0) {
            cell.label1.text = [titleArr objectAtIndex:1];
            cell.label2.text = [NSString stringWithFormat:@"(%ld)",(long)praise];
            [cell.label2 setLeft:cell.label1.text.length*15+cell.label1.left+2];
            [cell.headImage setImage:[UIImage imageNamed:[imgArr objectAtIndex:1]]];
        }
        if (indexPath.row==1) {
            cell.label1.text = [titleArr objectAtIndex:2];
            cell.label2.text = [NSString stringWithFormat:@"(%ld)",(long)all_activities];
            [cell.headImage setImage:[UIImage imageNamed:[imgArr objectAtIndex:2]]];
        }
        if (indexPath.row==2) {
            cell.label1.text = [titleArr objectAtIndex:3];
            cell.label2.text = [NSString stringWithFormat:@"(%ld)",(long)noticeCount];
            // [cell.label2 setLeft:cell.label1.right+30];
            [cell.headImage setImage:[UIImage imageNamed:[imgArr objectAtIndex:3]]];
        }
    }
    
    if (indexPath.section==3)
    {
        if (indexPath.row==0) {
            cell.label1.text = [titleArr objectAtIndex:4];
            cell.label2.text = [NSString stringWithFormat:@""];
            [cell.headImage setImage:[UIImage imageNamed:[imgArr objectAtIndex:4]]];
        }
    }
    //[cell.imageView setImage:[self tripPhotoForRowAtIndexPath:indexPath]];
    UIView* line = [[UIView alloc]init];
    line.backgroundColor = RGB_MAKE(234, 234, 234);
    line.frame = CGRectMake(0, cell.height-1, _Screen_Width, 1);
    [cell.contentView addSubview:line];
    return cell;
}
-(void)replace_picture
{
    UILog(@"更换头像");
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //UILog(@"%ld",(long)indexPath.row);
    
    if (indexPath.section==0) {
        
        if ([self IS_Guest])
        {
            RegisteredViewController* vc = [[RegisteredViewController alloc]init];
            //vc.s_type =[[NSString alloc]initWithFormat:@"login"];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
            return ;
        }
        
        PersonalDataViewController* vc= [[PersonalDataViewController alloc]init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
    if (indexPath.section==1)
    {
        // 游客禁止认证
        if ([self IS_Guest])
            return ;
        
        if ([isauth isEqualToString:@"0"]) {
            CertificationViewController* vc =[[CertificationViewController alloc]init];
            //vc.s_type = @"isauth";
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
        if ([isauth isEqualToString:@"1"]) {
            MyHomeViewController* vc =[[MyHomeViewController alloc]init];
            vc.title = [[NSUserDefaults standardUserDefaults] objectForKey:LOCAL_NICKNAME];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
    if (indexPath.section==2)
    {
        
        if (indexPath.row==0) {
            if (praise == 0)
            {
                [TipsHud ShowTipsHud:@"暂无点赞作品!" :self.view];
                return ;
            }
            SavingViewController* vc = [[SavingViewController alloc]init];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
        if (indexPath.row==1) {
            if (all_activities == 0)
            {
                [TipsHud ShowTipsHud:@"暂未参加活动!" :self.view];
                return ;
            }
            ActivityListViewController* vc= [[ActivityListViewController alloc]init];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
        
        if (indexPath.row==2) {
            
            if (noticeCount == 0)
            {
                [TipsHud ShowTipsHud:@"暂无通知!" :self.view];
                return ;
            }
            
            NoticeViewController* vc = [[NoticeViewController alloc]init];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
    if (indexPath.section==3) {
        if (indexPath.row==0) {
            
            SettingsViewController* vc = [[SettingsViewController alloc]init];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
    
        }
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    MyViewTableViewCell *cell = (MyViewTableViewCell*)[self tableView:self.myTableView cellForRowAtIndexPath:indexPath];
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

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    
    return 0;
}
//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    UIView* v = [[UIView alloc]init];
//    v.frame = CGRectMake(0, 0, _Screen_Width, 20);
//    v.backgroundColor = [UIColor redColor];
//    
//    return v;
//}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
//    if (section == 1)
//    {
//        
//        UIView* header = [[UIView alloc]init];
//        header.backgroundColor = [UIColor redColor];
//        //header.layer.masksToBounds = YES;
//        //header.layer.borderWidth = 1;
//        //header.layer.borderColor = [colorToString(@"#dddddd") CGColor];
//        UILabel* label = [[UILabel alloc]init];
//        label.text = @"";
//        [label setFrame:CGRectMake(10, 35/2-20/2, 100,15)];
//        [header addSubview:label];
//        return header;
//        
//    }
//    else
//    {
//        return nil;
//    }
    UIView* header = [[UIView alloc]init];
    header.backgroundColor = colorToString(@"#f6f6f6");
    //header.layer.masksToBounds = YES;
    //header.layer.borderWidth = 1;
    //header.layer.borderColor = [colorToString(@"#dddddd") CGColor];
    UILabel* label = [[UILabel alloc]init];
    label.text = @"";
    [label setFrame:CGRectMake(10, 35/2-20/2, 100,15)];
    [header addSubview:label];
    return header;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)dealloc
{
    titleArr = nil;
    imgArr = nil;
    self.myTableView = nil;
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
