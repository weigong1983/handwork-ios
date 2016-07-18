//
//  LeaveMessageViewController.m
//  Handwork
//
//  Created by apple on 15-5-7.
//  Copyright (c) 2015年 周文超. All rights reserved.
//

#import "LeaveMessageViewController.h"

@interface LeaveMessageViewController ()
@property (strong, nonatomic) IBOutlet UITextView *textView;
@property (strong, nonatomic) IBOutlet UILabel *placeholder;
@property (strong, nonatomic) IBOutlet UIButton *submit_btn;

@end

@implementation LeaveMessageViewController
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.textView resignFirstResponder];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"给研究院留言";
    //[self.submit_btn setTitleColor:colorToString(@"#999999") forState:UIControlStateNormal];
    self.placeholder.textColor = colorToString(@"#cccccc");
    self.textView.textColor = colorToString(@"#333333");
    [self.submit_btn setTitleColor:colorToString(@"#333333") forState:UIControlStateNormal];
    
    self.submit_btn.layer.borderColor = [colorToString(@"#dddddd") CGColor];
    self.submit_btn.layer.borderWidth = 1;
    // Do any additional setup after loading the view from its nib.
}
- (IBAction)submitclick:(UIButton *)sender {
    
    NSString* url =  [NSString stringWithFormat:@"Works/leaveMsg"];
    NSMutableDictionary* dict = [NSMutableDictionary dictionary];
    if (self.textView.text.length) {
        [dict setValue:self.textView.text forKey:@"content"];
    }
    else
    {
        ALERT_OK(@"内容不能为空!");
        return;
    }
    UILog(@"self.mgid-> %@",self.mgid);
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
        
        NSDictionary* dic = [[weak_request responseString] objectFromJSONString];
        
        int status = [[dic objectForKey:@"status"]intValue];
        
        [self isDistance:status];
        if (status!=1) {
            return ;
        }
        
        NSString* info = [NSString stringWithFormat:@"%@",[dic objectForKey:@"info"]];
        ALERT_OK(info);
        UILog(@"dict %@",dic);
        
        [self performSelector:@selector(back) withObject:nil afterDelay:1.5];

    }];
    
    [weak_request startAsynchronous];
}
-(void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}
//-(void)textViewDidChange:(UITextView *)textView
//
//{
//    
//    //    textview 改变字体的行间距
//    
//    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
//    
//    paragraphStyle.lineSpacing = 5;// 字体的行间距
//    
//    
//    
//    NSDictionary *attributes = @{
//                                 
//                                 NSFontAttributeName:[UIFont systemFontOfSize:15],
//                                 
//                                 NSParagraphStyleAttributeName:paragraphStyle
//                                 
//                                 };
//    
//    textView.attributedText = [[NSAttributedString alloc] initWithString:textView.text attributes:attributes];
//    
//}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text

{    if (![text isEqualToString:@""])
{
    

    self.placeholder.hidden = YES;
    
}
    
    if ([text isEqualToString:@""] && range.location == 0 && range.length == 1)
        
    {
        
        self.placeholder.hidden = NO;
        
    }
    if ([text isEqualToString:@"\n"]){ //判断输入的字是否是回车，即按下return
        //在这里做你响应return键的代码
        //[textView resignFirstResponder];
        return YES; //这里返回NO，就代表return键值失效，即页面上按下return，不会出现换行，如果为yes，则输入页面会换行
    }
    
    return YES;
    
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
