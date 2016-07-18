//
//  AdvertisingColumn.h
//  Handwork
//
//  Created by ios on 15-5-5.
//  Copyright (c) 2015年 周文超. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "TAPageControl.h"

// 广告条和下方作品列表之间的间距
#define PADDING_BOTTOM  4

@protocol AdvertisingColumnDelegate;

@interface AdvertisingColumn : UIView<UIScrollViewDelegate>{
    NSTimer *_timer;
    id <AdvertisingColumnDelegate>  _delegate;
}

//广告栏
@property (nonatomic,strong) UIScrollView *scrollView;
@property (nonatomic,strong) TAPageControl *pageControl;
@property (nonatomic,strong) UILabel *imageNum;
@property (nonatomic) NSInteger totalNum;
@property (nonatomic,strong) NSMutableArray* ImageArr;
@property (nonatomic,strong) id<AdvertisingColumnDelegate> delegate;
- (void)setArray:(NSArray *)imgArray;

- (void)openTimer;
- (void)closeTimer;
@end

@protocol AdvertisingColumnDelegate <NSObject>

@optional
- (void)didClickPage:(AdvertisingColumn *)view atIndex:(NSInteger)index;

@end