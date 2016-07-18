#import <UIKit/UIKit.h>
@class XHImageViewer;
@protocol XHImageViewerDelegate <NSObject>

@optional
- (void)imageViewer:(XHImageViewer *)imageViewer  willDismissWithSelectedView:(UIImageView*)selectedView;

@end

@interface XHImageViewer : UIView

@property (nonatomic, weak) id<XHImageViewerDelegate> delegate;
@property (nonatomic, assign) CGFloat backgroundScale;
@property (nonatomic, strong) UIPageControl* pagecontrol;
- (void)showWithImageViews:(NSArray*)views selectedView:(UIImageView*)selectedView;
@end
