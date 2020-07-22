//
//  AttributedTextView.m
//  BaseiOSApp-ObjC
//
//  Created by Arjun K P on 12/02/15.
//  Copyright (c) 2015 Arjun K P. All rights reserved.
//

#import "AttributedTextView.h"
#import "UIView+BfViewHelpers.h"

@implementation AttributedTextView

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self setBorderColour:[UIColor grayColor] andBorderWidth:1.0f];
    [self setCornerRadius:5.0f];
}

@end
