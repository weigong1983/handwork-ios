//
//  WorkDetailsViewController.h
//  Handwork
//
//  Created by ios on 15-5-5.
//  Copyright (c) 2015年 周文超. All rights reserved.
//

#import "BaseViewController.h"
#import "HomePageViewController.h"
@interface WorkDetailsViewController : BaseViewController
@property (nonatomic,strong)NSString* mgid;
@property (nonatomic,strong)NSString* madeflowinfo;
@property (nonatomic,strong)NSString* uid;
@property (nonatomic, assign)HomePageViewController* vc;
@end
