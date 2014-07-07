//
//  RootTabBarController.m
//  TakeMeAway
//
//  Created by Jymn_Chen on 14-4-28.
//  Copyright (c) 2014年 Jymn_Chen. All rights reserved.
//

#import "RootTabBarController.h"
#import "AppDelegate.h"
#import "Location.h"
#import "REFrostedViewController.h"

@interface RootTabBarController ()

@property (strong, nonatomic) UIView *leftSideView;

@property (strong, nonatomic) UIPanGestureRecognizer *panGesture;

@end

@implementation RootTabBarController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.leftSideView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 64.0, 44.0, self.view.frame.size.height - 114.0)];
#ifdef SIDE_VIEW_LOCAL_TEST
    _leftSideView.backgroundColor = [UIColor greenColor];
    _leftSideView.alpha = 0.1;
#endif
    AppDelegate *appDelegate = [AppDelegate sharedDelegate];
    [appDelegate.window addSubview:_leftSideView];
    
    self.panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panInView:)];
    [_leftSideView addGestureRecognizer:_panGesture];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)panInView:(id)sender {
    REFrostedViewController *controller = [AppDelegate sharedDelegate].app_frostedViewController;
    [controller panGestureRecognized:_panGesture];
}

- (void)enableMainSideViewPanGesture {
    _leftSideView.hidden = NO;
}

- (void)unenableMainSideViewPanGesture {
    _leftSideView.hidden = YES;
}

@end
