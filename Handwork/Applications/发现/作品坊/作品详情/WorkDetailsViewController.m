//
//  WorkDetailsViewController.m
//  Handwork
//
//  Created by ios on 15-5-5.
//  Copyright (c) 2015年 周文超. All rights reserved.
//

#import "WorkDetailsViewController.h"
#import "AdvertisingColumn.h"
#import "PersonalDataViewController.h"
#import "ProductionProcessViewController.h"
#import "MyHomeViewController.h"
#import "LeaveMessageViewController.h"
#import "ImageBrowsingViewController.h"
#import "TableViewCell.h"
#import "XHImageViewer.h"
#import "InstituteViewController.h"

#import "savingAndCommentsList.h"
#import "UIView+Animated.h"

#import <ShareSDK/ShareSDK.h>


//#import "CustomUITableView.h"
//
//#import "CustomTableViewCell.h"

//static NSString *const menuCellIdentifier = @"rotationCell";

@interface WorkDetailsViewController ()<AdvertisingColumnDelegate,XHImageViewerDelegate>
{
    AdvertisingColumn *_headerView;
    IBOutlet UIScrollView *scrollView;
    IBOutlet UIButton *btn1;
    IBOutlet UIButton *btn2;
    IBOutlet UIButton *btn3;
    IBOutlet UILabel *titlelabel;
    IBOutlet UILabel *contentlabel;
    IBOutlet UIView *line;
    IBOutlet UILabel *introductionlabel;
    IBOutlet UILabel *authorinformation;
    //IBOutlet UIScrollView *small_scroll;
    
    
    NSMutableArray *headImgArray; // 头部中图
    NSMutableArray *imgArray;     // 全屏大图
    
    IBOutlet UIImageView *headImage;
    IBOutlet UILabel *issale_label;
    //NSMutableArray* _imageViews;
    IBOutlet UIView *information_view;
    IBOutlet UIView *user_information_view;
    IBOutlet UIView *content_view;
    IBOutlet UILabel *namelabel;
    
    IBOutlet UILabel *nicknamelabel;
   
    IBOutlet UIImageView *isupclick_image;
    IBOutlet UITableView *myTableView;
    IBOutlet UIButton *madeflowinfo_btn;
    NSMutableArray*  detailsArr;
    NSMutableArray*  dataArr;
    IBOutlet UILabel *upclickcount_label;
    IBOutlet UILabel *remsgcount_label;
    
    NSString* createman;
    NSString* isupclick;
    IBOutlet UIView *introduction_view;
    UIImageView* bgimage;
    
    IBOutlet UIView* tableview_backgroundColor;
    
    NSString* detailUrl;
    NSString* nickname;
    NSString* jobtitle;
    NSString* imageUrl;
}
@end

@implementation WorkDetailsViewController
- (IBAction)btn_click:(UIButton *)sender {
    //UILog(@"%d",sender.tag);
    if (sender.tag==0) {
        ProductionProcessViewController* vc =[[ProductionProcessViewController alloc]init];
        vc.madeflowinfo = self.madeflowinfo;
        [self.navigationController pushViewController:vc animated:YES];
    }
    if (sender.tag==1) {
        
        
        if (tableview_backgroundColor.hidden==YES) {
            tableview_backgroundColor.hidden =NO;
            [self.navigationController.view addSubViewiew:tableview_backgroundColor withSidesConstrainsInsets:UIEdgeInsetsZero];
        }
        else
        {
            tableview_backgroundColor.hidden=YES;
        }
    }
    if (sender.tag==2) {
        InstituteViewController* vc= [[InstituteViewController alloc]init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];

    }
    if (sender.tag==3) {
        MyHomeViewController* vc = [[MyHomeViewController alloc]init];
        vc.uid = self.uid;
        [self.navigationController pushViewController:vc animated:YES];
    }
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (IBAction)btn_click1:(UIButton *)sender {
    
    //UILog(@"%ld",(long)sender.tag);
    if (sender.tag==0) {
//        if ([self Check_Guest]) {
//            return;
//        }
//        ALERT_OK(@"分享");
        NSString *imagePath = nil;
        if (imgArray.count!=0) {
            
            imagePath =  [imgArray objectAtIndex:0];
        }
        if (imagePath == nil) {
            return;
        }
        
        //作品名称 - 作者昵称
        NSString* title_nickname = [NSString stringWithFormat:@"%@ － %@",titlelabel.text,namelabel.text];
        
        NSString* url = [NSString stringWithFormat:@"%@",detailUrl];
        
        //构造分享内容
        id<ISSContent> publishContent = [ShareSDK content:title_nickname
                                           defaultContent:@"分享自手作品App"
                                                    image:[ShareSDK imageWithUrl:imagePath]
                                                    title:title_nickname
                                                      url:url
                                              description:@"国内领先的手工艺O2O平台"
                                                mediaType:SSPublishContentMediaTypeNews];
        //创建弹出菜单容器
        id<ISSContainer> container = [ShareSDK container];
        [container setIPadContainerWithView:sender arrowDirect:UIPopoverArrowDirectionUp];
        
        //弹出分享菜单
        [ShareSDK showShareActionSheet:container
                             shareList:nil
                               content:publishContent
                         statusBarTips:YES
                           authOptions:nil
                          shareOptions:nil
                                result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                    
                                    if (state == SSResponseStateSuccess)
                                    {
                                        //NSLog(NSLocalizedString(@"TEXT_ShARE_SUC", @"分享成功"));
                                        ALERT_OK(@"分享成功!");
                                    }
                                    else if (state == SSResponseStateFail)
                                    {
                                        //NSLog(NSLocalizedString(@"TEXT_ShARE_FAI", @"分享失败,错误码:%d,错误描述:%@"), [error errorCode], [error errorDescription]);
                                        
                                        NSLog(@"分享失败,错误码:%ld,错误描述:%@",[error errorCode], [error errorDescription]);
                                        
                                        ALERT_OK(@"分享失败!");
                                    }
                                }];
    }
    if (sender.tag==1) {
        
//        if ([self Check_Guest])
//        {
//            return;
//        }
        [self savingclick:sender];
        
        UILog(@"%ld",(long)sender.tag);
    }
    if (sender.tag==2) {
//        if ([self Check_Guest])
//        {
//            return;
//        }
        savingAndCommentsList* vc = [[savingAndCommentsList alloc]init];
        vc.type =[NSString stringWithFormat:@"%ld", sender.tag-1];
        vc.mgid = self.mgid;
        [self.navigationController pushViewController:vc animated:YES];
    }
}


//点攒处理
-(void)savingclick:(UIButton*)sender
{

    NSString* s = nil;
    
    if ([isupclick isEqualToString:@"0"]) {
        s=@"upClick";
    }
    else
    {
        s=@"cancelUpclick";
    }
    
    
    NSString* url =  [NSString stringWithFormat:@"Works/%@",s];
    NSMutableDictionary* dic = [NSMutableDictionary dictionary];
    [dic setValue:self.mgid forKey:@"id"];
    
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
        self.vc.isRefresh = YES;
        [self loadData];
    }];
    
    [weak_request startAsynchronous];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    tableview_backgroundColor.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.55];
    tableview_backgroundColor.hidden = YES;
    [tableview_backgroundColor addSubview:myTableView];
    
    dataArr = [[NSMutableArray alloc]initWithObjects:@"作品登记卡",@"作品名称",@"材料",@"尺寸",@"出品地",@"出品人",@"职称",@"",@"制作工艺",@"制作工时",@"参考价格",@"定制时间",@"作品编号",@"",@"包装",@"广东省岭南民间工艺研究院监制",nil];
    
    detailsArr = [[NSMutableArray alloc]initWithObjects:@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",nil];
    
    
    contentlabel.textColor = colorToString(@"#666666");
    line.backgroundColor = colorToString(@"#cccccc");
    introductionlabel.textColor = colorToString(@"#999999");
    authorinformation.textColor = colorToString(@"#999999");
    titlelabel.textColor = colorToString(@"#333333");
    
    issale_label.backgroundColor = RGB_MAKE(14, 160, 0);
    issale_label.font = [UIFont systemFontOfSize:15];
    
    [btn1 setTitleColor:colorToString(@"#333333") forState:UIControlStateNormal];
    [btn2 setTitleColor:colorToString(@"#333333") forState:UIControlStateNormal];
    [btn3 setTitleColor:colorToString(@"#333333") forState:UIControlStateNormal];
    
    /*
     ***广告栏
     */
    _headerView = [[AdvertisingColumn alloc]initWithFrame:CGRectMake(0,0,_Screen_Width,150)];
    
    _headerView.backgroundColor = [UIColor blackColor];
    _headerView.delegate =self;
    
    /*
     ***加载的数据
     */
    headImgArray = [[NSMutableArray alloc]init];
    imgArray = [[NSMutableArray alloc]init];
    
    //[_headerView setImageArr:imgArray];
    
    [scrollView addSubview:_headerView];
    
    self.title = @"作品详情";
    [scrollView setContentSize:CGSizeMake(0, _Screen_Height+60)];
    if (_Screen_Height==480) {
        [scrollView setContentSize:CGSizeMake(0, _Screen_Height+150)];
    }
    
    
    btn1.layer.borderWidth = 1;
    
    btn1.layer.borderColor = [colorToString(@"#cccccc") CGColor];
    btn2.layer.borderWidth = 1;
    
    btn2.layer.borderColor = [colorToString(@"#cccccc") CGColor];
    btn3.layer.borderWidth = 1;
    
    btn3.layer.borderColor = [colorToString(@"#cccccc") CGColor];
    // Do any additional setup after loading the view from its nib.
//     bgimage = [[UIImageView alloc]init];
//    [bgimage setImage:[UIImage imageNamed:@"启动页2.jpg"]];
//    bgimage.frame = CGRectMake(0, 0, _Screen_Width, _Screen_Height);
//    [self.view addSubview:bgimage];
    
    //return;
    [self loadData];
    
//    myTableView.layer.borderColor = [RGB_MAKE(141, 119, 105) CGColor];
//    myTableView.layer.borderWidth = 2;
    
    // 设置作品卡列表的颜色
    myTableView.alpha = 0.94;
    myTableView.backgroundColor = RGB_MAKE(209, 193, 180);
    myTableView.layer.borderWidth = 2;
    myTableView.layer.borderColor = [RGB_MAKE(141, 119, 105) CGColor];//设置列表边
//    [myTableView setWidth:_Screen_Width-40];
//    [myTableView setHeight:_Screen_Height-35];
    
}


-(void)loadData
{
    NSString* url =  [NSString stringWithFormat:@"Works/detailWorks"];
    NSMutableDictionary* dict = [NSMutableDictionary dictionary];
    
    //UILog(@"self.mgid-> %@",self.mgid);
    if (self.mgid !=nil) {
        [dict setValue:self.mgid forKey:@"id"];
    }
    else
    {
        return;
    }
    
    ASIHTTPRequest* request = [HttpRequest requestPost:url Dic:dict authorization:YES];
    __weak typeof(ASIHTTPRequest)* weak_request = request;
    
    [weak_request setCompletionBlock:^{
        [MBProgressHUD hideHUDForView:self.view animated:NO];
       
        NSDictionary* dic = [[weak_request responseString] objectFromJSONString];
        
        int status = [[dic objectForKey:@"status"]intValue];
        
        [self isDistance:status];
        if (status!=1) {
            return ;
        }
        
        //return;
        NSDictionary* data = [dic objectForKey:@"data"];
        
        NSDictionary* author = [data objectForKey:@"author"];
        
        //UILog(@"data %@",data);
        
//        return;
        
        if (!strIsEmpty([data objectForKey:@"detailUrl"])) {
             detailUrl = [data objectForKey:@"detailUrl"];
            
            UILog(@"detailUrl %@",detailUrl);
        }
        
        NSDictionary* workdetail = [data objectForKey:@"workdetail"];
        
        isupclick = nil;
        
        if (!strIsEmpty([[data objectForKey:@"isupclick"] stringValue]))
        {
            isupclick = [NSString stringWithFormat:@"%@",[[data objectForKey:@"isupclick"] stringValue]];
        }
        
        //UILog(@"isupclick %@",isupclick);
        if ([isupclick isEqualToString:@"0"]){
            [isupclick_image setImage:[UIImage imageNamed:@"(数据)点赞"]];
        }
        else
        {
            [isupclick_image setImage:[UIImage imageNamed:@"点赞"]];
        }
       remsgcount_label.text  = [workdetail objectForKey:@"remsgcount"];
        upclickcount_label.text = [workdetail objectForKey:@"upclickcount"];
        
        if (!strIsEmpty([workdetail objectForKey:@"gdname"])) {
            NSString* str= [NSString stringWithFormat:@"%@",[workdetail objectForKey:@"gdname"]];
            titlelabel.text = str;
            
            // 自动计算宽度
            CGSize size = CGSizeMake(210, 50);
            CGSize titleSize = [titlelabel.text sizeWithFont:titlelabel.font constrainedToSize:size lineBreakMode:UILineBreakModeWordWrap];
            [titlelabel setWidth:titleSize.width];
            
            [issale_label setLeft:titlelabel.width + titlelabel.left + 4];
        }
        
        // 显示出售状态
        issale_label.hidden = NO;
        
        // 出售状态：1：非卖品； 2：出售中； 3：已售
        int issale = [[workdetail objectForKey:@"issale"] intValue];
        int marktype = [[workdetail objectForKey:@"marktype"] intValue];
        if (issale == 1)
        {
            issale_label.text = @"非卖品";
        }
        else if (issale == 2)
        {
            if (marktype == 1)
            {
                issale_label.text = [NSString stringWithFormat:@"￥%@", [workdetail objectForKey:@"saleprice"]];
            }
            else
            {
                issale_label.text = @"洽商";
            }
        }
        else if (issale == 3)
        {
            issale_label.text = @"已售";
        }
        
        // 自动计算宽度
        CGSize size = CGSizeMake(320, 2000);
        CGSize labelsize = [issale_label.text sizeWithFont:issale_label.font constrainedToSize:size lineBreakMode:UILineBreakModeWordWrap];
        [issale_label setWidth:labelsize.width + 8];
        
        
        NSArray* workimgs = nil;
        if ( ![[data objectForKey:@"workimgs"] isEqual:[NSNull null]])
        {
            workimgs = [data objectForKey:@"workimgs"];
        }
        
        [headImgArray removeAllObjects];
        if (workimgs !=nil) {
            if (workimgs.count!=0)
            {
                NSInteger count = workimgs.count;
                for (int i=0; i<count; i++)
                {
                    NSDictionary* workimgsDic = [workimgs objectAtIndex:i];
                    if (!strIsEmpty([workimgsDic objectForKey:@"m_image"])) {
                        NSString* image = [NSString stringWithFormat:@"%@",[workimgsDic objectForKey:@"m_image"]];
                        [headImgArray addObject:image];
                    }
                }
                //CGSize size = [UIImage downloadImageSizeWithURL:[headImgArray objectAtIndex:0]];;
                
                CGFloat image_height =  _Screen_Width;
                [_headerView setHeight:image_height];
                [_headerView.scrollView setHeight:image_height];
                
                //[_headerView.pageControl setTop:_headerView.scrollView.height-40];
                [_headerView setArray:headImgArray];
                _headerView.pageControl.frame = CGRectMake(0, _headerView.scrollView.height-40, _Screen_Width, 20);
                [introduction_view setTop:_headerView.height];
                [content_view setTop:introduction_view.bottom];
            }
            
        }
        else {
//            [introduction_view setTop:0];
//            [content_view setTop:introduction_view.bottom];
            UIImageView* image = [[UIImageView alloc]init];
            [image setImage:[UIImage imageNamed:@"默认.jpg"]];
            image.frame = CGRectMake(0, 0, _Screen_Width, 150);
            [_headerView addSubview:image];
        }
        
        
        if (!strIsEmpty([workdetail objectForKey:@"description"])) {
            NSString* str= [NSString stringWithFormat:@"%@",[workdetail objectForKey:@"description"]];
            contentlabel.text = str;
            
            //UILog(@"+++ %@",str);
            contentlabel.numberOfLines=0;
            [contentlabel sizeToFit];
            [btn1 setTop:contentlabel.bottom+10];
            [btn2 setTop:btn1.bottom+8];
            [btn3 setTop:btn2.bottom+8];
            [content_view setHeight:25+contentlabel.height+175];
            
            [information_view setTop:content_view.bottom];
            [user_information_view setTop:information_view.bottom];
            
            [scrollView setContentSize:CGSizeMake(0, user_information_view.bottom+60)];
        }
        
        
       
        
        [imgArray removeAllObjects];
        if (workimgs.count!=0)
        {
            NSInteger count = workimgs.count;
            for (int i=0; i<count; i++)
            {
                NSDictionary* workimgsDic = [workimgs objectAtIndex:i];
                if (!strIsEmpty([workimgsDic objectForKey:@"image"])) {
                    NSString* image = [NSString stringWithFormat:@"%@",[workimgsDic objectForKey:@"image"]];
                    [imgArray addObject:image];
                }
            }
        }
        
        
        if (!strIsEmpty([author objectForKey:@"uid"]))
        {
            self.uid = [NSString stringWithFormat:@"%@",[author objectForKey:@"uid"]];
            
        }
        
        if (!strIsEmpty([author objectForKey:@"s_photo"]))
        {
            NSString* url = [NSString stringWithFormat:@"%@",[author objectForKey:@"s_photo"]];
            
            [headImage setImageWithURL:[NSURL URLWithString:url] placeholderImage:nil];
        }
        if (!strIsEmpty([author objectForKey:@"nickname"]))
        {
            NSString* url = [NSString stringWithFormat:@"%@",[author objectForKey:@"nickname"]];
            
            namelabel.text = url;
        }
        
        if (!strIsEmpty([author objectForKey:@"callname"]))
        {
            NSString* callname = [NSString stringWithFormat:@"%@",[author objectForKey:@"callname"]];
            
            nicknamelabel.text = callname;
        }
        //if (!strIsEmpty([mademan objectForKey:@"uname"]))
        //{
            //NSString* url = [NSString stringWithFormat:@"%@",[mademan objectForKey:@"uname"]];
            
        
        //}
        
        //NSDictionary* madeflow =[author objectForKey:@"madeflow"];
        //UILog(@"data %@",data);
        //return;
        if (!strIsEmpty([data objectForKey:@"madeflow"])) {
            NSString* str =[NSString stringWithFormat:@"%@",[data objectForKey:@"madeflow"]];
            self.madeflowinfo = str;
            //UILog(@"--> %@",str);
        }
        
        NSDictionary* workcard = [data objectForKey:@"workcard"];
        
        //作品登记卡
        if (![workcard isEqual:[NSNull null]]) {
            if(!strIsEmpty([workcard objectForKey:@"workname"]))
            {
                NSString* str = [NSString stringWithFormat:@"%@",[workcard objectForKey:@"workname"]];
                [detailsArr setObject:str atIndexedSubscript:1];
            }
            
            
            
            if(!strIsEmpty([workcard objectForKey:@"material"]))
            {
                NSString* str = [NSString stringWithFormat:@"%@",[workcard objectForKey:@"material"]];
                [detailsArr setObject:str atIndexedSubscript:2];
            }
//            if(!strIsEmpty([workcard objectForKey:@"size"]))
//            {
//                NSString* str = [NSString stringWithFormat:@"%@寸",[workcard objectForKey:@"size"]];
//                [detailsArr setObject:str atIndexedSubscript:3];
//            }
            if(!strIsEmpty([workcard objectForKey:@"size"]))
            {
                NSString* str = [NSString stringWithFormat:@"%@",[workcard objectForKey:@"size"]];
                [detailsArr setObject:str atIndexedSubscript:3];
            }
            if(!strIsEmpty([workcard objectForKey:@"madeplace"]))
            {
                NSString* str = [NSString stringWithFormat:@"%@",[workcard objectForKey:@"madeplace"]];
                [detailsArr setObject:str atIndexedSubscript:4];
            }
            
            if(!strIsEmpty([workcard objectForKey:@"mademan"]))
            {
                NSString* str = [NSString stringWithFormat:@"%@",[workcard objectForKey:@"mademan"]];
                [detailsArr setObject:str atIndexedSubscript:5];
            }
            if(!strIsEmpty([workcard objectForKey:@"jobtitle"]))
            {
                NSString* str = [NSString stringWithFormat:@"%@",[workcard objectForKey:@"jobtitle"]];
                [detailsArr setObject:str atIndexedSubscript:6];
            }
            
            if(!strIsEmpty([workcard objectForKey:@"producer"]))
            {
                NSString* str = [NSString stringWithFormat:@"%@",[workcard objectForKey:@"producer"]];
                
                
                [detailsArr setObject:str atIndexedSubscript:7];
            }
            //if (!strIsEmpty([workcard objectForKey:@"createman"])) {
                createman = [NSString stringWithFormat:@"%@",[workcard objectForKey:@"createman"]];
           // }
            
            if(!strIsEmpty([workcard objectForKey:@"manufacture"]))
            {
                NSString* str = [NSString stringWithFormat:@"%@",[workcard objectForKey:@"manufacture"]];
                [detailsArr setObject:str atIndexedSubscript:8];
            }
            if(!strIsEmpty([workcard objectForKey:@"productiontime"]))
            {
                NSString* str = [NSString stringWithFormat:@"%@",[workcard objectForKey:@"productiontime"]];
                [detailsArr setObject:str atIndexedSubscript:9];
            }
            if(!strIsEmpty([workcard objectForKey:@"referenceprice"]))
            {
                //NSString* str = [NSString stringWithFormat:@"%@",[workcard objectForKey:@"referenceprice"]];
                
                NSString* priceString = @"";
                // 出售状态：1：非卖品； 2：出售中； 3：已售
                int issale = [[workdetail objectForKey:@"issale"] intValue];
                int marktype = [[workdetail objectForKey:@"marktype"] intValue];
                if (issale == 1)
                {
                    priceString = @"非卖品";
                }
                else if (issale == 2)
                {
                    if (marktype == 1)
                    {
                        priceString = [NSString stringWithFormat:@"￥%@", [workdetail objectForKey:@"saleprice"]];
                    }
                    else
                    {
                        priceString = @"洽商";
                    }
                }
                else if (issale == 3)
                {
                    priceString = @"已售";
                }
                [detailsArr setObject:priceString atIndexedSubscript:10];
            }
            if(!strIsEmpty([workcard objectForKey:@"customtime"]))
            {
                NSString* str = [NSString stringWithFormat:@"%@",[workcard objectForKey:@"customtime"]];
                [detailsArr setObject:str atIndexedSubscript:11];
            }
            
            if(!strIsEmpty([workcard objectForKey:@"opusnumber"]))
            {
                NSString* str = [NSString stringWithFormat:@"%@",[workcard objectForKey:@"opusnumber"]];
                [detailsArr setObject:str atIndexedSubscript:12];
            }
            
            if(!strIsEmpty([workcard objectForKey:@"limited"]))
            {
                NSString* str = [NSString stringWithFormat:@"%@",[workcard objectForKey:@"limited"]];
                
                if ([str isEqualToString:@"1"]) {
                    str = @"原作";
                }
                if ([str isEqualToString:@"2"]) {
                    str = @"限量";
                }
                if ([str isEqualToString:@"3"]) {
                    str = @"量产";
                }
                
                [detailsArr setObject:str atIndexedSubscript:13];
            }
            if(!strIsEmpty([workcard objectForKey:@"packing"]))
            {
                NSString* str = [NSString stringWithFormat:@"%@",[workcard objectForKey:@"packing"]];
                [detailsArr setObject:str atIndexedSubscript:14];
            }
            if(!strIsEmpty([workcard objectForKey:@"institute"]))
            {
                NSString* str = [NSString stringWithFormat:@"%@",[workcard objectForKey:@"institute"]];
                [dataArr setObject:str atIndexedSubscript:15];
            }
            
//            nicknamelabel.text = [detailsArr objectAtIndex:6];
//            bgimage.hidden = YES;
            
            
//            UILog(@"-. %@",nicknamelabel.text);
            
            [myTableView reloadData];
        }
        
        //UILog(@"%@",dict);
    }];
   
    [MBProgressHUD showHUDAddedTo:self.view animated:YES withText:@"正在加载" detailText:nil];
    [weak_request startAsynchronous];
}

-(void)didClickPage:(AdvertisingColumn *)view atIndex:(NSInteger)index
{
    XHImageViewer *imageViewer = [[XHImageViewer alloc] init];
    imageViewer.delegate = self;
    [imageViewer showWithImageViews:view.ImageArr selectedView:[view.ImageArr objectAtIndex:index]];
}
#pragma mark 定时滚动scrollView
-(void)viewDidAppear:(BOOL)animated{
    //显示窗口
    [super viewDidAppear:animated];
    //[self loadData];
    //    [NSThread sleepForTimeInterval:3.0f];//睡眠，所有操作都不起作用
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_headerView openTimer];//开启定时器
    });
}
-(void)viewWillDisappear:(BOOL)animated{//将要隐藏窗口  setModalTransitionStyle=UIModalTransitionStyleCrossDissolve时是不隐藏的，故不执行
    [super viewWillDisappear:animated];
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
    [imageViewer showWithImageViews:imgArray selectedView:(UIImageView *)tap.view];
}

#pragma mark - XHImageViewerDelegate

- (void)imageViewer:(XHImageViewer *)imageViewer willDismissWithSelectedView:(UIImageView *)selectedView {
    //NSInteger index = [imgArray indexOfObject:selectedView];
    //NSLog(@"index : %d", index);
    //imageViewer.pagecontrol.currentPage = index;
}


#pragma mark UITabViewDataSource
-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //UILog(@"tableViewData :  %d",tableViewData.count);
    return dataArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier = @"Cell";
    TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil)
    {
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        NSArray * nibViews  =[[NSBundle mainBundle] loadNibNamed:@"TableViewCell" owner:self options:nil] ;
        cell= [nibViews objectAtIndex:0];
    }
    
    [cell setHeight:40];
    cell.backgroundColor = RGB_MAKE(209, 193, 180);
    cell.line_v.backgroundColor = RGB_MAKE(165, 153, 143);
    
    cell.label3.text = [detailsArr objectAtIndex:indexPath.row];
    cell.label1.textColor = RGB_MAKE(54, 52, 50);
    cell.label1.text = [NSString stringWithFormat:@"%@",[dataArr objectAtIndex:indexPath.row]];
    [cell.line_v setLeft:cell.label1.text.length*15+cell.label1.left+5];
    [cell.line_v setWidth:cell.line_v.width-(cell.label1.text.length*15+cell.label1.left)-15];
    cell.label2.text = @"";
    
    cell.label1.font = [UIFont systemFontOfSize:16];
    cell.label2.font = [UIFont systemFontOfSize:16];
    cell.label3.font = [UIFont systemFontOfSize:16];
    
    if (indexPath.row==0) {
        
        cell.label3.text = @"";
        cell.label2.text = @"";
        cell.label1.textAlignment = NSTextAlignmentCenter;
        cell.label1.font  = [UIFont boldSystemFontOfSize:18];
        cell.label1.textColor = RGB_MAKE(0, 0, 0);
        cell.label1.frame = CGRectMake(myTableView.width/2-100, cell.height/2-10,200, 20);
        cell.line_v.hidden = YES;
    }
    
    if (indexPath.row==3)
    {
        
        cell.label2.text = @"(cm)";
        [cell.line_v setWidth:cell.line_v.width-25];
    }
    if(indexPath.row==6)
    {
        //cell.label3.backgroundColor = [UIColor grayColor];
        [cell.label3 setLeft:cell.label1.text.length*15+cell.label1.left+3];
        [cell.label3 setWidth:250];
    }
    
    if (indexPath.row==7)
    {
        cell.label3.text = @"";
        cell.line_v.hidden = YES;
        //cell.backgroundColor =[UIColor redColor];
        NSArray* arr  = @[@"主创",@"监制"];
        for (int i=0; i<arr.count; i++) {
            
            UIImageView* image = [[UIImageView alloc]init];
            image.frame = CGRectMake(10+80*i, cell.height/2-10, 20, 20);
            image.backgroundColor =[UIColor clearColor];
            [image setImage:[UIImage imageNamed:@"未勾选.png"]];
            //image.layer.borderWidth = 1;
            //image.layer.borderColor = [RGB_MAKE(163, 151, 141) CGColor];
            [cell.contentView addSubview:image];
            
            if (i==0)
            {
                if (createman !=nil) {
                    if ([createman isEqualToString:@"1"]) {
                        [image setImage:[UIImage imageNamed:@"勾选.png"]];
                    }
                }
            }
            
            if (i==1)
            {
                if ([[detailsArr objectAtIndex:indexPath.row] isEqualToString:@"1"]) {
                    [image setImage:[UIImage imageNamed:@"勾选.png"]];
                }
            }
            
            UILabel* l = [[UILabel alloc]init];
            l.text = [arr objectAtIndex:i];
            [cell.contentView addSubview:l];
            l.frame = CGRectMake(image.right+5, cell.height/2-10, 30, 20);
            l.font = [UIFont systemFontOfSize:15];
        }
        cell.label1.text = @"";
    }
    
    if (indexPath.row==9)
    {
        
        cell.label2.text = @"人/天";
        [cell.line_v setWidth:cell.line_v.width-28];
    }
    if (indexPath.row==10)
    {
        
        cell.label2.text = @"(元)";
        [cell.line_v setWidth:cell.line_v.width-25];
    }
    if (indexPath.row==11)
    {
        
        cell.label2.text = @"(天)";
        [cell.line_v setWidth:cell.line_v.width-25];
    }
    if (indexPath.row==13)
    {
        cell.label3.text = @"";
        cell.line_v.hidden = YES;
        NSArray* arr  = @[@"原作",@"限量",@"量产"];
        for (int i=0; i<arr.count; i++) {
            
            UIImageView* image = [[UIImageView alloc]init];
            image.frame = CGRectMake(10+80*i, cell.height/2-10, 20, 20);
            //image.backgroundColor =[UIColor clearColor];
            //image.layer.borderWidth = 1;
            [image setImage:[UIImage imageNamed:@"未勾选.png"]];
            image.layer.borderColor = [RGB_MAKE(163, 151, 141) CGColor];
            [cell.contentView addSubview:image];
            
            UILabel* l = [[UILabel alloc]init];
            l.text = [arr objectAtIndex:i];
            [cell.contentView addSubview:l];
            l.frame = CGRectMake(image.right+5, cell.height/2-10, 30, 20);
            l.font = [UIFont systemFontOfSize:15];
            
            if([[detailsArr objectAtIndex:indexPath.row] isEqualToString:[arr objectAtIndex:i]])
            {
                //l.textColor = [UIColor redColor];
                [image setImage:[UIImage imageNamed:@"勾选.png"]];
            }
        }
        cell.label1.text = @"";
    }
    if (indexPath.row==15) {
        cell.line_v.hidden = YES;
        cell.label2.text = @"";
        cell.label1.textAlignment = NSTextAlignmentCenter;
        cell.label1.font  = [UIFont systemFontOfSize:16];
        cell.label1.textColor = RGB_MAKE(157, 47, 41);
        cell.label1.frame = CGRectMake(myTableView.width/2-125, cell.height/2-10,250, 20);
        cell.label3.text = @"";
    }
    
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TableViewCell *cell = (TableViewCell*)[self tableView:myTableView cellForRowAtIndexPath:indexPath];
    //UILog(@"cell.height %0.0f",cell.height);
    return cell.frame.size.height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //[tableView deselectRowAtIndexPath:indexPath animated:YES];
    tableview_backgroundColor.hidden = YES;
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
- (IBAction)share:(UIButton *)sender
{
    NSString *imagePath = nil;
    if (imgArray.count!=0) {
        
        imagePath =  [imgArray objectAtIndex:0];
    }
    if (imagePath == nil) {
        return;
    }
    
    //作品名称 - 作者昵称
    NSString* title_nickname = [NSString stringWithFormat:@"%@ － %@",titlelabel.text,namelabel.text];
    
    NSString* url = [NSString stringWithFormat:@"%@",detailUrl];
    
    //构造分享内容
    id<ISSContent> publishContent = [ShareSDK content:title_nickname
                                       defaultContent:@"分享自手作品App"
                                                image:[ShareSDK imageWithUrl:imagePath]
                                                title:title_nickname
                                                  url:url
                                          description:@"国内领先的手工艺O2O平台"
                                            mediaType:SSPublishContentMediaTypeNews];
    //创建弹出菜单容器
    id<ISSContainer> container = [ShareSDK container];
    [container setIPadContainerWithView:sender arrowDirect:UIPopoverArrowDirectionUp];
    
    //弹出分享菜单
    [ShareSDK showShareActionSheet:container
                         shareList:nil
                           content:publishContent
                     statusBarTips:YES
                       authOptions:nil
                      shareOptions:nil
                            result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                
                                if (state == SSResponseStateSuccess)
                                {
                                    //NSLog(NSLocalizedString(@"TEXT_ShARE_SUC", @"分享成功"));
                                    ALERT_OK(@"分享成功!");
                                }
                                else if (state == SSResponseStateFail)
                                {
                                    //NSLog(NSLocalizedString(@"TEXT_ShARE_FAI", @"分享失败,错误码:%d,错误描述:%@"), [error errorCode], [error errorDescription]);
                                    ALERT_OK(@"分享失败!");
                                }
                            }];
}

// 投诉举报
- (IBAction)report:(UIButton *)sender
{
    UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"举报" message:@"" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"垃圾广告",@"色情相关",@"侵犯版权",@"盗用他人资料",nil];
    alert.tag = 100;
    [alert show];
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 100) {
        if (buttonIndex==0)
        {
            return ;
        }
        
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"举报" message:@"将该用户发布的此条内容作为附件，提交到平台运营中心调查。" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alert.tag = 200;
        [alert show];
        return ;
    } else if (alertView.tag == 200){
        if (buttonIndex == 1)
        {
            [MBProgressHUD showHUDAddedTo:self.view animated:YES withText:@"正在提交..." detailText:nil];
            [self performSelector:@selector(reportSuccess) withObject:nil afterDelay:2.0];
            return ;
        }
    }
}

-(void)reportSuccess
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [TipsHud ShowTipsHud:@"举报成功，我们会尽快处理！" :self.view ];
}

-(void)dealloc
{
    dataArr = nil;
    detailsArr = nil;
    _headerView =nil;
    
    UILog(@"delloc");
}


@end
