//
//  OrdersManager.h
//  TakeMeAway
//
//  Created by Jymn_Chen on 14-5-10.
//  Copyright (c) 2014年 Jymn_Chen. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Order;

@interface OrdersManager : NSObject

+ (instancetype)defaultManager;

- (NSArray *)loadAllOrders;
- (void)addNewOrder;
- (void)updateOrder:(NSString *)aOrderID;
- (void)removeOrder:(NSString *)aOrderID;

@end
