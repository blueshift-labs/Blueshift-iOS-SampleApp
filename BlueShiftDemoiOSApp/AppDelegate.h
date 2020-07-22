//
//  AppDelegate.h
//  BaseiOSApp-ObjC
//
//  Created by Arjun K P on 10/02/15.
//  Copyright (c) 2015 Arjun K P. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <BlueShift-iOS-SDK/BlueShift.h>
#import "BlueshiftInAppDelegate.h"
#import <UserNotifications/UserNotifications.h>


@interface AppDelegate : UIResponder <UIApplicationDelegate, UNUserNotificationCenterDelegate, BlueshiftUniversalLinksDelegate>

@property (strong, nonatomic) UIWindow *window;


@end
