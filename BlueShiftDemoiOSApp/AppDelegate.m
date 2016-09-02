//
//  AppDelegate.m
//  BaseiOSApp-ObjC
//
//  Created by Arjun K P on 10/02/15.
//  Copyright (c) 2015 Arjun K P. All rights reserved.
//

#import "AppDelegate.h"
#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>
#import "ProductCartViewController.h"
#import "ProductDetailViewController.h"
#import "ProductListViewController.h"
#import <CoreLocation/CoreLocation.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [Fabric with:@[CrashlyticsKit]];
    
    // Push Notification
        UIUserNotificationType userNotificationTypes = (UIUserNotificationTypeAlert |
                                                        UIUserNotificationTypeBadge |
                                                        UIUserNotificationTypeSound);
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:userNotificationTypes
                                                                                 categories:nil];
        [application registerUserNotificationSettings:settings];
        [application registerForRemoteNotifications];
    
    // Obtain an instance of BlueShiftConfig ...
    BlueShiftConfig *config = [BlueShiftConfig config];
    
    // Set the api Key for the config ...
    // 0bcedd92238db589d8975462eb0a1c45
    [config setApiKey:@"ae8087e9fb141de419ddbac09ed8b0a9"];
    
    // Set the applications launch Options for SDK to track ...
    [config setApplicationLaunchOptions:launchOptions];
    
    // Set the Two Predefined DeepLinking URL's ...
    [config setProductPageURL:[NSURL URLWithString:@"blueshiftdemo://ch.bullfin.BlueShiftDemo/HomeViewController/ProductListViewController/ProductDetailViewController"]];
    [config setCartPageURL:[NSURL URLWithString:@"blueshiftdemo://ch.bullfin.BlueShiftDemo/HomeViewController/ProductListViewController/ProductDetailViewController/ProductCartViewController"]];
    [config setOfferPageURL:[NSURL URLWithString:@"blueshiftdemo://ch.bullfin.BlueShiftDemo/HomeViewController/OfferViewController"]];
    
    [[BlueShiftBatchUploadConfig sharedInstance] setBatchUploadTimer:180.0];
    
    // Initialize the configuration ...
    [BlueShift initWithConfiguration:config];
    
    return YES;
}



- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
