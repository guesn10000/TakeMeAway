//
//  OrdersTableViewController.m
//  TakeMeAway
//
//  Created by Jymn_Chen on 14-4-23.
//  Copyright (c) 2014年 Jymn_Chen. All rights reserved.
//

#import "OrdersTableViewController.h"
#import "AppDelegate.h"
#import "Store.h"
#import "Order.h"
#import "OrdersManager.h"
#import "TableDataSource.h"
#import "LocalCache.h"
#import "OrderCell.h"
#import "REFrostedViewController.h"
#import "RootTabBarController.h"

static NSString * const kOrderCellIdentifier      = @"OrderCellIdentifier";
static NSString * const kOrdersToOrderDetailSegue = @"OrdersToOrderDetail_segue";

@interface OrdersTableViewController ()

@property (strong, nonatomic) NSMutableArray  *orders;
@property (strong, nonatomic) TableDataSource *orderDataSource;

@end

@implementation OrdersTableViewController

#pragma mark - View life cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.orders = [NSMutableArray array];
    
    [self setupOrders];
    [self setupTableView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(ordersTableShouldUpdate:)
                                                 name:UIOrdersTableShouldUpdateNotification
                                               object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    RootTabBarController *rootTabController = [AppDelegate sharedDelegate].app_rootTabBarController;
    [rootTabController enableMainSideViewPanGesture];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Data and view setup

- (void)setupOrders {
    // 如果用户没有登录，直接从本地缓存中加载订单列表
    NSArray *tmpOrders = [[OrdersManager defaultManager] loadAllOrders];
    [_orders addObjectsFromArray:tmpOrders];
    
#warning - Unfinished
    // 否则发起网络请求，从网络中获取登录用户的所有订单信息
}

- (void)setupTableView {
    TableViewCellConfigureBlock configureCell = ^(OrderCell *cell, Order *order) {
        [cell configureCellForOrder:order];
    };
    self.orderDataSource = [[TableDataSource alloc] initWithItems:_orders
                                                   cellIdentifier:kOrderCellIdentifier
                                               configureCellBlock:configureCell];
    self.tableView.dataSource = _orderDataSource;
}

#pragma mark - Notification Handlers

- (void)ordersTableShouldUpdate:(NSNotification *)noti {
#warning - Unfinished
    // 如果用户已经登录，那么发起网络请求，从后台中获取完整的订单信息
    
    // 否则从本地数据库中重新加载订单信息
    
    // 刷新列表
}

#pragma mark - UITableViewDataSource

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
 */

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [[ShareDataZone shareDataZone] share_setCurrentOrder:_orders[indexPath.row]];
    
    [self performSegueWithIdentifier:kOrdersToOrderDetailSegue sender:nil];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 150.0;
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    RootTabBarController *rootTabController = [AppDelegate sharedDelegate].app_rootTabBarController;
    [rootTabController unenableMainSideViewPanGesture];
}

#pragma mark - Actions

- (IBAction)openSideMenu:(id)sender {
    [[AppDelegate sharedDelegate].app_frostedViewController presentMenuViewController];
}

@end
