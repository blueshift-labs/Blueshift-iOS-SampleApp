//
//  ProductCartViewController.m
//  BaseiOSApp-ObjC
//
//  Created by Arjun K P on 17/02/15.
//  Copyright (c) 2015 Arjun K P. All rights reserved.
//

#import "ProductCartViewController.h"
#import "SegueIdentifiers.h"

@interface ProductCartViewController ()

@end

@implementation ProductCartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[BlueShift sharedInstance] setPushDelegate:self];
    self.navigationItem.title = @"Cart";
    [self.navigationController setNavigationBarHidden:NO];
    
    BlueShiftProduct *product1 = [[BlueShiftProduct alloc] init];
    [product1 setSku:@"PROM001"];
    [product1 setPrice:100];
    [product1 setQuantity:100];

    BlueShiftProduct *product2 = [[BlueShiftProduct alloc] init];
    [product2 setSku:@"SERSGQ100"];
    [product2 setPrice:10];
    [product2 setQuantity:14];

    BlueShiftProduct *product3 = [[BlueShiftProduct alloc] init];
    [product3 setSku:@"FERWER345"];
    [product3 setPrice:105];
    [product3 setQuantity:108];
    
    self.productsArray = @[product1, product2, product3];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [[BlueShift sharedInstance] trackScreenViewedForViewController:self canBatchThisEvent:NO];
    [[BlueShift sharedInstance] trackAddToCartWithSKU:@"PROM002" andQuantity:100 canBatchThisEvent:YES];
}

- (IBAction)continueButtonPressed:(id)sender {
    [[BlueShift sharedInstance] trackCheckOutCartWithProducts:self.productsArray andRevenue:100 andDiscount:40 andCoupon:@"FLAT20" canBatchThisEvent:NO];
    [self performSegueWithIdentifier:kSegueProductOrdered sender:self];
}

- (void)handlePushDictionary:(NSDictionary *)details {
    NSString *mrp = [details objectForKey:@"mrp"];
    NSString *price = [details objectForKey:@"price"];
    NSString *sku = [details objectForKey:@"sku"];
    
    NSString *alertMessage = [NSString stringWithFormat:@"Product Viewed Successfully. \n\n MRP -> %@ \n\n Price -> %@ \n\n SKU -> %@",mrp,price,sku];
    
    [[[UIAlertView alloc] initWithTitle:@"Product Viewed" message:alertMessage delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([segue.identifier isEqualToString:kSegueProductOrdered]) {
        ProductOrderCompletedViewController *destinationViewController = (ProductOrderCompletedViewController *)segue.destinationViewController;
        destinationViewController.productsArray = self.productsArray;
    }
}


@end
