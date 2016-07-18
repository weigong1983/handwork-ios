//
//  HZAreaPickerView.m
//  areapicker
//
//  Created by Cloud Dai on 12-9-9.
//  Copyright (c) 2012年 clouddai.com. All rights reserved.
//

#import "HZAreaPickerView.h"
#import <QuartzCore/QuartzCore.h>

#define kDuration 0.3

@interface HZAreaPickerView ()
{
    NSMutableArray *provinces, *cities, *areas;
}

@end

@implementation HZAreaPickerView

@synthesize delegate=_delegate;
@synthesize pickerStyle=_pickerStyle;
@synthesize locate=_locate;
@synthesize locatePicker = _locatePicker;
@synthesize provinces,cities,areas;
//- (void)dealloc
//{
//    [_locate release];
//    [_locatePicker release];
//    [provinces release];
//    [super dealloc];
//}

-(HZLocation *)locate
{
    if (_locate == nil) {
        _locate = [[HZLocation alloc] init];
    }
    
    return _locate;
}

- (id)initWithStyle:(HZAreaPickerStyle)pickerStyle delegate:(id<HZAreaPickerDelegate>)delegate data:(NSMutableArray*)data
{
    
//    self = [[[[NSBundle mainBundle] loadNibNamed:@"HZAreaPickerView" owner:self options:nil] objectAtIndex:0] retain];
     self = [[[NSBundle mainBundle] loadNibNamed:@"HZAreaPickerView" owner:self options:nil] objectAtIndex:0];
    if (self) {
        self.delegate = delegate;
        self.pickerStyle = pickerStyle;
        self.locatePicker.dataSource = self;
        self.locatePicker.delegate = self;
        
        //加载数据
        if (self.pickerStyle == HZAreaPickerWithStateAndCityAndDistrict) {
            
            provinces = [[NSMutableArray alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"area.plist" ofType:nil]];
            
            cities = [[provinces objectAtIndex:0] objectForKey:@"cities"];
            
//            self.locate.state = [[provinces objectAtIndex:0] objectForKey:@"state"];
//            
//            self.locate.city = [[cities objectAtIndex:0] objectForKey:@"city"];
            
            areas = [[cities objectAtIndex:0] objectForKey:@"areas"];
            if (areas.count > 0){
                self.locate.district = [areas objectAtIndex:0];
            } else{
                self.locate.district = @"";
            }
            
//            self.arr_provinces = [[NSMutableArray alloc]init];
//            for ( int i = 0; i<provinces.count; i++) {
//                //UILog(@"provinces %@",[[provinces objectAtIndex:i] objectForKey:@"state"]);
//                [self.arr_provinces addObject:[[provinces objectAtIndex:i] objectForKey:@"state"]];
//            }
//            self.arr_cities = [[NSMutableArray alloc]init];
//            
//            //UILog(@"self.arr_cities %@",self.arr_cities);
//            
//            for (int i=0; i<cities.count; i++) {
//               // UILog(@"cities %@",);
//                [self.arr_cities addObject:[[cities objectAtIndex:i] objectForKey:@"city"]];
//            }
            
        } else if(self.pickerStyle == HZAreaPickerWithStateAndCity){
            provinces = [[NSMutableArray alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"city.plist" ofType:nil]];
            cities = [[provinces objectAtIndex:0] objectForKey:@"cities"];
//            self.locate.state = [[provinces objectAtIndex:0] objectForKey:@"state"];
//            self.locate.city = [cities objectAtIndex:0];
        }
        else
        {
            //self.dataArr =data;
            
            provinces = data;
            //self.locate = nil;
//            self.locate.state = [provinces objectAtIndex:0];
//            self.locate.city = [provinces objectAtIndex:0];
//            for (int i=0; i<provinces.count; i++){
//                
//                UILog(@"%@",[provinces objectAtIndex:i]);
//                
//            }
            //self.locate.city = [cities objectAtIndex:0];
        }
    }
        
    return self;
    
}

//- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
//{
//    if(component==0)
//    {
//        //第一列返回一个Label组件
//        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 75, 32)];
//        label.backgroundColor = [UIColor grayColor];
//        label.textColor = [UIColor redColor];
//        label.text = @"First";
//        return label;
//    }
//    else
//    {
//        //第二列返回一个图片组件
//        if(row==0)
//        {
//            return [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Orange.gif"]];
//        }
//        else
//        {
//            return [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Strawberry.gif"]];
//        }
//    }
//}

#pragma mark - PickerView lifecycle

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    if (self.pickerStyle == HZAreaPickerWithStateAndCityAndDistrict) {
        return 3;
    } else if(self.pickerStyle == HZAreaPickerWithStateAndCity){
        return 2;
    }
    else
    {
        return 1;
    }
    
    
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    switch (component) {
        case 0:
            return [provinces count];
            break;
        case 1:
            
            return [cities count];
            break;
        case 2:
            if (self.pickerStyle == HZAreaPickerWithStateAndCityAndDistrict) {
                return [areas count];
                break;
            }
        default:
            return 0;
            break;
    }
    //UILog(@"provinces %d",provinces.count);
}

//确定每个轮子的每一项显示什么内容
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (self.pickerStyle == HZAreaPickerWithStateAndCityAndDistrict) {
        switch (component) {
            case 0:
                return [[provinces objectAtIndex:row] objectForKey:@"state"];
                
                break;
            case 1:
                
                return [[cities objectAtIndex:row] objectForKey:@"city"];
                
                break;
            case 2:
                if ([areas count] > 0)
                {
                   
                    return [areas objectAtIndex:row];
                    break;
                }
            default:
                return  @"";
                break;
        }
    } else if(self.pickerStyle == HZAreaPickerWithStateAndCity){
        switch (component) {
            case 0:
                //UILog(@"state --> %@",[[provinces objectAtIndex:row] objectForKey:@"state"]);
                return [[provinces objectAtIndex:row] objectForKey:@"state"];
                
                break;
            case 1:
                return [cities objectAtIndex:row];
                break;
            default:
                return @"";
                break;
        }
    }
    else
    {
        
        switch (component){
            case 0:
                return [provinces objectAtIndex:row];
                break;
            default:
                return @"";
                break;
        }
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (self.pickerStyle == HZAreaPickerWithStateAndCityAndDistrict)
    {
        
        switch (component)
        {
            case 0:
                cities = [[provinces objectAtIndex:row] objectForKey:@"cities"];
                [self.locatePicker selectRow:0 inComponent:1 animated:YES];
                [self.locatePicker reloadComponent:1];
                
                areas = [[cities objectAtIndex:0] objectForKey:@"areas"];
                [self.locatePicker selectRow:0 inComponent:2 animated:YES];
                [self.locatePicker reloadComponent:2];
                
                self.locate.state = [[provinces objectAtIndex:row] objectForKey:@"state"];
                self.locate.city = [[cities objectAtIndex:0] objectForKey:@"city"];
                
                
                if ([areas count] > 0) {
                    self.locate.district = [areas objectAtIndex:0];
                } else{
                    self.locate.district = @"";
                }
                //UILog(@"self.locate.state %@   self.locate.city  %@ self.locate.district %@",self.locate.state,self.locate.city,self.locate.district);
                 //[self.locatePicker selectRow:row  inComponent:component animated:NO];
                //[dic setObject:row forKey:component];
        
                break;
            case 1:
        
                areas = [[cities objectAtIndex:row] objectForKey:@"areas"];
                [self.locatePicker selectRow:0 inComponent:2 animated:YES];
                [self.locatePicker reloadComponent:2];
                
                self.locate.city = [[cities objectAtIndex:row] objectForKey:@"city"];
                if ([areas count] > 0) {
                    self.locate.district = [areas objectAtIndex:0];
                } else{
                    self.locate.district = @"";
                }
         
                break;
            case 2:
         
                if ([areas count] > 0) {
                    self.locate.district = [areas objectAtIndex:row];
                } else{
                    self.locate.district = @"";
                }
         
                break;
            default:
                break;
                
                
        }
        
    } else if(self.pickerStyle == HZAreaPickerWithStateAndCity){
        switch (component) {
            case 0:
                cities = [[provinces objectAtIndex:row] objectForKey:@"cities"];
                [self.locatePicker selectRow:0 inComponent:1 animated:YES];
                [self.locatePicker reloadComponent:1];
                
                self.locate.state = [[provinces objectAtIndex:row] objectForKey:@"state"];
                self.locate.city = [cities objectAtIndex:0];
                break;
            case 1:
                self.locate.city = [cities objectAtIndex:row];
                break;
            default:
                break;
        }
    }
    
    else{
        //NSInteger selectedProvinceIndex = [self.locatePicker selectedRowInComponent:0];
        
        //NSString *seletedProvince = [self.dataArr objectAtIndex:selectedProvinceIndex];
        switch (component) {
            case 0:
                //cities = [provinces objectAtIndex:row];
                [self.locatePicker selectRow:row inComponent:0 animated:YES];
                [self.locatePicker reloadComponent:0];
                self.locate.city = [provinces objectAtIndex:row];
                //UILog(@"component--> %d",component);
                //UILog(@"row --> %d",row);
                break;
            default:
                break;
        }
        //NSString *seletedCity = [cities objectAtIndex:row];
        //NSString *msg = [NSString stringWithFormat:@",];
        //NSLog(@"cities %@",seletedCity);
    }
    
    
    self.component = component;
    self.row = row;
    
    if([self.delegate respondsToSelector:@selector(pickerDidChaneStatus:)]) {
        [self.delegate pickerDidChaneStatus:self];
    }
}


#pragma mark - animation

- (void)showInView:(UIView *) view
{
    // 宽度需要自适应手机屏幕宽度
    self.frame = CGRectMake(0, view.frame.size.height, _Screen_Width/*self.frame.size.width*/, self.frame.size.height);

    [view addSubview:self];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.frame = CGRectMake(0, view.frame.size.height - self.frame.size.height, self.frame.size.width, self.frame.size.height);
    }];
    
}

- (void)cancelPicker
{
    
    [UIView animateWithDuration:0.3
                     animations:^{
                         self.frame = CGRectMake(0, self.frame.origin.y+self.frame.size.height, self.frame.size.width, self.frame.size.height);
                     }
                     completion:^(BOOL finished){
                         [self removeFromSuperview];
                         
                     }];
    
}

@end
