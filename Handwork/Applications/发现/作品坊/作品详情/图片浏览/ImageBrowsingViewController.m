//
//  ImageBrowsingViewController.m
//  Handwork
//
//  Created by apple on 15-5-8.
//  Copyright (c) 2015年 周文超. All rights reserved.
//

#import "ImageBrowsingViewController.h"
#import "TAAbstractDotView.h"
#import "TAPageControl.h"

@interface ImageBrowsingViewController ()<TAPageControlDelegate>
@property (strong, nonatomic) IBOutlet UIScrollView *scroll;
@property (strong, nonatomic) TAPageControl *customStoryboardPageControl;
@property (strong, nonatomic) IBOutlet UIPageControl *pagecontro;
@property (strong, nonatomic) NSArray *imagesData;
@end

@implementation ImageBrowsingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationController setNavigationBarHidden:YES];
    if ([[[UIDevice currentDevice] systemVersion] floatValue]>=7.0) { // 判断是否是IOS7
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    }
    self.imagesData = [NSArray arrayWithObjects:@"", nil];
    
     [self setupScrollViewImages];
    NSString* str = [NSString stringWithFormat:@"%d/%d",self.current+1,self.imagesData.count];
    self.title = str;
    //分页控制
    _customStoryboardPageControl = [[TAPageControl alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.scroll.frame) - 60, CGRectGetWidth(self.scroll.frame), 40)];
    
    _customStoryboardPageControl.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;//貌似不_customStoryboardPageControl呢
    _customStoryboardPageControl.currentPage = self.current; //初始页码为0
    
    
//    for (int i=0; i<self.imagesData.count; i++) {
//        UIImageView* image = [[UIImageView alloc]init];
//        [image setImage:[UIImage imageNamed:[self.imagesData objectAtIndex:i]]];
//        image.frame = CGRectMake(i*_Screen_Width, 0, _Screen_Width, _Screen_Height);
//        [self.scroll addSubview:image];
//    }
//    
    //    _pageControl.backgroundColor  = [UIColor greenColor];
    [self.scroll addSubview:_customStoryboardPageControl];
    
    self.customStoryboardPageControl.numberOfPages = self.imagesData.count;
    [self.scroll setContentOffset:CGPointMake(_Screen_Width*self.current, 0)];
    [self.scroll setContentSize:CGSizeMake(_Screen_Width*self.imagesData.count, 0)];
    // Do any additional setup after loading the view from its nib.
}// Example of use of delegate for second scroll view to respond to bullet touch event

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSInteger page = scrollView.contentOffset.x/CGRectGetWidth(scrollView.frame);
    UILog(@"%d",page+1);
    NSString* str = [NSString stringWithFormat:@"%d/%d",page+1,self.imagesData.count];
    self.title = str;
    self.customStoryboardPageControl.currentPage = page;
    self.pagecontro.currentPage = page;
    
}

- (void)TAPageControl:(TAPageControl *)pageControl didSelectPageAtIndex:(NSInteger)index
{
    NSLog(@"Bullet index %ld", (long)index);
    [self.scroll scrollRectToVisible:CGRectMake(CGRectGetWidth(self.scroll.frame) * index, 0, CGRectGetWidth(self.scroll.frame), CGRectGetHeight(self.scroll.frame)) animated:YES];
}

- (void)setupScrollViewImages
{
    //    for (UIScrollView *scrollView in self.scroll)
    //    {
    //
    //    }
    
    [self.imagesData enumerateObjectsUsingBlock:^(NSString *imageName, NSUInteger idx, BOOL *stop) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(_Screen_Width * idx, 0, _Screen_Width, _Screen_Height)];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.image = [UIImage imageNamed:imageName];
        [self.scroll addSubview:imageView];
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
