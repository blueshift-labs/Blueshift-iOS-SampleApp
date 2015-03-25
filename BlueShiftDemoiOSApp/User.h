//
//  User.h
//  BaseiOSApp-ObjC
//
//  Created by Arjun K P on 12/02/15.
//  Copyright (c) 2015 Arjun K P. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <JSONModel/JSONModel.h>
#import <JSONKit/JSONKit.h>
#import "BfErrorCode.h"
#import "Routes.h"
#import <AFNetworking/AFNetworking.h>
#include <CommonCrypto/CommonDigest.h>
#import "AppDelegate.h"
#import "StatusCodes.h"
#import "AppConstants.h"
#import "NSString+BfStringHelpers.h"
#import "AFHTTPRequestOperationManager+BfHTTPRequestOperationManagerHelpers.h"

@interface User : JSONModel

@property NSString *authToken;
@property NSString *email;
@property NSString *userID;
@property NSString *firstName;
@property NSString *lastName;

@property NSString<Optional>    *pushToken;
@property NSString<Optional>    *password;
@property NSString<Optional>    *fbToken;
@property NSString<Optional>    *imageUrl;
@property NSString<Optional>    *phoneNumber;
@property NSString<Optional>    *address;
@property NSNumber<Optional>    *rewardPoints;

+ (User*)currentUser;
+ (void)removeCurrentUser;

+ (void)signInWithEmail:(NSString*)email andPassword:(NSString*)password completionHandler:(void (^)(BOOL, BfErrorCode, NSString*))handler;
+ (void)signUpWithUserDetails:(NSDictionary*)userDetails andPhoto:(UIImage*)photo completionHandler:(void (^)(BOOL, BfErrorCode, NSString*))handler;
+ (void)updateUserDetails:(NSDictionary*)userDetails andPhoto:(UIImage*)photo completionHandler:(void (^)(BOOL, BfErrorCode, NSString*))handler;
+ (void)fetchUserDetailsWithCompletionHandler:(void(^)(BOOL,BfErrorCode, NSString *))handler;

+ (void)logout:(void (^)(BOOL))handler;

+ (void)parseLoginSuccessResponse:(NSDictionary*)response;

- (void)save;

+ (BOOL)isFirstTimeUser;
+ (void)saveCurrentTimeStamp;

+ (void)saveEmail:(NSString*)email andPassword:(NSString*)password;
+ (NSDictionary*)loadEmailAndPassword;

+ (void)forgotPassword:(NSString *)email withCompletionHandler:(void(^)(BOOL, BfErrorCode, NSString *))handler;


@end
