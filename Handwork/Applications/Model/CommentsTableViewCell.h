//
//  CommentsTableViewCell.h
//  Handwork
//
//  Created by apple on 15-5-8.
//  Copyright (c) 2015年 周文超. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommentsTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *headView;
@property (strong, nonatomic) IBOutlet UILabel *usernamelabel;
@property (strong, nonatomic) IBOutlet UILabel *contentlabel;
@property (strong, nonatomic) IBOutlet UIView *line_v;
@property (strong, nonatomic) IBOutlet UILabel *timelabel;

@end
