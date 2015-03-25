//
//  LoginViewController.m
//  BaseiOSApp-ObjC
//
//  Created by Arjun K P on 12/02/15.
//  Copyright (c) 2015 Arjun K P. All rights reserved.
//

#import "LoginViewController.h"
#import "User.h"
#import <SVProgressHUD/SVProgressHUD.h>
#import "SegueIdentifiers.h"
#import "UIView+BfViewHelpers.h"
#import <BlueShift-iOS-SDK/BlueShiftRequestOperation.h>
#import <CoreLocation/CoreLocation.h>

@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self updateTextfieldWithIcons];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [[BlueShift sharedInstance] trackScreenViewedForViewController:self];
}

- (void)updateTextfieldWithIcons {
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)signInPressed:(id)sender {
    
    NSString *email = self.emailTextField.text;
    [[BlueShiftUserInfo sharedUserInfo] setEmail:email];
    [[BlueShiftUserInfo sharedUserInfo] setRetailerCustomerID:@"178978789"];
    [[BlueShiftUserInfo sharedUserInfo] save];
    [[BlueShiftUserInfo sharedUserInfo] setUnsubscribed:NO];
    
    [[BlueShift sharedInstance] identifyUserWithEmail:[BlueShiftUserInfo sharedUserInfo].email andDetails:nil];
    [self performSegueWithIdentifier:kSegueShowHome sender:self];
    
}

- (IBAction)signUpPressed:(id)sender {
    [self performSegueWithIdentifier:kSegueShowSignUp sender:self];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
