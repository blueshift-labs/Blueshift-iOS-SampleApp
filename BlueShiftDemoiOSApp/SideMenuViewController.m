//
//  SideMenuViewController.m
//  BaseiOSApp-ObjC
//
//  Created by Arjun K P on 12/02/15.
//  Copyright (c) 2015 Arjun K P. All rights reserved.
//

#import "SideMenuViewController.h"
#import "DeckViewController.h"
#import "SideMenuCell.h"

@interface SideMenuViewController ()

@end

@implementation SideMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    /*
        Side Menu Option Format ...
        @{@"title": @"Option Title", @"action": @"showFunctionName", @"image": @"optionImage", @"cellType":@"SideMenuCell"},
    */
    NSDictionary *option1 = @{
                              @"title":@"Live Content",
                              @"action":@"showLiveContent"
                              };
    NSDictionary *option2 = @{
                              @"title":@"Return/Cancel",
                              @"action":@"showCancelReturn"
                              };
    NSDictionary *option3 = @{
                              @"title":@"Mailing list subscription",
                              @"action":@"showMailSubscription"
                              };
    NSDictionary *option4 = @{
                              @"title":@"Subscription Event",
                              @"action":@"showSubscriptionEvent"
                              };
    NSDictionary *option5 = @{
                              @"title":@"Logout",
                              @"action":@"logout"
                              };
    
    self.options =  @[
                      option1, option2, option3, option4, option5
                      ];
    /*
    self.menuTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:0 inSection:0];
    [self.menuTableView selectRowAtIndexPath:indexPath animated:YES  scrollPosition:UITableViewScrollPositionBottom];
     */
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.options.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *option = self.options[indexPath.row];
    
    SideMenuCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SideMenuCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [cell setOption:option];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *selectedOption = self.options[indexPath.row];
    if ([[selectedOption valueForKey:@"action"] isEqualToString:@""]) {
        return ;
    }
    
    DeckViewController *deckViewController = (DeckViewController*)self.viewDeckController;
    [deckViewController closeLeftViewAnimated:YES];
    
    // The proper way to call a method by name as NSString
    SEL action = NSSelectorFromString([selectedOption valueForKey:@"action"]);
    IMP actionMethod = [deckViewController methodForSelector:action];
    void (*actionFunc)(id,SEL) = (void*)actionMethod;
    actionFunc(deckViewController, action);
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
