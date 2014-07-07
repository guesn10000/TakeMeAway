//
//  MainSideViewController.m
//  TakeMeAway
//
//  Created by Jymn_Chen on 14-4-23.
//  Copyright (c) 2014年 Jymn_Chen. All rights reserved.
//

#import "MainSideViewController.h"
#import "AppDelegate.h"
#import "RootTabBarController.h"

static NSString * const kMainSideViewToLoginSegue      = @"MainSideViewToLogin_segue";
static NSString * const kMainSideViewToAccountSegue    = @"MainSideViewToAccount_segue";
static NSString * const kMainSideViewToFavouritesSegue = @"MainSideViewToFavourites_segue";
static NSString * const kMainSideViewToSettingsSegue   = @"MainSideViewToSettings_segue";

@interface MainSideViewController ()
{
    BOOL p_segue;
}
@end

@implementation MainSideViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    p_segue = NO;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    RootTabBarController *rootTabController = [AppDelegate sharedDelegate].app_rootTabBarController;
    [rootTabController unenableMainSideViewPanGesture];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    if (!p_segue) {
        RootTabBarController *rootTabController = [AppDelegate sharedDelegate].app_rootTabBarController;
        [rootTabController enableMainSideViewPanGesture];
    }
}

- (void)viewDidDisappear:(BOOL)animated {
    p_segue = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0:
#warning - Unfinished
            // 如果未登录，跳转到登录页面
            [self performSegueWithIdentifier:kMainSideViewToLoginSegue sender:nil];
            
            // 否则，跳转到个人中心
            // [self performSegueWithIdentifier:kMainSideViewToAccountSegue sender:nil];
            
            break;
        
        case 1:
            [self performSegueWithIdentifier:kMainSideViewToFavouritesSegue sender:nil];
            break;
            
        case 2:
            [self performSegueWithIdentifier:kMainSideViewToSettingsSegue sender:nil];
            break;
            
        default:
            break;
    }
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    p_segue = YES;
}

@end
