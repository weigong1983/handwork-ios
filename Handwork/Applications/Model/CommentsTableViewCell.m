//
//  CommentsTableViewCell.m
//  Handwork
//
//  Created by apple on 15-5-8.
//  Copyright (c) 2015年 周文超. All rights reserved.
//

#import "CommentsTableViewCell.h"
#import "BaseViewController.h"
@implementation CommentsTableViewCell

- (void)awakeFromNib {
    // Initialization code
    
    self.headView.layer.masksToBounds = YES;
    self.headView.layer.cornerRadius = 30;
    self.usernamelabel.textColor = colorToString(@"#333333");
    self.contentlabel.textColor = colorToString(@"#666666");
    self.timelabel.textColor = colorToString(@"#999999");
    
    self.line_v.backgroundColor = RGB_MAKE(240, 240, 240);
    [self.line_v setTop:self.height-1];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
