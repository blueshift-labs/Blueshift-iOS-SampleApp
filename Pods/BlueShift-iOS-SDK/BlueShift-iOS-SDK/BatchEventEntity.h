//
//  BatchEventEntity.h
//  Pods
//
//  Created by Shahas on 31/08/16.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "NSNumber+BlueShiftHelpers.h"
#import "BlueShiftHTTPMethod.h"
#import "BlueShiftAppDelegate.h"
#import "NSDate+BlueShiftDateHelpers.h"

@interface BatchEventEntity : NSManagedObject

// property to hold the parameters array as encrypted NSData ...

@property (nonatomic, retain) NSData * paramsArray;

@property (nonatomic, retain) NSNumber *retryAttemptsCount;

@property (nonatomic, retain) NSNumber *nextRetryTimeStamp;

// Method to insert Entry for a particular request operation in core data ...

- (void)insertEntryParametersList:(NSArray *)parametersArray andNextRetryTimeStamp:(NSInteger)nextRetryTimeStamp andRetryAttemptsCount:(NSInteger)retryAttemptsCount;



// Method to return the batch records from Core Data ...
+ (NSArray *)fetchBatchesFromCoreData;

@end
