//
//  NoticeTableViewCell.h
//  Handwork
//
//  Created by ios on 15-5-4.
//  Copyright (c) 2015年 周文超. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NoticeTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *i_image;
@property (strong, nonatomic) IBOutlet UILabel *product_name;
@property (strong, nonatomic) IBOutlet UILabel *time_label;

@end
