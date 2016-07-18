//
//  TipsHud.h
//  HudDemo
//
//  Created by BO on 13-1-8.
//
//

#import <UIKit/UIKit.h>

@interface TipsHud : UIView {

	
	BOOL useAnimation;
	
    float yOffset;
    float xOffset;
	
	float width;
	float height;
	
	CGSize minSize;
	
	float margin;
	
	
	float graceTime;
	float minShowTime;
	NSTimer *graceTimer;
	NSTimer *minShowTimer;
	NSDate *showStarted;
	
	UILabel *label;

	
	
    NSString *labelText;
	float opacity;
	UIFont *labelFont;

	
    BOOL isFinished;
	BOOL removeFromSuperViewOnHide;

	
	CGAffineTransform rotationTransform;
}



/**
 * A convenience constructor that initializes the HUD with the window's bounds. Calls the designated constructor with
 * window.bounds as the parameter.
 *
 * @param window The window instance that will provide the bounds for the HUD. Should probably be the same instance as
 * the HUD's superview (i.e., the window that the HUD will be added to).
 */
- (id)initWithWindow:(UIWindow *)window;

/**
 * A convenience constructor that initializes the HUD with the view's bounds. Calls the designated constructor with
 * view.bounds as the parameter
 *
 * @param view The view instance that will provide the bounds for the HUD. Should probably be the same instance as
 * the HUD's superview (i.e., the view that the HUD will be added to).
 */
- (id)initWithView:(UIView *)view;




@property (retain,nonatomic) NSString *labelText;



/**
 * The opacity of the HUD window. Defaults to 0.9 (90% opacity).
 */
@property (assign) float opacity;

/**
 * The x-axis offset of the HUD relative to the centre of the superview.
 */
@property (assign) float xOffset;

/**
 * The y-ayis offset of the HUD relative to the centre of the superview.
 */
@property (assign) float yOffset;

/**
 * The amounth of space between the HUD edge and the HUD elements (labels, indicators or custom views).
 *
 * Defaults to 20.0
 */
@property (assign) float margin;



/*
 * Grace period is the time (in seconds) that the invoked method may be run without
 * showing the HUD. If the task finishes befor the grace time runs out, the HUD will
 * not be shown at all.
 * This may be used to prevent HUD display for very short tasks.
 * Defaults to 0 (no grace time).
 * Grace time functionality is only supported when the task status is known!
 * @see taskInProgress
 */
@property (assign) float graceTime;


/**
 * The minimum time (in seconds) that the HUD is shown.
 * This avoids the problem of the HUD being shown and than instantly hidden.
 * Defaults to 0 (no minimum show time).
 */
@property (assign) float minShowTime;



/**
 * Removes the HUD from it's parent view when hidden.
 * Defaults to NO.
 */
@property (assign) BOOL removeFromSuperViewOnHide;

/**
 * Font to be used for the main label. Set this property if the default is not adequate.
 */
#if __has_feature(objc_arc)
@property (strong) UIFont* labelFont;
#else
@property (retain) UIFont* labelFont;
#endif


/**
 * The minimum size of the HUD bezel. Defaults to CGSizeZero.
 */
@property (assign) CGSize minSize;

/**
 * Display the HUD. You need to make sure that the main thread completes its run loop soon after this method call so
 * the user interface can be updated. Call this method when your task is already set-up to be executed in a new thread
 * (e.g., when using something like NSOperation or calling an asynchronous call like NSUrlRequest).
 *
 * If you need to perform a blocking thask on the main thread, you can try spining the run loop imeidiately after calling this
 * method by using:
 *
 * [[NSRunLoop currentRunLoop] runUntilDate:[NSDate distantPast]];
 *
 * @param animated If set to YES the HUD will disappear using the current animationType. If set to NO the HUD will not use
 * animations while disappearing.
 */
- (void)show:(BOOL)animated;

/**
 * Hide the HUD. This still calls the hudWasHidden delegate. This is the counterpart of the hide: method. Use it to
 * hide the HUD when your task completes.
 *
 * @param animated If set to YES the HUD will disappear using the current animationType. If set to NO the HUD will not use
 * animations while disappearing.
 */
- (void)hide:(BOOL)animated;

/**
 * Hide the HUD after a delay. This still calls the hudWasHidden delegate. This is the counterpart of the hide: method. Use it to
 * hide the HUD when your task completes.
 *
 * @param animated If set to YES the HUD will disappear using the current animationType. If set to NO the HUD will not use
 * animations while disappearing.
 * @param delay Delay in secons until the HUD is hidden.
 */
- (void)hide:(BOOL)animated afterDelay:(NSTimeInterval)delay;



+(void)ShowTipsHud:(NSString *) tips :(UIView *)superView;

@end
