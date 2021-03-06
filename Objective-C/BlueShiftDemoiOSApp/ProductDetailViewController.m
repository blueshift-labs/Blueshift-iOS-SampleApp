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
#import "Cart.h"

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

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [[BlueShift sharedInstance] trackScreenViewedForViewController:self canBatchThisEvent:YES];
    [[BlueShift sharedInstance] registerForInAppMessage: NSStringFromClass([ProductDetailViewController class])];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [[BlueShift sharedInstance] unregisterForInAppMessage];
}

- (UIViewController*)topViewController {
    return [self topViewControllerWithRootViewController:[UIApplication sharedApplication].keyWindow.rootViewController];
}

-(UIViewController*)topViewControllerWithRootViewController:(UIViewController*)viewController {
    if ([self isKindOfClass:[UITabBarController class]]){
        UITabBarController *tabBarController = (UITabBarController *)viewController;
        return [self topViewControllerWithRootViewController:tabBarController.selectedViewController];
    }
    else if ([self isKindOfClass:[UINavigationController class]]){
        UINavigationController *navigationController = (UINavigationController *)viewController;
        return [self topViewControllerWithRootViewController: navigationController.visibleViewController];
    }
    else if (self.presentedViewController){
        return [self topViewControllerWithRootViewController: viewController.presentedViewController];
    }
    else if (self.childViewControllers.count > 0){
        return [self topViewControllerWithRootViewController: viewController.childViewControllers.lastObject];
    }
    
    return viewController;
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
    self.priceLabel.text = [NSString stringWithFormat:@"$ %@", [self.data objectForKey:@"price"]];
    self.skuLabel.text = [self.data objectForKey:@"sku"];
    self.pickerView.hidden = true;
    [self.quantityButton setBorderColour:[UIColor blackColor] andBorderWidth:1.0];
    [self.quantityButton setCornerRadius:5.0];
}

- (void)tapGestureAction {
    self.pickerView.hidden = true;
    self.tapGesture.enabled = false;
}


- (void)fetchProductID:(NSString *)productID {
    if(productID) {
        self.data = [Cart fetchProduct:productID];
    }

}

/*
- (void)handlePushDictionary:(NSDictionary *)details {
    NSString *sku = [details objectForKey:@"product_id"];
    if(sku) {
        self.data = [Cart fetchProduct:sku];
    }
}

 */

- (void)handleCarouselPushDictionary:(NSDictionary *)details withSelectedIndex:(NSInteger)index {
    NSArray *carouselItems = [details objectForKey:@"carousel_elements"];
    NSDictionary *selectedItem = [carouselItems objectAtIndex:index];
    NSString *sku = [selectedItem objectForKey:@"product_id"];
    if(sku) {
        self.data = [Cart fetchProduct:sku];
    }
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
    NSMutableDictionary *dictionary = [self.data mutableCopy];
    [dictionary setObject:[NSNumber numberWithInteger:self.quantity] forKey:@"quantity"];
    [Cart addToCard:dictionary];
}

- (IBAction)gotoCartButtonDidPressed:(id)sender {
    [self pushCartPage];
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

- (IBAction)wishListButtonPressed:(id)sender {

}

@end
