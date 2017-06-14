//
//  CancelReturnViewController.m
//  BlueShiftDemoiOSApp
//
//  Created by Arjun K P on 12/03/15.
//  Copyright (c) 2015 Arjun K P. All rights reserved.
//

#import "CancelReturnViewController.h"

@implementation CancelReturnViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"Cancel / Return";
    [self.navigationController setNavigationBarHidden:NO];
    
    BlueShiftProduct *product1 = [[BlueShiftProduct alloc] init];
    [product1 setSku:@"ARJDRG100"];
    [product1 setPrice:100];
    [product1 setQuantity:100];
    
    BlueShiftProduct *product2 = [[BlueShiftProduct alloc] init];
    [product2 setSku:@"SERSGQ100"];
    [product2 setPrice:10];
    [product2 setQuantity:14];
    
    self.productsArray = @[product1, product2];
    
    
    self.products =  @[
                       @{
                           @"sku": @"9780140247732",
                           @"name":@"Death of a Salesman",
                           @"price":@"$20.00",
                           @"image_url":@"https://images.randomhouse.com/cover/9780140247732"
                           },
                       @{
                           @"sku":@"9780140421996",
                           @"name":@"Leaves of Grass",
                           @"price":@"$13.00",
                           @"image_url":@"https://images.randomhouse.com/cover/9780140421996"
                           }

                          ];
    
//    self.productListTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
//    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:0 inSection:0];
//    [self.productListTableView selectRowAtIndexPath:indexPath animated:YES  scrollPosition:UITableViewScrollPositionBottom];
//    [self updateProductsListTableViewUI];
    
}

- (void)updateProductsListTableViewUI {
    [self.productListTableView setBackgroundColor:[UIColor whiteColor]];
    [self.productListTableView setBorderColour:[UIColor whiteColor] andBorderWidth:1.0f];
    [self.productListTableView setSeparatorColor:[UIColor whiteColor]];
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [[BlueShift sharedInstance] trackScreenViewedForViewController:self canBatchThisEvent:YES];
    [[BlueShift sharedInstance] trackProductViewedWithSKU:@"ARJDRG100" andCategoryID:10 canBatchThisEvent:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.products.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *option = self.products[indexPath.row];
    NSString *cellIdentifier = @"ProductCell";
    
    ProductCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.option = option;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120;
}


- (IBAction)cancelButtonPressed:(id)sender {
    [[BlueShift sharedInstance] trackPurchaseCancelForOrderID:@"ORD100" canBatchThisEvent:NO];
}

- (IBAction)returnButtonPressed:(id)sender {
    [[BlueShift sharedInstance] trackPurchaseReturnForOrderID:@"ORD100" andProducts:self.productsArray canBatchThisEvent:NO];
}

@end
