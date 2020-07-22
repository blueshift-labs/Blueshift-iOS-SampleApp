//
//  UIView+BfViewHelpers.m
//  BaseiOSApp-ObjC
//
//  Created by Arjun K P on 11/02/15.
//  Copyright (c) 2015 Arjun K P. All rights reserved.
//

#import "UIView+BfViewHelpers.h"

@implementation UIView (BfViewHelpers)

- (UIViewController*)parentViewController {
    id nextResponder = [self nextResponder];
    
    while (nextResponder != NULL && ![nextResponder isKindOfClass:[UIViewController class]]) {
        nextResponder = [nextResponder nextResponder];
    }
    
    return (UIViewController*)nextResponder;
}

- (void)setBorderColour:(UIColor *)borderColour andBorderWidth:(CGFloat)borderWidth {
    CGColorRef CGBorderColor = borderColour.CGColor;
    self.layer.borderColor = CGBorderColor;
    self.layer.borderWidth = borderWidth;
}

- (void)setCornerRadius:(CGFloat)cornerRadius {
    self.layer.cornerRadius = cornerRadius;
}

- (void)makeViewCircularWithBorderColour:(UIColor *)borderColour andBorderWidth:(CGFloat)borderWidth {
    self.layer.cornerRadius = self.frame.size.width/2.0f;
    [self setBorderColour:borderColour andBorderWidth:borderWidth];
}

@end
