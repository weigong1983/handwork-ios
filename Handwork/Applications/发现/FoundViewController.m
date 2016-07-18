//
//  FoundViewController.m
//  Handwork
//
//  Created by ios on 15-4-29.
//  Copyright (c) 2015年 周文超. All rights reserved.
//

#import "FoundViewController.h"
#import "FoundViewTableViewCell.h"
#import "InstituteViewController.h"
#import "WorksFangViewController.h"
#import "collectionViewController.h"
#import "ArtisansViewController.h"

#import "PersonalWorks.h"
@interface FoundViewController ()
{
    NSMutableArray* arrCell;
}
@property (strong, nonatomic) IBOutlet UITableView *myTableView;
@end

@implementation FoundViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    arrCell = [[NSMutableArray alloc]init];
}

#pragma mark UITabViewDataSource
-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //UILog(@"tableViewData :  %d",tableViewData.count);
    return 4;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier = @"Cell";
    FoundViewTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil)
    {
//      cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        NSArray * nibViews  =[[NSBundle mainBundle] loadNibNamed:@"FoundViewTableViewCell" owner:self options:nil] ;
        cell= [nibViews objectAtIndex:0];
    }
    NSString* s_img = [NSString stringWithFormat:@"发现 (%ld).jpg",(long)indexPath.row+1];
    [cell.image_bg setImage:[UIImage imageNamed:s_img]];

    
    [arrCell addObject:cell];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    FoundViewTableViewCell *cell = (FoundViewTableViewCell*)[self tableView:self.myTableView cellForRowAtIndexPath:indexPath];

    // 适配屏幕
    if (IS_IPHONE_6P) {
        return cell.frame.size.height + 40;
    }
    else if (IS_IPHONE_6)
    {
        return cell.frame.size.height + 20;
    }
    else
    {
        return cell.frame.size.height;
    }
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UILog(@"%ld",(long)indexPath.row);
    if (indexPath.row==0) {
        WorksFangViewController* vc = [[WorksFangViewController alloc]init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
    if (indexPath.row==1) {
        ArtisansViewController* vc = [[ArtisansViewController alloc]init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
    if (indexPath.row==2)
    {
        collectionViewController* vc = [[collectionViewController alloc]init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
    if (indexPath.row==3) {
        InstituteViewController* vc= [[InstituteViewController alloc]init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
