//
//  MyHomeViewController.h
//  Handwork
//
//  Created by ios on 15-5-4.
//  Copyright (c) 2015年 周文超. All rights reserved.
//

#import "BaseViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "FXRecordArcView.h"

@interface MyHomeViewController : BaseViewController
{
    
}
@property(nonatomic, strong) FXRecordArcView *recordView;

@property (nonatomic) BOOL isRecording;
@property (nonatomic,strong) NSString* uid;

@property (strong, nonatomic)  UIButton *playButton;
@property (strong, nonatomic)  UIButton *recordButton;
@end
