//
//  InstituteViewController.m
//  Handwork
//
//  Created by ios on 15-5-4.
//  Copyright (c) 2015年 周文超. All rights reserved.
//

#import "InstituteViewController.h"
#import "ActivityTableViewCell.h"
#import "EventDetails.h"
#import "WebDetailViewController.h"

#import "ACETelPrompt.h"
#import <MessageUI/MFMailComposeViewController.h>
@interface InstituteViewController ()<MFMailComposeViewControllerDelegate>
{
    IBOutlet UITableView *myTableView;
    NSArray* imgArr;
    NSMutableArray* titleArr;
   
    NSMutableArray* dataArr;
    NSMutableArray* activityArr;
    
    UIImageView* logoImageView;
}

@property (nonatomic,strong)NSString* s_content;
@property (nonatomic,strong)NSString* s_bus;
@end

@implementation InstituteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"研究院";
    imgArr = @[@"",@"研究院-电话.png",@"研究院-邮箱.png",@"研究院-地址.png", @"乘车指引.png", @"研究院-规则.png"];
    titleArr = [[NSMutableArray alloc]initWithObjects:@"", @"", @"", @"", @"", @"",nil];
    
    
    dataArr = [[NSMutableArray alloc]init];
    activityArr = [[NSMutableArray alloc]init];
    //myTableView.separatorColor = [UIColor redColor];
    //myTableView.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view from its nib.
    
    UIView* afView = [[UIView alloc] initWithFrame:CGRectMake(0,0, _Screen_Width, _Screen_Width / 2)];
    afView.backgroundColor=[UIColor blackColor];
    [afView setContentMode:UIViewContentModeScaleAspectFill];
    
    logoImageView = [[UIImageView alloc]init];
    [logoImageView setImage:[UIImage imageNamed:@"默认.jpg"]];
    
    logoImageView.frame = CGRectMake(0, 0, _Screen_Width, _Screen_Width / 2);
    [afView addSubview:logoImageView];
    
    
    //afView.delegate=self;
    myTableView.tableHeaderView = afView;
    
    
    [self loadData];
    
    [self getTopactivity];
}
-(void)loadData
{
    NSString* url = [NSString stringWithFormat:@"Find/getInstitute"];
    
    ASIHTTPRequest* request = [HttpRequest requestPost:url Dic:nil authorization:YES];
    
    __weak typeof (ASIHTTPRequest)* request_weak = request;
    
    [request setCompletionBlock:^{
        NSDictionary* dic = [[request_weak responseString]objectFromJSONString];
       
        [MBProgressHUD hideHUDForView:self.view animated:NO];
        // NSDictionary* data = [dic objectForKey:@"data"];
        
        int status = [[dic objectForKey:@"status"]intValue];
        
        if (status!=1)
        {
            NSString* info = [NSString stringWithFormat:@"%@",[dic objectForKey:@"info"]];
            ALERT_OK(info);
            return ;
        }
        // UILog(@"获得-> %@",dic);
        NSDictionary* data =[dic objectForKey:@"data"];
        if (![data isEqual:[NSNull null]])
        {
            // 显示研究院logo
            if (!strIsEmpty([data objectForKey:@"m_image"]))
            {
                NSString* logoUrl = [data objectForKey:@"m_image"];
                if (!strIsEmpty(logoUrl))
                {
                    [logoImageView setImageWithURL:[NSURL URLWithString:logoUrl]
                              placeholderImage:[UIImage imageNamed:@"默认.jpg"]];
                }
            }
            
            if (!strIsEmpty([data objectForKey:@"name"])) {
             NSString* s = [data objectForKey:@"name"];
                [titleArr setObject:s atIndexedSubscript:0];
            }
            if (!strIsEmpty([data objectForKey:@"telphone"])) {
                NSString* s = [data objectForKey:@"telphone"];
                [titleArr setObject:s atIndexedSubscript:1];
            }
            if (!strIsEmpty([data objectForKey:@"mail"])) {
                NSString* s = [data objectForKey:@"mail"];
                [titleArr setObject:s atIndexedSubscript:2];
            }
            if (!strIsEmpty([data objectForKey:@"address"])) {
                NSString* s = [data objectForKey:@"address"];
                [titleArr setObject:s atIndexedSubscript:3];
            }

            // 这两项文字固定
            [titleArr setObject:@"乘车指引" atIndexedSubscript:4];
            [titleArr setObject:@"《工艺美术品交易服务标准》" atIndexedSubscript:5];

            // 乘车指引
            if (!strIsEmpty([data objectForKey:@"bus"])) {
                self.s_bus = [self filterHTML:[data objectForKey:@"bus"]];
            }

            if (!strIsEmpty([data objectForKey:@"standardurl"])) {
                self.s_content = [self filterHTML:[data objectForKey:@"standardurl"]];
                //[titleArr setObject:s atIndexedSubscript:4];
                //UILog(@"s %@",s);
            }
        }
        
        
        [myTableView reloadData];
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
        
        int status= [[dic objectForKey:@"status"]intValue];
        if (status!=1)
        {
            NSString* info = [NSString stringWithFormat:@"%@",[dic objectForKey:@"info"]];
            ALERT_OK(info);
            return ;
        }
        
        
        NSDictionary* data = [dic objectForKey:@"data"];
        
        NSArray* infos = [data objectForKey:@"infos"];
        
        if (infos.count!=0) {
            
            NSInteger count = infos.count;
            
            for (int i=0; i<count; i++){
                NSDictionary* d = [infos objectAtIndex:i];
                DataModel* model = [[DataModel alloc]init];
                if (!strIsEmpty([d objectForKey:@"image"])) {
                    //model.s_image =[NSString stringWithFormat:@"%@",[d objectForKey:@"image"]];
                    NSString* s = [NSString stringWithFormat:@"%@",[d objectForKey:@"image"]];
                    model.s_image = s;
                };
                if (!strIsEmpty([d objectForKey:@"id"])) {
                    //model.s_image =[NSString stringWithFormat:@"%@",[d objectForKey:@"image"]];
                    NSString* s = [NSString stringWithFormat:@"%@",[d objectForKey:@"id"]];
                    model.s_mgid = s;
                };
                
                if (!strIsEmpty([d objectForKey:@"title"])) {
                    //model.s_image =[NSString stringWithFormat:@"%@",[d objectForKey:@"image"]];
                    NSString* s = [NSString stringWithFormat:@"%@",[d objectForKey:@"title"]];
                    model.s_title = s;
                };
                if (!strIsEmpty([d objectForKey:@"startdatetime"])) {
                    //model.s_image =[NSString stringWithFormat:@"%@",[d objectForKey:@"image"]];
                    NSString* s = [NSString stringWithFormat:@"%@",[d objectForKey:@"startdatetime"]];
                    model.s_createtime = s;
                };
                if (!strIsEmpty([d objectForKey:@"address"])) {
                    //model.s_image =[NSString stringWithFormat:@"%@",[d objectForKey:@"image"]];
                    NSString* s = [NSString stringWithFormat:@"%@",[d objectForKey:@"address"]];
                    model.s_address = s;
                };
                [activityArr addObject:model];
            }
            
            [myTableView reloadData];
        }
        
    }];
    [request_weak startAsynchronous];
}

-(NSString *)filterHTML:(NSString *)html
{
    NSScanner * scanner = [NSScanner scannerWithString:html];
    NSString * text = nil;
    while([scanner isAtEnd]==NO)
    {
        //找到标签的起始位置
        [scanner scanUpToString:@"<" intoString:nil];
        //找到标签的结束位置
        [scanner scanUpToString:@">" intoString:&text];
        //替换字符
        html = [html stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@>",text] withString:@""];
    }
    //    NSString * regEx = @"<([^>]*)>";
    //    html = [html stringByReplacingOccurrencesOfString:regEx withString:@""];
    return html;
}
#pragma mark UITabViewDataSource
-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
//设置Section的Header
//-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
//
//    
//    if (section==1) {
//        NSString *result = @"近期活动";
//        return result;
//    }
//    else
//    {
//        return nil;
//    }
//}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 1)
    {
        
        UIView* header = [[UIView alloc]init];
        header.backgroundColor = [UIColor whiteColor];
        header.backgroundColor = RGB_MAKE(244, 244, 244);
        //header.layer.masksToBounds = YES;
        //header.layer.borderWidth = 1;
        //header.layer.borderColor = [colorToString(@"#dddddd") CGColor];
        
        UIView* view = [[UIView alloc]init];
        view.backgroundColor = [UIColor whiteColor];
        view.frame = CGRectMake(0,10 , _Screen_Width, 45);
        [header addSubview:view];
        
        UILabel* label = [[UILabel alloc]init];
        label.text = @"近期活动";
        label.textColor = colorToString(@"#333333");
        label.font = [UIFont systemFontOfSize:14];
        label.backgroundColor = [UIColor whiteColor];
        [label setFrame:CGRectMake(10,(45/2-10), 100, 20)];
        [view addSubview:label];
        return header;
        
    }
    else
    {
        return nil;
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0) {
        return titleArr.count;
    }
    if (section==1) {
        return activityArr.count;
    }
    
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString* Identifier = @"cell";
    
    ActivityTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:Identifier];
    
    if (cell == nil)
    {
        NSArray * nibViews  =[[NSBundle mainBundle] loadNibNamed:@"ActivityTableViewCell" owner:self options:nil];
        cell= (ActivityTableViewCell*)[nibViews objectAtIndex:0];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    if (indexPath.section==0)
    {
        [cell setHeight:45];
        cell.label3.text = @"";
        cell.label2.text = @"";
        cell.label1.text = [titleArr objectAtIndex:indexPath.row];
        [cell.label1 setFrame:CGRectMake(45, cell.height/2-10, 250, 20)];
        cell.label1.textColor = colorToString(@"#333333");
        cell.label1.font = [UIFont systemFontOfSize:15];
       // [cell.left_image setImage:nil];
        
        NSString* s_image = [imgArr objectAtIndex:indexPath.row];
        
        [cell.imageView setImage:[UIImage imageNamed:s_image]];
        //UILog(@"s_image %@",s_image);
//        cell.textLabel.text = [titleArr objectAtIndex:indexPath.row];
        
   
        if (indexPath.row==0)
        {
            cell.accessoryType = UITableViewCellAccessoryNone;
            [cell.label1 setFrame:CGRectMake(15, cell.height/2-10, 250, 20)];
        }
        if (indexPath.row==3) {
            cell.label1.frame = CGRectMake(45, cell.height/2-20/2, 250, 20);
            cell.label1.text = [titleArr objectAtIndex:indexPath.row];
            cell.label1.numberOfLines = 0;
            [cell.label1 sizeToFit];
            cell.textLabel.text = @"";
            
            [cell setHeight:cell.label1.height+20];
        }
//
//        if (indexPath.row==4) {
//            UIView* line= [[UIView alloc]init];
//            line.backgroundColor = colorToString(@"#dddddd");
//            line.frame = CGRectMake(12, cell.height-1, _Screen_Width-12, 1);
//            [cell.contentView addSubview:line];
//        }
        
//        UIView* line= [[UIView alloc]init];
//        line.backgroundColor = colorToString(@"#dddddd");
//        line.frame = CGRectMake(12, cell.height-1, _Screen_Width-12, 1);
//        [cell.contentView addSubview:line];
    }
    
    if (indexPath.section==1) {
        
        if (activityArr.count!=0) {
            
            DataModel* model = [activityArr objectAtIndex:indexPath.row];
            NSURL* URL = [NSURL URLWithString:model.s_image];
            [cell.left_image setImageWithURL:URL placeholderImage:nil];
            
            
            cell.label1.text = model.s_title;
            cell.label2.text = [NSString stringWithFormat:@"地点: %@",model.s_address];
            cell.label3.text = [NSString stringWithFormat:@"时间: %@",model.s_createtime];
            
            if (indexPath.row==0) {
                UIView* line= [[UIView alloc]init];
                line.backgroundColor = colorToString(@"#dddddd");
                line.frame = CGRectMake(12, 0, _Screen_Width-12, 1);
                [cell.contentView addSubview:line];
            }
            UIView* line= [[UIView alloc]init];
            line.backgroundColor = colorToString(@"#dddddd");
            line.frame = CGRectMake(12, cell.height-1, _Screen_Width-12, 1);
            [cell.contentView addSubview:line];
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        
    }
    return cell;
}




-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    ActivityTableViewCell *cell = (ActivityTableViewCell*)[self tableView:myTableView cellForRowAtIndexPath:indexPath];
    return cell.height;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //EventDetails* vc = [[EventDetails alloc]init];
    //[self.navigationController pushViewController:vc animated:YES];
    if (indexPath.section==0) {

        if (indexPath.row==4) { // 乘车指引
            WebDetailViewController* vc = [[WebDetailViewController alloc]init];
            vc.url = self.s_bus;
            vc.title = @"乘车指引";
            [self.navigationController pushViewController:vc animated:YES];
        }
        else if (indexPath.row==5) { // 工艺美术交易服务标准
            WebDetailViewController* vc = [[WebDetailViewController alloc]init];
            NSUserDefaults* user = [NSUserDefaults standardUserDefaults];
            vc.url = [NSString stringWithFormat:@"%@?%@",self.s_content,[user objectForKey:API_TOKEN]];
            vc.title = @"工艺美术交易服务标准";
            [self.navigationController pushViewController:vc animated:YES];
        }
        
        
        if (indexPath.row==1) {
            [ACETelPrompt callPhoneNumber:[titleArr objectAtIndex:indexPath.row] call:^(NSTimeInterval duration)
             {
                 NSLog(@"用户打了一个电话用了 %.1f 秒", duration);
             } cancel:^{
                 NSLog(@"用户取消了电话");
             }];
        }
        
        if (indexPath.row==2) {
            [self sendMailInApp];
        }
        
        if (indexPath.row==3) {
            
            WebDetailViewController* vc = [[WebDetailViewController alloc]init];
            //NSString* url = @"";
            vc.url = [NSString stringWithFormat:@"http://map.baidu.com/?shareurl=1&poiShareUid=669775d0cc388426fc0eb0be#1"];
            
            vc.title = @"百度地图";
            [self.navigationController pushViewController:vc animated:YES];
        }
    
    }
    
    if (indexPath.section==1) {
        if (activityArr.count!=0) {
            DataModel* model = [activityArr objectAtIndex:indexPath.row];
            EventDetails* vc = [[EventDetails alloc]init];
            vc.mgid = model.s_mgid;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
    
    UILog(@"--> %d",indexPath.row);
}

//-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
//{
//    return 35;
//}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section ==0)
        return 0.0f;
    else
        return 55;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - 在应用内发送邮件
//激活邮件功能
- (void)sendMailInApp
{
    Class mailClass = (NSClassFromString(@"MFMailComposeViewController"));
    if (!mailClass) {
        //[self alertWithMessage:@"当前系统版本不支持应用内发送邮件功能，您可以使用mailto方法代替"];
        ALERT_OK(@"当前系统版本不支持应用内发送邮件功能，您可以使用mailto方法代替");
        return;
    }
    if (![mailClass canSendMail]) {
        //[self alertWithMessage:@"用户没有设置邮件账户"];
        ALERT_OK(@"用户没有设置邮件账户");
        return;
    }
    [self displayMailPicker];
}
//调出邮件发送窗口
- (void)displayMailPicker
{
    MFMailComposeViewController *mailPicker = [[MFMailComposeViewController alloc] init];
    mailPicker.mailComposeDelegate = self;
    
    //设置主题
    [mailPicker setSubject: @"主题"];
    //添加收件人
    NSArray *toRecipients = [NSArray arrayWithObject:@""];
    [mailPicker setToRecipients: toRecipients];
    //添加抄送
    //NSArray *ccRecipients = [NSArray arrayWithObjects:@"second@example.com", @"third@example.com", nil];
    
    //[mailPicker setCcRecipients:ccRecipients];
    
    //添加密送
    //NSArray *bccRecipients = [NSArray arrayWithObjects:@"fourth@example.com", nil];
    //[mailPicker setBccRecipients:bccRecipients];
    
    // 添加一张图片
    UIImage *addPic = [UIImage imageNamed: @"logo150x150.png"];
    NSData *imageData = UIImagePNGRepresentation(addPic);            // png
    //关于mimeType：http://www.iana.org/assignments/media-types/index.html
    [mailPicker addAttachmentData: imageData mimeType: @"" fileName: @"Icon.png"];
    
    //添加一个pdf附件
    //NSString *file = [self fullBundlePathFromRelativePath:@"高质量C++编程指南.pdf"];
    //NSData *pdf = [NSData dataWithContentsOfFile:file];
    //[mailPicker addAttachmentData:pdf mimeType: @"" fileName: @"高质量C++编程指南.pdf"];
    
    NSString *emailBody = @"<font color='red'>内容</font> 正文";
    [mailPicker setMessageBody:emailBody isHTML:YES];
    //[self presentModalViewController: mailPicker animated:YES];
    [self presentViewController:mailPicker animated:YES completion:nil];
    
}
#pragma mark - 实现 MFMailComposeViewControllerDelegate
- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    //关闭邮件发送窗口
    //    [self dismissModalViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
    NSString *msg;
    switch (result) {
        case MFMailComposeResultCancelled:
            msg = @"取消编辑邮件";
            break;
        case MFMailComposeResultSaved:
            msg = @"成功保存邮件";
            break;
        case MFMailComposeResultSent:
            msg = @"将邮件放到队列中，还没发送";
            break;
        case MFMailComposeResultFailed:
            msg = @"保存或者发送邮件失败";
            break;
        default:
            msg = @"";
            break;
    }
    ALERT_OK(msg);
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
