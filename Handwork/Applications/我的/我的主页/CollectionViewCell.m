//
//  CollectionViewCell.m
//  Handwork
//
//  Created by ios on 15-5-4.
//  Copyright (c) 2015年 周文超. All rights reserved.
//

#import "CollectionViewCell.h"

@implementation CollectionViewCell

- (void)awakeFromNib {
    // Initialization code
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor whiteColor];
        
        self.imgView = [[UIImageView alloc]initWithFrame:CGRectMake(0,0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame))];
        //self.imgView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        [self addSubview:self.imgView];
        
        // 文字背景
        self.textBgView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.imgView.frame)-20, CGRectGetWidth(self.frame),20)];
        self.textBgView.alpha = 0.5f;
        self.textBgView.backgroundColor = [UIColor blackColor];
        [self addSubview:self.textBgView];

        self.text = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.imgView.frame)-20, CGRectGetWidth(self.frame)-10,20)];
        self.text.textColor = [UIColor whiteColor];
        self.text.textAlignment = NSTextAlignmentRight;
       
        [self addSubview:self.text];
        
//        self.btn = [UIButton buttonWithType:UIButtonTypeCustom];
//        self.btn.frame = CGRectMake(5, CGRectGetMaxY(self.text.frame), CGRectGetWidth(self.frame)-10,30);
//        [self.btn setTitle:@"按钮" forState:UIControlStateNormal];
//        self.btn.backgroundColor = [UIColor orangeColor];
//        [self addSubview:self.btn];
    }
    return self;
}@end
