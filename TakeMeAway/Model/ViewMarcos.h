//
//  ViewMarcos.h
//  TakeMeAway
//
//  Created by Jymn_Chen on 14-4-27.
//  Copyright (c) 2014年 Jymn_Chen. All rights reserved.
//

#ifndef TakeMeAway_ViewMarcos_h
#define TakeMeAway_ViewMarcos_h

#define StoryboardName @"Main"

#define IntroduceViewController_ID  @"IntroduceViewController_ID"
#define RootNavigationController_ID @"RootNavigationController_ID"
#define RootTabBarController_ID     @"RootTabBarController_ID"
#define MainSideViewController_ID   @"MainSideViewController_ID"
#define FoodTypeSideViewController_ID @"FoodTypeSideViewController_ID"
#define ShoppingViewController_ID   @"ShoppingViewController_ID"

#define StoryboardInitialViewController [[UIStoryboard storyboardWithName:StoryboardName bundle:nil] instantiateInitialViewController]
#define StoryboardViewController(_identifier) [[UIStoryboard storyboardWithName:StoryboardName bundle:nil] instantiateViewControllerWithIdentifier:(_identifier)]

#define ShoppingViews_XIB @"ShoppingViews"
#define FoodCell_XIB @"FoodCell"
#define ShopCell_XIB @"ShopCell"
#define SearchResultCell_XIB @"SearchResultCell"

#endif
