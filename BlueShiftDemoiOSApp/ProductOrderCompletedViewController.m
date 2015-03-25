//
//  ProductOrderCompletedViewController.m
//  BlueShiftDemoiOSApp
//
//  Created by Arjun K P on 19/02/15.
//  Copyright (c) 2015 Arjun K P. All rights reserved.
//

#import "ProductOrderCompletedViewController.h"
#import <BlueShift-iOS-SDK/BlueShift.h>

@interface ProductOrderCompletedViewController ()

@end

@implementation ProductOrderCompletedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"Order Confirmed";
    [self.navigationController setNavigationBarHidden:NO];
    
    [[BlueShift sharedInstance] trackProductsPurchased:self.productsArray withOrderID:@"ORD8908" andRevenue:100 andShippingCost:20 andDiscount:40 andCoupon:@"free coupon"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [[BlueShift sharedInstance] trackScreenViewedForViewController:self];
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
