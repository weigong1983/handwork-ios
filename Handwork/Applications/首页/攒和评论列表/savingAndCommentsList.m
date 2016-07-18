//
//  savingAndCommentsList.m
//  Handwork
//
//  Created by ios on 15-5-6.
//  Copyright (c) 2015年 周文超. All rights reserved.
//

#import "savingAndCommentsList.h"
#import "CommentsTableViewCell.h"
@interface savingAndCommentsList ()
{
    UIButton* tempbtn;
    IBOutlet UIButton *btn1;
    IBOutlet UIButton *btn2;
    IBOutlet UIView *line_v;
    
    IBOutlet UIButton *Comments_btn;
    IBOutlet UIView *bottom_view;
    IBOutlet UITableView *myTableView;
    IBOutlet UIScrollView *scrollView;
    IBOutlet UITextField *inputField;
    NSMutableArray* arr_worksRemsgs;
    NSInteger current_Y;
}
@end

@implementation savingAndCommentsList

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    arr_worksRemsgs = [[NSMutableArray alloc]init];
//    //增加监听，当键盘出现或改变时收出消息
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(keyboardWillShow:)
//                                                 name:UIKeyboardWillShowNotification
//                                               object:nil];
//    
//    //增加监听，当键退出时收出消息
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(keyboardWillHide:)
//                                                 name:UIKeyboardWillHideNotification
//                                               object:nil];
    
    [btn1 setTitleColor:colorToString(@"#333333") forState:UIControlStateNormal];
     [btn1 setTitleColor:colorToString(@"#bf0100") forState:UIControlStateSelected];
     [btn2 setTitleColor:colorToString(@"#333333") forState:UIControlStateNormal];
      [btn2 setTitleColor:colorToString(@"#bf0100") forState:UIControlStateSelected];
    
    
    inputField.layer.borderColor = [colorToString(@"#dddddd")CGColor];
    inputField.layer.borderWidth= 1;
    inputField.layer.cornerRadius =5;
    
    
    Comments_btn.layer.masksToBounds = YES;
    Comments_btn.layer.cornerRadius =5;
    
    
    
        //[imageView release ];
        
        //UIImageButton* imagebutton = [UIImageButton buttonWithType:UIButtonTypeCustom];
        //imagebutton.frame = CGRectMake(viewX,viewY,W, H);
        //[imagebutton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        //[imagebutton setValue:[NSNumber numberWithInt:i] forKey:@"column"];
        
        //[imagebutton setImageWithURL:url];
        //[contenView addSubview:imagebutton];
        
       // [contenView setHeight:contenLabel.height+((row+1)*W)+20];

    
    //[line_v setBackgroundColor:colorToString(@"#bf0100")];
    [line_v setBackgroundColor:colorToString(@"#f0f0f0")];
    if ([self.type isEqualToString:@"0"]) {
        btn1.selected = YES;
        myTableView.hidden = YES;
        bottom_view.hidden = YES;
         scrollView.hidden = NO;
        tempbtn = btn1;
        self.title = @"赞过的人";
    }
    else
    {
        btn2.selected = YES;
        myTableView.hidden = NO;
        bottom_view.hidden = NO;
         scrollView.hidden = YES;
        tempbtn = btn2;
        self.title = @"评论过的人";
    }
    
    //current_Y = bottom_view.top;
    
    [self getWorksUpclicks];
    
    [self getWorksRemsgs];
    // Do any additional setup after loading the view from its nib.
}
- (IBAction)reMessage:(UIButton *)sender {
    
//    if ([self Check_Guest]) {
//        return;
//    }
    
    if (inputField.text.length) {
        NSString* url =  [NSString stringWithFormat:@"Works/reMessage"];
        NSMutableDictionary* dic = [NSMutableDictionary dictionary];
        [dic setValue:self.mgid forKey:@"id"];
        [dic setValue:inputField.text forKey:@"content"];
        
        ASIHTTPRequest* request = [HttpRequest requestPost:url Dic:dic authorization:YES];
        __weak typeof(ASIHTTPRequest)* weak_request = request;
        
        [weak_request setCompletionBlock:^{
            
            NSDictionary* dict = [[weak_request responseString] objectFromJSONString];
            
            int status = [[dict objectForKey:@"status"]intValue];
            if (status!=1) {
                NSString* info = [NSString stringWithFormat:@"%@",[dict objectForKey:@"info"]];
                ALERT_OK(info);
                return ;
            }
            NSString* info = [NSString stringWithFormat:@"%@",[dict objectForKey:@"info"]];
            [TipsHud ShowTipsHud:info :self.view];
            //UILog(@"data %@",data);
            inputField.text = @"";
            [self getWorksRemsgs];
            
            // 隐藏键盘
            [inputField resignFirstResponder];

        }];
        
        [weak_request startAsynchronous];
    }
    else
    {
        ALERT_OK(@"内容不能为空!");
    }
    
}
-(void)getWorksRemsgs
{
    NSString* url =  [NSString stringWithFormat:@"Works/getWorksRemsgs"];
    NSMutableDictionary* dic = [NSMutableDictionary dictionary];
    [dic setValue:self.mgid forKey:@"id"];
    
    ASIHTTPRequest* request = [HttpRequest requestPost:url Dic:dic authorization:YES];
    __weak typeof(ASIHTTPRequest)* weak_request = request;
    
    [weak_request setCompletionBlock:^{
        
        NSDictionary* dict = [[weak_request responseString] objectFromJSONString];
        
        int status = [[dict objectForKey:@"status"]intValue];
        if (status!=1) {
            NSString* info = [NSString stringWithFormat:@"%@",[dict objectForKey:@"info"]];
            ALERT_OK(info);
            return ;
        }
        NSDictionary* data = [dict objectForKey:@"data"];
        
        NSArray* infos = [data objectForKey:@"infos"];
        int infos_count = [infos count];
        if (infos_count!=0) {
            [arr_worksRemsgs removeAllObjects];
            for (int i=0; i<infos_count; i++)
            {
                NSDictionary* infos_dic = [infos objectAtIndex:i];
                DataModel* model = [[DataModel alloc]init];
                if (!strIsEmpty([infos_dic objectForKey:@"s_photo"]))
                {
                    model.s_photo = [infos_dic objectForKey:@"s_photo"];
                }
                if (!strIsEmpty([infos_dic objectForKey:@"nickname"]))
                {
                    model.s_nickname = [infos_dic objectForKey:@"nickname"];
                }
                if (!strIsEmpty([infos_dic objectForKey:@"uid"]))
                {
                    model.s_uid = [infos_dic objectForKey:@"uid"];
                }
                if (!strIsEmpty([infos_dic objectForKey:@"remessage"]))
                {
                    model.s_remessage = [infos_dic objectForKey:@"remessage"];
                }
                if (!strIsEmpty([infos_dic objectForKey:@"createtime"]))
                {
                    model.s_createtime = [infos_dic objectForKey:@"createtime"];
                }
                [arr_worksRemsgs addObject:model];
            }
            
            [myTableView reloadData];
        }
        UILog(@"data %@",data);
    }];
    
    [weak_request startAsynchronous];
}


-(void)getWorksUpclicks
{
    NSString* url =  [NSString stringWithFormat:@"Works/getWorksUpclicks"];
    NSMutableDictionary* dic = [NSMutableDictionary dictionary];
    [dic setValue:self.mgid forKey:@"id"];
    
    ASIHTTPRequest* request = [HttpRequest requestPost:url Dic:dic authorization:YES];
    __weak typeof(ASIHTTPRequest)* weak_request = request;
    
    [weak_request setCompletionBlock:^{
        
        NSDictionary* dict = [[weak_request responseString] objectFromJSONString];
        
        int status = [[dict objectForKey:@"status"]intValue];
        if (status!=1) {
            NSString* info = [NSString stringWithFormat:@"%@",[dict objectForKey:@"info"]];
            ALERT_OK(info);
            return ;
        }
        
        NSDictionary* data = [dict objectForKey:@"data"];
        
        NSArray* infos = [data objectForKey:@"infos"];
        
        //UILog(@"data %@",data);
        
        int count = [infos count];
        
        if (count!=0) {
            int totalColumns =4;
            
            //左右间距
            int spacing = 24;
            
            //通过列数来判断每个图的大小
            int x = ((_Screen_Width-((totalColumns-1)*spacing))/totalColumns);
            
            //上下间距
            CGFloat Y = 20;
            
            //控件宽
            CGFloat W = x;
            
            //控件高
            CGFloat H = x;
            
            CGFloat X = (_Screen_Width - totalColumns * W) / (totalColumns + 1);
            //NSMutableArray *array = [[NSMutableArray alloc]init];
            for (int i=0; i<count; i++)
            {
                int row = i / totalColumns; //行号
                int col = i % totalColumns; //列号
                
                CGFloat viewX = X + col * (W + X);
                //从文字开始
                CGFloat topY  = 21;
                CGFloat viewY =  topY + row * (H + Y);
                
                NSDictionary* d_data = [infos objectAtIndex:i];
                
                //UIImageView* imageView = [[UIImageView alloc]init];
                UIImageView* imageView = [[UIImageView alloc]init];
                if (!strIsEmpty([d_data  objectForKey:@"s_photo"]))
                {
                    [imageView setImageWithURL:[NSURL URLWithString:[d_data  objectForKey:@"s_photo"]] placeholderImage:[UIImage imageNamed:@"默认头像.png"]];
                    
                }
                

                imageView.layer.masksToBounds = YES;
                imageView.layer.cornerRadius = W/2;
                
                //imageView.t_delegate = self;
                
                //                        if (i==(images.count-1))
                //                        {
                //                            imageView.maxCount = images.count;
                //                        }
                
                
                //NSURL* url = [NSURL URLWithString:[images objectAtIndex:i]];
                //[imageView setImageWithURL:url];
                imageView.frame = CGRectMake(viewX,viewY,W, H);
                imageView.tag = 10 + i;
                //imageView.identifier = cell;
                
                [imageView setContentScaleFactor:[[UIScreen mainScreen] scale]];
                
                imageView.contentMode =  UIViewContentModeScaleAspectFill;
                
                imageView.clipsToBounds  = YES;
                
                //[self.view addSubview:imageView];
                [scrollView addSubview:imageView];
                [scrollView setHeight:20+((row+1)*W)+60];
            }
            

        }
        
    }];
    
    [weak_request startAsynchronous];
}

-(void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    
    return YES;
}// return NO to disallow editing.
- (void)textFieldDidBeginEditing:(UITextField *)textField;
{
    
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
- (IBAction)btn_click:(UIButton *)sender {
    if (tempbtn.tag!=sender.tag) {
        tempbtn.selected = NO;
    }
    else
    {
        return;
    }
    tempbtn = sender;
    tempbtn.selected = YES;
    
    [UIView animateWithDuration:0.2 animations:^{
        if (sender.tag==0) {
            self.title = @"赞过的人";
            myTableView.hidden = YES;
            bottom_view.hidden = YES;
            scrollView.hidden = NO;
        }
        else
        {
            self.title = @"评论过的人";
            myTableView.hidden = NO;
            bottom_view.hidden = NO;
            scrollView.hidden = YES;
        }

    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}





#pragma mark UITabViewDataSource
-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //UILog(@"tableViewData :  %d",tableViewData.count);
    if (arr_worksRemsgs.count==0) {
        return 1;
    }
    else
    {
        return arr_worksRemsgs.count;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier = @"Cell";
    CommentsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil)
    {
        //        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        NSArray * nibViews  =[[NSBundle mainBundle] loadNibNamed:@"CommentsTableViewCell" owner:self options:nil] ;
        cell= [nibViews objectAtIndex:0];
    }
    //cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    if (arr_worksRemsgs.count==0)
    {
        UILabel* label = [[UILabel alloc]init];
        label.frame = CGRectMake(_Screen_Width/2-40, cell.height/2-10, 80, 20);
        label.textAlignment = NSTextAlignmentCenter;
        [label setText:@"暂无评论"];
        [cell.contentView addSubview:label];
        
    }
    if (arr_worksRemsgs.count!=0) {
        DataModel* model = [arr_worksRemsgs objectAtIndex:indexPath.row];
        NSString* url = model.s_photo;
        [cell.headView setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"默认头像.png"]];
        
        cell.usernamelabel.text = model.s_nickname;
        
        cell.contentlabel.text = model.s_remessage;
        
        cell.timelabel.text = model.s_createtime;
        //myTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    }
    //[[cell imageView] setImage:[self tripPhotoForRowAtIndexPath:indexPath]];
//    NSString* s_img = [NSString stringWithFormat:@"发现 (%d).jpg",indexPath.row+1];
//    [cell.image_bg setImage:[UIImage imageNamed:s_img]];
//    cell.textLabel.text = [NSString stringWithFormat:@"%ld",(long)indexPath.row];
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CommentsTableViewCell *cell = (CommentsTableViewCell*)[self tableView:myTableView cellForRowAtIndexPath:indexPath];
    UILog(@"cell.height %0.0f",cell.height);
    
    return cell.frame.size.height;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UILog(@"%ld",(long)indexPath.row);
    
}

//当键盘出现或改变时调用
//- (void)keyboardWillShow:(NSNotification *)aNotification
//{
//    //获取键盘的高度
//    NSDictionary *userInfo = [aNotification userInfo];
//    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
//    CGRect keyboardRect = [aValue CGRectValue];
//    int height = keyboardRect.size.height;
//    
//    UILog(@"键盘出现 高度 %d",height);
//    [bottom_view setTop:height+50/2];
//}

//当键退出时调用
//- (void)keyboardWillHide:(NSNotification *)aNotification
//{
//    
//    NSDictionary *userInfo = [aNotification userInfo];
//    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
//    CGRect keyboardRect = [aValue CGRectValue];
//    int height = keyboardRect.size.height;
//    UILog(@"键盘隐藏 高度 %d",height);
//    [bottom_view setTop:myTableView.bottom];
//}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
