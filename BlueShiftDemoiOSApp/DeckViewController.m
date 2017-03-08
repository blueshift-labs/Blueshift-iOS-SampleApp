//
//  DeckViewController.m
//  BaseiOSApp-ObjC
//
//  Created by Arjun K P on 12/02/15.
//  Copyright (c) 2015 Arjun K P. All rights reserved.
//

#import "DeckViewController.h"
#import "User.h"
#import "LoginViewController.h"

@interface DeckViewController ()

@end

@implementation DeckViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.leftController = [[UIStoryboard storyboardWithName:@"Main" bundle:NULL] instantiateViewControllerWithIdentifier:@"SideMenuViewController"];
    self.centerController = [[UIStoryboard storyboardWithName:@"Main" bundle:NULL] instantiateViewControllerWithIdentifier:@"MainNavigationController"];
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;

    self.leftSize = screenWidth*0.3; // Size in (virtual) pixels, that is hidden of the side menu (and NOT the width of the menu)
    //[self setPanningMode:IIViewDeckNoPanning];
    //[self showProduct];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)showHome {
    UINavigationController *centerController = (UINavigationController*)self.centerController;
    [centerController popToRootViewControllerAnimated:YES];
}


- (void)showProduct {
    NSArray *viewControllerStoryBoardIDArray = @[
                                                 @"ProductListViewController"
                                                 ];
    [self performTransitionUsingViewControllerStoryBoardIDArray:viewControllerStoryBoardIDArray];
}

- (void)showLiveContent {
    NSArray *viewControllerStoryBoardIDArray = @[
                                                 @"ProductListViewController",
                                                 @"LiveContentViewController"
                                                 ];
    [self performTransitionUsingViewControllerStoryBoardIDArray:viewControllerStoryBoardIDArray];
}

- (void)showMailSubscription {
    NSArray *viewControllerStoryBoardIDArray = @[
                                                 @"ProductListViewController",
                                                 @"MailingSubscriptionViewController"
                                                 ];
    [self performTransitionUsingViewControllerStoryBoardIDArray:viewControllerStoryBoardIDArray];
}

- (void)showCancelReturn {
    NSArray *viewControllerStoryBoardIDArray = @[
                                                 @"ProductListViewController",
                                                 @"CancelReturnViewController"
                                                 ];
    [self performTransitionUsingViewControllerStoryBoardIDArray:viewControllerStoryBoardIDArray];
}

- (void)showSubscriptionEvent {
    NSArray *viewControllerStoryBoardIDArray = @[
                                                 @"ProductListViewController",
                                                 @"SubscriptionEventsViewController"
                                                 ];
    [self performTransitionUsingViewControllerStoryBoardIDArray:viewControllerStoryBoardIDArray];
}

- (void)logout {
    [User logout:^(BOOL status) {
        if(status) {
            [self showLoginPage];
        }
    }];
}

- (void)showLoginPage {
    //picking sign in page from story bord and pushing top of navigation controller
    
    LoginViewController *loginViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:NULL] instantiateViewControllerWithIdentifier:@"LoginViewController"];
    [self.navigationController pushViewController:loginViewController animated:YES];
    //[self.view.window.rootViewController presentViewController:loginViewController animated:YES completion:nil];
}

- (void)performTransitionUsingViewControllerStoryBoardIDArray:(NSArray *)viewControllerStoryBoardIDArray {
    // Method to perform deeplink using the path components array ...
    
    // Get the current center navigational controller and pop the view controllers...
    UINavigationController *centerController = (UINavigationController *)self.centerController;
    [centerController popToRootViewControllerAnimated:NO];
    
    // Get the current story board for the root view controller ...
    UIStoryboard *storyboard = [[[UIApplication sharedApplication] delegate] window].rootViewController.storyboard;
    
    //NSMutableArray *viewControllers = [centerController.viewControllers mutableCopy];
    NSMutableArray *viewControllers = [[NSMutableArray alloc]init];
    for (NSString *storyboardID in viewControllerStoryBoardIDArray) {
        
        // Need to do a proper way to fetch valid view controllers here ...
        // Below is just a quick way ...
        if (![storyboardID isEqualToString:@"/"]) {
            [viewControllers addObject:[storyboard instantiateViewControllerWithIdentifier:storyboardID]];
        }
    }
    
    centerController.viewControllers = viewControllers;
}


@end
