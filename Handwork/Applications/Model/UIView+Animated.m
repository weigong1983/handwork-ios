//
//  UIView+Animated.m
//  Handwork
//
//  Created by mac on 15/6/8.
//  Copyright (c) 2015年 周文超. All rights reserved.
//

#import "UIView+Animated.h"

@implementation UIView (Animated)
- (void)addSubViewiew:(UIView *)view withSidesConstrainsInsets:(UIEdgeInsets)insets {
    NSParameterAssert(view);
    
    [view setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    [self addSubview:view];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:view
                                                     attribute:NSLayoutAttributeTop
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeTop
                                                    multiplier:1.0
                                                      constant:insets.top]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:view
                                                     attribute:NSLayoutAttributeLeading
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeLeading
                                                    multiplier:1.0
                                                      constant:insets.left]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:view
                                                     attribute:NSLayoutAttributeBottom
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeBottom
                                                    multiplier:1.0
                                                      constant:insets.bottom]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:view
                                                     attribute:NSLayoutAttributeTrailing
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeTrailing
                                                    multiplier:1.0
                                                      constant:insets.right]];
}

@end
