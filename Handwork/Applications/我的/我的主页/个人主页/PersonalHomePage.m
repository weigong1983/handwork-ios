//
//  PersonalHomePage.m
//  Handwork
//
//  Created by ios on 15-6-15.
//  Copyright (c) 2015年 周文超. All rights reserved.
//

#import "PersonalHomePage.h"
#import "FXRecordArcView.h"
#import <AVFoundation/AVFoundation.h>

#import "VoiceConverter.h"
#import "FileTools.h"
@interface PersonalHomePage ()<FXRecordArcViewDelegate,UIGestureRecognizerDelegate,AVAudioPlayerDelegate>
{
    IBOutlet UIImageView *headPortrait;
    UIView *recordTouchView;
    UIView * bg_View;
    NSURL*  url_path;
    NSString* saveAmrPath;
    DataModel* model;
}
//真实姓名
@property (strong, nonatomic) IBOutlet UILabel *nicknamelabel;

//认证图
@property (strong, nonatomic) IBOutlet UIImageView *certification_Image;

@property (strong, nonatomic) IBOutlet UILabel *callnamelabel;

//地址
@property (strong, nonatomic) IBOutlet UILabel *addresslabel;
//
@property (strong, nonatomic) IBOutlet UIImageView *address_icon;

//签名
@property (strong, nonatomic) IBOutlet UILabel *signaturelabel;
@property (strong, nonatomic) IBOutlet UIButton *voice_btn;
@property (strong, nonatomic) UIButton * recordButton;

@property (weak, nonatomic) IBOutlet UILabel *timelabel;
@property (nonatomic)BOOL isRefresh;
@property (nonatomic,strong)FXRecordArcView* recordView;
@property (nonatomic,strong) AVAudioPlayer *audioPlayer;
@end

@implementation PersonalHomePage

@synthesize model;

- (void)viewDidLoad
{
    [super viewDidLoad];
    

    self.recordButton = [[UIButton alloc]init];
    self.recordButton.adjustsImageWhenHighlighted = YES;
    self.recordButton.tag = 999;
    [self.recordButton setTitleColor:RGB_MAKE(40, 40, 40) forState:UIControlStateNormal];
    
    NSMutableAttributedString *titleString = [[NSMutableAttributedString alloc] initWithString:@"录制个性语音"];
    NSRange strRange = {0,[titleString length]};
    [titleString addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:strRange];
    [titleString addAttribute:NSForegroundColorAttributeName value:RGB_MAKE(76, 145, 225) range:strRange];
    
    
    //设置颜色
    [self.recordButton setAttributedTitle:titleString forState:UIControlStateNormal];
    //UILog(@"btn_voice.bottom %0.0f",btn_voice.bottom+5);
    self.recordButton.frame = CGRectMake(_Screen_Width/2-100,1000, 200, 30);
    [self.recordButton addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    self.recordButton.hidden = YES;
    
    
    [self.view addSubview:self.recordButton];
    
    
    if (self.uid == nil)
    {
        // 暂时没实现隐藏掉-魏工
        self.recordButton.hidden = NO;
        
        //UILog(@"self.uid %@",self.uid);
    }
//
//    label = [[UILabel alloc]init];
//    [label setTextAlignment:NSTextAlignmentCenter];
//    
//    [view addSubview:label];
    
    // Do any additional setup after loading the view from its nib.
    
    headPortrait.layer.masksToBounds = YES;
    headPortrait.layer.cornerRadius = 75;
    
    recordTouchView = [[UIView alloc]init];
    recordTouchView.backgroundColor = [UIColor clearColor];
    recordTouchView.frame = CGRectMake(0, 0, _Screen_Width, self.view.frame.size.height);
    recordTouchView.hidden = YES;
    [self.view addSubview:recordTouchView];
    
    bg_View = [[UIView alloc]init];
    bg_View.backgroundColor = [UIColor blackColor];
    //    bg_View.alpha = 0.8f;
    bg_View.frame = CGRectMake(0, self.view.frame.size.height, _Screen_Width,200);
    [recordTouchView addSubview:bg_View];
    
    self.recordView = [[FXRecordArcView alloc] initWithFrame:CGRectMake(0, 0, _Screen_Width, 140)];
    //    self.recordView.backgroundColor = [UIColor grayColor];
    [bg_View addSubview:self.recordView];
    self.recordView.delegate = self;
    
    NSArray* arrBtn = @[@"录音",@"完成",@"试听",@"保存"];
    for (int i=0; i<arrBtn.count; i++) {
        UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
        //[btn setImage:[UIImage imageNamed:@"按钮.png"] forState:UIControlStateNormal];
        //[btn setBackgroundImage:[UIImage imageNamed:@"按钮.png"] forState:UIControlStateNormal];
        //[btn setTitleColor:RGB_MAKE(40, 40, 40) forState:UIControlStateNormal];
        //[btn setTitleColor:RGB_MAKE(50, 50, 50) forState:UIControlStateHighlighted];
        btn.tag = 100+i;
        if (i==2) {
            btn.enabled = NO;
        }
        btn.backgroundColor = RGB_MAKE(192, 0, 0);
        btn.layer.borderWidth =1;
        btn.layer.borderColor = [[UIColor whiteColor]CGColor];
        [btn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
        btn.adjustsImageWhenHighlighted = YES;
        [btn addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
        btn.layer.masksToBounds = YES;
        btn.layer.cornerRadius = 45/2;
        btn.frame = CGRectMake((_Screen_Width/4/2-45/2)+_Screen_Width/4*i,150,45,45);
        [btn setTitle:[arrBtn objectAtIndex:i] forState:UIControlStateNormal];
        [bg_View addSubview:btn];
    }
    
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}
-(void)loadData
{

    [headPortrait setImageWithURL:[NSURL URLWithString:self.model.s_photo] placeholderImage:[UIImage imageNamed:@"默认头像.png"]];
    
    if (self.model.s_nickname !=nil)
    {
        self.nicknamelabel.text = self.model.s_nickname;
        
        //self.nicknamelabel.frame = CGRectMake(_Screen_Width/2-realname.text.length*Label_Font/2,headImage.bottom+15, realname.text.length*Label_Font, 20);
        
        
        [self getLabelLeng:self.nicknamelabel];
        
        [self.certification_Image setLeft:self.nicknamelabel.right+5];
        self.certification_Image.hidden = NO;
    }
    
    if (self.model.s_callname!=nil)
    {
        self.callnamelabel.text = self.model.s_callname;
        [self getLabelLeng:self.callnamelabel];
    }
    
    if (self.model.s_address!=nil) {
        self.addresslabel.text = self.model.s_address;
        
        [self getLabelLeng:self.addresslabel];
        [self.address_icon setLeft:self.addresslabel.right+5];
        self.address_icon.hidden = NO;
    }
    else
    {
        self.address_icon.hidden = YES;
        
        [self.signaturelabel setBottom:self.addresslabel.bottom+2];
    }
    
    if (self.model.s_signature!=nil) {
        self.signaturelabel.text = self.model.s_signature;
        [self getLabelLeng:self.signaturelabel];
        
        //UILog(@"self.model.s_signature %@",self.model.s_signature);
    }
    
    if (model.s_voicepath!=nil)
    {
        
        self.voice_btn.hidden = NO;
        
        [MBProgressHUD showHUDAddedTo:self.view animated:YES withText:@"加载音频" detailText:nil];
        
        if ([model.s_voicetype isEqualToString:@"ios"])
        {
            
            saveAmrPath = [self s_writeToFile:model.s_voicepath];
            
             url_path = [NSURL URLWithString:saveAmrPath];
            
             NSString* savePathWmv = [FileTools getPathByFileName:@"record" ofType:@"wmv"];
            
            //安卓删除原wmv文件
            if ([FileTools fileExistsAtPath:savePathWmv])
            {
                [FileTools deleteFileAtPath:savePathWmv];
            }
        }
       else
       {
           
           NSString* savePath = [self s_writeToFile:model.s_voicepath];
           
           //转换
           [VoiceConverter amrToWav:savePath wavSavePath:[FileTools getPathByFileName:@"record" ofType:@"wmv"]];
           
           //安卓删除原amr文件
           if ([FileTools fileExistsAtPath:savePath])
           {
               [FileTools deleteFileAtPath:savePath];
           }
           
           url_path = [NSURL URLWithString:[FileTools getPathByFileName:@"record" ofType:@"wmv"]];
       }
        
        //UILog(@"model.s_voicepath %@",model.s_voicepath);
        
        [MBProgressHUD hideHUDForView:self.view animated:NO];
        
        [self.recordButton setTop:self.voice_btn.bottom + 5];
        
        
        //UILog(@"url_path %@",url_path);
        
        self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url_path error:nil];
        AVAudioSession *audioSession = [AVAudioSession sharedInstance];
        [audioSession setCategory:AVAudioSessionCategoryPlayback error:nil];
        self.audioPlayer.delegate = self;
        [self.audioPlayer setVolume:1];
        [self.audioPlayer prepareToPlay];
        self.timelabel.text = [NSString stringWithFormat:@"%0.0f″",self.audioPlayer.duration];
    }
}


-(NSInteger)getLabelLeng:(UILabel*)label
{
    
    NSInteger leng = label.text.length*Label_Font;
    
    //UILog(@"label.text.length %lu",(unsigned long)label.text.length);
    
    //UILog(@"leng %d",leng);
    
    [label setWidth:leng];
    
    [label setLeft:_Screen_Width/2-leng/2];
    
    
    
    return leng;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [UIView animateWithDuration:0.5 animations:^{
        self.recordView.timeLabel.text = @"";
        [bg_View setTop:self.view.frame.size.height];
    } completion:^(BOOL finished) {
        recordTouchView.hidden = YES;
    }];
}

- (void)recordArcView:(FXRecordArcView *)arcView voiceRecorded:(NSString *)recordPath length:(float)recordLength{
    //    UIAlertView *alert =
    //    [[UIAlertView alloc] initWithTitle: @"record"
    //                               message: [NSString stringWithFormat:@"录音地址：%@,  时常：%f",recordPath, recordLength]
    //                              delegate: nil
    //                     cancelButtonTitle:@"OK"
    //                     otherButtonTitles:nil];
    //    [alert show];
    
    UIButton* btn = (UIButton*)[self.view viewWithTag:102];
    btn.enabled = YES;
}


-(void)click:(UIButton*)sender
{
    if(sender.tag==999)
    {
        [UIView animateWithDuration:0.5 animations:^{
            recordTouchView.hidden = NO;
            [bg_View setTop:self.view.frame.size.height-200];
            
            [self.audioPlayer stop];
            self.audioPlayer.currentTime = 0.0;
            [self.audioPlayer prepareToPlay];
            [self unpressedEvent];
        }];
    }
    if (sender.tag==100) {
        [self.recordView startForFilePath:[self fullPathAtCache:@"record.wav"]];
        
    }
    if (sender.tag==101) {
        [self.recordView commitRecording];
        UIButton* btn = (UIButton*)[self.view viewWithTag:102];
        btn.enabled = YES;
    }
    if (sender.tag==102) {
        self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:[self fullPathAtCache:@"record.wav"]] error:nil];
        [self.audioPlayer play];
    }
    if (sender.tag==103)
    {
        
        [self.audioPlayer stop];
        
        UILog(@"保存");
        
        [self.recordView commitRecording];
        
        [UIView animateWithDuration:0.5 animations:^{
            self.recordView.timeLabel.text = @"";
            [bg_View setTop:_Screen_Height];
        } completion:^(BOOL finished) {
            recordTouchView.hidden = YES;
        }];
        
        [self setVoice:[self fullPathAtCache:@"record.wav"]];
    }
}
- (IBAction)play_voice:(UIButton *)sender {
    
    BOOL startsPlaying = !self.audioPlayer.playing;
    
    if (startsPlaying) {
        [self.audioPlayer play];
        [self pressedEvent:sender];
    }
    else {
        [self.audioPlayer stop];
         self.audioPlayer.currentTime = 0.0;
        [self.audioPlayer prepareToPlay];
        [self unpressedEvent];
    }
}




-(void)setVoice:(NSString*)voice
{
    
    //UILog(@"voice %@",voice);
    
    NSString* url = [NSString stringWithFormat:@"Account/setVoice"];
    
    NSMutableDictionary* setData = [NSMutableDictionary dictionary];
    
    //NSData *nsdata = [voice dataUsingEncoding:NSUTF8StringEncoding];
    
    NSError* error;
    NSData* lzdata= [NSData dataWithContentsOfFile:voice options:0 error:&error];
    
    
    if (!error) {
        // (char*)[lzdata bytes] 楼主data数据
        // [lzdatalength] 楼主data数据长度
    }
    
    // Get NSString from NSData object in Base64
    NSString *base64Encoded = [lzdata base64EncodedStringWithOptions:0];
    
    [setData setObject:base64Encoded forKey:@"voice"];
    [setData setObject:@"temp" forKey:@"name"];
//    [setData setObject:@"amr" forKey:@"extion"];
    
    [setData setObject:@"ios" forKey:@"voicetype"];
    //UILog(@"+++  +++  %@",setData);
    //return;
    ASIHTTPRequest* request  = [HttpRequest requestPost:url Dic:setData authorization:YES];
    
    __weak typeof (ASIHTTPRequest)* request_weak = request;
    
    
    [request_weak setUploadProgressDelegate:self];
    
    request_weak.showAccurateProgress=YES;//
    
    [request_weak setCompletionBlock:^{
        
        NSDictionary* dic = [[request_weak responseString] objectFromJSONString];
        
        int status = [[dic objectForKey:@"status"]intValue];
        if (status !=1)
        {
            NSString* info = [NSString stringWithFormat:@"%@",[dic objectForKey:@"info"]];
            ALERT_OK(info);
            return ;
        }
        NSString* info = [NSString stringWithFormat:@"%@",[dic objectForKey:@"info"]];
        //ALERT_OK(info);
        //UILog(@"++  %@",dic);
        //UILog(@" self.model.s_voicepath %@", self.model.s_voicepath);
        
        
        
        [MBProgressHUD hideHUDForView:self.view animated:NO];
        
        
        
        NSDictionary* data = [dic objectForKey:@"data"];
        
        NSString *urlStr = [NSString stringWithFormat:@"%@",[data objectForKey:@"voicepath"]];
        
        
        if ([FileTools fileExistsAtPath:saveAmrPath]) {
            if ([FileTools deleteFileAtPath:saveAmrPath])
            {
                UILog(@"删除原来录音文件");
                [MBProgressHUD showHUDAddedTo:self.view animated:YES withText:@"加载音频" detailText:nil];
                saveAmrPath = [self s_writeToFile:urlStr];
                url_path = [NSURL URLWithString:saveAmrPath];
            }
        }
        else{
            [MBProgressHUD showHUDAddedTo:self.view animated:YES withText:@"加载音频" detailText:nil];
            saveAmrPath = [self s_writeToFile:urlStr];
            url_path = [NSURL URLWithString:saveAmrPath];
        }
        
        
        
        [MBProgressHUD hideHUDForView:self.view animated:NO];
        
       self.audioPlayer = [self.audioPlayer initWithContentsOfURL:url_path error:nil];
        
        self.audioPlayer.delegate = self;
        
        [self.audioPlayer prepareToPlay];
        
        [TipsHud ShowTipsHud:info :self.view];
        
//        NSUserDefaults* userfaulst = [NSUserDefaults standardUserDefaults];
//        
//        if (!strIsEmpty([data objectForKey:@"voicepath"])) {
//            [userfaulst setObject:[NSString stringWithFormat:@"%@",[data objectForKey:@"voicepath"]]forKey:LOCAL_VOICEPATH];
//        }
        
        
        //[MBProgressHUD hideHUDForView:self.view animated:NO];
        
        //[self loadData];
        
    }];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES withText:@"正在上传" detailText:nil];
    [request_weak startAsynchronous];
}
-(void)setProgress:(float)newProgress{
    
    //[self.pvsetProgress:newProgress];
    
    UILog(@"%@",[NSString stringWithFormat:@"%0.f%%",newProgress*100]);
    
    //progressView.progress =newProgress*100;
    
}
- (NSString *)fullPathAtCache:(NSString *)fileName
{
    NSError *error;
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)objectAtIndex:0];
    
    NSFileManager *fm = [NSFileManager defaultManager];
    
    if (YES != [fm fileExistsAtPath:path])
    {
        if (YES != [fm createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:&error])
        {
            NSLog(@"create dir path=%@, error=%@", path, error);
        }
    }
    return [path stringByAppendingPathComponent:fileName];
}


-(void)pressedEvent:(id)sender
{
    //按钮的压下事件的响应方法
    UIButton *btn = sender;
    
    //定义一个动画的帧数组
    NSArray *imgArray = [NSArray arrayWithObjects:[UIImage imageNamed:@"voice0.png"],[UIImage imageNamed:@"voice1.png"],[UIImage imageNamed:@"voice2.png"],nil];
    
    //初始化一个UIImageView用于逐帧播放我们的动画
    UIImageView *animImgView = [[UIImageView alloc]init];
    
    // CGRectMake(0, 0, ((UIImage*)[imgArray objectAtIndex:0]).size.width, ((UIImage*)[imgArray objectAtIndex:0]).size.height);//这里默认认为动画的每帧大小是一致的，顾取出第一个图片的大小来作为UIImageView的大小
    animImgView.frame =btn.frame;
    
   // [animImgView setTop:btn.bottom+0.5];
    
    //上边只是这是了UIImageView的大小，这里设置他的摆放位置，让动画的中心点和按钮的中心点重叠
    //    animImgView.center = btn.center;
    
    //设置这个是为了在压下的按钮触发的释放动作中获取到这个播放动画的UIImageView
    animImgView.tag = 10000;
    
    //将逐帧动画的数组传递给UIImageView
    animImgView.animationImages = imgArray;
    
    //浏览所有图片一次所用的时间
    animImgView.animationDuration = 0.65;
    
    // 0 = loops forever 动画重复次数
    animImgView.animationRepeatCount = 0;
    
    //开始播放动画
    [animImgView startAnimating];
    
    //添加视图到窗体中
    [self.view addSubview:animImgView];
    
    //将动画播放的视图移到elf.view的最底层，这里需要注意图层遮挡问题
    //    [self.view sendSubviewToBack:animImgView];
}

-(void)unpressedEvent
{
    //按钮的松开事件的响应方法
    [[self.view viewWithTag:10000] removeFromSuperview];
}

#pragma mark - AVAudioPlayerDelegate
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    //self.playerControl1.playing = NO;
    //[self updateViewConstraints];
    [self unpressedEvent];
    [self.audioPlayer prepareToPlay];
}

- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError *)error{
    UILog(@"error %@",error);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)dealloc
{
    self.recordButton = nil;
    recordTouchView = nil;
    self.recordView = nil;
    self.audioPlayer = nil;
    model = nil;
    UILog(@"delloc");
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
