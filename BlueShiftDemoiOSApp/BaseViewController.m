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
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setNavigationBarTitle:(NSString *)title {
    // Code to change the navigation bar title...
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
