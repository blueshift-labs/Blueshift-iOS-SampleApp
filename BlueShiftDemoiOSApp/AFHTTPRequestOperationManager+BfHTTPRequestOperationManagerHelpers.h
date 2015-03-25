//
//  AFHTTPRequestOperationManager+BfHTTPRequestOperationManagerHelpers.h
//  BaseiOSApp-ObjC
//
//  Created by Arjun K P on 12/02/15.
//  Copyright (c) 2015 Arjun K P. All rights reserved.
//

#import "AFHTTPRequestOperationManager.h"

@interface AFHTTPRequestOperationManager (BfHTTPRequestOperationManagerHelpers)

- (AFHTTPRequestOperation *)PATCH:(NSString *)URLString
                       parameters:(NSDictionary *)parameters
        constructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))block
                          success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                          failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

- (AFHTTPRequestOperation *)PUT:(NSString *)URLString
                     parameters:(NSDictionary *)parameters
      constructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))block
                        success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                        failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

@end
