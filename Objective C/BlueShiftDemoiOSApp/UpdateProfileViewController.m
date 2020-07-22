//
//  UpdateProfileViewController.m
//  BaseiOSApp-ObjC
//
//  Created by Arjun K P on 12/02/15.
//  Copyright (c) 2015 Arjun K P. All rights reserved.
//

#import "UpdateProfileViewController.h"
#import "AppConstants.h"
#import "UIView+BfViewHelpers.h"
#import <SVProgressHUD/SVProgressHUD.h>
#import "SegueIdentifiers.h"
#import "User.h"
#import <SDWebImage/UIButton+WebCache.h>

@interface UpdateProfileViewController ()

@end

@implementation UpdateProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self updateTextfieldWithIcons];
    [self updateTextFieldWithDetails];
    
    self.imagePicker = [[UIImagePickerController alloc] init];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
}

- (void)viewDidLoadIfDeviceLessThanOrEqualToIPhone5 {
    [self.contentViewWidthConstraint setConstant:kScreenWidthLessThanOrEqualToIPhone5];
    [self.contentView layoutIfNeeded];
}

- (void)updateTextfieldWithIcons {

}

- (void)updateTextFieldWithDetails {
    User *currentUser = [User currentUser];
    [self.emailTextView setText:currentUser.email];
    [self.firstNameTextField setText:currentUser.firstName];
    [self.lastNameTextField setText:currentUser.lastName];
    [self.contactNumberTextField setText:currentUser.phoneNumber];
    [self.addressTextView setText:currentUser.address];
    [self.uploadPhotoButton sd_setBackgroundImageWithURL:[NSURL URLWithString:currentUser.imageUrl]
                                                    forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"UploadProfileIcon.png"] completed:nil];
        
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

- (IBAction)updateButtonPressed:(id)sender {
    if ([self validateTextFields]) {
        
        [SVProgressHUD show];
        NSMutableDictionary *params = [@{
                                         @"user[profile_attributes][first_name]": self.firstNameTextField.text,
                                         @"user[profile_attributes][last_name]": self.lastNameTextField.text,
                                         @"user[profile_attributes][phone_number]": self.contactNumberTextField.text,
                                         @"user[profile_attributes][address]":self.addressTextView.text,
                                         } mutableCopy];
        
        
        [User updateUserDetails:params andPhoto:(UIImage*)self.selectedImage completionHandler:^(BOOL status, BfErrorCode errorCode, NSString *errorMessage) {
            [SVProgressHUD dismiss];
            
            if(status) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Profile is updated successfully" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                [alert show];
                [self.navigationController popViewControllerAnimated:YES];
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
    if(![self.firstNameTextField validateContent:AttributedTextFieldValidateAlphaNumeric]) {
        message = @"Invalid First Name";
    } else if(![self.lastNameTextField validateContent:AttributedTextFieldValidateAlphaNumeric]) {
        message = @"Invalid Last Name";
    } else if(![self.contactNumberTextField validateContent:AttributedTextFieldValidatePhoneNumber]) {
        message = @"Phone Number Required";
    }else if (self.addressTextView.text.length == 0) {
        message = @"Address Required";
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
