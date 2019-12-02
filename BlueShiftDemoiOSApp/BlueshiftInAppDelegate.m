//
//  BlueshiftInAppDelegate.m
//  BlueShiftDemoiOSApp
//
//  Created by Noufal on 31/10/19.
//  Copyright © 2019 Arjun K P. All rights reserved.
//

#import "BlueshiftInAppDelegate.h"

@implementation BlueshiftInAppDelegate

- (void)actionButtonDidTapped:(NSDictionary *)payloadDictionary {
    NSLog(@"inapp notification clicked");
}

- (void)inAppNotificationWillAppear:(NSDictionary *)notificationDictionary {
    NSLog(@"inapp notification will appear");
}

- (void)inAppNotificationDidAppear:(NSDictionary *)notificationDictionary {
    NSLog(@"inapp notification did appear");
}

- (void)inAppNotificationWillDisappear:(NSDictionary *)notificationDictionary {
     NSLog(@"inapp notification will disappear");
}

- (void)inAppNotificationDidDisappear:(NSDictionary *)notificationDictionary {
     NSLog(@"inapp notification did disappear");
}

@end
