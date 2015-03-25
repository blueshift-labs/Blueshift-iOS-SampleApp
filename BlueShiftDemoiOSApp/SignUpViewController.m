//
//  SignUpViewController.m
//  BaseiOSApp-ObjC
//
//  Created by Arjun K P on 12/02/15.
//  Copyright (c) 2015 Arjun K P. All rights reserved.
//

#import "SignUpViewController.h"
#import "AppConstants.h"
#import "UIView+BfViewHelpers.h"
#import <SVProgressHUD/SVProgressHUD.h>
#import "SegueIdentifiers.h"
#import "User.h"

@interface SignUpViewController ()

@end

@implementation SignUpViewController{
    UIImage *checkBoxSelectedImage;
    UIImage *checkBoxUnselectedImage;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self updateTextfieldWithIcons];
    
    checkBoxSelectedImage = [UIImage imageNamed:@"CheckboxSelected.png"];
    checkBoxUnselectedImage = [UIImage imageNamed:@"CheckboxUnSelected.png"];
    
    self.imagePicker = [[UIImagePickerController alloc] init];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)updateTextfieldWithIcons {

}

- (void)viewDidLoadIfDeviceLessThanOrEqualToIPhone5 {
    [self.contentViewWidthConstraint setConstant:kScreenWidthLessThanOrEqualToIPhone5];
    [self.contentView layoutIfNeeded];
}

- (IBAction)termsAndConditionsCheckboxPressed:(id)sender {
    self.isTermsAndConditionsAgreed = !self.isTermsAndConditionsAgreed;
    
    if (self.isTermsAndConditionsAgreed == TRUE) {
        [self.agreeTermsAndConditionsCheckBoxButton setImage: checkBoxSelectedImage forState:UIControlStateNormal];
    }
    else {
        [self.agreeTermsAndConditionsCheckBoxButton setImage:checkBoxUnselectedImage forState:UIControlStateNormal];
    }
}

- (IBAction)uploadProfileButtonPressed:(id)sender{
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        self.imagePicker.delegate = self;
        self.imagePicker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        self.imagePicker.allowsEditing = NO;
        
        [self presentViewController:self.imagePicker animated:YES completion:^{
        }];
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo {
    [self dismissViewControllerAnimated:YES completion:^{
    }];
    
    self.selectedImage = image;
    [self.uploadPhotoButton setBackgroundImage:self.selectedImage forState:UIControlStateNormal];
}

- (IBAction)signInPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:NO];
}

- (IBAction)signUpPressed:(id)sender {
    if (self.isTermsAndConditionsAgreed == FALSE) {
        [[[UIAlertView alloc] initWithTitle:@"Required" message:@"Please Agree to the terms and conditions" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        return ;
    }
    
    if ([self validateTextFields]) {
        
        [SVProgressHUD show];
        NSMutableDictionary *params = [@{
                                         @"user[profile_attributes][first_name]": self.firstNameTextField.text,
                                         @"user[profile_attributes][last_name]": self.lastNameTextField.text,
                                         @"user[email]": self.emailTextField.text,
                                         @"user[password]": self.passwordTextField.text,
                                         @"user[password_confirmation]": self.confirmPasswordTextField.text,
                                         @"user[profile_attributes][contact_number]": self.contactNumberTextField.text,
                                         @"user[profile_attributes][address]":self.addressTextView.text,
                                         } mutableCopy];
        
        [User signUpWithUserDetails:params andPhoto:(UIImage*)self.selectedImage completionHandler:^(BOOL status, BfErrorCode errorCode, NSString *errorMessage) {
            [SVProgressHUD dismiss];
            
            if(status) {
                // Success
                [self.navigationController popToRootViewControllerAnimated:YES];
            } else {
                if(errorCode == BfErrorCodeNetworkError || errorCode == BfErrorCodeUnknownError) {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:errorMessage delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                    [alert show];
                }
            }
        }];
    }
    
}

-(BOOL)validateTextFields
{
    BOOL status = NO;
    NSString *message;
    
    if(![self.emailTextField validateContent:AttributedTextFieldValidateEmail]) {
        message = @"Invalid Email";
    } else if(![self.passwordTextField validateContent:AttributedTextFieldValidateAlphaNumeric]) {
        message = @"Password Required";
    } else if(![self.firstNameTextField validateContent:AttributedTextFieldValidateAlphaNumeric]) {
        message = @"Invalid First Name";
    } else if(![self.lastNameTextField validateContent:AttributedTextFieldValidateAlphaNumeric]) {
        message = @"Invalid Last Name";
    } else if(![self.contactNumberTextField validateContent:AttributedTextFieldValidatePhoneNumber]) {
        message = @"Phone Number Required";
    } else if(![self.passwordTextField.text isEqualToString:self.confirmPasswordTextField.text]) {
        message = @"Password does not match";
    }
    else {
        status = YES;
    }
    
    if(status==NO) {
        [[[UIAlertView alloc] initWithTitle:@"Invalid Field" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    }
    
    return status;
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
