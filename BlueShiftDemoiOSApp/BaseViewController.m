//
//  BaseViewController.m
//  BaseiOSApp-ObjC
//
//  Created by Arjun K P on 12/02/15.
//  Copyright (c) 2015 Arjun K P. All rights reserved.
//

#import "BaseViewController.h"
#import <ViewDeck/IIViewDeckController.h>
#import "AppConstants.h"
#include "ProductCartViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.baseViewControllerDelegate = self;
    
    //Fix for setting conditions for the screen Width for Iphone Less Than 5 ...
    if (self.view.frame.size.width <= (kScreenWidthLessThanOrEqualToIPhone5 + 2.0f)) {
        if (self.baseViewControllerDelegate) {
            if ([self.baseViewControllerDelegate respondsToSelector:@selector(viewDidLoadIfDeviceLessThanOrEqualToIPhone5)]) {
                [self.baseViewControllerDelegate viewDidLoadIfDeviceLessThanOrEqualToIPhone5];
            }
        }
    }
    
    [self initUIElements];
}

- (void)initUIElements {
    self.borderColor = [UIColor colorWithRed:226.0f/255.0f green:226.0f/255.0f blue:226.0f/255.0f alpha:1.0f];
    if ([[[NSBundle mainBundle] bundleIdentifier]  isEqual: @"com.blueshift.reads"]) {
        self.navigationController.navigationBar.barTintColor = [UIColor colorNamed:@"appColor"];
    } else {
        self.navigationController.navigationBar.barTintColor = [UIColor colorNamed:@"AppColorRed"];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setNavigationBarTitle:(NSString *)title {
    // Code to change the navigation bar title...
}

- (void)pushCartPage {
    //pushing cart page through deckview controller
    
    ProductCartViewController *cartViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:NULL] instantiateViewControllerWithIdentifier:@"ProductCartViewController"];
    [self.navigationController pushViewController:cartViewController animated:YES];
}

@end
