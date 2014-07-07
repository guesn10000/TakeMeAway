//
//  AppDelegate.h
//  TakeMeAway
//
//  Created by Jymn_Chen on 14-4-22.
//  Copyright (c) 2014年 Jymn_Chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RootTabBarController;
@class MainSideViewController;
@class REFrostedViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) REFrostedViewController *app_frostedViewController;

@property (strong, nonatomic) RootTabBarController *app_rootTabBarController;

@property (strong, nonatomic) MainSideViewController *app_mainSideViewController;

@property (strong, nonatomic) REFrostedViewController *app_typeFrostedViewController;

+ (instancetype)sharedDelegate;

@end
