//
//  SignUpViewController.h
//  BaseiOSApp-ObjC
//
//  Created by Arjun K P on 12/02/15.
//  Copyright (c) 2015 Arjun K P. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "AttributedTextField.h"
#import "AttributedTextView.h"

@interface SignUpViewController : UIViewController<UIImagePickerControllerDelegate>

@property IBOutlet UIView *contentView;
@property IBOutlet UIScrollView *scrollView;
@property IBOutlet UIButton *agreeTermsAndConditionsCheckBoxButton;
@property IBOutlet UIButton *uploadPhotoButton;

@property IBOutlet AttributedTextField *emailTextField;
@property IBOutlet AttributedTextField *passwordTextField;
@property IBOutlet AttributedTextField *confirmPasswordTextField;
@property IBOutlet AttributedTextField *firstNameTextField;
@property IBOutlet AttributedTextField *lastNameTextField;
@property IBOutlet AttributedTextField *contactNumberTextField;
@property IBOutlet AttributedTextView *addressTextView;

@property IBOutlet NSLayoutConstraint *contentViewWidthConstraint;

@property UIImagePickerController *imagePicker;
@property UIImage *selectedImage;
@property BOOL isTermsAndConditionsAgreed;

- (IBAction)uploadProfileButtonPressed:(id)sender;
- (IBAction)termsAndConditionsCheckboxPressed:(id)sender;
- (IBAction)signInPressed:(id)sender;
- (IBAction)signUpPressed:(id)sender;

@end
