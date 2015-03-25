//
//  AttributedTextField.h
//  BaseiOSApp-ObjC
//
//  Created by Arjun K P on 12/02/15.
//  Copyright (c) 2015 Arjun K P. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BfTextField.h"

#define AttributedTextFieldValidateNumber           0x00000001
#define AttributedTextFieldValidateLocalisedNumber  0x00000002
#define AttributedTextFieldValidateEmail            0x00000004
#define AttributedTextFieldValidateAlphabet         0x00000008
#define AttributedTextFieldValidateAlphaNumeric     0x00000010
#define AttributedTextFieldValidatePhoneNumber      0x00000020

@interface AttributedTextField : BfTextField

- (BOOL)validateContent:(NSInteger)flags;

@end
