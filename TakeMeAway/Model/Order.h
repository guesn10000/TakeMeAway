//
//  Order.h
//  TakeMeAway
//
//  Created by Jymn_Chen on 14-4-23.
//  Copyright (c) 2014年 Jymn_Chen. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, OrderState) {
    OrderStateOrdered = 0,  // 下单成功
    OrderStateConfirm,      // 商家确认
    OrderStateFinish,       // 完成订单
    OrderStateCancel        // 已取消
};

@interface Order : NSObject

@property (copy, readonly, nonatomic) NSString *orderID;
@property (copy, readonly, nonatomic) NSString *orderTime; // 下订单时间
@property (copy, readonly, nonatomic) NSString *storeID;
@property (copy, readonly, nonatomic) NSString *expectArriveTime; // 预计送达时间
@property (assign, readonly, nonatomic) OrderState currentState;

@property (copy, readonly, nonatomic) NSString *storeConfirmTime; // 订单确认时间
@property (copy, readonly, nonatomic) NSString *finishTime; // 订单完成时间
@property (copy, readonly, nonatomic) NSArray  *menuList;


- (instancetype)initWithID:(NSString *)aID
                 orderTime:(NSString *)aOrderTime
                   storeID:(NSString *)aStoreID
                expectTime:(NSString *)anArriveTime
                     state:(OrderState)aState;

- (NSString *)getOrderStateContent;

- (void)loadStoreInfoWithID:(NSString *)aID;
- (NSString *)getStoreName;
- (NSURL *)getStoreLogoURL;

- (void)updateOrderState;

@end
