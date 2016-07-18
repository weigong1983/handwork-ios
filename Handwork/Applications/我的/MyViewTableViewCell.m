//
//  MyViewTableViewCell.m
//  Handwork
//
//  Created by ios on 15-4-30.
//  Copyright (c) 2015年 周文超. All rights reserved.
//

#import "MyViewTableViewCell.h"
#import "BaseViewController.h"
#import "API.h"
@implementation MyViewTableViewCell

- (void)awakeFromNib {
    // Initialization code
    
    self.label1.textColor = colorToString(@"#333333");
    self.label1.font = [UIFont systemFontOfSize:FONT_SIZE_17];
    self.label2.textColor = colorToString(@"#999999");
    
    self.label2.font =[UIFont systemFontOfSize:FONT_SIZE_14];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
