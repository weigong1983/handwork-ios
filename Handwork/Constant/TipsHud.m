//
//  TipsHud.m
//  HudDemo
//
//  Created by BO on 13-1-8.
//
//

#import "TipsHud.h"
#import <QuartzCore/QuartzCore.h>
TipsHud *shareTipsHud;


@interface TipsHud () {
    CGPoint zeroPoint;
}
- (void)hideUsingAnimation:(BOOL)animated;
- (void)showUsingAnimation:(BOOL)animated;
- (void)done;
- (void)updateLabelText:(NSString *)newText;
//- (void)updateDetailsLabelText:(NSString *)newText;
//- (void)updateProgress;
//- (void)updateIndicators;
- (void)handleGraceTimer:(NSTimer *)theTimer;
- (void)handleMinShowTimer:(NSTimer *)theTimer;
- (void)setTransformForCurrentOrientation:(BOOL)animated;
//- (void)cleanUp;
//- (void)launchExecution;
- (void)deviceOrientationDidChange:(NSNotification *)notification;
- (void)hideDelayed:(NSNumber *)animated;


@property (retain,nonatomic ) UIView *indicator;
@property (retain,nonatomic) NSTimer *graceTimer;
@property (retain,nonatomic ) NSTimer *minShowTimer;
@property (retain,nonatomic) NSDate *showStarted;


@property (assign) float width;
@property (assign) float height;

@end


@implementation TipsHud


#pragma mark -
#pragma mark Accessors

@synthesize opacity;
@synthesize labelFont;


@synthesize indicator;

@synthesize width;
@synthesize height;
@synthesize xOffset;
@synthesize yOffset;
@synthesize minSize;

@synthesize margin;


@synthesize graceTime;
@synthesize minShowTime;
@synthesize graceTimer;
@synthesize minShowTimer;

@synthesize removeFromSuperViewOnHide;



@synthesize showStarted,labelText;


+(void)ShowTipsHud:(NSString *) tips :(UIView *)superView{
    if(shareTipsHud == nil) {
        shareTipsHud =[[TipsHud alloc] initWithView:superView];
        [shareTipsHud retain];
    }
    NSMutableArray * params = [NSMutableArray arrayWithObjects:tips, superView,nil];
    [shareTipsHud performSelectorOnMainThread:@selector(showTips:) withObject:params waitUntilDone:YES];
}

-(void)showTips:(NSMutableArray *)params{
    UIView *superView = params[1];
    NSString *tips =params[0];
    
    [shareTipsHud removeFromSuperview];
    [superView addSubview:shareTipsHud];
    
    shareTipsHud.frame = CGRectMake(superView.frame.size.width/2, superView.frame.size.height/2, 0, 0);
    [shareTipsHud show:YES];
    [shareTipsHud setLabelText:tips];
    [shareTipsHud hide:YES afterDelay:1];
}

- (void)setLabelText:(NSString *)newText
{
	if ([NSThread isMainThread]) {
		[self updateLabelText:newText];
		[self setNeedsLayout];
		[self setNeedsDisplay];
	} else {
		[self performSelectorOnMainThread:@selector(updateLabelText:) withObject:newText waitUntilDone:NO];
		[self performSelectorOnMainThread:@selector(setNeedsLayout) withObject:nil waitUntilDone:NO];
		[self performSelectorOnMainThread:@selector(setNeedsDisplay) withObject:nil waitUntilDone:NO];
	}
}


#pragma mark -
#pragma mark Accessor helpers

- (void)updateLabelText:(NSString *)newText {
    if (labelText != nil) {
        [labelText release];
    }
    labelText = newText;
    [labelText retain];
}



#pragma mark -
#pragma mark Constants

#define PADDING 30.0f
#define MARGIN  30.0f

#define LABELFONTSIZE 14.0f




#pragma mark -
#pragma mark Lifecycle methods

- (id)initWithWindow:(UIWindow *)window {
    return [self initWithView:window];
}

- (id)initWithView:(UIView *)view {
	// Let's check if the view is nil (this is a common error when using the windw initializer above)
	if (!view) {
		[NSException raise:@"TipsHubViewIsNillException"
					format:@"The view used in the TipsHubView initializer is nil."];
	}
    
	id me = [self initWithFrame:view.bounds];
	// We need to take care of rotation ourselfs if we're adding the HUD to a window
	if ([view isKindOfClass:[UIWindow class]]) {
		[self setTransformForCurrentOrientation:NO];
	}
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deviceOrientationDidChange:)
												 name:UIDeviceOrientationDidChangeNotification object:nil];
	
	return me;
}

- (void)removeFromSuperview {
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIDeviceOrientationDidChangeNotification
                                                  object:nil];
    [super removeFromSuperview];
    
    
}


- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
	if (self) {
        // Set default values for properties
        self.labelText = nil;
        self.opacity = 0.7f;
        self.labelFont = [UIFont boldSystemFontOfSize:LABELFONTSIZE];
        self.xOffset = 0.0f;
        self.yOffset = 0.0f;
		self.margin = MARGIN;
		self.graceTime = 0.0f;
		self.minShowTime = 0.0f;
		self.removeFromSuperViewOnHide = YES;
		self.minSize = CGSizeZero;
		
		self.autoresizingMask =UIViewAutoresizingNone;
        // Transparent background
        self.opaque = NO;
        self.backgroundColor = [UIColor clearColor];
		
        // Make invisible for now
        self.alpha = 0.0f;
		
        // Add label
        label = [[UILabel alloc] initWithFrame:self.bounds];
		
		rotationTransform = CGAffineTransformIdentity;
    }
    return self;
}

#if !__has_feature(objc_arc)
- (void)dealloc {
    [indicator release];
    [label release];
    [labelText release];
	[graceTimer release];
	[minShowTimer release];
	[showStarted release];
    [super dealloc];
}
#endif

#pragma mark -
#pragma mark Layout

- (void)layoutSubviews {
	
    // Add label if label text was set
    if (nil != self.labelText) {
        // Get size of label text
        CGSize dims = [self.labelText sizeWithFont:self.labelFont];
		
        // Compute label dimensions based on font metrics if size is larger than max then clip the label width
        float lHeight = dims.height;
        float lWidth;
        lWidth = dims.width;
        // Set label properties
        label.font = self.labelFont;
        label.adjustsFontSizeToFitWidth = NO;
        label.textAlignment = NSTextAlignmentCenter;
        label.opaque = NO;
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor whiteColor];
        label.text = self.labelText;
		
        
        self.width = lWidth + 2 * margin;
        
        self.height =  lHeight + PADDING;
		
		
        // Set the label position and dimensions
        CGRect lFrame = CGRectMake(self.margin,PADDING/2,
                                   lWidth, lHeight);
        label.frame = lFrame;
       
    
		
        [self addSubview:label];
		

    }
	
	if (self.width < minSize.width) {
		self.width = minSize.width;
	}
	if (self.height < minSize.height) {
		self.height = minSize.height;
	}
    
    if(self.superview!=nil) {
        self.frame =CGRectMake(self.superview.frame.size.width/2-self.width/2, self.superview.frame.size.height/2-self.height/2, self.width, self.height);
    }
}

#pragma mark -
#pragma mark Showing and execution

- (void)show:(BOOL)animated {
	useAnimation = animated;
	
	// If the grace time is set postpone the HUD display
	if (self.graceTime > 0.0) {
		self.graceTimer = [NSTimer scheduledTimerWithTimeInterval:self.graceTime
														   target:self
														 selector:@selector(handleGraceTimer:)
														 userInfo:nil
														  repeats:NO];
	}
	// ... otherwise show the HUD imediately
	else {
		[self setNeedsDisplay];
		[self showUsingAnimation:useAnimation];
	}
}

- (void)hide:(BOOL)animated {
	useAnimation = animated;
	
	// If the minShow time is set, calculate how long the hud was shown,
	// and pospone the hiding operation if necessary
	if (self.minShowTime > 0.0 && showStarted) {
		NSTimeInterval interv = [[NSDate date] timeIntervalSinceDate:showStarted];
		if (interv < self.minShowTime) {
			self.minShowTimer = [NSTimer scheduledTimerWithTimeInterval:(self.minShowTime - interv)
																 target:self
															   selector:@selector(handleMinShowTimer:)
															   userInfo:nil
																repeats:NO];
			return;
		}
	}
	
	// ... otherwise hide the HUD immediately
    [self hideUsingAnimation:useAnimation];
}

- (void)hide:(BOOL)animated afterDelay:(NSTimeInterval)delay {
	[self performSelector:@selector(hideDelayed:) withObject:[NSNumber numberWithBool:animated] afterDelay:delay];
}

- (void)hideDelayed:(NSNumber *)animated {
	[self hide:[animated boolValue]];
}

- (void)handleGraceTimer:(NSTimer *)theTimer {
	// Show the HUD only if the task is still running
}

- (void)handleMinShowTimer:(NSTimer *)theTimer {
	[self hideUsingAnimation:useAnimation];
}


- (void)animationFinished:(NSString *)animationID finished:(BOOL)finished context:(void*)context {
    if([animationID isEqualToString:@"end"]){
        [self done];
    }
    
}

- (void)done {
    isFinished = YES;
	
    // If delegate was set make the callback
    self.alpha = 0.0f;
    
	if (removeFromSuperViewOnHide && self.layer.animationKeys.count==0) {
		[self removeFromSuperview];
	}
}


#pragma mark -
#pragma mark Fade in and Fade out

- (void)showUsingAnimation:(BOOL)animated {
    self.alpha = 0.0f;
    
	self.showStarted = [NSDate date];
    // Fade in
    [self.layer removeAllAnimations];
    if (animated) {
        [UIView beginAnimations:@"start" context:NULL];
        [UIView setAnimationDuration:0.30];
        self.alpha = 1.0f;
        [UIView commitAnimations];
    }
    else {
        self.alpha = 1.0f;
    }
}

- (void)hideUsingAnimation:(BOOL)animated {
    // Fade out
    if (animated) {
        [UIView beginAnimations:@"end" context:NULL];
        [UIView setAnimationDuration:0.80];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDidStopSelector:@selector(animationFinished: finished: context:)];
        
        // 0.02 prevents the hud from passing through touches during the animation the hud will get completely hidden
        // in the done method
        self.alpha = 0.02f;
        [UIView commitAnimations];
    }
    else {
        self.alpha = 0.0f;
        [self done];
    }
}

#pragma mark BG Drawing

- (void)drawRect:(CGRect)rect {
	
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // Draw rounded HUD bacgroud rect
    CGRect boxRect = CGRectMake(0,
                      0, self.width, self.height);

	// Corner radius
	float radius = 6.0f;
	
    CGContextBeginPath(context);
    CGContextSetGrayFillColor(context, 0.0f, self.opacity);
    CGContextMoveToPoint(context, CGRectGetMinX(boxRect) + radius, CGRectGetMinY(boxRect));
    CGContextAddArc(context, CGRectGetMaxX(boxRect) - radius, CGRectGetMinY(boxRect) + radius, radius, 3 * (float)M_PI / 2, 0, 0);
    CGContextAddArc(context, CGRectGetMaxX(boxRect) - radius, CGRectGetMaxY(boxRect) - radius, radius, 0, (float)M_PI / 2, 0);
    CGContextAddArc(context, CGRectGetMinX(boxRect) + radius, CGRectGetMaxY(boxRect) - radius, radius, (float)M_PI / 2, (float)M_PI, 0);
    CGContextAddArc(context, CGRectGetMinX(boxRect) + radius, CGRectGetMinY(boxRect) + radius, radius, (float)M_PI, 3 * (float)M_PI / 2, 0);
    CGContextClosePath(context);
    CGContextFillPath(context);
}

#pragma mark -
#pragma mark Manual oritentation change

#define RADIANS(degrees) ((degrees * (float)M_PI) / 180.0f)

- (void)deviceOrientationDidChange:(NSNotification *)notification {
	if (!self.superview) {
		return;
	}
	
	if ([self.superview isKindOfClass:[UIWindow class]]) {
		[self setTransformForCurrentOrientation:YES];
	} else {
		self.bounds = self.superview.bounds;
		[self setNeedsDisplay];
	}
}

- (void)setTransformForCurrentOrientation:(BOOL)animated {
	UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
	NSInteger degrees = 0;
	
	// Stay in sync with the superview
	if (self.superview) {
		self.bounds = self.superview.bounds;
		[self setNeedsDisplay];
	}
	
	if (UIInterfaceOrientationIsLandscape(orientation)) {
		if (orientation == UIInterfaceOrientationLandscapeLeft) { degrees = -90; }
		else { degrees = 90; }
		// Window coordinates differ!
		self.bounds = CGRectMake(0, 0, self.bounds.size.height, self.bounds.size.width);
	} else {
		if (orientation == UIInterfaceOrientationPortraitUpsideDown) { degrees = 180; }
		else { degrees = 0; }
	}
	
	rotationTransform = CGAffineTransformMakeRotation(RADIANS(degrees));
    
	if (animated) {
		[UIView beginAnimations:nil context:nil];
	}
	[self setTransform:rotationTransform];
	if (animated) {
		[UIView commitAnimations];
	}
}



@end
