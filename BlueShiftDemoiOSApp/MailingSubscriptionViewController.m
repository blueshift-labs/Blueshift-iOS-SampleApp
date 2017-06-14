//
//  MailingSubscriptionViewController.m
//  BlueShiftDemoiOSApp
//
//  Created by Arjun K P on 12/03/15.
//  Copyright (c) 2015 Arjun K P. All rights reserved.
//

#import "MailingSubscriptionViewController.h"

@implementation MailingSubscriptionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"Subscribe Mail";
    [self.navigationController setNavigationBarHidden:NO];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [[BlueShift sharedInstance] trackScreenViewedForViewController:self canBatchThisEvent:YES];
}

- (IBAction)subscribeMailingListPressed:(id)sender {
    [[BlueShift sharedInstance] trackEmailListSubscriptionForEmail:self.emailTextField.text canBatchThisEvent:NO];
}

- (IBAction)unSubscribeMailingListPressed:(id)sender {
    [[BlueShift sharedInstance] trackEmailListUnsubscriptionForEmail:self.emailTextField.text canBatchThisEvent:NO];
}

@end
