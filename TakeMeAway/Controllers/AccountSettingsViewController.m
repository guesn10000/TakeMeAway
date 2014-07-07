//
//  AccountSettingsViewController.m
//  TakeMeAway
//
//  Created by Jymn_Chen on 14-4-23.
//  Copyright (c) 2014年 Jymn_Chen. All rights reserved.
//

#import "AccountSettingsViewController.h"
#import "AppDelegate.h"
#import "REFrostedViewController.h"
#import "RootTabBarController.h"

@interface AccountSettingsViewController ()

@end

@implementation AccountSettingsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)goBackToMainView:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        REFrostedViewController *controller = [AppDelegate sharedDelegate].app_frostedViewController;
        [controller hideMenuViewController];
        
        RootTabBarController *rootController = [AppDelegate sharedDelegate].app_rootTabBarController;
        [rootController enableMainSideViewPanGesture];
    }];
}

- (IBAction)quitLogin:(id)sender {
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return (section == 0) ? 4 : 1;
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
