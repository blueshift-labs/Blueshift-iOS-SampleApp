//
//  ProductCartViewController.m
//  BaseiOSApp-ObjC
//
//  Created by Arjun K P on 17/02/15.
//  Copyright (c) 2015 Arjun K P. All rights reserved.
//

#import "ProductCartViewController.h"
#import "SegueIdentifiers.h"
#import "ProductOrderCompletedViewController.h"
#import "Cart.h"
#import "CartTableViewCell.h"
#import "DeckViewController.h"

#define kMinimumScrollHeight    420.0

@interface ProductCartViewController ()
@property NSArray *blueShiftProducts;
@end

@implementation ProductCartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initUIComponents];
    
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
    
    //self.products = @[product1, product2, product3];
    [self populateTableWithItems];
    
    //[[BlueShift sharedInstance] triggerInAppNotification];
    //[[BlueShift sharedInstance] fetchInAppNotificationFromAPI];
    [[BlueShift sharedInstance] fetchInAppNotificationFromAPI:^(void){
        [[BlueShift sharedInstance] displayInAppNotification];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [[BlueShift sharedInstance] registerForInAppMessage: NSStringFromClass([ProductCartViewController class])];
    [[BlueShift sharedInstance] trackScreenViewedForViewController:self canBatchThisEvent:YES];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
     [[BlueShift sharedInstance] unregisterForInAppMessage];
}

- (void)createBlueShiftProducts {
    NSMutableArray *blueShiftProuducts = [[NSMutableArray alloc]init];
    for(NSDictionary *item in self.products) {
        BlueShiftProduct *product = [[BlueShiftProduct alloc] init];
        [product setSku:[item objectForKey:@"sku"]];
        [product setPrice: [[item objectForKey:@"price"] floatValue]];
        [product setQuantity:(NSInteger)[item objectForKey:@"quantity"]];
        [blueShiftProuducts addObject:product];
    }
    self.blueShiftProducts = blueShiftProuducts;
}

- (void)populateTableWithItems {
    self.products = [Cart sharedInstance];
    if(self.products.count > 0) {
        self.cartEmptyView.hidden = true;
    } else {
        self.cartEmptyView.hidden = false;
    }
    [self.itemsTableView reloadData];
    self.scrollViewHeightConstraint.constant = kMinimumScrollHeight + self.itemsTableView.contentSize.height;
    [self calculateTotalPrice];
}

- (void)calculateTotalPrice {
    CGFloat totalPrice = 0.0;
    for (NSDictionary* dictionary in self.products) {
        NSNumber *price = [NSNumber numberWithInt:[[dictionary objectForKey:@"price"] intValue]];
        NSNumber *quanity = [NSNumber numberWithInt:[[dictionary objectForKey:@"quantity"] intValue]];
        CGFloat itemTotal = [price floatValue] * [quanity integerValue];
        totalPrice += itemTotal;
    }
    self.finalTotalLabel.text = [NSString stringWithFormat:@"$ %.2f", totalPrice];
    self.totalLabel.text = [NSString stringWithFormat:@"$ %.2f", totalPrice];
}

- (void)initUIComponents {
    [self.priceView setBorderColour:[UIColor lightGrayColor] andBorderWidth:1.0];
    [self.addressView setBorderColour:[UIColor lightGrayColor] andBorderWidth:1.0];
    [self.priceView setCornerRadius:10.0];
    [self.addressView setCornerRadius:10.0];
}

- (IBAction)continueButtonPressed:(id)sender {
    [[BlueShift sharedInstance] trackCheckOutCartWithProducts:self.blueShiftProducts andRevenue:100 andDiscount:40 andCoupon:@"FLAT20" canBatchThisEvent:NO];
    //[self pushOrderPage];
    [Cart clearCart];
    [[[UIAlertView alloc] initWithTitle:@"Order Confirmed" message:@"Your order placed sucessfully" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    DeckViewController *deckViewController = (DeckViewController*)self.viewDeckController;
    double delayInSeconds = 0.5;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [deckViewController showProduct];
    });
}

- (void)handlePushDictionary:(NSDictionary *)details {
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.products.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *option = self.products[indexPath.row];
    NSString *cellIdentifier = @"CartTableViewCell";
    
    CartTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [cell setCartCell:option];
    cell.delegate = self;
    [cell layoutIfNeeded];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 125;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (void)pushOrderPage {
    //pushing cart page through deckview controller
    
    ProductOrderCompletedViewController *orderViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:NULL] instantiateViewControllerWithIdentifier:@"ProductOrderCompletedViewController"];
    [self.navigationController pushViewController:orderViewController animated:YES];
}

- (void)removeButtonDidTapped:(NSDictionary *)item {
    [Cart removeFromCart:item];
    [self populateTableWithItems];
}

@end
