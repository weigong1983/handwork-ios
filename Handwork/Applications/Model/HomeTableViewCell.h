//
//  HomeTableViewCell.h
//  Handwork
//
//  Created by ios on 15-4-30.
//  Copyright (c) 2015年 周文超. All rights reserved.
//

#import <UIKit/UIKit.h>

#define IMAGE_HEIGHT 295
#define IMAGE_OFFSET_SPEED 25


@interface HomeTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIView *collectionView_bg;
@property (strong, nonatomic) IBOutlet UIView *view2;
@property (strong, nonatomic) IBOutlet UIView *line_v;
@property (strong, nonatomic) IBOutlet UIButton *workDetails_btn;
@property (strong, nonatomic) IBOutlet UIImageView *certification_image;

@property (strong, nonatomic) IBOutlet UIImageView *image_bg;
@property (strong, nonatomic) IBOutlet UIButton *collection_btn;
@property (strong, nonatomic) IBOutlet UIImageView *headImage;
@property (strong, nonatomic) IBOutlet UILabel *username_label;
@property (strong, nonatomic) IBOutlet UILabel *productname_label;
@property (strong, nonatomic) IBOutlet UIButton *collection_small_btn;

@property (strong, nonatomic) IBOutlet UILabel *comments_count;
@property (strong, nonatomic) IBOutlet UIButton *browse_btn;
@property (strong, nonatomic) IBOutlet UILabel *praise_count;


/*
 
 image used in the cell which will be having the parallax effect
 
 */
@property (nonatomic, strong, readwrite) UIImage *image;

/*
 Image will always animate according to the imageOffset provided. Higher the value means higher offset for the image
 */
@property (nonatomic, assign, readwrite) CGPoint imageOffset;
@end
