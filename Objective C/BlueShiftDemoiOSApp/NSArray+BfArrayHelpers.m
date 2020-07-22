//
//  NSArray+BfArrayHelpers.m
//  BaseiOSApp-ObjC
//
//  Created by Arjun K P on 11/02/15.
//  Copyright (c) 2015 Arjun K P. All rights reserved.
//

#import "NSArray+BfArrayHelpers.h"

@implementation NSArray (BfArrayHelpers)

+ (NSArray *)sortArray:(NSArray *)unSortedArray byOrder:(SortOrder)sortOrder usingVariableKey:(NSString *)variableKey {
    NSArray *sortedArray = [NSArray array];
    BOOL isAscendingOrder = NO;
    
    
    if (sortOrder == SortOrderAscending) {
        isAscendingOrder = YES;
    }
    
    if (unSortedArray) {
        NSSortDescriptor *valueDescriptor = [[NSSortDescriptor alloc] initWithKey:variableKey ascending:isAscendingOrder];
        NSArray *descriptors = [NSArray arrayWithObject:valueDescriptor];
        sortedArray = [[unSortedArray sortedArrayUsingDescriptors:descriptors] mutableCopy];
    }
    return sortedArray;
}

@end
