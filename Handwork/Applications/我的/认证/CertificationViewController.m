//
//  CertificationViewController.m
//  Handwork
//
//  Created by ios on 15-5-4.
//  Copyright (c) 2015年 周文超. All rights reserved.
//

#import "CertificationViewController.h"
#import "MyViewTableViewCell.h"
#import "ModifyViewController.h"

#import "HZAreaPickerView.h"
@interface CertificationViewController ()<HZAreaPickerDelegate>
{
    NSArray* titleArr;
    //NSArray* detailsArr;
    NSMutableArray* detailsArr;
    NSInteger current;
    
    NSMutableArray* dataArr;
    NSMutableArray* setArr;
    
    NSString* state;
    NSString* city;
    NSString* district;
    
    NSString* provinces;
    
    NSString* cities;
    
    NSString* areas;
}
@property (strong, nonatomic) IBOutlet UITableView *myTableView;
@property (assign, nonatomic) NSInteger row;
@property (assign, nonatomic) NSInteger component;
@property (strong, nonatomic) HZAreaPickerView *locatePicker;

@end

@implementation CertificationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"认证";
    
    self.isRefresh = YES;
    
    titleArr = @[@"姓名",@"职称",@"称号",@"非遗",@"从业年限",@"工艺品类",@"地区",@"所属行会"];
    
  
    
    detailsArr = [[NSMutableArray alloc]initWithObjects:@"",@"中级工艺师",@"市级工艺美术大师",@"市级传承人",@"1990",@"雕刻",@"",@"", nil];
    
    setArr = [[NSMutableArray alloc]initWithObjects:@"realname",@"Job",@"callname",@"Intangibleheritage",@"worktime",@"madeclassid",@"",@"association", nil];
    
    dataArr = [[NSMutableArray alloc]init];
    // Do any additional setup after loading the view from its nib.
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (self.isRefresh) {
        self.isRefresh = NO;
        
        if (self.association!=nil) {
             [detailsArr setObject:self.association atIndexedSubscript:7];
        }
       
        NSUserDefaults* userfaulst = [NSUserDefaults standardUserDefaults];
        
        NSString* nickname =  [userfaulst objectForKey:LOCAL_NICKNAME];
        
        [detailsArr setObject:nickname atIndexedSubscript:0];
        
//        NSIndexPath *indexPath=[NSIndexPath indexPathForRow:7 inSection:1];
//        [self.myTableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
        [self.myTableView reloadData];
    }
}

- (void)viewDidUnload
{
//    [self setAreaText:nil];
//    [self setCityText:nil];
    [super viewDidUnload];
     [self cancelLocatePicker];
    // Release any retained subviews of the main view.
}
-(void)cancelLocatePicker
{
    [self.locatePicker cancelPicker];
    self.locatePicker.delegate = nil;
    self.locatePicker = nil;
}

#pragma mark - HZAreaPicker delegate
-(void)pickerDidChaneStatus:(HZAreaPickerView *)picker
{
    
    NSString* str = nil;
    if (picker.pickerStyle == HZAreaPickerWithStateAndCityAndDistrict) {
        str= [NSString stringWithFormat:@"%@ %@ %@", picker.locate.state, picker.locate.city, picker.locate.district];
    } else if(picker.pickerStyle == HZAreaPickerWithStateAndCity){
        
        str = [NSString stringWithFormat:@"%@ %@", picker.locate.state, picker.locate.city];
    }
    else
    {
        
        str = picker.locate.city;
    }
    
    self.component = picker.component;
    self.row = picker.row;
    
//    [detailsArr setObject:str atIndexedSubscript:current];
//    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:current inSection:1];
//    [self.myTableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
}

#pragma mark UITabViewDataSource
-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
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
    cell.headImage.hidden = YES;
    cell.label1.textColor = colorToString(@"#333333");
    cell.label1.font = [UIFont systemFontOfSize:15];
    
    cell.label1.textColor = colorToString(@"#999999");
    cell.label1.font = [UIFont systemFontOfSize:15];
    if(indexPath.section==0)
    {
        [cell setHeight:80];
        cell.label1.text = @"头像";
        [cell.label1 setTop:cell.height/2-10];
        NSUserDefaults* userfaulst = [NSUserDefaults standardUserDefaults];
        
        NSString* url =  [userfaulst objectForKey:LOCAL_PHOTO];
        
        [cell.headImage setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"默认头像.png"]];
        
        cell.headImage.hidden = NO;
//        [cell.headImage setImage:[UIImage imageNamed:@"头像2.jpg"]];
        [cell.headImage setFrame:CGRectMake(_Screen_Width-85, cell.height/2-60/2,60, 60)];
        cell.headImage.layer.masksToBounds = YES;
        cell.headImage.layer.cornerRadius = 30;
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    if (indexPath.section==1) {
       
        
        cell.label1.text = [titleArr objectAtIndex:indexPath.row];
        [cell.label1 setWidth:cell.label1.text.length*16];
        
        
        cell.label2.text = [detailsArr objectAtIndex:indexPath.row];
        [cell.label2 setWidth:cell.label2.text.length*16];
        cell.label2.textAlignment = NSTextAlignmentRight;
        [cell.label2 setLeft:_Screen_Width-(cell.label2.text.length*16+35)];
        
        if (indexPath.row==4) {
            cell.label2.text = [NSString stringWithFormat:@"%@年",[detailsArr objectAtIndex:indexPath.row]];
        }
        
    }
    if (indexPath.section==2) {
        cell.label1.text = @"提交认证";
        [cell.label1 setWidth:cell.label1.text.length*16];
        
        [cell.label1 setLeft:_Screen_Width/2-(cell.label1.text.length*16/2)];
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    
    return cell;
}




-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    MyViewTableViewCell *cell = (MyViewTableViewCell*)[self tableView:self.myTableView cellForRowAtIndexPath:indexPath];
    return cell.height;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self cancelLocatePicker];
    //EventDetails* vc = [[EventDetails alloc]init];
    //[self.navigationController pushViewController:vc animated:YES];
    if (indexPath.section==1) {
        if(indexPath.row==0)
        {
            ModifyViewController* vc= [[ModifyViewController alloc]init];
            vc.dataName = [detailsArr objectAtIndex:indexPath.row];
            vc.s_type = [titleArr objectAtIndex:indexPath.row];
            vc.s_type1 = [setArr objectAtIndex:indexPath.row];
            vc.vc = self;
            [self.navigationController pushViewController:vc animated:YES];
        }
        //UILog(@"%d",indexPath.row);
        if(indexPath.row==1)
        {
            [dataArr removeAllObjects];
            [dataArr addObject:@"高级工艺师"];
            [dataArr addObject:@"中级工艺师"];
            [dataArr addObject:@"初级工艺师"];
            [dataArr addObject:@"工艺师"];
            self.locatePicker = [[HZAreaPickerView alloc] initWithStyle:5 delegate:self data:dataArr];
            //self.locatePicker.backgroundColor = [UIColor blackColor];
            [self.locatePicker showInView:self.view];
        }
        if (indexPath.row==2) {
            //国家级工艺美术大师、省级工艺美术大师、市级工艺美术师
            [dataArr removeAllObjects];
            [dataArr addObject:@"国家级工艺美术大师"];
            [dataArr addObject:@"省级工艺美术大师"];
            [dataArr addObject:@"市级工艺美术师"];
            [dataArr addObject:@"工艺美术师"];
            self.locatePicker = [[HZAreaPickerView alloc] initWithStyle:5 delegate:self data:dataArr];
            //self.locatePicker.backgroundColor = [UIColor blackColor];
            [self.locatePicker showInView:self.view];
        }
        if (indexPath.row==3) {
            //国家级工艺美术大师、省级工艺美术大师、市级工艺美术师
            [dataArr removeAllObjects];
            [dataArr addObject:@"国家级传承人"];
            [dataArr addObject:@"省级传承人"];
            [dataArr addObject:@"市级传承人"];
            [dataArr addObject:@"传承人"];
            self.locatePicker = [[HZAreaPickerView alloc] initWithStyle:5 delegate:self data:dataArr];
            //self.locatePicker.backgroundColor = [UIColor blackColor];
            [self.locatePicker showInView:self.view];
        }
        if (indexPath.row==4) {
            //国家级工艺美术大师、省级工艺美术大师、市级工艺美术师
            [dataArr removeAllObjects];
            for (int i=1970; i<=2015; i++) {
                NSString* s_time = [NSString stringWithFormat:@"%d",i];
                [dataArr addObject:s_time];
            }
            self.locatePicker = [[HZAreaPickerView alloc] initWithStyle:5 delegate:self data:dataArr];
            //self.locatePicker.backgroundColor = [UIColor blackColor];
            [self.locatePicker showInView:self.view];
        }
        if (indexPath.row==5) {
            //国家级工艺美术大师、省级工艺美术大师、市级工艺美术师
            [dataArr removeAllObjects];
            [dataArr addObject:@"雕刻"];
            [dataArr addObject:@"刺绣"];
            [dataArr addObject:@"陶瓷"];
            [dataArr addObject:@"漆器"];
            [dataArr addObject:@"金属"];
            [dataArr addObject:@"综合"];
            self.locatePicker = [[HZAreaPickerView alloc] initWithStyle:5 delegate:self data:dataArr];
            //self.locatePicker.backgroundColor = [UIColor blackColor];
            [self.locatePicker showInView:self.view];
        }
        if (indexPath.row==6) {
            
//            self.locatePicker = [[HZAreaPickerView alloc] initWithStyle:HZAreaPickerWithStateAndCity delegate:self data:nil];
//            //self.locatePicker.backgroundColor = [UIColor blackColor];
//            [self.locatePicker showInView:self.view];
            
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
        
        [self.locatePicker.can_btn addTarget:self action:@selector(locatePicker_btnclick:) forControlEvents:UIControlEventTouchUpInside];
        [self.locatePicker.ok_btn addTarget:self action:@selector(locatePicker_btnclick:) forControlEvents:UIControlEventTouchUpInside];
        
        if (indexPath.row==7) {
            ModifyViewController* vc= [[ModifyViewController alloc]init];
            vc.vc = self;
            vc.dataName = [detailsArr objectAtIndex:indexPath.row];
            vc.s_type = [titleArr objectAtIndex:indexPath.row];
            vc.s_type1 = [setArr objectAtIndex:indexPath.row];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }

    if (indexPath.section==2) {
        //ALERT_OK(@"提交认证");
        
        [self setUserInfo];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 15;
}

-(void)locatePicker_btnclick:(UIButton*)sender
{
    //UILog(@"%d",current);
    if (sender.tag==0)
    {
        
        NSString* str =  self.locatePicker.locate.city;
        if(current==4)
        {
            float time = [[NSString stringWithFormat:@"%@",str]floatValue];
            str = [NSString stringWithFormat:@"%0.0f",2015-time];
        }
        if (current==6) {
            str = [NSString stringWithFormat:@"%@ %@ %@" ,self.locatePicker.locate.state,self.locatePicker.locate.city,self.locatePicker.locate.district];
            
            
            if (self.locatePicker.locate.state!=nil) {
                state = self.locatePicker.locate.state;
            }
            if (self.locatePicker.locate.city!=nil) {
                city = self.locatePicker.locate.city;
            }
            if (self.locatePicker.locate.district!=nil) {
                district = self.locatePicker.locate.district;
            }
            
        }
        UILog(@"current %ld",(long)current);
        
        if (str!=nil)
        {
            [detailsArr setObject:str atIndexedSubscript:current];
        }
        
        [detailsArr setObject:str atIndexedSubscript:current];
        //[submit setValue:str forKey:[typeArr objectAtIndex:current]];
        
        //[self setUserInfo:submit];
        
        NSIndexPath *indexPath=[NSIndexPath indexPathForRow:current inSection:1];
        [self.myTableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
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


-(void)setUserInfo
{
    
    
    
    NSMutableDictionary* submit = [NSMutableDictionary dictionary];
    
    NSString* url = [NSString stringWithFormat:@"Account/setUserInfo"];
    [submit setObject:@"1" forKey:@"isauth"];
    
    //float time = [[NSString stringWithFormat:@"%@",[detailsArr objectAtIndex:4]]floatValue];
    //NSString* str = [NSString stringWithFormat:@"%0.0f年",2015-time];
    
    
    NSString* madeclassid = [detailsArr objectAtIndex:5];
    
    if ([madeclassid isEqualToString:@"雕刻"]) {
        madeclassid = @"1";
    }
    if ([madeclassid isEqualToString:@"刺绣"]) {
        madeclassid = @"2";
    }
    if ([madeclassid isEqualToString:@"陶瓷"]) {
        madeclassid = @"3";
    }
    if ([madeclassid isEqualToString:@"漆器"]) {
        madeclassid = @"4";
    }
    if ([madeclassid isEqualToString:@"金属"]) {
        madeclassid = @"5";
    }
    if ([madeclassid isEqualToString:@"综合"]) {
        madeclassid = @"6";
    }
    
    [detailsArr setObject:madeclassid atIndexedSubscript:5];
    
    //UILog(@"+++ %@",madeclassid);
    for (int i=0; i<detailsArr.count; i++)
    {
        
        if (![[setArr objectAtIndex:i] isEqualToString:@""]) {
           [submit setObject:[detailsArr objectAtIndex:i] forKey:[setArr objectAtIndex:i]];
            
             UILog(@"detailsArr %@",[detailsArr objectAtIndex:i]);
        }
    }
    
    if (state!=nil) {
          [submit setObject:state forKey:@"province"];
    }
    if (city!=nil)
    {
        [submit setObject:city forKey:@"city"];
    }
    if (district!=nil) {
         [submit setObject:district forKey:@"district"];
    }
    UILog(@"submit %@",submit);
    
    //return;
    
    ASIHTTPRequest* request = [HttpRequest requestPost:url Dic:submit authorization:YES];
    
    __weak typeof (ASIHTTPRequest)* request_weak = request;
    
    [request_weak setCompletionBlock:^{
        NSDictionary* dic = [[request_weak responseString]objectFromJSONString];
        
        [MBProgressHUD hideHUDForView:self.view animated:NO];
        int status = [[dic objectForKey:@"status"]intValue];
        [self isDistance:status];
        if (status!=1) {
            
            NSString* info = [NSString stringWithFormat:@"%@",[dic objectForKey:@"info"]];
            ALERT_OK(info);
            return ;
        }
        NSString* info = [NSString stringWithFormat:@"%@",[dic objectForKey:@"info"]];
        //ALERT_OK(info);
        
        [TipsHud ShowTipsHud:info :self.view];
        [self performSelector:@selector(back) withObject:nil afterDelay:2.0f];
        //[self loadData];
    }];
      [MBProgressHUD showHUDAddedTo:self.view animated:YES withText:@"正在修改" detailText:nil];
    [request_weak startAsynchronous];
}
-(void)back
{
    [self.navigationController popViewControllerAnimated:YES];
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
