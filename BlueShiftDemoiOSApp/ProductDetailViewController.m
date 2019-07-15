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
    [self inApp];
}

- (void)inApp {
    NSDictionary *dictionary = @{
                                 @"type": @"html",
                                 @"html": @"<!DOCTYPE html><html><body><h1>This is heading 1</h1><h2>This is heading 2</h2><h3>This is heading 3</h3><h4>This is heading 4</h4><h5>This is heading 5</h5><h6>This is heading 6</h6></body></html>",
                                 @"width": @"80",
                                 @"height": @"60",
                                 @"position": @"bottom"
                                 };
    [[BlueShift sharedInstance] createInAppNotification:dictionary];
    
    NSDictionary *dictionary2 = @{
                                 @"type": @"html",
                                 @"html": @"<!DOCTYPE html> <html> <head lang=\"en\"> <meta charset=\"UTF-8\"/> <meta name=\"viewport\" content=\"width=device-width, initial-scale=1, maximum-scale=1\"/> <!-- Slick CSS --> <link rel=\"stylesheet\" href=\"slick.css\"> <link rel=\"stylesheet\" href=\"slick-theme.css\"> <link rel=\"stylesheet\" href=\"pagination.css\"> </head> <body> <div class=\"outer\"> <div class=\"button-close\"> <!-- This is the close button svg. Add the light.svg to this folder and change the image src to 'light.svg' for a lighter (x) --> <a href=\"appboy://close\"><img src=\"dark.svg\" width=\"20px;\"/></a> </div> <div class=\"slick-container\"> <!-- FIRST SLIDE --> <div class=\"slick-slide first\"> <div class=\"top-container\"> <!-- This is the main image. Add your image to this folder and change the image src to the image of your choice. --> <div class=\"main-image\"><img src=\"TRL_Inapp_FullScreen_1000x1600_4.0_Welcome_03.png\" width=\"90%\"></div> </div> <div class=\"bottom-container\"> <p style=\"padding-top: 10%;\"> Personalize your experience and stay up&#8209;to&#8209;date on your favorite shows! </p> </div> </div> <!-- SECOND SLIDE --> <div class=\"slick-slide second\"> <div class=\"top-container\"> <!-- This is the main image. Add your image to this folder and change the image src to the image of your choice. --> <div class=\"main-image\"><img src=\"TRL_Inapp_FullScreen_1000x1600_4.0_Authentication_Prompt_03.png\" width=\"75%\"></div> </div> <div class=\"bottom-container\"> <h3 class=\"header\">Never miss a moment!<br/>Get alerts on:</h3> <ul class=\"messages\"> <li>Early premieres</li> <li>New episodes</li> <li>Digital exclusives</li> </ul> </div> </div> <!-- THIRD SLIDE --> <div class=\"slick-slide third\"> <div class=\"top-container\"> <!-- This is the main image. Add your image to this folder and change the image src to the image of your choice. --> <div class=\"main-image\"><img src=\"TRL_Inapp_FullScreen_1000x1600_4.0_Authentication_Prompt_03.png\" width=\"75%\"></div> </div> <div class=\"bottom-container\"> <h3 style=\"margin: 0;\" class=\"header\">Unlock the full experience!</h3> <p> Sign in with your TV provider now to watch every episode. </p> <p class=\"paren\">(Psst...it's free with your participating TV provider!)</p> </div> </div> <!-- If you would like more slides, copy and paste a slide --> <!-- and insert it in between these lines. Make sure your slide's div has 'slick-slide' as a class. --> </div> <footer> <div class=\"button-one\"> <a><p>GET STARTED</p></a> </div> <div class=\"skip-one\"> <br/> <br/><a onclick=\"appboyBridge.closeMessage();\" class=\"skip-one\" href=\"\">Skip for Now</a> </div> <div class=\"button-two\"> <a href=\"trav-go://iam/optin-push\"><p>YES, PLEASE</p></a> </div> <div class=\"skip-two\"> <br/> <br/><a class=\"skip-two\">Skip for Now</a> </div> <div class=\"button-center\"> <a href=\"trav-go://login\"><p>SIGN IN</p></a> </div> <div class=\"skip-three\"> <a class=\"skip-three\" onclick=\"noLogin()\"> I Don't Have a Log In</a> </div> <div class=\"skip-four\"> <a class=\"skip-four\" onclick=\"appboyBridge.closeMessage();\">Ask Me Later</a> </div> </footer> </div> <script src=\"https://ajax.googleapis.com/ajax/libs/jquery/2.2.4/jquery.min.js\"></script> <!-- Slick JS --> <script src=\"slick.min.js\"></script> <script> function noLogin() { appboyBridge.getUser().setCustomUserAttribute(\"clicked-i-dont-have-a-login\", true); appboyBridge.closeMessage(); } $(document).ready(function(){ // Initialize slick $('.slick-container').slick({ infinite: false, edgeFriction: 0, prevArrow: false, nextArrow: $('.button-one, .skip-two'), dots: true, customPaging : function() { return '<span class=\"slick-dot\"></span>' } }); // Initially hide the \"GOT IT\" button until you reach the last slide $('.button-center').hide(); $('.button-two').hide(); $('.skip-two').hide(); $('.skip-three').hide(); $('.skip-four').hide(); // This event listener changes the footer buttons. When the modal reaches the last slide, // it hides the \"SKIP\" and \"NEXT\" buttons and displays the \"GOT IT!\" button $('.slick-container').on('beforeChange', function(event, slick, currentSlide, nextSlide) { var firstSlide = slick.slideCount -3 var lastSlide = slick.slideCount-1 var secondToLastSlide = slick.slideCount-2 if (slick.slideCount >= 2) { if (currentSlide === firstSlide && nextSlide == secondToLastSlide) { $('.button-two').show(); $('.skip-two').show(); $('.button-one').hide(); $('.skip-one').hide(); } else if (currentSlide === secondToLastSlide && nextSlide == lastSlide) { $('.button-two').hide(); $('.skip-two').hide(); $('.button-one').hide(); $('.button-center').show(); $('.skip-three').show(); $('.skip-four').show(); }else if (currentSlide === secondToLastSlide && nextSlide == firstSlide) { $('.button-two').hide(); $('.skip-two').hide(); $('.button-one').show(); $('.skip-one').show(); $('.button-center').hide(); $('.skip-three').hide(); $('.skip-four').hide(); } else if (currentSlide === lastSlide && nextSlide == secondToLastSlide) { $('.button-two').show(); $('.skip-two').show(); $('.button-one').hide(); $('.button-center').hide(); $('.skip-three').hide(); $('.skip-four').hide(); }; }; }); }); </script> </body> </html>",
                                 @"width": @"90",
                                 @"height": @"90",
                                 @"position": @"center",
                                 @"shadow_backround": @YES
                                 };
    [[BlueShift sharedInstance] createInAppNotification:dictionary2];
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

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [[BlueShift sharedInstance] trackScreenViewedForViewController:self canBatchThisEvent:YES];
    //[[BlueShift sharedInstance] trackProductViewedWithSKU:@"PROM002" andCategoryID:10 canBatchThisEvent:YES];
    //[[BlueShift sharedInstance] trackEventForEventName:@"test1" canBatchThisEvent:NO];
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

@end
