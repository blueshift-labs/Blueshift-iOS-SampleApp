//
//  ProductListViewController.h
//  BaseiOSApp-ObjC
//
//  Created by Arjun K P on 17/02/15.
//  Copyright (c) 2015 Arjun K P. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProductCell.h"
#import "AttributedTextField.h"
#import <MessageUI/MFMailComposeViewController.h>

#define kDeviceTokenMailSubject   @"BlueShift Push Device Token"

@interface ProductListViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, MFMailComposeViewControllerDelegate>

@property IBOutlet UITableView *productListTableView;
@property NSArray *products;

@property UIButton *emailButton;

@property IBOutlet AttributedTextField *searchTextField;

- (IBAction)searchButtonPressed:(id)sender;

@end
