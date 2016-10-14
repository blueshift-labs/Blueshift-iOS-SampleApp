//
//  ProductDetailViewController.m
//  BaseiOSApp-ObjC
//
//  Created by Arjun K P on 17/02/15.
//  Copyright (c) 2015 Arjun K P. All rights reserved.
//

#import "ProductDetailViewController.h"
#import "SegueIdentifiers.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "UIView+BfViewHelpers.h"

@interface ProductDetailViewController ()
@property NSInteger quantity;
@property UITapGestureRecognizer *tapGesture;
@end

@implementation ProductDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"Product View";
    [self.navigationController setNavigationBarHidden:NO];
    [[BlueShift sharedInstance] setPushParamDelegate:self];
    [self initUIComponents];
    self.quantity = 1;
    [self createTapGesture];
}

- (void)createTapGesture {
    self.tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self  action:@selector(tapGestureAction)];
    self.tapGesture.numberOfTapsRequired = 1;
    [self.tapGesture setDelegate:self];
    
    [self.view addGestureRecognizer:self.tapGesture];
    
    self.tapGesture.enabled = false;
}

- (void)initUIComponents {
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:[self.data objectForKey:@"image_url"]] placeholderImage:[UIImage imageNamed:@"BookPlaceholder"]];
    self.nameLabel.text = [self.data objectForKey:@"name"];
    self.priceLabel.text = [self.data objectForKey:@"price"];
    self.skuLabel.text = [self.data objectForKey:@"sku"];
    self.pickerView.hidden = true;
    [self.quantityButton setBorderColour:[UIColor blackColor] andBorderWidth:1.0];
    [self.quantityButton setCornerRadius:5.0];
}

- (void)tapGestureAction {
    self.pickerView.hidden = true;
    self.tapGesture.enabled = false;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [[BlueShift sharedInstance] trackScreenViewedForViewController:self canBatchThisEvent:YES];
    //[[BlueShift sharedInstance] trackProductViewedWithSKU:@"PROM002" andCategoryID:10 canBatchThisEvent:YES];
    //[[BlueShift sharedInstance] trackEventForEventName:@"test1" canBatchThisEvent:NO];
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

- (IBAction)quantityButtonDidPressed:(id)sender {
    if(self.pickerView.hidden) {
        self.tapGesture.enabled = true;
        self.pickerView.hidden = false;
    } else {
        self.pickerView.hidden = true;
    }
}

- (IBAction)addToCartButtonDidPressed:(id)sender {
    [[BlueShift sharedInstance] trackAddToCartWithSKU:[self.data objectForKey:@"sku"] andQuantity:self.quantity canBatchThisEvent:NO];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)thePickerView {
    
    return 1;//Or return whatever as you intend
}

- (NSInteger)pickerView:(UIPickerView *)thePickerView numberOfRowsInComponent:(NSInteger)component {
    
    return 10;//Or, return as suitable for you...normally we use array for dynamic
}

- (NSString *)pickerView:(UIPickerView *)thePickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [NSString stringWithFormat:@"%ld",(long)row + 1];//Or, your suitable title; like Choice-a, etc.
}

- (void)pickerView:(UIPickerView *)thePickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    //Here, like the table view you can get the each section of each row if you've multiple sections
    [self.quantityButton setTitle:[NSString stringWithFormat:@"Quanity:%ld", row + 1] forState:UIControlStateNormal];
    [self.quantityButton setTitle:[NSString stringWithFormat:@"Quanity:%ld", row + 1] forState:UIControlStateSelected];
    [self.quantityButton setTitle:[NSString stringWithFormat:@"Quanity:%ld", row + 1] forState:UIControlStateHighlighted];
    self.quantity = row + 1;
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
