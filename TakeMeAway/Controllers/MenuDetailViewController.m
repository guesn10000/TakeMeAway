//
//  MenuDetailViewController.m
//  TakeMeAway
//
//  Created by Jymn_Chen on 14-5-10.
//  Copyright (c) 2014年 Jymn_Chen. All rights reserved.
//

#import "MenuDetailViewController.h"
#import "Food.h"
#import "TableDataSource.h"
#import "ShopCell.h"

static NSString * const kShopCellIdentifier = @"ShopCellIdentifier";

@interface MenuDetailViewController () <UITableViewDelegate>

@property (weak, readwrite, nonatomic) IBOutlet UITableView *menuList_tableView;
@property (weak, readwrite, nonatomic) IBOutlet UILabel *totalPrice_label;

@property (copy, readwrite, nonatomic) NSArray *menuList;
@property (strong, readwrite, nonatomic) TableDataSource *menuListDataSource;

@end

@implementation MenuDetailViewController

#pragma mark - View life cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupFoods];
    [self setupTableView];
    [self setupTotalPrice];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Setup foods and table view

- (void)setupFoods {
    
#ifdef LOCAL_TEST
    Food *food1 = [[Food alloc] initWithFoodID:@"0001" name:@"叉烧粉" sales:@"100" price:@"10" score:@"4.5" state:@"1" foodType:@"粉"];
    Food *food2 = [[Food alloc] initWithFoodID:@"0002" name:@"锅烧粉" sales:@"200" price:@"10" score:@"4.4" state:@"1" foodType:@"粉"];
    Food *food3 = [[Food alloc] initWithFoodID:@"0003" name:@"瘦肉粉" sales:@"300" price:@"10" score:@"4.3" state:@"1" foodType:@"粉"];
    [food1 addToShoppingList];
    [food2 addToShoppingList];
    [food3 addToShoppingList];
    [food1 addToShoppingList];
    [food2 addToShoppingList];
    [food3 addToShoppingList];
    
    self.menuList = @[food1, food2, food3];
#else
#warning - Unfinished
    // 根据订单ID发起网络请求，获取该订单的美食列表，并赋值给menuList
#endif
    
}

- (void)setupTableView {
    [_menuList_tableView registerNib:[ShopCell nib] forCellReuseIdentifier:kShopCellIdentifier];
    
    TableViewCellConfigureBlock configureCell = ^(ShopCell *cell, Food *item) {
        [cell configureCellForShopItem:item];
    };
    
    self.menuListDataSource = [[TableDataSource alloc] initWithItems:_menuList
                                                      cellIdentifier:kShopCellIdentifier
                                                  configureCellBlock:configureCell];
    self.menuList_tableView.dataSource = _menuListDataSource;
}

- (void)setupTotalPrice {
    CGFloat totalPrice = 0.0f;
    for (Food *food in _menuList) {
        totalPrice += [food getTotalPrice];
    }
    _totalPrice_label.text = [NSString stringWithFormat:@"%.2f元", totalPrice];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44.0;
}

#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
}

@end
