//
//  ConfirmOrderViewController.m
//  TakeMeAway
//
//  Created by Jymn_Chen on 14-4-23.
//  Copyright (c) 2014年 Jymn_Chen. All rights reserved.
//

#import "ConfirmOrderViewController.h"
#import "JCAlert.h"
#import "AppDelegate.h"
#import "OrdersManager.h"
#import "REFrostedViewController.h"

@interface ConfirmOrderViewController ()

@property (strong, nonatomic) IBOutlet UISwipeGestureRecognizer *swipeGesture;

@property (weak, nonatomic) IBOutlet UILabel     *destinationAddress_label;
@property (weak, nonatomic) IBOutlet UITextField *receiverTelephone_textField;
@property (weak, nonatomic) IBOutlet UILabel     *expectTime_label;
@property (weak, nonatomic) IBOutlet UITextField *orderRemark_textField;
@property (weak, nonatomic) IBOutlet UILabel     *payment_label;

@end

@implementation ConfirmOrderViewController

#pragma mark - View life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _swipeGesture.direction = UISwipeGestureRecognizerDirectionDown | UISwipeGestureRecognizerDirectionUp;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Actions

- (IBAction)confirmOrder:(id)sender {
    [JCAlert alertWithMessage:@"下单成功，我们将尽快为您配送"];
    
    // 生成新的订单
    [[OrdersManager defaultManager] addNewOrder];
    
    // 同时提醒OrdersTableViewController刷新列表
    [[NSNotificationCenter defaultCenter] postNotificationName:UIOrdersTableShouldUpdateNotification object:nil];
    
    // 清空缓存中购物车的购物清单
    [[NSNotificationCenter defaultCenter] postNotificationName:UIOrderDidConfirmNotification object:nil];
    
    REFrostedViewController *frostedController = [AppDelegate sharedDelegate].app_frostedViewController;
    [frostedController dismissViewControllerAnimated:YES completion:^{
        [self.navigationController popToRootViewControllerAnimated:NO];
    }];
}

- (IBAction)swipeVertically:(id)sender {
    [_receiverTelephone_textField resignFirstResponder];
    [_orderRemark_textField resignFirstResponder];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger rows = 0;
    switch (section) {
        case 0:
            rows = 2;
            break;
            
        case 1:
            rows = 2;
            break;
            
        case 2:
            rows = 1;
            break;
            
        case 3:
            rows = 1;
            break;
            
        default:
            break;
    }
    
    return rows;
}

@end
