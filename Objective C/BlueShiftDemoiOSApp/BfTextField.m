//
//  BfTextField.m
//  BaseiOSApp-ObjC
//
//  Created by Arjun K P on 12/02/15.
//  Copyright (c) 2015 Arjun K P. All rights reserved.
//

#import "BfTextField.h"
#import "UIView+BfViewHelpers.h"

@implementation BfTextField

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.delegate = self;
}

- (void)setTextFieldIcon:(UIImage *)icon {
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(25, 0, icon.size.width + kDefaultTextFieldImagePadding , icon.size.height)];
    [imageView setContentMode:UIViewContentModeRight];
    [imageView setImage:icon];
    self.leftView = imageView;
    self.leftViewMode = UITextFieldViewModeAlways;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [self resignFirstResponder];
    [self resetParentView];
    
    return YES;
}

- (void)resetParentView {
    if(self.parentViewController == NULL) {
        return;
    }
    
    CGRect frame = self.parentViewController.view.frame;
    [UIView animateWithDuration:0.2 animations:^{
        self.parentViewController.view.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
    }];
}

@end
