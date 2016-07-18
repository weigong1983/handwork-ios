//
//  HomeTableViewCell.m
//  Handwork
//
//  Created by ios on 15-4-30.
//  Copyright (c) 2015年 周文超. All rights reserved.
//

#import "HomeTableViewCell.h"
#import "BaseViewController.h"
@implementation HomeTableViewCell

- (void)awakeFromNib {
    // Initialization code
    
    self.collectionView_bg.layer.masksToBounds = YES;
    self.collectionView_bg.layer.cornerRadius = 15;
    self.username_label.textColor = colorToString(@"#333333");
    self.productname_label.textColor = colorToString(@"#666666");
    self.headImage.layer.masksToBounds = YES;
    self.headImage.layer.cornerRadius = self.headImage.frame.size.width/2;
    
    self.praise_count.textColor = colorToString(@"#666666");
    self.comments_count.textColor = colorToString(@"#666666");
    
    self.line_v.backgroundColor = RGB_MAKE(240, 240, 240);
    [self.line_v setTop:self.height-1];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) [self setupImageView];
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) [self setupImageView];
    return self;
}

#pragma mark - Setup Method
- (void)setupImageView
{
    // Clip subviews
    self.clipsToBounds = YES;
    
    // Add image subview
    self.image_bg = [[UIImageView alloc] initWithFrame:CGRectMake(self.bounds.origin.x, self.bounds.origin.y, self.bounds.size.width, IMAGE_HEIGHT)];
    self.image_bg.backgroundColor = [UIColor clearColor];
    self.image_bg.contentMode = UIViewContentModeScaleAspectFill;
    self.image_bg.clipsToBounds = NO;
    [self addSubview:self.image_bg];
}
# pragma mark - Setters

- (void)setImage:(UIImage *)image
{
    // Store image
    self.image_bg.image = image;
    
    // Update padding
    [self setImageOffset:self.imageOffset];
}

- (void)setImageOffset:(CGPoint)imageOffset
{
    // Store padding value
    _imageOffset = imageOffset;
    
    // Grow image view
    CGRect frame = self.image_bg.bounds;
    CGRect offsetFrame = CGRectOffset(frame, _imageOffset.x, _imageOffset.y);
    self.image_bg.frame = offsetFrame;
    
}

@end
