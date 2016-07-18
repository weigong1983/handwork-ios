//
//  HZAreaPickerView.h
//  areapicker
//
//  Created by Cloud Dai on 12-9-9.
//  Copyright (c) 2012年 clouddai.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HZLocation.h"
#import "BaseViewController.h"
typedef enum {
    HZAreaPickerWithStateAndCity,
    HZAreaPickerWithStateAndCityAndDistrict
} HZAreaPickerStyle;

@class HZAreaPickerView;

@protocol HZAreaPickerDelegate <NSObject>

@optional
- (void)pickerDidChaneStatus:(HZAreaPickerView *)picker;

@end

@interface HZAreaPickerView : UIView <UIPickerViewDelegate, UIPickerViewDataSource>
@property (strong, nonatomic) IBOutlet UIButton *ok_btn;
@property (strong, nonatomic) IBOutlet UIButton *can_btn;

@property (assign, nonatomic) NSInteger row;
@property (assign, nonatomic) NSInteger component;

@property (assign, nonatomic) id <HZAreaPickerDelegate> delegate;
@property (strong, nonatomic) IBOutlet UIPickerView *locatePicker;
@property (strong, nonatomic) HZLocation *locate;
@property (strong, nonatomic) NSMutableArray *dataArr;
@property (strong, nonatomic) NSMutableArray *provinces;
@property (strong, nonatomic) NSMutableArray *cities;
@property (strong, nonatomic) NSMutableArray *areas;

@property (nonatomic) HZAreaPickerStyle pickerStyle;

- (id)initWithStyle:(HZAreaPickerStyle)pickerStyle delegate:(id <HZAreaPickerDelegate>)delegate data:(NSMutableArray*)data;
- (void)showInView:(UIView *)view;
- (void)cancelPicker;

@end
