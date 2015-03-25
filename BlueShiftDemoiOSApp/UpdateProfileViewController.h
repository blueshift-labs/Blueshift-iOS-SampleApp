//
//  UpdateProfileViewController.h
//  BaseiOSApp-ObjC
//
//  Created by Arjun K P on 12/02/15.
//  Copyright (c) 2015 Arjun K P. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "AttributedTextField.h"
#import "AttributedTextView.h"


@interface UpdateProfileViewController : UIViewController<UIImagePickerControllerDelegate>

@property IBOutlet NSLayoutConstraint *contentViewWidthConstraint;

@property IBOutlet UIView *contentView;
@property IBOutlet UIScrollView *scrollView;
@property IBOutlet UIButton *uploadPhotoButton;

@property IBOutlet AttributedTextView *emailTextView;
@property IBOutlet AttributedTextField *firstNameTextField;
@property IBOutlet AttributedTextField *lastNameTextField;
@property IBOutlet AttributedTextField *contactNumberTextField;
@property IBOutlet AttributedTextView *addressTextView;

@property UIImagePickerController *imagePicker;
@property UIImage *selectedImage;

- (IBAction)uploadProfileButtonPressed:(id)sender;
- (IBAction)updateButtonPressed:(id)sender;

@end
