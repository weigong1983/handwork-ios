//
//  AdvertisingColumn.m
//  Handwork
//
//  Created by ios on 15-5-5.
//  Copyright (c) 2015年 周文超. All rights reserved.
//

#import "AdvertisingColumn.h"
#import "TAPageControl.h"
#import "UIImageView+WebCache.h"
@implementation AdvertisingColumn

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame))];
        _scrollView.backgroundColor = [UIColor whiteColor];
        _scrollView.delegate = self;//设置代理UIscrollViewDelegate
        _scrollView.showsVerticalScrollIndicator = NO;//是否显示竖向滚动条
        _scrollView.showsHorizontalScrollIndicator = NO;//是否显示横向滚动条
        _scrollView.pagingEnabled = YES;//是否设置分页
        
        [self addSubview:_scrollView];
        
       UITapGestureRecognizer* tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleTap:)];
        [_scrollView addGestureRecognizer:tap];
        
        /*
         ***容器，装载
         */
        UIView *containerView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetHeight(self.frame)-20, CGRectGetWidth(self.frame), 20)];
        containerView.backgroundColor = [UIColor clearColor];
        [self addSubview:containerView];
        
//        UIView *alphaView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(containerView.frame), CGRectGetHeight(containerView.frame))];
//        alphaView.backgroundColor = [UIColor orangeColor];
//        alphaView.alpha = 0.7;
//        [containerView addSubview:alphaView];
        
        //分页控制
        _pageControl = [[TAPageControl alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_scrollView.frame) - 40, CGRectGetWidth(_scrollView.frame), 40)];
        
        _pageControl.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;//貌似不起作用呢
        _pageControl.currentPage = 0; //初始页码为0
    
        
        
        
        //    _pageControl.backgroundColor  = [UIColor greenColor];
        [self addSubview:_pageControl];
        //图片张数
//        _imageNum = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, CGRectGetWidth(containerView.frame)-20, 20)];
//        _imageNum.font = [UIFont boldSystemFontOfSize:15];
//        _imageNum.backgroundColor = [UIColor clearColor];
//        _imageNum.textColor = [UIColor whiteColor];
//        _imageNum.textAlignment = NSTextAlignmentRight;
        //[containerView addSubview:_imageNum];
        /*
         ***配置定时器，自动滚动广告栏
         */
        _timer = [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(timerAction:) userInfo:nil repeats:YES];
        [[NSRunLoop  currentRunLoop] addTimer:_timer forMode:NSDefaultRunLoopMode];
        [_timer setFireDate:[NSDate distantFuture]];//关闭定时器
    }
    return self;
}


-(void)timerAction:(NSTimer *)timer{
    if (_totalNum>1) {
        CGPoint newOffset = _scrollView.contentOffset;
        newOffset.x = newOffset.x + CGRectGetWidth(_scrollView.frame);
        //    NSLog(@"newOffset.x = %f",newOffset.x);
        if (newOffset.x > (CGRectGetWidth(_scrollView.frame) * (_totalNum-1))) {
            newOffset.x = 0 ;
        }
        int index = newOffset.x / CGRectGetWidth(_scrollView.frame);   //当前是第几个视图
        newOffset.x = index * CGRectGetWidth(_scrollView.frame);
        _imageNum.text = [NSString stringWithFormat:@"%d / %ld",index+1,(long)_totalNum];
        [_scrollView setContentOffset:newOffset animated:YES];
    }else{
        [_timer setFireDate:[NSDate distantFuture]];//关闭定时器
    }
}

#pragma mark- PageControl绑定ScrollView
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{//滚动就执行（会很多次）
    if ([scrollView isMemberOfClass:[UITableView class]]) {
        
    }else {
        int index = fabs(scrollView.contentOffset.x) / scrollView.frame.size.width;   //当前是第几个视图
        _pageControl.currentPage = index;
        for (UIView *view in scrollView.subviews) {
            if(view.tag == index){
                
            }else{
                
            }
        }
    }
    //    NSLog(@"string%f",scrollView.contentOffset.x);
}
- (void)setArray:(NSArray *)imgArray{
    
    _totalNum = [imgArray count];
    if (_totalNum>0) {
        
        self.ImageArr = [[NSMutableArray alloc]initWithCapacity:imgArray.count];
        for (int i = 0; i<_totalNum; i++) {
            UIImageView *img = [[UIImageView alloc]initWithFrame:CGRectMake(i*CGRectGetWidth(_scrollView.frame), 0, CGRectGetWidth(_scrollView.frame), CGRectGetHeight(_scrollView.frame) - PADDING_BOTTOM)];
            img.contentMode = UIViewContentModeScaleAspectFill;
            img.image = [UIImage imageNamed:imgArray[i]];
            //关键步骤 设置可变化背景view属性
//            img.autoresizingMask = UIViewAutoresizingFlexibleHeight| UIViewAutoresizingFlexibleWidth;
//            img.clipsToBounds = YES;
//            img.contentMode = UIViewContentModeScaleAspectFill;
            
            //UIImage imageWithImage:<#(UIImage *)#> scaledToSize:<#(CGSize)#>
            
            [img setImageWithURL:[NSURL URLWithString:imgArray[i]] placeholderImage:[UIImage imageNamed:@"默认.jpg"]];
            [img setContentScaleFactor:[[UIScreen mainScreen] scale]];
            
            img.contentMode =  UIViewContentModeScaleAspectFill;
            
            img.clipsToBounds  = YES;
            //img.backgroundColor = imgArray[i];
            [img setTag:i];
            [_scrollView addSubview:img];
            [self.ImageArr addObject:img];
        }
        //_imageNum.text = [NSString stringWithFormat:@"%ld / %ld",_pageControl.currentPage+1,(long)_totalNum];
        if (imgArray.count<=1) {
            self.pageControl.alpha = 0;
        }
        else
        {
            self.pageControl.alpha = 1;
        }
        _pageControl.numberOfPages = _totalNum; //设置页数 //滚动范围 600=300*2，分2页
        CGRect frame;
        frame = _pageControl.frame;
        frame.size.width = 15*_totalNum;
        _pageControl.frame = frame;
    }else{
        UIImageView *img = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(_scrollView.frame), CGRectGetHeight(_scrollView.frame))];
        [img setImage:[UIImage imageNamed:@"默认.jpg"]];
        
//        _headerView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"默认.jpg"]];
        img.userInteractionEnabled = YES;
        
        [img setContentScaleFactor:[[UIScreen mainScreen] scale]];
        
        img.contentMode =  UIViewContentModeScaleToFill;
        
        img.clipsToBounds  = YES;
        
        [_scrollView addSubview:img];
        _imageNum.text = @"提示：滚动栏无数据。";
    }
    _scrollView.contentSize = CGSizeMake(CGRectGetWidth(_scrollView.frame)*_totalNum,CGRectGetHeight(_scrollView.frame));//滚动范围 600=300*2，分2页
}


- (void)openTimer{
    [_timer setFireDate:[NSDate distantPast]];//开启定时器
}
- (void)closeTimer{
    [_timer setFireDate:[NSDate distantFuture]];//关闭定时器
}


#pragma protocol

- (void)handleTap:(UITapGestureRecognizer *)tap {
    
    if ([_delegate respondsToSelector:@selector(didClickPage:atIndex:)]) {
        [_delegate didClickPage:self atIndex:_pageControl.currentPage];
    }
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
