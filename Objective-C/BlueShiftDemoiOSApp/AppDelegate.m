//
//  AppDelegate.m
//  BaseiOSApp-ObjC
//
//  Created by Arjun K P on 10/02/15.
//  Copyright (c) 2015 Arjun K P. All rights reserved.
//

#import "AppDelegate.h"
#import "ProductCartViewController.h"
#import "ProductDetailViewController.h"
#import "ProductListViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "Cart.h"
#import "BlueShiftDelegates.h"
#import "BlueshiftInAppDelegate.h"
#import <Firebase/Firebase.h>
@import AdSupport;
@import FirebasePerformance;
@import FirebaseAnalytics;
@import Fabric;

#define SYSTEM_VERSION_GRATERTHAN_OR_EQUALTO(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)


@interface AppDelegate ()
@property UIActivityIndicatorView* activityIndicator;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    NSString *configFileName = @"";
    if([[[NSBundle mainBundle]bundleIdentifier] isEqualToString: @"com.blueshift.reads"]) {
        configFileName = [[NSString alloc]initWithFormat: @"GoogleService-Info"];
    } else {
        configFileName =  [[NSString alloc]initWithFormat: @"%@-GoogleService-Info", [[NSBundle mainBundle]bundleIdentifier]];
    }
    FIROptions *options = [[FIROptions alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:configFileName ofType:@"plist"]];
    [FIRApp configureWithOptions: options];
    [[Fabric sharedSDK]setDebug:YES];
    
    // Obtain an instance of BlueShiftConfig
    BlueShiftConfig *config = [BlueShiftConfig config];
    
    // Set the api Key for the config
    [config setApiKey:@"API KEY"];

    //Enabled deug info logs
    [config setDebug:YES];
    
    // By default flag is set as true to show push notification dialog immediately after launch
    // Set this to false to delay the push permission dialog
    [config setEnablePushNotification:NO];
    
    //Set userNotificationDelegate for push notificaitons
    [config setUserNotificationDelegate:self];

    //Enable Blueshift In-app notifications
    [config setEnableInAppNotification: YES];
    
    // Optional (v2.2.3) - Set Blueshift Region, default region is US.
    [config setRegion:BlueshiftRegionUS];
   
    // optional - Set this flag to false to disable the silent push registration
//    [config setEnableSilentPushNotification:NO];
    
    // optional - Enable app open event, by default it is set to false.
    [config setEnableAppOpenTrackEvent:true];
    
    //optional - Set app open time interval
    [config setAutomaticAppOpenTimeInterval:60];

    // optional v2.1.12 - Set isSceneDelegateConfiguration to true if the app is using sceneDelegate configuration. By default it is set to false.
//    [config setIsSceneDelegateConfiguration:YES];
    
    //Optional :Set batched events upload interval in seconds. By defult its 300 seconds.
    [[BlueShiftBatchUploadConfig sharedInstance] setBatchUploadTimer:60.0];
    
    //Optional :Set time interval in seconds between two cosecutive In-app message displays staying on same screen. By default its 60 seconds.
    [config setBlueshiftInAppNotificationTimeInterval:30.0];
    
    // Set app group id for Carousel deep linking
    [config setAppGroupID:@"group.blueshift.reads"];
    
    // Optional: Change the SDK core data files location only if needed. The default location is the Document directory.
    [config setSdkCoreDataFilesLocation:BlueshiftFilesLocationLibraryDirectory];
    
    // Optional - SDK uses BlueshiftDeviceIdSourceIDFV by default if you do not include the following line of code.
    [config setBlueshiftDeviceIdSource: BlueshiftDeviceIdSourceIDFVBundleID];
    
    //Optinal - Set custom Authorization Options. SDK sets [.alert, .badge, .sound] as default attributes.
    if (@available(iOS 12.0, *)) {
        config.customAuthorizationOptions = UNAuthorizationOptionAlert| UNAuthorizationOptionSound| UNAuthorizationOptionBadge| UNAuthorizationStatusProvisional;
    } else {
        config.customAuthorizationOptions = UNAuthorizationOptionAlert| UNAuthorizationOptionSound| UNAuthorizationOptionBadge;
    }

    //Optinal - Set custom push notification categories.
//    config.customCategories = [self getCustomeCategories];
    
    //Optional :Set BlueShiftDelegates class object for handling push notification events callbacks.
//    BlueShiftDelegates *blueShiftDelegatge = [[BlueShiftDelegates alloc] init];
//    [config setBlueShiftPushDelegate:blueShiftDelegatge];
    
    //Optional :Set BlueshiftInAppDelegate class object for handling In-app notification event callbacks
//    BlueshiftInAppDelegate *inappDelegate = [[BlueshiftInAppDelegate alloc] init];
//    [config setInAppNotificationDelegate:inappDelegate];

    //Set universal links delegate to enable Blueshift Universal links
    [config setBlueshiftUniversalLinksDelegate:self];

    // Initialize the configuration
    [BlueShift initWithConfiguration:config];
    
    return YES;
}

#pragma mark - remote notification delegate methods
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(nonnull NSData *)deviceToken {
    [[BlueShift sharedInstance].appDelegate registerForRemoteNotification:deviceToken];
    NSLog(@"device token %@", deviceToken);
}

- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error {
    [[BlueShift sharedInstance].appDelegate failedToRegisterForRemoteNotificationWithError:error];
}


- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult result))handler {
    if ([[BlueShift sharedInstance] isBlueshiftPushNotification: userInfo]) {
        [[BlueShift sharedInstance].appDelegate handleRemoteNotification:userInfo forApplication:application fetchCompletionHandler:handler];
    } else {
        handler(UIBackgroundFetchResultNoData);
    }
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(nonnull NSDictionary *)userInfo {
    [[BlueShift sharedInstance].appDelegate application:application handleRemoteNotification:userInfo];
}

- (void)application:(UIApplication *) application handleActionWithIdentifier: (NSString *) identifier forRemoteNotification: (NSDictionary *) notification
  completionHandler: (void (^)(void)) completionHandler {
    [[BlueShift sharedInstance].appDelegate handleActionWithIdentifier:identifier forRemoteNotification:notification completionHandler:completionHandler];
}

#pragma mark - UserNotificationCenter delegate methods
-(void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions options))completionHandler {
    if ([[BlueShift sharedInstance] isBlueshiftPushNotification:notification.request.content.userInfo]) {
        [[BlueShift sharedInstance].userNotificationDelegate handleUserNotificationCenter:center willPresentNotification:notification withCompletionHandler:^(UNNotificationPresentationOptions options) {
            completionHandler(options);
        }];
    } else {
        if (@available(iOS 14.0, *)) {
            completionHandler(UNNotificationPresentationOptionList | UNNotificationPresentationOptionBanner | UNNotificationPresentationOptionBadge | UNNotificationPresentationOptionSound);
        } else {
            completionHandler(UNNotificationPresentationOptionAlert | UNNotificationPresentationOptionBadge | UNNotificationPresentationOptionSound);
        }
    }
}

- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)(void))completionHandler {
    if ([[BlueShift sharedInstance] isBlueshiftPushNotification: response.notification.request.content.userInfo]) {
        [[BlueShift sharedInstance].userNotificationDelegate handleUserNotification:center didReceiveNotificationResponse:response withCompletionHandler:^{
            completionHandler();
        }];
    } else {
        completionHandler();
    }
}

#pragma mark - Handle universal links and deep links 
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
    if([options[@"source"]  isEqual: @"Blueshift"]) {
        [self didCompleteLinkProcessing:url];
    }
    return YES;
}

- (BOOL)application:(UIApplication *)application continueUserActivity:(NSUserActivity *)userActivity
 restorationHandler:(void (^)(NSArray<id<UIUserActivityRestoring>> *restorableObjects))restorationHandler {
    NSURL *url = userActivity.webpageURL;
    if (url != nil) {
        if ([[BlueShift sharedInstance] isBlueshiftUniversalLinkURL:url]) {
            [[BlueShift sharedInstance].appDelegate handleBlueshiftUniversalLinksForURL:url];
        } else {
            
        }
    }
    return YES;
}

#pragma mark - Universal link delegate methods
-(void)didCompleteLinkProcessing:(NSURL *)url {
    NSLog(@"%@", url);
    [_activityIndicator removeFromSuperview];
    if (url == nil || [url.absoluteString isEqual: @""]) {
        return;
    }
    NSString *productURL = [[[url.absoluteString componentsSeparatedByString:@"?"] firstObject] stringByReplacingOccurrencesOfString:@"http://" withString:@"https://"];
    NSArray* products = Cart.fetchProducts;
    NSPredicate *bPredicate = [NSPredicate predicateWithFormat:@"SELF.web_url = %@",productURL];
    NSDictionary *details = [[products filteredArrayUsingPredicate:bPredicate] firstObject];
    if (details != nil) {
        [self pushProductDetails:details];
    } else {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Product not found" message:url.absoluteString preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:cancel];
        UIAlertAction* open = [UIAlertAction actionWithTitle:@"Open in Safari" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [UIApplication.sharedApplication openURL:url options:@{} completionHandler:nil];
            });
        }];
        [alertController addAction:open];
        UIViewController *rootviewController = [[[UIApplication sharedApplication] delegate] window].rootViewController;
        [rootviewController presentViewController:alertController animated:YES completion:nil];
    }
}

- (void)pushProductDetails:(NSDictionary *)details {
    //pushing cart page through deckview controller
    
    ProductDetailViewController *detailsViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:NULL] instantiateViewControllerWithIdentifier:@"ProductDetailViewController"];
    detailsViewController.data = details;
    [(UINavigationController *)self.window.rootViewController pushViewController:detailsViewController animated:YES];
}

-(void)didFailLinkProcessingWithError:(NSError *)error url:(NSURL *)url {
    NSLog(@"%@", error);
    [_activityIndicator removeFromSuperview];
}

-(void)didStartLinkProcessing {
    _activityIndicator = [[UIActivityIndicatorView alloc] init];
    UIViewController *rootviewController = [[[UIApplication sharedApplication] delegate] window].rootViewController;
    _activityIndicator.center = [rootviewController.view center];
    if (@available(iOS 13.0, *)) {
        _activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleLarge;
    } else {
        _activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    }
    [[rootviewController view] addSubview:_activityIndicator];
    [_activityIndicator startAnimating];    
}

@end
