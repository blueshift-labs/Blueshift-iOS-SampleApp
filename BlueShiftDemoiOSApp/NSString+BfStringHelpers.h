//
//  NSString+BfStringHelpers.h
//  BaseiOSApp-ObjC
//
//  Created by Arjun K P on 11/02/15.
//  Copyright (c) 2015 Arjun K P. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BfErrorCode.h"

@interface NSString (BfStringHelpers)

+ (instancetype)stringWithBfErrorCode:(BfErrorCode)errorCode;
- (NSString *)replaceLastOccurenceOfSubString:(NSString *)subString withReplaceString:(NSString *)replaceString;

@end
