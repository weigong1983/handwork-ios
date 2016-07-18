//
//  NoticeTableViewCell.m
//  Handwork
//
//  Created by ios on 15-5-4.
//  Copyright (c) 2015年 周文超. All rights reserved.
//

#import "NoticeTableViewCell.h"
#import "BaseViewController.h"
@implementation NoticeTableViewCell

- (void)awakeFromNib {
    // Initialization code
    self.time_label.textColor = colorToString(@"#999999");
    self.product_name.textColor = colorToString(@"#333333");
    self.i_image.layer.masksToBounds = YES;
    self.i_image.layer.cornerRadius = 20;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
