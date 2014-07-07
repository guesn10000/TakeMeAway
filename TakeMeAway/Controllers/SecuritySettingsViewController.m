//
//  SecuritySettingsViewController.m
//  TakeMeAway
//
//  Created by Jymn_Chen on 14-5-11.
//  Copyright (c) 2014年 Jymn_Chen. All rights reserved.
//

#import "SecuritySettingsViewController.h"

@interface SecuritySettingsViewController ()

@end

@implementation SecuritySettingsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return (section) ? 1 : 3;
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
