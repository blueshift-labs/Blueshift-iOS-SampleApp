//
//  NSArray+BfArrayHelpers.h
//  BaseiOSApp-ObjC
//
//  Created by Arjun K P on 11/02/15.
//  Copyright (c) 2015 Arjun K P. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SortOrder.h"

@interface NSArray (BfArrayHelpers)

+ (NSArray *)sortArray:(NSArray *)unSortedArray byOrder:(SortOrder)sortOrder usingVariableKey:(NSString *)variableKey;

@end
