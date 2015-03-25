//
//  BlueShiftAppDelegate.h
//  BlueShift-iOS-SDK
//
//  Created by Arjun K P on 19/02/15.
//  Copyright (c) 2015 Bullfinch Software. All rights reserved.
//

#ifndef BlueShift_iOS_SDK_BlueShiftAppDelegate_h
#define BlueShift_iOS_SDK_BlueShiftAppDelegate_h

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "BlueShift.h"
#import "BlueShiftPushDelegate.h"
#import "BlueShiftDeepLink.h"
#import "BlueShiftPushParamDelegate.h"

//@protocol BlueShiftPushDelegate;

@interface BlueShiftAppDelegate : NSObject<UIApplicationDelegate,UIAlertViewDelegate>

@property NSDictionary *userInfo;
@property NSDictionary *pushAlertDictionary;

@property NSObject<UIApplicationDelegate> *oldDelegate;
@property (nonatomic, retain) id<BlueShiftPushDelegate> blueShiftPushDelegate;
@property (nonatomic, retain) id<BlueShiftPushParamDelegate> blueShiftPushParamDelegate;

@property BlueShiftDeepLink *deepLinkToProductPage;
@property BlueShiftDeepLink *deepLinkToCartPage;

- (void) registerForNotification;
- (BOOL) handleRemoteNotificationOnLaunchWithLaunchOptions:(NSDictionary *)launchOptions;

@end
#endif
