//
//  NSString+BfStringHelpers.m
//  BaseiOSApp-ObjC
//
//  Created by Arjun K P on 11/02/15.
//  Copyright (c) 2015 Arjun K P. All rights reserved.
//

#import "NSString+BfStringHelpers.h"

@implementation NSString (BfStringHelpers)

+ (instancetype) stringWithBfErrorCode:(BfErrorCode)errorCode {
    NSString *message = @"An unknown error has occured. Please try again later.";
    
    switch (errorCode) {
        case BfErrorCodeNetworkError:
            message = @"Sorry, No Network Connectivity";
            break;
        case BfErrorCodeEmailPasswordWrong:
            message = @"Incorrect Email/Password";
            break;
        default:
            break;
    }
    
    return message;
}

- (NSString *)replaceLastOccurenceOfSubString:(NSString *)subString withReplaceString:(NSString *)replaceString {
    NSRange lastComma = [self rangeOfString:subString options:NSBackwardsSearch];
    NSString *replacedString = self;
    if(lastComma.location != NSNotFound) {
        replacedString = [self stringByReplacingCharactersInRange:lastComma
                                                       withString: replaceString];
    }
    
    return replacedString;
}

@end
