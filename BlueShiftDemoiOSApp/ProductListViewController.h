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
#import "DeckViewController.h"
#import "BaseViewController.h"

#define kDeviceTokenMailSubject   @"BlueShift Push Device Token"

@interface ProductListViewController : BaseViewController<UITableViewDataSource, UITableViewDelegate, MFMailComposeViewControllerDelegate, IIViewDeckControllerDelegate>

@property IBOutlet UITableView *productListTableView;
@property NSArray *products;

@property UIButton *emailButton;
@property UIButton *cartButton;
@property UIButton *sideMenuButton;
@property IBOutlet AttributedTextField *searchTextField;

- (IBAction)searchButtonPressed:(id)sender;

@end
