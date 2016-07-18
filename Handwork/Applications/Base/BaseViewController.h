//
//  BaseViewController.h
//  Handwork
//
//  Created by ios on 15-4-29.
//  Copyright (c) 2015年 周文超. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GZNavigationController.h"
#import "UIView+KGViewExtend.h"
#import "UIColor+HexColor.h"
#import "API.h"
#import "Config.h"
#import "MBProgressHUD.h"
#import "HttpRequest.h"
#import "ASIHTTPRequest.h"
#import "DataModel.h"
#import "UIImageView+WebCache.h"
#import "UIButton+WebCache.h"
#import "StringUtil.h"
#import "TipsHud.h"
#import "FeThreeDotGlow.h"
#import "MJRefresh.h"
#import "UIImage+LK.h"
#import "MobClick.h"

@interface BaseViewController : UIViewController
- (void)followScrollView:(UIView*)scrollableView;
- (void)checkForPartialScroll;
- (void)updateSizingWithDelta:(CGFloat)delta;
-(BOOL)IS_Guest;
-(BOOL)Check_Guest;
-(void)isDistance:(NSInteger)code;
-(BOOL)isUidToString:(NSString*)uid;
- (void)skipICloud:(NSString*)url;
-(NSString *)recordPathAMRToWAV;
-(NSString *)recordPathOrigin;
-(NSString*)s_writeToFile:(NSString*)s;
@end
