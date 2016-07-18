//
//  ArtisansTableViewCell.m
//  Handwork
//
//  Created by ios on 15-5-5.
//  Copyright (c) 2015年 周文超. All rights reserved.
//

#import "ArtisansTableViewCell.h"
#import "BaseViewController.h"
@implementation ArtisansTableViewCell

- (void)awakeFromNib {
    // Initialization code
    
    self.headImage.layer.masksToBounds = YES;
    self.headImage.layer.cornerRadius = self.headImage.width/2;
    
    self.namelabel.textColor = colorToString(@"#333333");
    self.label1.textColor = colorToString(@"#666666");
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
