//
//  AppDelegate.m
//  TakeMeAway
//
//  Created by Jymn_Chen on 14-4-22.
//  Copyright (c) 2014年 Jymn_Chen. All rights reserved.
//

#import "AppDelegate.h"
#import "JCUserDefaults.h"
#import "IntroduceViewController.h"
#import "REFrostedViewController.h"
#import "PersistentStack.h"

@interface AppDelegate ()

@property (weak, nonatomic) IntroduceViewController *app_introduceViewController;

@end

@implementation AppDelegate
@synthesize app_introduceViewController = _app_introduceViewController;

+ (instancetype)sharedDelegate {
    return [UIApplication sharedApplication].delegate;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    NSString *isAppInitialize = (NSString *)[JCUserDefaults objectForKey:kAppInitialize];
    if (!isAppInitialize || [isAppInitialize isEqualToString:@"YES"]) { // 初次载入，进入app介绍页面
        self.app_introduceViewController = (IntroduceViewController *)StoryboardViewController(IntroduceViewController_ID);
        self.window.rootViewController = _app_introduceViewController;
    }
    else {
        UINavigationController *rootViewController = (UINavigationController *)StoryboardViewController(RootNavigationController_ID);
        self.window.rootViewController = rootViewController;
    }
    
    self.app_rootTabBarController = (RootTabBarController *)StoryboardViewController(RootTabBarController_ID);
    self.app_mainSideViewController = (MainSideViewController *)StoryboardViewController(MainSideViewController_ID);
    self.app_frostedViewController = [[REFrostedViewController alloc] initWithContentViewController:(UIViewController *)_app_rootTabBarController menuViewController:(UIViewController *)_app_mainSideViewController];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    [[PersistentStack sharedPersistentStack] save:NULL];
}

@end
