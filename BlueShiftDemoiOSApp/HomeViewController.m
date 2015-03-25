//
//  HomeViewController.m
//  BaseiOSApp-ObjC
//
//  Created by Arjun K P on 12/02/15.
//  Copyright (c) 2015 Arjun K P. All rights reserved.
//

#import "HomeViewController.h"

@interface HomeViewController ()

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"Home";
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES];
    [[BlueShift sharedInstance] trackScreenViewedForViewController:self];
}

- (void)viewDidLoadIfDeviceLessThanOrEqualToIPhone5 {
    [self.contentViewWidthConstraint setConstant:kScreenWidthLessThanOrEqualToIPhone5];
    [self.contentView layoutIfNeeded];
}

- (IBAction)productsButtonPressed:(id)sender {
    [self performSegueWithIdentifier:kSegueShowProductList sender:self];
}

- (IBAction)cancelReturnButtonPressed:(id)sender {
    [self performSegueWithIdentifier:kSegueCancelReturn sender:self];
}

- (IBAction)mailingListSubscriptionButtonPressed:(id)sender {
    [self performSegueWithIdentifier:kSegueMailingSubscription sender:self];
}

- (IBAction)subscriptionEventsButtonPressed:(id)sender {
    [self performSegueWithIdentifier:kSegueSubscriptionEvents sender:self];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    

}


@end
