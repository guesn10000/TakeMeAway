//
//  LoginViewController.m
//  TakeMeAway
//
//  Created by Jymn_Chen on 14-4-23.
//  Copyright (c) 2014年 Jymn_Chen. All rights reserved.
//

#import "LoginViewController.h"
#import "AppDelegate.h"
#import "REFrostedViewController.h"
#import "RootTabBarController.h"
#import "MainSideViewController.h"

@interface LoginViewController ()

@property (weak, nonatomic) IBOutlet UITextField *username_textField;
@property (weak, nonatomic) IBOutlet UITextField *password_textField;

@property (strong, nonatomic) IBOutlet UISwipeGestureRecognizer *swipeGesture;

@end

@implementation LoginViewController

#pragma mark - View life cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _swipeGesture.direction = UISwipeGestureRecognizerDirectionDown | UISwipeGestureRecognizerDirectionUp;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return 2;
        case 1:
            return 1;
        case 2:
            return 1;
        default:
            return 0;
    }
}

#pragma mark - Actions

- (IBAction)gobackToMainView:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        REFrostedViewController *controller = [AppDelegate sharedDelegate].app_frostedViewController;
        [controller hideMenuViewController];
        
        RootTabBarController *rootController = [AppDelegate sharedDelegate].app_rootTabBarController;
        [rootController enableMainSideViewPanGesture];
    }];
}

- (IBAction)swipeVertically:(id)sender {
    [_username_textField resignFirstResponder];
    [_password_textField resignFirstResponder];
}

#pragma mark - Login

- (IBAction)loginAction:(id)sender {
#warning - Unfinished
    // 登录功能
    
    // 登录成功后跳转到帐号设置页面
    
}

- (IBAction)loginWithQQ:(id)sender {
#warning - Unfinished
    // QQ登录
}

- (IBAction)loginWithWeibo:(id)sender {
#warning - Unfinished
    // 微博登录
}

- (IBAction)loginWithWeChat:(id)sender {
#warning - Unfinished
    // 微信登录
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
