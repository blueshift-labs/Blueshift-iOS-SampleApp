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
#import "Cart.h"
#import "BlueShiftDelegates.h"
#import "BlueshiftInAppDelegate.h"
#import <Firebase/Firebase.h>

#define SYSTEM_VERSION_GRATERTHAN_OR_EQUALTO(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)


@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [FIRApp configure];
    [Fabric with:@[CrashlyticsKit]];
    
    // Push Notification
//        UIUserNotificationType userNotificationTypes = (UIUserNotificationTypeAlert |
//                                                        UIUserNotificationTypeBadge |
//                                                        UIUserNotificationTypeSound);
//        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:userNotificationTypes
//                                                                                 categories:nil];
//        [application registerUserNotificationSettings:settings];
//        [application registerForRemoteNotifications];
    
    // Obtain an instance of BlueShiftConfig ...
    BlueShiftConfig *config = [BlueShiftConfig config];
    
    // Set the api Key for the config ...
    [config setApiKey:@"5dfe3c9aee8b375bcc616079b08156d9"];
    
    // Set the applications launch Options for SDK to track ...
    [config setApplicationLaunchOptions:launchOptions];
    [config setUserNotificationDelegate:self];
    // Disable BlueShift Push Notification
    [config setEnablePushNotification:YES];
    [config setEnableInAppNotification: YES];
    [config setInAppManualTriggerEnabled: NO];
    [config setInAppBackgroundFetchEnabled: YES];
    // Disable BlueShift Analytics accessing location
    //[config setEnableLocationAccess:NO];
    // Disable BlueShift Analytics
    //[config setEnableAnalytics:NO];
    // Set the Two Predefined DeepLinking URL's ...
    [config setProductPageURL:[NSURL URLWithString:@"blueshiftdemo://ch.bullfin.BlueShiftDemo/ProductListViewController/ProductDetailViewController"]];
    [config setCartPageURL:[NSURL URLWithString:@"blueshiftdemo://ch.bullfin.BlueShiftDemo/ProductListViewController/ProductCartViewController"]];
    [config setOfferPageURL:[NSURL URLWithString:@"blueshiftdemo://ch.bullfin.BlueShiftDemo/ProductListViewController/OfferViewController"]];
    //[config setEnableAppOpenTrackEvent:NO];
    [[BlueShiftBatchUploadConfig sharedInstance] setBatchUploadTimer:60.0];
    
    // For Carousel deep linking
    [config setAppGroupID:@"group.blueshift.reads"];
    
    // BlueShiftDelegates is the class for handling BlueShiftPushDelegate delegate Callbacks
    BlueShiftDelegates *blueShiftDelegatge = [[BlueShiftDelegates alloc] init];
    [config setBlueShiftPushDelegate:blueShiftDelegatge];
    
    BlueshiftInAppDelegate *inappDelegate = [[BlueshiftInAppDelegate alloc] init];
    [config setInAppNotificationDelegate:inappDelegate];
    
    // Initialize the configuration ...
    [BlueShift initWithConfiguration:config];
    //[BlueShift autoIntegration];
    
    [Cart sharedInstance];
    
    return YES;
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(nonnull NSData *)deviceToken {
    [[BlueShift sharedInstance].appDelegate registerForRemoteNotification:deviceToken];
}


-(void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions options))completionHandler{
    [[BlueShift sharedInstance].userNotificationDelegate handleUserNotificationCenter:center willPresentNotification:notification withCompletionHandler:^(UNNotificationPresentationOptions options) {
        completionHandler(options);
    }];
}


- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)(void))completionHandler {
    [[BlueShift sharedInstance].userNotificationDelegate handleUserNotification:center didReceiveNotificationResponse:response withCompletionHandler:^{
        completionHandler();
    }];
}

- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error {
    [[BlueShift sharedInstance].appDelegate failedToRegisterForRemoteNotificationWithError:error];
}


- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult result))handler {
    [[BlueShift sharedInstance].appDelegate handleRemoteNotification:userInfo forApplication:application fetchCompletionHandler:handler];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(nonnull NSDictionary *)userInfo {
    [[BlueShift sharedInstance].appDelegate application:application handleRemoteNotification:userInfo];
}

- (void)application:(UIApplication *) application handleActionWithIdentifier: (NSString *) identifier forRemoteNotification: (NSDictionary *) notification
  completionHandler: (void (^)(void)) completionHandler {
    if (![BlueShift sharedInstance].appDelegate) {
        [BlueShift sharedInstance].appDelegate = [[BlueShiftAppDelegate alloc] init];
        [BlueShift sharedInstance].appDelegate.oldDelegate = [UIApplication sharedApplication].delegate;
    }
    [[BlueShift sharedInstance].appDelegate handleActionWithIdentifier:identifier forRemoteNotification:notification completionHandler:completionHandler];
}



- (void)handleCarouselPushForCategory:(NSString *)categoryName clickedWithIndex:(NSInteger)index withDetails:(NSDictionary *)details {
    NSLog(@"index is %ld\n", (long)index);
}

- (void)handleCarouselPushForCategory:(NSString *)categoryName clickedWithDetails:(NSDictionary *)detalis andDeepLinkURL:(NSString *)url {
    NSLog(@"url is %@", url);
}

- (void)pushCartPage {
    //pushing cart page through deckview controller
    
    ProductCartViewController *cartViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:NULL] instantiateViewControllerWithIdentifier:@"ProductCartViewController"];
    UINavigationController *navController = (UINavigationController *)[[[UIApplication sharedApplication] delegate] window].rootViewController;
    if(navController != nil && [navController respondsToSelector:@selector(popToRootViewControllerAnimated:)]) {
        [navController popToRootViewControllerAnimated:NO];
        
        NSMutableArray *viewControllers = [navController.viewControllers mutableCopy];
        [viewControllers addObject:cartViewController];
        navController.viewControllers = viewControllers;
    }
}


- (void)pushProductDetails:(NSDictionary *)details {
    //pushing cart page through deckview controller
    
    ProductDetailViewController *detailsViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:NULL] instantiateViewControllerWithIdentifier:@"ProductDetailViewController"];
    detailsViewController.data = details;
    [(UINavigationController *)self.window.rootViewController pushViewController:detailsViewController animated:YES];
}


-(void) buyCategoryPushClickedWithDetails:(NSDictionary *)details {
    [self pushCartPage];
}

-(void) promotionCategoryPushClickedWithDetails:(NSDictionary *)details {
    [self pushCartPage];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    [[BlueShift sharedInstance].appDelegate appDidEnterBackground:application];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [[BlueShift sharedInstance].appDelegate appDidBecomeActive:application];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)actionButtonDidTapped:(NSDictionary *)payloadDictionary {
    [self pushCartPage];
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
    [self pushCartPage];
    return YES;
}

- (BOOL)application:(UIApplication *)application continueUserActivity:(NSUserActivity *)userActivity
 restorationHandler:(void (^)(NSArray<id<UIUserActivityRestoring>> *restorableObjects))restorationHandler {
    if ([userActivity.activityType isEqualToString: NSUserActivityTypeBrowsingWeb]) {
        NSURL *url = userActivity.webpageURL;
        [[BlueShift sharedInstance] handleBlueshiftLink:url handler:^(NSURL *redirectURL){
            NSLog(@"%@ redirect url", redirectURL.absoluteString);
            dispatch_async(dispatch_get_main_queue(), ^{
                [UIApplication.sharedApplication openURL:redirectURL options: @{} completionHandler:nil];
            });
        }];
    }
    return YES;
}

@end
