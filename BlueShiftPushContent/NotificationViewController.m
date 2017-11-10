//
//  NotificationViewController.m
//  BlueShiftPushContent
//
//  Created by Shahas on 21/09/16.
//  Copyright © 2016 Arjun K P. All rights reserved.
//

#import "NotificationViewController.h"
#import <UserNotifications/UserNotifications.h>
#import <UserNotificationsUI/UserNotificationsUI.h>

@interface NotificationViewController () <UNNotificationContentExtension>


@end

@implementation NotificationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any required interface initialization here.
    
    self.appGroupID = @"group.blueshift.app";
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)didReceiveNotification:(UNNotification *)notification {
    if([self isBlueShiftCarouselPushNotification:notification]) {
        [self showCarouselForNotfication:notification];
    } else {    
        // Perform your codes here
    }
}

- (void)didReceiveNotificationResponse:(UNNotificationResponse *)response completionHandler:(void (^)(UNNotificationContentExtensionResponseOption))completion {
    //Place following codes after your code lines
    if([self isBlueShiftCarouselActions:response]) {
        [self setCarouselActionsForResponse:response completionHandler:^(UNNotificationContentExtensionResponseOption option) {
            completion(option);
        }];
    } else {
        
    }
}

@end
