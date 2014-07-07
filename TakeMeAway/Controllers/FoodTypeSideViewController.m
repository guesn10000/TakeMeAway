//
//  FoodTypeSideViewController.m
//  TakeMeAway
//
//  Created by Jymn_Chen on 14-4-23.
//  Copyright (c) 2014年 Jymn_Chen. All rights reserved.
//

#import "FoodTypeSideViewController.h"
#import "AppDelegate.h"
#import "REFrostedViewController.h"

static NSString * const kFoodTypeCellIdentifier = @"FoodTypeCellIdentifier";

@interface FoodTypeSideViewController ()
{
    REFrostedViewController *p_frostedViewController;
}

/*
 * 食物种类分类列表数据由后台返回
 */
@property (copy, nonatomic) NSArray *foodTypes;

@end

@implementation FoodTypeSideViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadFoodTypes];
    
    p_frostedViewController = [AppDelegate sharedDelegate].app_typeFrostedViewController;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)loadFoodTypes {
#ifdef LOCAL_TEST
    self.foodTypes = @[@"粥", @"粉", @"面", @"饭"];
#else
#warning - Unfinished
    // 以美食分类名，从ShoppingViewController的数组过滤，得到要展示的数据
#endif
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _foodTypes.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kFoodTypeCellIdentifier forIndexPath:indexPath];
    
    cell.textLabel.text = _foodTypes[indexPath.row];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [p_frostedViewController hideMenuViewController];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
