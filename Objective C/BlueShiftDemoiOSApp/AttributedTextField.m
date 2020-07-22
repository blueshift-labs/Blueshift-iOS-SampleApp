//
//  AttributedTextField.m
//  BaseiOSApp-ObjC
//
//  Created by Arjun K P on 12/02/15.
//  Copyright (c) 2015 Arjun K P. All rights reserved.
//

#import "AttributedTextField.h"
#import "UIView+BfViewHelpers.h"

@implementation AttributedTextField

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self setBorderColour:[UIColor grayColor] andBorderWidth:1.0f];
    [self setCornerRadius:5.0f];
}

- (BOOL)validateContent:(NSInteger)flags {
    BOOL validated = NO;
    NSString *content = self.text;
    NSString *contentWithoutSpace = [content stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    if(flags & AttributedTextFieldValidateNumber) {
        NSString *regex = @"^[0-9]+$";
        NSPredicate *test = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
        validated |= [test evaluateWithObject:content];
    }
    
    if(flags & AttributedTextFieldValidateLocalisedNumber) {
        NSString *regex = @"[0-9,.]+";
        NSPredicate *test = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
        validated |= [test evaluateWithObject:content];
    }
    
    if(flags & AttributedTextFieldValidateEmail) {
        NSString *regex =
        @"(?:[a-z0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[a-z0-9!#$%\\&'*+/=?\\^_`{|}"
        @"~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\"
        @"x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[a-z0-9](?:[a-"
        @"z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\\[(?:(?:25[0-5"
        @"]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-"
        @"9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21"
        @"-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])";
        NSPredicate *test = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
        validated |= [test evaluateWithObject:content];
    }
    
    if(flags & AttributedTextFieldValidateAlphabet) {
        NSString *regex = @"[a-zA-Z]+";
        NSPredicate *test = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
        validated |= [test evaluateWithObject:content];
    }
    
    if(flags & AttributedTextFieldValidateAlphaNumeric) {
        NSString *regex = @"[a-zA-Z0-9]+";
        NSPredicate *test = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
        validated |= [test evaluateWithObject:contentWithoutSpace];
    }
    
    if (flags & AttributedTextFieldValidatePhoneNumber) {
        NSString *regex = @"^(\\+)?\\d{6,15}$";
        NSPredicate *test = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
        validated |= [test evaluateWithObject:content];
    }
    
    return validated;
}


@end
