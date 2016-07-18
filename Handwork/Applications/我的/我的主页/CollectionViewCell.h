//
//  CollectionViewCell.h
//  Handwork
//
//  Created by ios on 15-5-4.
//  Copyright (c) 2015年 周文超. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CollectionViewCell : UICollectionViewCell
@property (strong, nonatomic) IBOutlet UILabel *l_money;
@property (strong, nonatomic) IBOutlet UIImageView *i_image;
@property(nonatomic ,strong)UIImageView *imgView;
@property(nonatomic ,strong)UIView *textBgView; // 热卖中的作品需要显示价格，增加一个半透明背景条
@property(nonatomic ,strong)UILabel *text;
@property(nonatomic ,strong)UIButton *btn;

@end
