#import <UIKit/UIKit.h>

@interface XHZoomingImageView : UIView

@property (nonatomic, readonly) UIScrollView *scrollView;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, readonly) BOOL isViewing;

@end
