//
//  OrderDetailViewController.m
//  TakeMeAway
//
//  Created by Jymn_Chen on 14-4-23.
//  Copyright (c) 2014年 Jymn_Chen. All rights reserved.
//

#import "OrderDetailViewController.h"
#import "LocalCache.h"
#import "Order.h"
#import "OrdersManager.h"

static NSString * const kOrderDetailToMenuDetailSegue = @"OrderDetailToMenuDetail_segue";

@interface OrderDetailViewController ()
{
    Order *p_order;
}

@property (weak, nonatomic) IBOutlet UIImageView *orderSucceed_imageView;
@property (weak, nonatomic) IBOutlet UIImageView *waitForConfirm_imageView;
@property (weak, nonatomic) IBOutlet UIImageView *storeConfirm_imageView;
@property (weak, nonatomic) IBOutlet UIImageView *waitForFinishOrder_imageView;
@property (weak, nonatomic) IBOutlet UIImageView *finishOrder_imageView;

@property (weak, nonatomic) IBOutlet UILabel *orderSucceedTime_label;
@property (weak, nonatomic) IBOutlet UILabel *storeConfirmTime_label;
@property (weak, nonatomic) IBOutlet UILabel *finishOrderTime_label;

@end

@implementation OrderDetailViewController

#pragma mark - View life cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    p_order = [[ShareDataZone shareDataZone] share_getCurrentOrder];
    [p_order updateOrderState];
    
#warning - Unfinished
    // 根据当前订单状态设置状态图片和各个状态的时间
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Actions

- (IBAction)openPhoneMenu:(id)sender {
#warning - Unfinished
}

- (IBAction)showMenuDetail:(id)sender {
    [self performSegueWithIdentifier:kOrderDetailToMenuDetailSegue sender:nil];
}

- (IBAction)confirmFinishingOrder:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)cancelOrder:(id)sender {
    [[OrdersManager defaultManager] removeOrder:p_order.orderID];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return (section == 0) ? 2 : 1;
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
