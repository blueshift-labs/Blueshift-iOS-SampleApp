//
//  BlueShiftHttpRequestBatchUpload.m
//  BlueShift-iOS-SDK
//
//  Created by Shahas on 25/08/16.
//  Copyright © 2016 Bullfinch Software. All rights reserved.
//

#import "BlueShiftHttpRequestBatchUpload.h"

// this static variable is meant to show the status of the request queue ...

static BlueShiftRequestQueueStatus _requestQueueStatus = BlueShiftRequestQueueStatusAvailable;

@implementation BlueShiftHttpRequestBatchUpload

// Method to start batch uploading
+ (void)startBatchUpload {
    [NSTimer scheduledTimerWithTimeInterval:[[BlueShiftBatchUploadConfig sharedInstance] fetchBatchUploadTimer]
                                     target:self
                                   selector:@selector(uploadBatches)
                                   userInfo:nil
                                    repeats:YES];
}

// Perform uploading task in background (inclues core data operations)
+ (void)uploadBatches {
    [self performSelectorInBackground:@selector(uploadBatch) withObject:nil];
}

// Method to upload batch
+ (void)uploadBatch {
    NSArray *operationEntitiesToBeExecuted = [HttpRequestOperationEntity fetchBatchWiseRecordFromCoreData];
    if(operationEntitiesToBeExecuted.count > 0) {
        [self processRequestsInQueue:operationEntitiesToBeExecuted completetionHandler:^(BOOL status) {
            if(status) {
                [self uploadBatch];
            }
        }];
    } else {
        return;
    }
}


+ (void) processRequestsInQueue:(NSArray *)operationEntitiesToBeExecuted completetionHandler:(void (^)(BOOL))handler {
    @synchronized(self) {
        // Will execute the code when the requestQueue is free / available and internet is connected ...
        
        if (_requestQueueStatus == BlueShiftRequestQueueStatusAvailable && [BlueShiftNetworkReachabilityManager networkConnected]==YES) {
            
            // Gets the current NSManagedObjectContext via appDelegate ...
            
            BlueShiftAppDelegate *appDelegate = (BlueShiftAppDelegate *)[UIApplication sharedApplication].delegate;
            NSManagedObjectContext *context = appDelegate.managedObjectContext;
            
            // Only handles when the fetched record is not nil ...
            
            if (operationEntitiesToBeExecuted != nil) {
                NSMutableArray *requestOperations = [[NSMutableArray alloc]init];
                for(HttpRequestOperationEntity *operationEntityToBeExecuted in operationEntitiesToBeExecuted) {
                    if ([operationEntityToBeExecuted.nextRetryTimeStamp floatValue] < [[[NSDate date] dateByAddingMinutes:kRequestRetryMinutesInterval] timeIntervalSince1970]) {
                        BlueShiftRequestOperation *requestOperation = [[BlueShiftRequestOperation alloc] initWithHttpRequestOperationEntity:operationEntityToBeExecuted];
                        [requestOperations addObject:requestOperation];
                    } else {
                        
                        BlueShiftRequestOperation *requestOperation = [[BlueShiftRequestOperation alloc] initWithHttpRequestOperationEntity:operationEntityToBeExecuted];
                        
                        [context deleteObject:operationEntityToBeExecuted];
                        NSError *saveError = nil;
                        BOOL deletedStatus = [context save:&saveError];
                        
                        if (deletedStatus == YES) {
                            _requestQueueStatus = BlueShiftRequestQueueStatusAvailable;
                            
                            // request record is removed successfully from core data ...
                            [BlueShiftRequestQueue addRequestOperation:requestOperation]; //- done to prevent crash ...
                        } else {
                            // To be handled if request executed is not deleted from core data...
                        }
                    }
                }
                
                // requestQueue status is made busy ...
                    
                _requestQueueStatus = BlueShiftRequestQueueStatusBusy;
                    
                    
                // Performs the request operation ...
                
                [BlueShiftHttpRequestBatchUpload performRequestOperation:requestOperations  completetionHandler:^(BOOL status) {
                    if (status == YES) {
                        // delete batch records for the request operation if it is successfully executed ...
                        for(HttpRequestOperationEntity *operationEntityToBeExecuted in operationEntitiesToBeExecuted) {
                            [context deleteObject:operationEntityToBeExecuted];
                            NSError *saveError = nil;
                            BOOL deletedStatus = [context save:&saveError];
                            
                            if (deletedStatus == YES) {
                                
                            } else {
                                // To be handled if request executed is not deleted from core data...
                                
                            }
                        }
                        handler(YES);
                        _requestQueueStatus = BlueShiftRequestQueueStatusAvailable;
                    } else {
                        // Request is not executed due to some reasons ...
                        
                        for(HttpRequestOperationEntity *operationEntityToBeExecuted in operationEntitiesToBeExecuted) {
                            [context deleteObject:operationEntityToBeExecuted];
                            NSError *saveError = nil;
                            BOOL deletedStatus = [context save:&saveError];
                            
                            if (deletedStatus == YES) {
                                
                            } else {
                                // To be handled if request executed is not deleted from core data...
                            }
                        }
                        
                        for(BlueShiftRequestOperation *requestOperation in requestOperations) {
                            NSInteger retryAttemptsCount = requestOperation.retryAttemptsCount;
                            requestOperation.retryAttemptsCount = retryAttemptsCount - 1;
                            requestOperation.nextRetryTimeStamp = [[[NSDate date] dateByAddingMinutes:kRequestRetryMinutesInterval] timeIntervalSince1970];
                            requestOperation.isBatchEvent = YES;
                            
                            // request record is removed successfully from core data ...
                            if (requestOperation.retryAttemptsCount > 0) {
                                [BlueShiftRequestQueue addRequestOperation:requestOperation];
                            }
                        }
                        _requestQueueStatus = BlueShiftRequestQueueStatusAvailable;
                        handler(NO);
                    }
                }];
            }
        }
    }
}

+ (void)performRequestOperation:(NSArray *)requestOperations completetionHandler:(void (^)(BOOL))handler {
    
    // get the request operation details ...
    NSString *url = [NSString stringWithFormat:@"%@%@", kBaseURL, kBatchUploadURL];
    BlueShiftHTTPMethod httpMethod = BlueShiftHTTPMethodPOST;
    
    NSMutableArray *parametersArray = [[NSMutableArray alloc]init];
    
    for(BlueShiftRequestOperation *requestOperation in requestOperations) {
        [parametersArray addObject:requestOperation.parameters];
    }
    NSDictionary *paramsDictionary = @{@"events": parametersArray};
    // perform executions based on the request operation http method ...
    
    if (httpMethod == BlueShiftHTTPMethodGET) {
        [[BlueShiftRequestOperationManager sharedRequestOperationManager] addBasicAuthenticationRequestHeaderForUsername:[BlueShiftConfig config].apiKey andPassword:nil];
        
        [[BlueShiftRequestOperationManager sharedRequestOperationManager] GET:url parameters:paramsDictionary success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            BOOL status = NO;
            
            // If server responds with status code ...
            if (operation.response.statusCode == kStatusCodeSuccessfullResponse) {
                status = YES;
            }
            
            // Performs the corresponding handler function ...
            handler(status);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            // Performs the corresponding handler function ...
            
            handler(NO);
        }];
    } else if (httpMethod == BlueShiftHTTPMethodPOST) {
        [[BlueShiftRequestOperationManager sharedRequestOperationManager] addBasicAuthenticationRequestHeaderForUsername:[BlueShift sharedInstance].config.apiKey andPassword:nil];
        
        [[BlueShiftRequestOperationManager sharedRequestOperationManager] POST:url parameters:paramsDictionary success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            BOOL status = NO;
            // If server responds with status code ...
            if (operation.response.statusCode == kStatusCodeSuccessfullResponse) {
                status = YES;
            }
            // Performs the corresponding handler function ...
            handler(status);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            // Performs the corresponding handler function ...
            handler(NO);
        }];
    }
}


@end
