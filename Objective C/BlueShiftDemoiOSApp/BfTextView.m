//
//  BfTextView.m
//  BaseiOSApp-ObjC
//
//  Created by Arjun K P on 12/02/15.
//  Copyright (c) 2015 Arjun K P. All rights reserved.
//

#import "BfTextView.h"

@implementation BfTextView

- (void)awakeFromNib {
    [super awakeFromNib];

}

- (void)setTextViewIcon:(UIImage *)icon {
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, kDefaultTextViewImagePadding, icon.size.width + kDefaultTextViewImagePadding , icon.size.height-kDefaultTextViewImagePadding)];
    [imageView setContentMode:UIViewContentModeTop];
    [imageView setImage:icon];
    [self addSubview:imageView];
    
    UIEdgeInsets textContainerInset = UIEdgeInsetsMake(kDefaultTextViewImagePadding, icon.size.width+kDefaultTextViewImagePadding, 0, 0);
    [self setTextContainerInset:textContainerInset];
}
@end
