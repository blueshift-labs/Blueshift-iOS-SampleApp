//
//  AFHTTPRequestOperationManager+BfHTTPRequestOperationManagerHelpers.m
//  BaseiOSApp-ObjC
//
//  Created by Arjun K P on 12/02/15.
//  Copyright (c) 2015 Arjun K P. All rights reserved.
//

#import "AFHTTPRequestOperationManager+BfHTTPRequestOperationManagerHelpers.h"

@implementation AFHTTPRequestOperationManager (BfHTTPRequestOperationManagerHelpers)

- (AFHTTPRequestOperation *)PATCH:(NSString *)URLString
                       parameters:(NSDictionary *)parameters
        constructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))block
                          success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                          failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    NSMutableURLRequest *request = [self.requestSerializer multipartFormRequestWithMethod:@"PATCH" URLString:[[NSURL URLWithString:URLString relativeToURL:self.baseURL] absoluteString] parameters:parameters constructingBodyWithBlock:block];
    AFHTTPRequestOperation *operation = [self HTTPRequestOperationWithRequest:request success:success failure:failure];
    [self.operationQueue addOperation:operation];
    
    return operation;
}

- (AFHTTPRequestOperation *)PUT:(NSString *)URLString
                     parameters:(NSDictionary *)parameters
      constructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))block
                        success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                        failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    NSMutableURLRequest *request = [self.requestSerializer multipartFormRequestWithMethod:@"PUT" URLString:[[NSURL URLWithString:URLString relativeToURL:self.baseURL] absoluteString] parameters:parameters constructingBodyWithBlock:block];
    AFHTTPRequestOperation *operation = [self HTTPRequestOperationWithRequest:request success:success failure:failure];
    [self.operationQueue addOperation:operation];
    
    return operation;
}

@end
