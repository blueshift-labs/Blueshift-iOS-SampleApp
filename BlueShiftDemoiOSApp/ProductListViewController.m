//
//  ProductListViewController.m
//  BaseiOSApp-ObjC
//
//  Created by Arjun K P on 17/02/15.
//  Copyright (c) 2015 Arjun K P. All rights reserved.
//

#import "ProductListViewController.h"
#import "SegueIdentifiers.h"
#import "UIView+BfViewHelpers.h"
#import <BlueShift-iOS-SDK/BlueShift.h>
#import "ProductDetailViewController.h"
#import "Cart.h"

@interface ProductListViewController ()
@property NSDictionary *selectedData;
@end

@implementation ProductListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"Product List";
    [self addNavigationBarButtons];
    [self addSideMenuButtonToNavigationBar];
    
    self.products =  [Cart fetchProducts];
    
//        if ([[NSUserDefaults standardUserDefaults] integerForKey:@"FreshInstal"]==0) {
//            NSDictionary *details = @{
//                                      @"App install":@"SBL",
//                                      };
//            [[BlueShift sharedInstance] trackEventForEventName:@"bsft_newinstalls" andParameters:details canBatchThisEvent:YES];
//            [[NSUserDefaults standardUserDefaults] setInteger:121 forKey:@"FreshInstal"];
//            [[NSUserDefaults standardUserDefaults]synchronize];
//        }
    
}



- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [self.productListTableView reloadData];
}

- (void)addNavigationBarButtons {
    UIBarButtonItem *emailButton = [self addEmailButtonToNavigationBar];
    UIBarButtonItem *cartButton = [self addCartBttonToNavigationBar];
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:emailButton,cartButton,nil];
}

- (UIBarButtonItem *)addEmailButtonToNavigationBar {
    self.emailButton = [[UIButton alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 25.0f, 25.0f)];
    [self.emailButton setBackgroundImage:[UIImage imageNamed:@"EmailIcon.png"] forState:UIControlStateNormal];
    [self.emailButton addTarget:self action:@selector(mailButtonPressedAction) forControlEvents:UIControlEventTouchUpInside];
    
    return [[UIBarButtonItem alloc] initWithCustomView:self.emailButton];
}

- (UIBarButtonItem *)addCartBttonToNavigationBar {
    self.cartButton = [[UIButton alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 25.0f, 25.0f)];
    [self.cartButton setBackgroundImage:[UIImage imageNamed:@"cartIcon"] forState:UIControlStateNormal];
    [self.cartButton addTarget:self action:@selector(cartButtonPressedAction) forControlEvents:UIControlEventTouchUpInside];
    
    return [[UIBarButtonItem alloc] initWithCustomView:self.cartButton];
}

- (void)addSideMenuButtonToNavigationBar {
    self.sideMenuButton = [[UIButton alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 25.0f, 25.0f)];
    [self.sideMenuButton setBackgroundImage:[UIImage imageNamed:@"sideMenu"] forState:UIControlStateNormal];
    [self.sideMenuButton addTarget:self action:@selector(sideMenuButtonAction) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.sideMenuButton];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)updateProductionListTableViewUI {
    [self.productListTableView setBackgroundColor:[UIColor whiteColor]];
    [self.productListTableView setBorderColour:[UIColor whiteColor] andBorderWidth:1.0f];
    [self.productListTableView setSeparatorColor:[UIColor whiteColor]];
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    //[[BlueShiftUserInfo sharedInstance] setUnsubscribed:NO];
    [[BlueShiftUserInfo sharedInstance] save];
    [self.navigationController setNavigationBarHidden:NO];
    [[BlueShift sharedInstance] trackScreenViewedForViewController:self canBatchThisEvent:YES];
    [self.productListTableView reloadData];
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
    [cell layoutIfNeeded];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *option = self.products[indexPath.row];
    self.selectedData = option;
    [[BlueShift sharedInstance] trackProductViewedWithSKU:[option objectForKey:@"sku"] andCategoryID:indexPath.row canBatchThisEvent:NO];
    [self performSegueWithIdentifier:kSegueShowProductDetail sender:self];
}

- (IBAction)searchButtonPressed:(id)sender {
    NSArray *skuArray = @[@"78656F",@"AE5643",@"HJU766"];
    [[BlueShift sharedInstance] trackProductSearchWithSkuArray:skuArray andNumberOfResults:4 andPageNumber:1 andQuery:self.searchTextField.text andFilters:@{@"filter1":@"values", @"filter2":@"values"} canBatchThisEvent:NO];
}

- (NSString *)messageBody
{
    NSMutableString *message = [NSMutableString stringWithFormat:@"\n\n Your Device Token is %@ ", [[BlueShift sharedInstance] getDeviceToken]];
    return [message copy];
}

- (void) toggleLeftViewAnimated:(BOOL)animated {
    if (self.viewDeckController != NULL) {
        [self.viewDeckController toggleLeftViewAnimated:animated completion:^(IIViewDeckController *controller, BOOL status) {
            if (status == YES ) {
                //[self.greyFadeView setHidden:NO];
            }
        }];
    }
}

- (void)sideMenuButtonAction {
    [self toggleLeftViewAnimated:YES];
}
- (void)mailButtonPressedAction {
    if ([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController* controller = [[MFMailComposeViewController alloc] init];
        controller.mailComposeDelegate = self;
        //[controller setToRecipients:@[kTripFeedbackContactMailId]];
        [controller setSubject:kDeviceTokenMailSubject];
        [controller setMessageBody:[self messageBody] isHTML:NO];
        if (controller){
            [self presentViewController:controller animated:YES completion:nil];
        }
        
    }
    else {
        [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Your Device is not configured to send Email" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    }
}

- (void)cartButtonPressedAction {
    [self pushCartPage];
}

#pragma mark - Mail Delegates

-(void)mailComposeController:(MFMailComposeViewController *)controller
         didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error{
    NSString *title = @"Error";
    NSString *message = @"Unknown Error";
    if (result == MFMailComposeResultSent) {
        title = @"Mail Sent";
        message = @"Your Device Token has been sent successfully";
    }
    else if(result==MFMailComposeResultCancelled) {
        title = @"Mail Cancelled";
        message = @"Your mail has been cancelled";
    }
    else if(result==MFMailComposeResultFailed) {
        title = @"Mail Composing Failed";
        message = @"Mail Composing Failed";
    }
    else if(result==MFMailComposeResultSaved) {
        title = @"Mail Saved";
        message = @"Your Mail has been saved";
    }
    [[[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    ProductDetailViewController *destinationController = segue.destinationViewController;
    destinationController.data = self.selectedData;
}


@end
