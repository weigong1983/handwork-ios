//
//  PersonalWorks.h
//  Handwork
//
//  Created by ios on 15-6-15.
//  Copyright (c) 2015年 周文超. All rights reserved.
//

#import "BaseViewController.h"

@class PersonalWorks;

@protocol PersonalWorksDelegate <NSObject>

@optional

-(void)didSelectItemAtIndexPath:(NSIndexPath *)indexPath andData:(NSArray*)dataArr;

@end


@interface PersonalWorks : BaseViewController


@property (nonatomic, assign) id <PersonalWorksDelegate> delegate;
@property (nonatomic) NSInteger height;
@property (nonatomic,copy)NSString* uid;
@property (nonatomic,copy)NSString* isCollect;
@end
