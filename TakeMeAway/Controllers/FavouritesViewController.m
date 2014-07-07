//
//  FavouritesViewController.m
//  TakeMeAway
//
//  Created by Jymn_Chen on 14-5-11.
//  Copyright (c) 2014年 Jymn_Chen. All rights reserved.
//

#import "FavouritesViewController.h"
#import "AppDelegate.h"
#import "REFrostedViewController.h"
#import "RootTabBarController.h"

@interface FavouritesViewController ()

@end

@implementation FavouritesViewController

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
