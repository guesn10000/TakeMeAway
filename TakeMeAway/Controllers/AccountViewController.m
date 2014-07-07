//
//  AccountViewController.m
//  TakeMeAway
//
//  Created by Jymn_Chen on 14-5-11.
//  Copyright (c) 2014年 Jymn_Chen. All rights reserved.
//

#import "AccountViewController.h"
#import "AppDelegate.h"
#import "REFrostedViewController.h"
#import "RootTabBarController.h"

@interface AccountViewController ()

@end

@implementation AccountViewController

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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return (section) ? 0 : 4;
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
}

@end
