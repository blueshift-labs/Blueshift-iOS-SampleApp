//
//  User.m
//  BaseiOSApp-ObjC
//
//  Created by Arjun K P on 12/02/15.
//  Copyright (c) 2015 Arjun K P. All rights reserved.
//

#import "User.h"

static User *_currentUser = NULL;

@implementation User

@synthesize authToken;

+ (User*)currentUser
{
    if(_currentUser == NULL) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *json = [defaults stringForKey:@"savedUserJSON"];
        if(json != NULL) {
            _currentUser = [[User alloc] initWithString:json error:NULL];
        } else {
            _currentUser = [[User alloc] init];
        }
    }
    
    return _currentUser;
}

+ (void)removeCurrentUser
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([User currentUser]) {
        [defaults removeObjectForKey:@"savedUserJSON"];
        if ([defaults synchronize]==YES) {
            _currentUser = NULL;
        }
    }
}


+ (void)signInWithEmail:(NSString *)email andPassword:(NSString *)password completionHandler:(void (^)(BOOL, BfErrorCode, NSString*))handler
{
    if(email == NULL || password == NULL) {
        handler(NO, BfErrorCodeEmailPasswordWrong, @"Incorrect email/password");
        return;
    }
    
    User *currentUser = [User currentUser];
    NSString *url = [NSString stringWithFormat:@"%@%@",kBaseURL,kRouteSignInWithEmail];
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    NSMutableDictionary *params = [@{
                                     @"user[email]": email,
                                     @"user[password]": password,
                                     } mutableCopy];
    
    if(currentUser.pushToken != NULL) {
        [params setValue:currentUser.pushToken forKey:@"user[ios_token]"];
    }
    
    [operationManager POST:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSInteger statusCode = operation.response.statusCode;
        NSNumber *status = @0;
        BfErrorCode errorCode = BfErrorCodeUnknownError;
        
        if(statusCode==kStatusCodeSuccessfullResponse) {
            [self parseLoginSuccessResponse:[responseObject objectForKey:@"user"]];
            status = @1;
            [User saveEmail:email andPassword:password];
        }
        
        status = [NSNumber numberWithInt:[[responseObject objectForKey:@"success"] intValue]];
        handler([status boolValue],errorCode, [responseObject objectForKey:@"error"]);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (operation.response.statusCode == kStatusCodeUnauthorized) {
            handler(NO,BfErrorCodeEmailPasswordWrong,@"Incorrect email/password");
        }
        else if(operation.response.statusCode == kStatusCodeNoInternetConnection) {
            handler(NO,BfErrorCodeNetworkError,nil);
        }
        else {
            handler(NO,BfErrorCodeUnknownError,nil);
        }
    }];
}

+ (void)parseLoginSuccessResponse:(NSDictionary*)response
{
    User *currentUser = [User currentUser];
    
    currentUser.authToken = [response objectForKey:@"authentication_token"];
    currentUser.userID = ((NSNumber*)[response objectForKey:@"id"]).stringValue;
    currentUser.email = [response objectForKey:@"email"];
    currentUser.firstName = [response objectForKey:@"first_name"];
    currentUser.lastName = [response objectForKey:@"last_name"];
    currentUser.rewardPoints = [NSNumber numberWithInteger:[[response objectForKey:@"reward_points"] integerValue]];
    currentUser.address = [response objectForKey:@"address"];
    currentUser.imageUrl = [response objectForKey:@"image_url"];
    currentUser.phoneNumber = [response objectForKey:@"phone_number"];
    
    [currentUser save];
    
    return;
}

- (void)save
{
    NSString *json = [self toJSONString];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:json forKey:@"savedUserJSON"];
}

- (void)update
{
    [self save];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void)logout:(void (^)(BOOL status))handler
{
    BOOL status = YES;
    [User removeCurrentUser];
    handler(status);
}

+ (BOOL)isFirstTimeUser
{
    BOOL status = YES;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *lastLoginTimeString = [defaults objectForKey:@"lastLoginTimeString"];
    if (lastLoginTimeString) {
        status = NO;
    }
    return status;
}

+ (void)saveCurrentTimeStamp
{
    NSString *currentTimeStamp = [NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970] * 1000];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:currentTimeStamp forKey:@"lastLoginTimeString"];
}

+ (void)saveEmail:(NSString *)email andPassword:(NSString *)password
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:email forKey:@"user[email]"];
    [defaults setObject:password forKey:@"user[password]"];
}

+ (NSDictionary*)loadEmailAndPassword
{
    NSMutableDictionary *credentials = [[NSMutableDictionary alloc] init];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *email = [defaults objectForKey:@"user[email]"];
    NSString *password = [defaults objectForKey:@"user[password]"];
    if(email != NULL) {
        [credentials setObject:email forKey:@"user[email]"];
    }
    if(password != NULL) {
        [credentials setObject:password forKey:@"user[password]"];
    }
    
    return credentials;
}

+ (void)signUpWithUserDetails:(NSMutableDictionary *)userDetails andPhoto:(UIImage*)photo completionHandler:(void (^)(BOOL, BfErrorCode, NSString*))handler
{
    NSString *url = [NSString stringWithFormat:@"%@%@",kBaseURL,kRouteSignUpWithUserDetails];
    
    NSMutableDictionary *params = userDetails;
    
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    [operationManager POST:url parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        if(photo != NULL) {
            NSData *photoData = UIImageJPEGRepresentation(photo, 0.8);
            [formData appendPartWithFileData:photoData name:@"user[profile_attributes][image_attributes][file]" fileName:@"photo.jpg" mimeType:@"image/jpeg"];
        }
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        BfErrorCode errorCode = BfErrorCodeUnknownError;
        NSNumber *status = [NSNumber numberWithInt:[[responseObject objectForKey:@"success"] intValue]];
        handler([status boolValue],errorCode, [responseObject objectForKey:@"error"]);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Status code: %ld",(long)operation.response.statusCode);
        handler(NO,BfErrorCodeUnknownError, nil);
    }];
}

+ (void)updateUserDetails:(NSMutableDictionary *)userDetails andPhoto:(UIImage*)photo completionHandler:(void (^)(BOOL, BfErrorCode, NSString*))handler
{
    User *currentUser = [User currentUser];
    NSString *urlTemplate = [NSString stringWithFormat:@"%@%@",kBaseURL,kRouteGetUserDetails];
    NSString *url = [urlTemplate stringByReplacingOccurrencesOfString:@"__USER_ID__" withString:currentUser.userID];
    [userDetails setObject:currentUser.authToken forKey:@"user_token"];
    [userDetails setObject:currentUser.email forKey:@"user_email"];
    
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    [operationManager PUT:url parameters:userDetails constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        if(photo != NULL) {
            NSData *photoData = UIImageJPEGRepresentation(photo, 0.8);
            [formData appendPartWithFileData:photoData name:@"user[profile_attributes][image_attributes][file]" fileName:@"photo.jpg" mimeType:@"image/jpeg"];
        }
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self fetchUserDetailsWithCompletionHandler:^(BOOL status, BfErrorCode errorCode, NSString *errorMessage) {
            if(status) {
                handler(YES,BfErrorCodeUnknownError,nil);
            }
        }];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Status code: %ld",(long)operation.response.statusCode);
        if(operation.response.statusCode == kStatusCodeNoInternetConnection) {
            handler(NO,BfErrorCodeNetworkError,nil);
        }
        else {
            handler(NO,BfErrorCodeUnknownError,nil);
        }
    }];
}

+ (void)fetchUserDetailsWithCompletionHandler:(void(^)(BOOL,BfErrorCode, NSString *))handler {
    User *currentUser = [User currentUser];
    NSString *urlTemplate = [NSString stringWithFormat:@"%@%@",kBaseURL,kRouteGetUserDetails];
    NSString *url = [urlTemplate stringByReplacingOccurrencesOfString:@"__USER_ID__" withString:currentUser.userID];
    
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    NSMutableDictionary *params = [@{
                                     @"user_token": currentUser.authToken,
                                     @"user_email": currentUser.email
                                     } mutableCopy];
    
    [operationManager GET:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        BfErrorCode errorCode = BfErrorCodeUnknownError;
        if (operation.response.statusCode == kStatusCodeSuccessfullResponse) {
            if (responseObject) {
                NSDictionary *userDetails = (NSDictionary *)responseObject;
                [User parseLoginSuccessResponse:userDetails];
            }
        }
        handler(YES,errorCode, @"Error");
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSInteger statusCode = operation.response.statusCode;
        BfErrorCode errorCode = BfErrorCodeUnknownError;
        if (statusCode == kStatusCodeNoInternetConnection) {
            errorCode = BfErrorCodeNetworkError;
        }
        
        NSString *errorMessage = [NSString stringWithBfErrorCode:errorCode];
        handler(NO,errorCode,errorMessage);
    }];
    
}

+ (void)forgotPassword:(NSString*)email withCompletionHandler:(void (^)(BOOL, BfErrorCode, NSString *))handler {
    NSString *url = [NSString stringWithFormat:@"%@%@",kBaseURL,kRouteForgotPassword];
    
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    NSMutableDictionary *params = [@{
                                     @"user[email]":email,
                                     } mutableCopy];
    
    [operationManager POST:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        BOOL status = NO;
        if (operation.response.statusCode == kStatusCodeSuccessfullResponse) {
            status = YES;
        }
        
        handler(status,BfErrorCodeUnknownError,@"Unknown Error");
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSInteger statusCode = operation.response.statusCode;
        BfErrorCode errorCode = BfErrorCodeUnknownError;
        if (statusCode == kStatusCodeNoInternetConnection) {
            errorCode = BfErrorCodeNetworkError;
        }
        
        NSString *errorMessage = [NSString stringWithBfErrorCode:errorCode];
        handler(NO,errorCode,errorMessage);
    }];
}

@end
