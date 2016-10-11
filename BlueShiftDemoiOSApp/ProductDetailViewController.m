//
//  ProductDetailViewController.m
//  BaseiOSApp-ObjC
//
//  Created by Arjun K P on 17/02/15.
//  Copyright (c) 2015 Arjun K P. All rights reserved.
//

#import "ProductDetailViewController.h"
#import "SegueIdentifiers.h"

@interface ProductDetailViewController ()

@end

@implementation ProductDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"Product View";
    [self.navigationController setNavigationBarHidden:NO];
    [[BlueShift sharedInstance] setPushParamDelegate:self];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [[BlueShift sharedInstance] trackScreenViewedForViewController:self canBatchThisEvent:YES];
    [[BlueShift sharedInstance] trackProductViewedWithSKU:@"PROM002" andCategoryID:10 canBatchThisEvent:YES];
    //[[BlueShift sharedInstance] trackEventForEventName:@"test1" canBatchThisEvent:NO];
    NSDictionary *params = @{
                             @"name":@"shahas",
                             @"des":@"soft:engg"
                             };
    [[BlueShift sharedInstance] trackEventForEventName:@"test1" andParameters:@{@"param1" : @"value1",
                                                                                @"param2" : @[@"arr1", @"arr2"]} canBatchThisEvent:NO];
}


- (void)handlePushDictionary:(NSDictionary *)details {
    NSString *mrp = [details objectForKey:@"mrp"];
    NSString *price = [details objectForKey:@"price"];
    NSString *sku = [details objectForKey:@"sku"];
    
    NSString *alertMessage = [NSString stringWithFormat:@"Product Viewed Successfully. \n\n MRP -> %@ \n\n Price -> %@ \n\n SKU -> %@",mrp,price,sku];
    
    [[[UIAlertView alloc] initWithTitle:@"Product Viewed" message:alertMessage delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)buyButtonPressed:(id)sender {
    [self performSegueWithIdentifier:kSegueShowProductCart sender:self];
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
