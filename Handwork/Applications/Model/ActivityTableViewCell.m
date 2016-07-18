//
//  ActivityTableViewCell.m
//  Handwork
//
//  Created by ios on 15-5-4.
//  Copyright (c) 2015年 周文超. All rights reserved.
//

#import "ActivityTableViewCell.h"
#import "BaseViewController.h"
@implementation ActivityTableViewCell

- (void)awakeFromNib {
    // Initialization code
    self.line_v.backgroundColor = RGB_MAKE(232, 232, 232);
    self.label1.textColor = colorToString(@"#333333");
    self.label2.textColor = colorToString(@"#999999");
    self.label3.textColor = colorToString(@"#999999");
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
