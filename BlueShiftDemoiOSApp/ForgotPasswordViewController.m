//
//  ForgotPasswordViewController.m
//  BaseiOSApp-ObjC
//
//  Created by Arjun K P on 12/02/15.
//  Copyright (c) 2015 Arjun K P. All rights reserved.
//

#import "ForgotPasswordViewController.h"
#import "User.h"
#import <SVProgressHUD/SVProgressHUD.h>

@implementation ForgotPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self updateTextFieldWithIcons];
}

- (void)updateTextFieldWithIcons {
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction) submitButtonPressed:(id)sender {
    
    NSString *email = self.emailTextField.text;
    
    [SVProgressHUD show];
    [User forgotPassword:email withCompletionHandler:^(BOOL status, BfErrorCode error, NSString *message) {
        [SVProgressHUD dismiss];
        
        if(status == YES) {
            [[[UIAlertView alloc] initWithTitle:@"Password Reset instruction has been sent to your mail" message:message delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
            
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            [[[UIAlertView alloc] initWithTitle:@"Error" message:message delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
        }
    }];
}

- (IBAction)cancelPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:NO];
}

@end
