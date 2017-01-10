//
//  SplashViewController.m
//  BaseiOSApp-ObjC
//
//  Created by Arjun K P on 12/02/15.
//  Copyright (c) 2015 Arjun K P. All rights reserved.
//

#import "SplashViewController.h"
#import "DeckViewController.h"
#import "LoginViewController.h"

@interface SplashViewController ()

@end

@implementation SplashViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self redirectWithAnimation];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)redirectWithAnimation {
    __strong SplashViewController *this = self;
    
    double delayInSeconds = 0.2;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [this redirect];
    });
}

- (void)redirect {
    User *currentUser = [User currentUser];
    if(currentUser.authToken == NULL || [currentUser.authToken isEqualToString:@""]) {
        [self pushLoginPage];
    } else {
        [self pushHomePage];
    }
}

- (void)pushHomePage {
    //pushing home page through deckview controller
    
    DeckViewController *deckViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:NULL] instantiateViewControllerWithIdentifier:@"DeckViewController"];
    [self.navigationController pushViewController:deckViewController animated:YES];
}

- (void)pushLoginPage {
    LoginViewController *viewController = [[UIStoryboard storyboardWithName:@"Main" bundle:NULL] instantiateViewControllerWithIdentifier:@"LoginViewController"];
    [self.navigationController pushViewController:viewController animated:YES];
}

@end
