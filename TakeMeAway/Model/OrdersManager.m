//
//  OrdersManager.m
//  TakeMeAway
//
//  Created by Jymn_Chen on 14-5-10.
//  Copyright (c) 2014年 Jymn_Chen. All rights reserved.
//

#import "OrdersManager.h"
#import "JCTimer.h"
#import "Order.h"
#import "Store.h"
#import "LocalCache.h"

@implementation OrdersManager

#pragma mark - Singleton

+ (instancetype)defaultManager {
    static OrdersManager *manager = nil;
    static dispatch_once_t onceToken = 0;
    dispatch_once(&onceToken, ^{
        manager = [[super allocWithZone:NULL] init];
    });
    
    return manager;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    return [self defaultManager];
}

- (instancetype)copyWithZone:(NSZone *)zone {
    return self;
}

#pragma mark - Orders Management

- (NSArray *)loadAllOrders {
#warning - Unfinished
    // 如果用户已经登录，就发起网络请求，从后台中获取订单列表
    
    // 否则，直接从本地缓存中加载订单列表
    return [[LocalCache shareLocalCache] getLocalOrdersFromCache];
}

- (void)addNewOrder {
    // 发起网络请求，让服务器生成订单，并返回生成的订单
    
    // 如果没有登录，将生成的订单并保存到本地数据库中：[[OrdersManager defaultManager] addNewOrder:anOrder];
    
    // 如果已经登录，不要保存订单到本地数据库中，否则可能会泄露用户隐私
}

- (void)updateOrder:(NSString *)aOrderID
{
#warning - Unfinished
}

- (void)removeOrder:(NSString *)aOrderID {
#warning - Unfinished
    // 以Order的ID发起网络请求，取消订单
    
    // 如果是非登录用户，还要在本地缓存中更新订单的状态为已取消
}

@end
