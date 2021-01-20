#import "SceneDelegate.h"

@interface SceneDelegate ()

@end

@implementation SceneDelegate


- (void)scene:(UIScene *)scene willConnectToSession:(UISceneSession *)session options:(UISceneConnectionOptions *)connectionOptions  API_AVAILABLE(ios(13.0)){
    if ([[[connectionOptions userActivities] allObjects]firstObject] != nil) {
          [[BlueShift sharedInstance].appDelegate handleBlueshiftUniversalLinksForActivity:[[[connectionOptions userActivities] allObjects]firstObject]];
      }
}


- (void)sceneDidDisconnect:(UIScene *)scene API_AVAILABLE(ios(13.0)){
    // Called as the scene is being released by the system.
    // This occurs shortly after the scene enters the background, or when its session is discarded.
    // Release any resources associated with this scene that can be re-created the next time the scene connects.
    // The scene may re-connect later, as its session was not neccessarily discarded (see `application:didDiscardSceneSessions` instead).
}


- (void)sceneDidBecomeActive:(UIScene *)scene API_AVAILABLE(ios(13.0)){
    // Called when the scene has moved from an inactive state to an active state.
    // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
}


- (void)sceneWillResignActive:(UIScene *)scene API_AVAILABLE(ios(13.0)){
    // Called when the scene will move from an active state to an inactive state.
    // This may occur due to temporary interruptions (ex. an incoming phone call).
}


- (void)sceneWillEnterForeground:(UIScene *)scene API_AVAILABLE(ios(13.0)){
    [[BlueShift sharedInstance].appDelegate sceneWillEnterForeground:scene];
}

- (void)sceneDidEnterBackground:(UIScene *)scene API_AVAILABLE(ios(13.0)){
    [[BlueShift sharedInstance].appDelegate sceneDidEnterBackground:scene];
}

- (void)scene:(UIScene *)scene continueUserActivity:(NSUserActivity *)userActivity API_AVAILABLE(ios(13.0)) {
        [[BlueShift sharedInstance].appDelegate handleBlueshiftUniversalLinksForActivity: userActivity];
}

@end
