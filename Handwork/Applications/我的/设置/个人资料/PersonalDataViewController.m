//
//  PersonalDataViewController.m
//  Handwork
//
//  Created by ios on 15-5-4.
//  Copyright (c) 2015年 周文超. All rights reserved.
//

#import "PersonalDataViewController.h"
#import "ModifyViewController.h"
#import "HZAreaPickerView.h"
#import "MyViewTableViewCell.h"
#import "UIImage+WTExtension.h"
#import "Photo.h"
#import "TipsHud.h"

@interface PersonalDataViewController ()<HZAreaPickerDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    NSArray* titleArr;
    NSMutableArray* detailsArr;
    IBOutlet UITableView *myTableView;
    NSMutableArray* dataArr;
    NSInteger current;
    
    NSMutableArray* typeArr;
    
    // 选择图片菜单
    UIActionSheet* actionSheets;
    
    
    NSString* filePath;
    
    UIImage *currentSelectAvatarImage;
    
    NSString* isauth;
    
    NSString* provinces;
    
    NSString* cities;
    
    NSString* areas;
}
@property (assign, nonatomic) NSInteger row;
@property (assign, nonatomic) NSInteger component;

@property (strong, nonatomic) NSString* head_url;
@property (strong, nonatomic) NSString* phone;
@property (strong, nonatomic) HZAreaPickerView *locatePicker;
@end

@implementation PersonalDataViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"个人资料";
  self.isRefresh = YES;
    //[self loadData];
    //
    // Do any additional setup after loading the view from its nib.
    
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    isauth = [userDefaults objectForKey:API_ISAUTH];
    
    titleArr = @[@"个人签名",@"姓名",@"职称",@"称号",@"非遗",@"从业年限",@"工艺品类",@"地区",@"所属行会"];
    
    detailsArr = [[NSMutableArray alloc]initWithObjects:@"",@"",@"",@"",@"",@"",@"",@"",@"", nil];
    
    
   
    
    dataArr = [[NSMutableArray alloc]init];
    
    typeArr = [[NSMutableArray alloc]initWithObjects:@"signature",@"nickname",@"job",@"callname",@"Intangibleheritage",@"worktime",@"madeclassid",@"province",@"association",@"phone",nil];
     //UILog(@"titleArr.count,detailsArr.count   %d %d",titleArr.count,detailsArr.count);
    
    //return;
    
    if ([isauth isEqualToString:@"0"]) {
        titleArr = @[@"个人签名",@"姓名"];
        detailsArr = [[NSMutableArray alloc]initWithObjects:@"",@"",nil];
        myTableView.pagingEnabled = NO;
    }
    
    myTableView.backgroundColor = [UIColor clearColor];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
//    if (self.isRefresh)
//    {
//        [self loadData];
//        self.isRefresh = NO;
//    }
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
     [self loadData];
}

-(void)setUserInfo:(NSMutableDictionary*)submit
{
    
    UILog(@"submit %@",submit);
    NSString* url = [NSString stringWithFormat:@"Account/setUserInfo"];
    
    ASIHTTPRequest* request = [HttpRequest requestPost:url Dic:submit authorization:YES];
    __weak typeof (ASIHTTPRequest)* request_weak = request;
    
    [request setCompletionBlock:^{
        NSDictionary* dic = [[request_weak responseString]objectFromJSONString];
        
        [MBProgressHUD hideHUDForView:self.view animated:NO];
        int status = [[dic objectForKey:@"status"]intValue];
        [self isDistance:status];
        if (status!=1) {
            return ;
        }
        NSString* info = [NSString stringWithFormat:@"%@",[dic objectForKey:@"info"]];
        //ALERT_OK(info);
        [TipsHud ShowTipsHud:info:self.view];
        
        [self loadData];
    }];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES withText:@"正在修改" detailText:nil];
    [request_weak startAsynchronous];
}

-(void)loadData
{
    NSString* url = [NSString stringWithFormat:@"Account/getUserInfo"];
    
    ASIHTTPRequest* request = [HttpRequest requestPost:url Dic:nil authorization:YES];
    
    
    
    __weak typeof (ASIHTTPRequest)* request_weak = request;
    
    [request setCompletionBlock:^{
        NSDictionary* dic = [[request_weak responseString]objectFromJSONString];
        
        //[MBProgressHUD hideHUDForView:self.view animated:NO];
        
        int status = [[dic objectForKey:@"status"]intValue];
        if (status!=1) {
            NSString* info = [NSString stringWithFormat:@"%@",[dic objectForKey:@"info"]];
            ALERT_OK(info);
            return ;
        }
        NSDictionary* data = [dic objectForKey:@"data"];
        
        UILog(@"data %@",data);
        
        if (!strIsEmpty([data objectForKey:@"s_photo"])) {
            NSString* s = [NSString stringWithFormat:@"%@",[data objectForKey:@"s_photo"]];
            self.head_url = s;
        }
     
        if (!strIsEmpty([data objectForKey:@"signature"])) {
            NSString* s = [NSString stringWithFormat:@"%@",[data objectForKey:@"signature"]];
            [detailsArr setObject:s atIndexedSubscript:0];
        }
        
        if (!strIsEmpty([data objectForKey:@"nickname"])) {
            NSString* s = [NSString stringWithFormat:@"%@",[data objectForKey:@"nickname"]];
            [detailsArr setObject:s atIndexedSubscript:1];
            
        }
        
        if (!strIsEmpty([data objectForKey:@"job"])) {
            NSString* s = [NSString stringWithFormat:@"%@",[data objectForKey:@"job"]];
            [detailsArr setObject:s atIndexedSubscript:2];
        }
        
        if (!strIsEmpty([data objectForKey:@"callname"])) {
            NSString* s = [NSString stringWithFormat:@"%@",[data objectForKey:@"callname"]];
            [detailsArr setObject:s atIndexedSubscript:3];
        }
        
//        if (!strIsEmpty([data objectForKey:@"isauth"])) {
//            
//            NSString* s = [NSString stringWithFormat:@"%@",[data objectForKey:@"isauth"]];
//            if ([s isEqualToString:@"0"])
//            {
//                s= @"普通用户";
//            }
//            else if ([s isEqualToString:@"1"]) {
//                s= @"工艺师";
//            }
//            else
//            {
//                s= @"认证中";
//            }
//            [detailsArr setObject:s atIndexedSubscript:3];
//        }
        if (!strIsEmpty([data objectForKey:@"phone"])) {
            NSString* s = [NSString stringWithFormat:@"%@",[data objectForKey:@"phone"]];
            self.phone = s;
        }
        
        if (!strIsEmpty([data objectForKey:@"Intangibleheritage"])) {
            NSString* s = [NSString stringWithFormat:@"%@",[data objectForKey:@"Intangibleheritage"]];
            [detailsArr setObject:s atIndexedSubscript:4];
        }
        
        if (!strIsEmpty([data objectForKey:@"worktime"])) {
            NSString* s = [NSString stringWithFormat:@"%@年",[data objectForKey:@"worktime"]];
            [detailsArr setObject:s atIndexedSubscript:5];
        }
        
        if (!strIsEmpty([data objectForKey:@"madeclassid"])) {
            NSString* s = [NSString stringWithFormat:@"%@",[data objectForKey:@"madeclassid"]];
            
            if ([s isEqualToString:@"1"]) {
                s = @"雕刻";
            }
            if ([s isEqualToString:@"2"]) {
                s = @"刺绣";
            }
            if ([s isEqualToString:@"3"]) {
                s = @"陶瓷";
            }
            if ([s isEqualToString:@"4"]) {
                s = @"漆器";
            }
            if ([s isEqualToString:@"5"]) {
                s = @"金属";
            }
            if ([s isEqualToString:@"6"]) {
                s = @"综合";
            }
            [detailsArr setObject:s atIndexedSubscript:6];
            
            
        }
       
        if (!strIsEmpty([data objectForKey:@"province"])) {
            
            
            provinces = [data objectForKey:@"province"];
            
            NSString* s = [NSString stringWithFormat:@"%@",[data objectForKey:@"province"]];
            if (!strIsEmpty([data objectForKey:@"city"])) {
                s = [NSString stringWithFormat:@"%@%@",[data objectForKey:@"province"],[data objectForKey:@"city"]];
                
                cities = [data objectForKey:@"city"];
            }
            if (!strIsEmpty([data objectForKey:@"district"])) {
                s = [NSString stringWithFormat:@"%@ %@ %@",[data objectForKey:@"province"],[data objectForKey:@"city"],[data objectForKey:@"district"]];
                areas = [data objectForKey:@"district"];
            }
            
            [detailsArr setObject:s atIndexedSubscript:7];
        }
        
        if (![isauth isEqualToString:@"0"]) {
            if (!strIsEmpty([data objectForKey:@"association"])){
                NSString* s = [NSString stringWithFormat:@"%@",[data objectForKey:@"association"]];
                [detailsArr setObject:s atIndexedSubscript:8];
            }
        }
        //NSString* s = [NSString stringWithFormat:@"%@",[data objectForKey:@"association"]];
//        NSString* s = [[NSString alloc]initWithFormat:@"%@",[data objectForKey:@"association"]];
//        [detailsArr setObject:s atIndexedSubscript:8];
        //return;
        
        
        //NSArray* infos = [data objectForKey:@"infos"];
        //NSString* info = [NSString stringWithFormat:@"%@",[dic objectForKey:@"info"]];
        //ALERT_OK(info);
        //UILog(@" %@ ",dic);
        [myTableView reloadData];
    }];
    //[MBProgressHUD showHUDAddedTo:self.view animated:YES withText:@"正在加载" detailText:nil];
    [request_weak startAsynchronous];
}


#pragma mark UITabViewDataSource
-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
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
    if (section==0) {
        return 1;
    }
    if (section==1) {
        return titleArr.count;
    }
    if (section==2) {
        return 1;
    }
    if (section==3) {
        return 1;
    }
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString* Identifier = @"cell";
    
    MyViewTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:Identifier];
    
    if (cell == nil)
    {
        NSArray * nibViews  =[[NSBundle mainBundle] loadNibNamed:@"MyViewTableViewCell" owner:self options:nil];
        cell= (MyViewTableViewCell*)[nibViews objectAtIndex:0];
    }
    
    [cell.label1 setLeft:10];
    cell.label2.text = @"";
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.headImage.hidden = YES;
    
    if(indexPath.section==0)
    {
        [cell setHeight:100];
        cell.label1.text = @"头像";
        [cell.label1 setTop:cell.height/2-10];
        
        cell.headImage.hidden = NO;
        [cell.headImage setImageWithURL:[NSURL URLWithString:self.head_url] placeholderImage:[UIImage imageNamed:@"默认头像.png"]];
        //[cell.headImage setImage:[UIImage imageNamed:@"头像2.jpg"]];
        [cell.headImage setFrame:CGRectMake(_Screen_Width-85, cell.height/2-75/2,75, 75)];
        cell.headImage.layer.masksToBounds = YES;
        cell.headImage.layer.cornerRadius = 75/2;
        [cell.headImage setTag:100];
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    //cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.section==1) {
        
        
        cell.label1.text = [titleArr objectAtIndex:indexPath.row];
        [cell.label1 setWidth:cell.label1.text.length*16];
        
        
        cell.label2.text = [detailsArr objectAtIndex:indexPath.row];
        [cell.label2 setWidth:cell.label2.text.length*16];
        cell.label2.textAlignment = NSTextAlignmentRight;
        [cell.label2 setLeft:_Screen_Width-(cell.label2.text.length*16+35)];
        
        [cell.label1 setWidth:cell.label1.text.length*17];
        
    }
    if (indexPath.section==2) {
        cell.label1.text = @"绑定手机";
        [cell.label1 setWidth:cell.label1.text.length*16];
        cell.label2.text = @"";
        if (self.phone!=nil) {
            cell.label2.text =self.phone;
        }
        [cell.label2 setWidth:cell.label2.text.length*16];
        cell.label2.textAlignment = NSTextAlignmentRight;
        [cell.label2 setLeft:_Screen_Width-(cell.label2.text.length*16+35)];
        //[cell.label1 setWidth:cell.label1.text.length*16];
        [cell.label1 setWidth:cell.label1.text.length*17];
       // [cell.label1 setLeft:_Screen_Width/2-(cell.label1.text.length*16/2)];
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    if (indexPath.section==3) {
        cell.label1.text = @"账号类型";
        [cell.label1 setWidth:cell.label1.text.length*16];
        
        NSString* s =nil;
        
        if ([isauth isEqualToString:@"0"]){
            s = @"普通用户";
        }
        
        if ([isauth isEqualToString:@"1"]){
            s = @"工艺师";
        }
        if ([isauth isEqualToString:@"2"]){
            s = @"认证中";
        }
        
        cell.label2.text = s;
         [cell.label1 setWidth:cell.label1.text.length*17];
        [cell.label2 setWidth:cell.label2.text.length*16];
        cell.label2.textAlignment = NSTextAlignmentRight;
        [cell.label2 setLeft:_Screen_Width-(cell.label2.text.length*16+35)];
        //[cell.label1 setWidth:cell.label1.text.length*16];
        
        // [cell.label1 setLeft:_Screen_Width/2-(cell.label1.text.length*16/2)];
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    return cell;
}




-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    MyViewTableViewCell *cell = (MyViewTableViewCell*)[self tableView:myTableView cellForRowAtIndexPath:indexPath];
    return cell.height;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //[tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if ([self Check_Guest])
    {
        //[TipsHud ShowTipsHud:@"游客无操作权限，请先注册账号!" :self.view];
        return;
    }
    
    if (indexPath.section==0) {
        
        
        actionSheets = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"拍照" otherButtonTitles:@"从相册选择", nil];
        
        [actionSheets showInView:self.view];
        
    }
    
    if (indexPath.section==1) {
        //ALERT_OK(@"提交认证");
        [self cancelLocatePicker];
        //EventDetails* vc = [[EventDetails alloc]init];
        //[self.navigationController pushViewController:vc animated:YES];
        if(indexPath.row==0)
        {
            ModifyViewController* vc= [[ModifyViewController alloc]init];
            vc.dataName = [detailsArr objectAtIndex:indexPath.row];
            vc.s_type = [titleArr objectAtIndex:indexPath.row];
            vc.s_type1 = [typeArr objectAtIndex:indexPath.row];
            [self.navigationController pushViewController:vc animated:YES];
        }
        //UILog(@"%d",indexPath.row);
        if(indexPath.row==1)
        {
            ModifyViewController* vc= [[ModifyViewController alloc]init];
            
            vc.dataName = [detailsArr objectAtIndex:indexPath.row];
            vc.s_type = [titleArr objectAtIndex:indexPath.row];
            vc.s_type1 = [typeArr objectAtIndex:indexPath.row];
            [self.navigationController pushViewController:vc animated:YES];
        }
        if (indexPath.row==2) {
            
            
            [dataArr removeAllObjects];
            [dataArr addObject:@"高级工艺师"];
            [dataArr addObject:@"中级工艺师"];
            [dataArr addObject:@"初级工艺师"];
            [dataArr addObject:@"工艺师"];
            
            
            self.locatePicker = [[HZAreaPickerView alloc] initWithStyle:5 delegate:self data:dataArr];
            NSInteger tag = 0;
            for (int i=0; i<dataArr.count; i++) {
                if ([[dataArr objectAtIndex:i] isEqualToString:[detailsArr objectAtIndex:2]]) {
                    tag = i;
                }
            }
            [self.locatePicker.locatePicker selectRow:tag inComponent:0 animated:YES];
          
            //self.locatePicker.backgroundColor = [UIColor blackColor];
            [self.locatePicker showInView:self.view];
            
         
        }
        if (indexPath.row==3) {
            //国家级工艺美术大师、省级工艺美术大师、市级工艺美术师
            [dataArr removeAllObjects];
            [dataArr addObject:@"国家级工艺美术大师"];
            [dataArr addObject:@"省级工艺美术大师"];
            [dataArr addObject:@"市级工艺美术师"];
            [dataArr addObject:@"工艺美术师"];
            self.locatePicker = [[HZAreaPickerView alloc] initWithStyle:5 delegate:self data:dataArr];
            //self.locatePicker.backgroundColor = [UIColor blackColor];
            
            NSInteger tag = 0;
            for (int i=0; i<dataArr.count; i++) {
                if ([[dataArr objectAtIndex:i] isEqualToString:[detailsArr objectAtIndex:3]]) {
                    tag = i;
                }
            }
            [self.locatePicker.locatePicker selectRow:tag inComponent:0 animated:YES];
            
            [self.locatePicker showInView:self.view];
            
           
        }
        if (indexPath.row==4) {
            
            //国家级工艺美术大师、省级工艺美术大师、市级工艺美术师
            [dataArr removeAllObjects];
            [dataArr addObject:@"国家级传承人"];
            [dataArr addObject:@"省级传承人"];
            [dataArr addObject:@"市级传承人"];
            [dataArr addObject:@"传承人"];
            
            self.locatePicker = [[HZAreaPickerView alloc] initWithStyle:5 delegate:self data:dataArr];
            NSInteger tag = 0;
            for (int i=0; i<dataArr.count; i++) {
                if ([[dataArr objectAtIndex:i] isEqualToString:[detailsArr objectAtIndex:4]]) {
                    tag = i;
                }
            }
            
            [self.locatePicker.locatePicker selectRow:tag inComponent:0 animated:YES];
           
            //self.locatePicker.backgroundColor = [UIColor blackColor];
            [self.locatePicker showInView:self.view];
            
         
        }
        if (indexPath.row==5) {
            
            //国家级工艺美术大师、省级工艺美术大师、市级工艺美术师
            [dataArr removeAllObjects];
            for (int i=1970; i<=2015; i++) {
                NSString* s_time = [NSString stringWithFormat:@"%d",i];
                [dataArr addObject:s_time];
            }
            self.locatePicker = [[HZAreaPickerView alloc] initWithStyle:5 delegate:self data:dataArr];
            NSInteger tag = 0;
            
            for (int i=0; i<dataArr.count; i++) {
                
                NSInteger i_time = [[detailsArr objectAtIndex:5] intValue];
                NSString* s_time = [NSString stringWithFormat:@"%ld",2015-i_time];
                
                if ([[dataArr objectAtIndex:i] isEqualToString:s_time]) {
                    tag = i;
                }
            }
            [self.locatePicker.locatePicker selectRow:tag inComponent:0 animated:YES];
            //self.locatePicker.backgroundColor = [UIColor blackColor];
            [self.locatePicker showInView:self.view];
            
          
        }
        if (indexPath.row==6) {
            //国家级工艺美术大师、省级工艺美术大师、市级工艺美术师
            [dataArr removeAllObjects];
            [dataArr addObject:@"雕刻"];
            [dataArr addObject:@"刺绣"];
            [dataArr addObject:@"陶瓷"];
            [dataArr addObject:@"漆器"];
            [dataArr addObject:@"金属"];
            [dataArr addObject:@"综合"];
            self.locatePicker = [[HZAreaPickerView alloc] initWithStyle:5 delegate:self data:dataArr];
            NSInteger tag = 0;
            
            for (int i=0; i<dataArr.count; i++) {
                
                if ([[dataArr objectAtIndex:i] isEqualToString:[detailsArr objectAtIndex:6]]) {
                    tag = i;
                }
            }
            [self.locatePicker.locatePicker selectRow:tag inComponent:0 animated:YES];
            self.locatePicker.locatePicker.showsSelectionIndicator=YES;
            //self.locatePicker.backgroundColor = [UIColor blackColor];
            [self.locatePicker showInView:self.view];
            
        }
        
        if (indexPath.row==7)
        {
//            [dataArr removeAllObjects];
//            for (int i=1970; i<=2015; i++) {
//                NSString* s_time = [NSString stringWithFormat:@"%d",i];
//                [dataArr addObject:s_time];
//            }
            
            self.locatePicker = [[HZAreaPickerView alloc] initWithStyle:HZAreaPickerWithStateAndCityAndDistrict delegate:self data:nil];
            
            for (int i=0; i<self.locatePicker.provinces.count; i++){
                NSString* s =[[self.locatePicker.provinces objectAtIndex:i] objectForKey:@"state"];
                if ([provinces isEqualToString:s]) {
                    self.row = i;
                }
            }
            int row1 = 0;
            self.locatePicker.cities = [[self.locatePicker.provinces objectAtIndex:self.row] objectForKey:@"cities"];
            
            
            
            for (int i=0; i<self.locatePicker.cities.count; i++){
                NSString* s =[[self.locatePicker.cities objectAtIndex:i] objectForKey:@"city"];
                if ([cities isEqualToString:s]) {
                    row1 = i;
                }
            }
        
            
            self.locatePicker.areas = [[self.locatePicker.cities objectAtIndex:row1] objectForKey:@"areas"];
            
            //UILog(@"self.locatePicker.areas %@",[[self.locatePicker.cities objectAtIndex:row1] objectForKey:@"areas"]);
            int row2 = 0;
            if (self.locatePicker.areas.count!=0)
            {
                for (int i=0; i<self.locatePicker.areas.count; i++){
                    
                    NSString* s =[self.locatePicker.areas objectAtIndex:i];
                    if ([areas isEqualToString:s]) {
                        row2 = i;
                    }
                    UILog(@"self.locatePicker.areas %@",s);
                }
                
                //[self.locatePicker.locatePicker reloadComponent:2];
                //UILog(@"row2 %d %@",row2,areas);
            }
            
            [self.locatePicker.locatePicker selectRow:self.row inComponent:0 animated:YES];
            
            [self.locatePicker.locatePicker selectRow:row1 inComponent:1 animated:YES];
            
           [self.locatePicker.locatePicker selectRow:row2 inComponent:2 animated:YES];
            [self.locatePicker.locatePicker reloadInputViews];
            [self.locatePicker.locatePicker reloadAllComponents];
            //[self.locatePicker.locatePicker selectRow:2 inComponent:1 animated:YES];
            //self.locatePicker.backgroundColor = [UIColor blackColor];
            [self.locatePicker showInView:self.view];
            
        }
        current = indexPath.row;
        //UILog(@"%d",current);
        [self.locatePicker.can_btn addTarget:self action:@selector(locatePicker_btnclick:) forControlEvents:UIControlEventTouchUpInside];
        [self.locatePicker.ok_btn addTarget:self action:@selector(locatePicker_btnclick:) forControlEvents:UIControlEventTouchUpInside];
        
        if (indexPath.row==8) {
            ModifyViewController* vc= [[ModifyViewController alloc]init];
            vc.dataName = [detailsArr objectAtIndex:indexPath.row];
            vc.s_type = [titleArr objectAtIndex:indexPath.row];
            vc.s_type1 = [typeArr objectAtIndex:indexPath.row];
            
            UILog(@"s_type1 %@",vc.s_type1);
            [self.navigationController pushViewController:vc animated:YES];
        }
    }

    
    if (indexPath.section==2) {
//        ModifyViewController* vc= [[ModifyViewController alloc]init];
//
//        vc.dataName = self.phone;
//        vc.s_type = @"手机号码";
//        vc.s_type1 = @"phone";
//        [self.navigationController pushViewController:vc animated:YES];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 15;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - HZAreaPicker delegate
-(void)pickerDidChaneStatus:(HZAreaPickerView *)picker
{
    
    NSString* str = nil;
    if (picker.pickerStyle == HZAreaPickerWithStateAndCityAndDistrict)
    {
        str= [NSString stringWithFormat:@"%@ %@ %@", picker.locate.state, picker.locate.city, picker.locate.district];
        
    } else if(picker.pickerStyle == HZAreaPickerWithStateAndCity){
        
        str = [NSString stringWithFormat:@"%@ %@", picker.locate.state, picker.locate.city];
    }
    else
    {
        str = picker.locate.city;
    }
    
    //UILog(@"component: %d row:%d",picker.component,picker.row);
    
    self.component = picker.component;
    self.row = picker.row;
    
    //[detailsArr setObject:str atIndexedSubscript:current];
    
    //更新第几行
//    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:current inSection:1];
//    [myTableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
}

-(void)locatePicker_btnclick:(UIButton*)sender
{
    //UILog(@"%d",current);
    if (sender.tag==0)
    {
        NSMutableDictionary* submit = [NSMutableDictionary dictionary];
        
        [submit setValue:@"2" forKey:@"isauth"];
      
        NSString* str =  self.locatePicker.locate.city;
        if ([str isEqualToString:[detailsArr objectAtIndex:current]])
        {
            //UILog(@"提交的数据  %@",str);
            UILog(@"一样");
            [self cancelLocatePicker];
            return;
        }
        if ([self.locatePicker.locate.city isEqualToString:@"(null)"]) {
            [self cancelLocatePicker];
            UILog(@"未更改");
            return;
        }
        UILog(@"+self.locatePicker.locate.city+ %@",self.locatePicker.locate.city);
        
        if (current==5) {
            float time = [[NSString stringWithFormat:@"%@",str]floatValue];
            str = [NSString stringWithFormat:@"%0.0f年",2015-time];
        }
        if (current==6) {
            
            if ([str isEqualToString:@"雕刻"]) {
                str = @"1";
            }
            if ([str isEqualToString:@"刺绣"]) {
                str = @"2";
            }
            if ([str isEqualToString:@"陶瓷"]) {
                str = @"3";
            }
            if ([str isEqualToString:@"漆器"]) {
                str = @"4";
            }
            if ([str isEqualToString:@"金属"]) {
                str = @"5";
            }
            if ([str isEqualToString:@"综合"]) {
                str = @"6";
            }
            
            [submit setValue:str forKey:[typeArr objectAtIndex:current]];
            [self setUserInfo:submit];
            [self cancelLocatePicker];
            return;
        }
        
        if (current==7) {
            
            //str =[NSString stringWithFormat:@"%@ %@", self.locatePicker.locate.state, self.locatePicker.locate.city];;
            [submit setValue:self.locatePicker.locate.state forKey:@"province"];
            [submit setValue:self.locatePicker.locate.city forKey:@"city"];
            [submit setValue:self.locatePicker.locate.district forKey:@"district"];
            
            UILog(@"%@省 %@市 %@ 街/区",self.locatePicker.locate.state,self.locatePicker.locate.city,self.locatePicker.locate.district);
            
            [self setUserInfo:submit];
            [self cancelLocatePicker];
            return;
        }
        if (str!=nil) {
            [detailsArr setObject:str atIndexedSubscript:current];
        }
        [submit setValue:str forKey:[typeArr objectAtIndex:current]];
        
        [self setUserInfo:submit];
        
//        NSIndexPath *indexPath=[NSIndexPath indexPathForRow:current inSection:1];
//        [myTableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
        [self cancelLocatePicker];
        
        
    }
    if (sender.tag==1) {
        [self cancelLocatePicker];
    }
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    [self cancelLocatePicker];
}

-(void)cancelLocatePicker
{
    [self.locatePicker cancelPicker];
    self.locatePicker.delegate = nil;
    self.locatePicker = nil;
}

// 开始拍照
-(void)takePhoto
{
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera])
    {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        // 设置拍照后的图片可被编辑
        picker.allowsEditing = YES;
        picker.sourceType = sourceType;
        //[self presentModalViewController:picker animated:YES];
        [self presentViewController:picker animated:YES completion:nil];
    }
    else
    {
        NSLog(@"不支持相机");
    }
}

// 打开本地相册
-(void)openAlbum
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.delegate = self;
    // 设置选择后的图片可被编辑
    picker.allowsEditing = YES;
    //[self presentModalViewController:picker animated:YES];
    [self presentViewController:picker animated:YES completion:nil];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    // 呼出的菜单按钮点击后的响应
    if (buttonIndex == actionSheets.cancelButtonIndex)
    {
        NSLog(@"取消");
        return ;
    }
    
    switch (buttonIndex)
    {
        case 0: //打开照相机拍照
            [self takePhoto];
            break;
        case 1: //打开本地相册
            [self openAlbum];
            break;
    }
}




#pragma mark - 保存图片至沙盒
- (void)saveImage:(UIImage *)currentImage withName:(NSString *)imageName
{
    NSData *imageData = UIImageJPEGRepresentation(currentImage, 0.5);
    // 获取沙盒目录
    NSString *fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"]
                          stringByAppendingPathComponent:imageName];
    // 将图片写入文件
    [imageData writeToFile:fullPath atomically:NO];
}

// 当选择一张图片后进入这里
-(void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:^{}];
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    [self saveImage:image withName:@"currentImage.png"];
    NSString *fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"currentImage.png"];
    UIImage *savedImage = [[UIImage alloc] initWithContentsOfFile:fullPath];
    
    // 更新头像视图
    [savedImage resize:CGSizeMake(AVATAR_WIDTH, AVATAR_HEIGHT) roundCorner:AVATAR_ROUND_PX quality:kCGInterpolationDefault];
    
    UIImageView* avatarImageView = (UIImageView*)[self.view viewWithTag:100];
    [avatarImageView setImage:savedImage];
    currentSelectAvatarImage = savedImage;
    
    // 更新服务器头像
    [MBProgressHUD showHUDAddedToEx:self.view animated:YES withText:@"正在保存" detailText:nil];
    
    NSMutableDictionary* dic = [NSMutableDictionary dictionary];
    // 图片处理
    NSString *imageString = [Photo image2String:currentSelectAvatarImage];
    [dic setObject:imageString forKey:@"avatar"];
    
    [self pushAvatar:dic];
}
-(void)pushAvatar:(NSMutableDictionary*)dic
{
    NSString* url = [NSString stringWithFormat:@"Account/pushAvatar"];
    
    ASIHTTPRequest* request = [HttpRequest requestPost:url Dic:dic authorization:YES];
    
    __weak typeof (ASIHTTPRequest)* request_weak = request;
    [request_weak setUploadProgressDelegate:self];
    
    request_weak.showAccurateProgress=YES;//
    [request setCompletionBlock:^{
        NSDictionary* dic = [[request_weak responseString]objectFromJSONString];
        
        [MBProgressHUD hideHUDForView:self.view animated:NO];
        
        int status = [[dic objectForKey:@"status"]intValue];
        if (status!=1) {
            NSString* info = [NSString stringWithFormat:@"%@",[dic objectForKey:@"info"]];
            ALERT_OK(info);
            return ;
        }
        
        NSDictionary * data =[dic objectForKey:@"data"];
        
        UILog(@"+++ %@",dic);
        NSUserDefaults* userfaulst= [NSUserDefaults standardUserDefaults];
        [userfaulst setObject:[NSString stringWithFormat:@"%@",[data objectForKey:@"s_photo"]]forKey:LOCAL_PHOTO];
        
        [self loadData];
    }];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES withText:@"上传中..." detailText:nil];
    [request_weak startAsynchronous];
}

-(void)setProgress:(float)newProgress{
    
    // [self.pvsetProgress:newProgress];
    
    UILog(@"%@",[NSString stringWithFormat:@"%0.f%%",newProgress*100]);
    if (newProgress*100 == 100) {
        [MBProgressHUD hideHUDForView:self.view animated:NO];
        [self loadData];
    }
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    NSLog(@"您取消了选择图片");
    // [picker dismissModalViewControllerAnimated:YES];
    [picker dismissViewControllerAnimated:YES completion:nil];
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
