//
//  ArtisansTableViewCell.h
//  Handwork
//
//  Created by ios on 15-5-5.
//  Copyright (c) 2015年 周文超. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ArtisansTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *headImage;
@property (strong, nonatomic) IBOutlet UILabel *namelabel;
@property (strong, nonatomic) IBOutlet UILabel *label1;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIButton *workDetails_btn;
@property (strong, nonatomic) IBOutlet UIImageView *img_certification;
@property (strong, nonatomic) NSMutableArray* buttons;
@end
