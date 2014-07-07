//
//  Order.m
//  TakeMeAway
//
//  Created by Jymn_Chen on 14-4-23.
//  Copyright (c) 2014年 Jymn_Chen. All rights reserved.
//

#import "Order.h"

@interface Order ()
{
    NSString *p_storeName;
    NSString *p_storeLogoURL;
}

@property (copy, readwrite, nonatomic) NSString *orderID;
@property (copy, readwrite, nonatomic) NSString *storeID;

@property (copy, readwrite, nonatomic) NSString *orderTime;
@property (copy, readwrite, nonatomic) NSString *expectArriveTime;
@property (copy, readwrite, nonatomic) NSString *storeConfirmTime;
@property (copy, readwrite, nonatomic) NSString *finishTime;

@property (assign, readwrite, nonatomic) OrderState currentState;

@property (copy, readwrite, nonatomic) NSArray *menuList;

@end

@implementation Order

#pragma mark - Initialization

- (instancetype)initWithID:(NSString *)aID orderTime:(NSString *)aOrderTime storeID:(NSString *)aStoreID expectTime:(NSString *)anArriveTime state:(OrderState)aState
{
    self = [super init];
    
    if (self) {
        _orderID = [aID copy];
        _orderTime = [aOrderTime copy];
        _storeID = [aStoreID copy];
        _expectArriveTime = [anArriveTime copy];
        _currentState = aState;
        
        _menuList = nil;
        _storeConfirmTime = nil;
        _finishTime = nil;
    }
    
    return self;
}

- (NSString *)getOrderStateContent {
    NSString *state;
    
    switch (_currentState) {
        case OrderStateOrdered:
            state = @"等待商家确认";
            break;
            
        case OrderStateConfirm:
            state = @"配送中";
            break;
            
        case OrderStateFinish:
            state = @"已完成";
            break;
            
        case OrderStateCancel:
            state = @"已取消";
            break;
            
        default:
            break;
    }
    
    return state;
}

#pragma mark - Store Info

- (void)loadStoreInfoWithID:(NSString *)aID {
#warning - Unfinished
    // 以商家的ID从网络获取商家的部分信息，如p_storeName p_storeLogoURL
}

- (NSString *)getStoreName {
    return p_storeName;
}

- (NSURL *)getStoreLogoURL {
    return [NSURL URLWithString:p_storeLogoURL];
}

#pragma mark - Update State

- (void)updateOrderState {
#warning - Unfinished
    // 根据订单的ID发起网络请求，更新当前的状态，并设置当前状态对应的时间
}

@end
