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
#import "DeckViewController.h"

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
    
    [[BlueShift sharedInstance] trackScreenViewedForViewController:self canBatchThisEvent:YES];
}

- (void)updateTextfieldWithIcons {
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)signInPressed:(id)sender {
    
    NSString *email = self.emailTextField.text;
    [[BlueShiftUserInfo sharedInstance] setEmail:email];
    //[[BlueShiftUserInfo sharedUserInfo] setRetailerCustomerID:[NSString stringWithFormat:@"%f", [[NSDate date] timeIntervalSince1970]]];
    NSString *customerID = [self md5HexDigest:self.emailTextField.text];
    [[BlueShiftUserInfo sharedInstance] setRetailerCustomerID:customerID];
    [[BlueShiftUserInfo sharedInstance] setUnsubscribed:NO];
    [[BlueShiftUserInfo sharedInstance] save];
    
    [[BlueShift sharedInstance] identifyUserWithEmail:[BlueShiftUserInfo sharedInstance].email andDetails:nil canBatchThisEvent:NO];
    
    if(self.emailTextField.text.length > 0) {
        User *currentUser = [User currentUser];
        currentUser.authToken = @"123456789";
        currentUser.email = self.emailTextField.text;
        //[currentUser save];
    }
    
    //[self performSegueWithIdentifier:kSegueShowHome sender:self];
    [self pushHomePage];
    
}

- (void)pushHomePage {
    //pushing home page through deckview controller
    
    DeckViewController *deckViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:NULL] instantiateViewControllerWithIdentifier:@"DeckViewController"];
    [self.navigationController pushViewController:deckViewController animated:YES];
}

- (NSString*)md5HexDigest:(NSString*)input {
    const char* str = [input UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(str, strlen(str), result);
    
    NSMutableString *ret = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH*2];
    for(int i = 0; i<CC_MD5_DIGEST_LENGTH; i++) {
        [ret appendFormat:@"%02x",result[i]];
    }
    return ret;
}

- (NSString *)convertIntoAscii:(NSString *)message {
    
    int length = 0;
    NSString *ascii = @"";
    while (length < message.length) {
        int asc = [message characterAtIndex:length];
        length = length + 1;
        ascii = [NSString stringWithFormat:@"%@%d", ascii, asc];
    }
    return ascii;
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
