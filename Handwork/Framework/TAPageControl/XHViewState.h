#import <UIKit/UIKit.h>

@interface XHViewState : UIView

@property (nonatomic, strong) UIView *superview;
@property (nonatomic, assign) CGRect frame;
@property (nonatomic, assign) BOOL userInteratctionEnabled;
@property (nonatomic, assign) CGAffineTransform transform;

+ (XHViewState *)viewStateForView:(UIView *)view;
- (void)setStateWithView:(UIView *)view;

@end
