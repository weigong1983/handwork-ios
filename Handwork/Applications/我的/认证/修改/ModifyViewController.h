//
//  ModifyViewController.h
//  Handwork
//
//  Created by ios on 15-5-4.
//  Copyright (c) 2015年 周文超. All rights reserved.
//

#import "BaseViewController.h"
#import "CertificationViewController.h"
@interface ModifyViewController : BaseViewController
@property (nonatomic,strong)NSString* dataName;
@property (nonatomic,strong)NSString* s_type;
@property (nonatomic,strong)NSString* s_type1;
@property (nonatomic,assign)CertificationViewController* vc;
@end
