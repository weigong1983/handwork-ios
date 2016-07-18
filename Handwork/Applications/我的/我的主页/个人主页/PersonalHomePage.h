//
//  PersonalHomePage.h
//  Handwork
//
//  Created by ios on 15-6-15.
//  Copyright (c) 2015年 周文超. All rights reserved.
//

#import "BaseViewController.h"

@interface PersonalHomePage : BaseViewController
@property (nonatomic,strong) DataModel* model;
@property (nonatomic,copy)   NSString* uid;

-(void)loadData;
@end
