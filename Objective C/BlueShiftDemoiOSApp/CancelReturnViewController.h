//
//  CancelReturnViewController.h
//  BlueShiftDemoiOSApp
//
//  Created by Arjun K P on 12/03/15.
//  Copyright (c) 2015 Arjun K P. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <BlueShift-iOS-SDK/BlueShift.h>
#import "ProductCell.h"
#import "UIView+BfViewHelpers.h"

@interface CancelReturnViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>

@property NSArray *productsArray;
@property NSArray *products;

@property IBOutlet UITableView *productListTableView;

- (IBAction)cancelButtonPressed:(id)sender;
- (IBAction)returnButtonPressed:(id)sender;

@end
