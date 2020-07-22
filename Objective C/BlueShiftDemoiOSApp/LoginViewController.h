//
//  LoginViewController.h
//  BaseiOSApp-ObjC
//
//  Created by Arjun K P on 12/02/15.
//  Copyright (c) 2015 Arjun K P. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AttributedTextField.h"
#import <CoreLocation/CoreLocation.h>

@interface LoginViewController : UIViewController

@property IBOutlet AttributedTextField *emailTextField;
@property IBOutlet AttributedTextField *passwordTextField;
@property CLLocationManager *locationManager;
@property (weak, nonatomic) IBOutlet UIView *TitleView;

- (IBAction)signInPressed:(id)sender;
- (IBAction)signUpPressed:(id)sender;

 
@end
