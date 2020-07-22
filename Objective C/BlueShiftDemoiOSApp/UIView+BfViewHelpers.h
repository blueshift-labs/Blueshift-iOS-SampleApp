//
//  UIView+BfViewHelpers.h
//  BaseiOSApp-ObjC
//
//  Created by Arjun K P on 11/02/15.
//  Copyright (c) 2015 Arjun K P. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (BfViewHelpers)

- (UIViewController*)parentViewController;
- (void)setBorderColour:(UIColor *)borderColour andBorderWidth:(CGFloat)borderWidth;
- (void)setCornerRadius:(CGFloat)cornerRadius;
- (void)makeViewCircularWithBorderColour:(UIColor *)borderColour andBorderWidth:(CGFloat)borderWidth;

@end
