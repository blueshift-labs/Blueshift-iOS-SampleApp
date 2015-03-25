//
//  BfTextField.h
//  BaseiOSApp-ObjC
//
//  Created by Arjun K P on 12/02/15.
//  Copyright (c) 2015 Arjun K P. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kDefaultTextFieldImagePadding       10.0f

@interface BfTextField : UITextField<UITextFieldDelegate>

- (void)setTextFieldIcon:(UIImage *)image;
- (void)resetParentView;

@end
