//
//  User.h
//  TakeMeAway
//
//  Created by Jymn_Chen on 14-5-10.
//  Copyright (c) 2014年 Jymn_Chen. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, UserType) {
    UserTypeNormal = 0,
    UserTypeQQ,
    UserTypeWeChat,
    UserTypeWeibo
};

@interface User : NSObject

@property (copy, nonatomic) NSString *username;
@property (copy, nonatomic) NSString *password;
@property (assign, nonatomic) UserType userType;
@property (assign, nonatomic) NSUInteger score; // 积分

@property (copy, nonatomic) NSString *thumbnailURL; // 头像URL
@property (copy, nonatomic) NSString *backgroundURL; // 背景URL

@property (strong, nonatomic) NSMutableArray *favouriteFoods;
@property (strong, nonatomic) NSMutableArray *favouriteStores;

@end
