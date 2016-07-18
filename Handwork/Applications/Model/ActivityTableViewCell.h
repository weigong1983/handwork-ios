//
//  ActivityTableViewCell.h
//  Handwork
//
//  Created by ios on 15-5-4.
//  Copyright (c) 2015年 周文超. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ActivityTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIView *line_v;
@property (strong, nonatomic) IBOutlet UIImageView *left_image;
@property (strong, nonatomic) IBOutlet UILabel *label1;
@property (strong, nonatomic) IBOutlet UILabel *label2;
@property (strong, nonatomic) IBOutlet UILabel *label3;

@end
