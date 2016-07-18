#import "XHViewState.h"

@implementation XHViewState

+ (XHViewState *)viewStateForView:(UIView *)view {
    static NSMutableDictionary *dict = nil;
    if(dict==nil){ dict = [NSMutableDictionary dictionary]; }
    
    XHViewState *state = dict[@(view.hash)];
    if(state==nil){
        state = [[self alloc] init];
        dict[@(view.hash)] = state;
    }
    return state;
}

- (void)setStateWithView:(UIView *)view {
    CGAffineTransform trans = view.transform;
    view.transform = CGAffineTransformIdentity;
    
    self.superview = view.superview;
    self.frame     = view.frame;
    self.transform = trans;
    self.userInteratctionEnabled = view.userInteractionEnabled;
    
    view.transform = trans;
}

@end
