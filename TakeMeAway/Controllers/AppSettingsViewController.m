//
//  AppSettingsViewController.m
//  TakeMeAway
//
//  Created by Jymn_Chen on 14-4-23.
//  Copyright (c) 2014年 Jymn_Chen. All rights reserved.
//

#import "AppSettingsViewController.h"
#import "AppDelegate.h"
#import "REFrostedViewController.h"
#import "RootTabBarController.h"

@interface AppSettingsViewController ()

@end

@implementation AppSettingsViewController

#pragma mark - View life cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Actions

- (IBAction)goBackToMainView:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        REFrostedViewController *controller = [AppDelegate sharedDelegate].app_frostedViewController;
        [controller hideMenuViewController];
        
        RootTabBarController *rootController = [AppDelegate sharedDelegate].app_rootTabBarController;
        [rootController enableMainSideViewPanGesture];
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
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
