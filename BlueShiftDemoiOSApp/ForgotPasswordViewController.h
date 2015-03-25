//
//  ForgotPasswordViewController.h
//  BaseiOSApp-ObjC
//
//  Created by Arjun K P on 12/02/15.
//  Copyright (c) 2015 Arjun K P. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AttributedTextField.h"

@interface ForgotPasswordViewController : UIViewController

@property IBOutlet AttributedTextField *emailTextField;

- (IBAction) submitButtonPressed:(id)sender;
- (IBAction)cancelPressed:(id)sender;

@end
