//
//  LocalCache.m
//  TakeMeAway
//
//  Created by Jymn_Chen on 14-4-23.
//  Copyright (c) 2014年 Jymn_Chen. All rights reserved.
//

#import "LocalCache.h"
#import "Location.h"
#import "Store.h"
#import "Order.h"
#import "JCTimer.h"
#import "PersistentStack.h"

@interface LocalCache ()

/*
 * 缓存中的未确认购物车美食列表，形式为：
 * {
 *  商家id1 : 订购的美食列表(NSArray类)
 *  商家id2 : 订购的美食列表(NSArray类)
 * }
 */
@property (strong, readwrite, nonatomic) NSMutableDictionary *unconfirmShoppingList;

/*
 * 记录本机用户的订单历史，形式为：
 * [
 *  订单号1对应的Order类
 *  订单号2对应的Order类
 * ]
 */
@property (strong, nonatomic) NSMutableArray *localOrders;

@end

@implementation LocalCache

#pragma mark - Singleton

+ (instancetype)shareLocalCache {
    static LocalCache *localCache = nil;
    static dispatch_once_t onceToken = 0;
    dispatch_once(&onceToken, ^{
        localCache = [[super allocWithZone:NULL] init];
    });
    
    return localCache;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    return [self shareLocalCache];
}

- (instancetype)copyWithZone:(NSZone *)zone {
    return self;
}

#pragma mark - Unconfirm Orders

- (NSMutableArray *)getUnconfirmShoppingListFromeCache:(NSString *)aStoreID {
#warning - Unfinished
    // 从本地数据库中抓取数据
    
    if (!_unconfirmShoppingList) {
        self.unconfirmShoppingList = [NSMutableDictionary dictionary];
    }
    
    NSArray *shoppingList = _unconfirmShoppingList[aStoreID];
    if (!shoppingList) {
        shoppingList = [NSArray array];
    }
    
    return [shoppingList mutableCopy];
}

- (void)setUnconfirmShoppingListToCache:(NSMutableArray *)aList storeID:(NSString *)aStoreID {
    if (!_unconfirmShoppingList) {
        self.unconfirmShoppingList = [NSMutableDictionary dictionary];
    }
    
    if (aList) {
        self.unconfirmShoppingList[aStoreID] = [NSArray arrayWithArray:aList];
    }
    
#warning - Unfinished
    // 写入本地数据库中
}

- (void)removeUnconfirmShoppingListFromCache:(NSString *)aStoreID {
    if (!_unconfirmShoppingList) {
        self.unconfirmShoppingList = [NSMutableDictionary dictionary];
    }
    
    [_unconfirmShoppingList removeObjectForKey:aStoreID];
    
#warning - Unfinished
    // 写入本地数据库中
}

#pragma mark - Local Orders

- (NSArray *)getLocalOrdersFromCache {
    
#ifdef LOCAL_TEST
    _localOrders = [NSMutableArray array];
    
    Order *order1 = [[Order alloc] initWithID:@"0001" orderTime:@"2014-5-1 10:00:00" storeID:@"0001" expectTime:@"2014-5-1 12:00:00" state:OrderStateOrdered];
    Order *order2 = [[Order alloc] initWithID:@"0002" orderTime:@"2014-4-1 10:00:00" storeID:@"0002" expectTime:@"2014-4-1 12:00:00" state:OrderStateFinish];
    Order *order3 = [[Order alloc] initWithID:@"0003" orderTime:@"2014-3-1 10:00:00" storeID:@"0003" expectTime:@"2014-3-1 12:00:00" state:OrderStateFinish];
    Order *order4 = [[Order alloc] initWithID:@"0004" orderTime:@"2014-2-1 10:00:00" storeID:@"0004" expectTime:@"2014-2-1 12:00:00" state:OrderStateFinish];
    Order *order5 = [[Order alloc] initWithID:@"0005" orderTime:@"2014-1-1 10:00:00" storeID:@"0005" expectTime:@"2014-1-1 12:00:00" state:OrderStateFinish];
    Order *order6 = [[Order alloc] initWithID:@"0006" orderTime:@"2014-1-1 09:00:00" storeID:@"0006" expectTime:@"已取消" state:OrderStateCancel];
    
    [_localOrders addObject:order1];
    [_localOrders addObject:order2];
    [_localOrders addObject:order3];
    [_localOrders addObject:order4];
    [_localOrders addObject:order5];
    [_localOrders addObject:order6];
#else
#warning - Unfinished
    // 从本地数据库中抓取数据
    
    if (!_localOrders) {
        self.localOrders = [NSMutableArray array];
    }
#endif
    
    return _localOrders;
}

- (void)addLocalOrderToCache:(Order *)order {
    if (!_localOrders) {
        self.localOrders = [NSMutableArray array];
    }
    
    [_localOrders addObject:order];
    
#warning - Unfinished
    // 写入本地数据库中
}

- (void)removeLocalOrderFromCache:(Order *)order {
    if (_localOrders) {
        [_localOrders removeObject:order];
        
#warning - Unfinished
        // 写入本地数据库中
    }
}

@end


@interface ShareDataZone ()

@property (strong, readwrite, nonatomic) Location *currentLocation;

@property (strong, readwrite, nonatomic) Store *currentStore;

@property (strong, readwrite, nonatomic) Food *currentFood;

@property (strong, readwrite, nonatomic) Order *currentOrder;

@end

@implementation ShareDataZone

#pragma mark - Singleton

+ (instancetype)shareDataZone {
    static ShareDataZone *dataZone = nil;
    static dispatch_once_t s_onceToken = 0;
    dispatch_once(&s_onceToken, ^{
        dataZone = [[super allocWithZone:NULL] init];
        dataZone.isLocationChanged = NO;
    });
    
    return dataZone;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    return [self shareDataZone];
}

- (instancetype)copyWithZone:(NSZone *)zone {
    return self;
}

#pragma mark - Current Location

- (Location *)share_getCurrentLocation {
    return _currentLocation;
}

- (NSString *)share_getCurrentLocationName {
    return _currentLocation.name;
}

- (void)share_setCurrentLocation:(Location *)aLocation {
    self.currentLocation = aLocation;
    self.isLocationChanged = YES;
}

#pragma mark - Current Store

- (Store *)share_getCurrentStore {
    return _currentStore;
}

- (NSString *)share_getCurrentStoreID {
    return _currentStore.storeID;
}

- (NSString *)share_getCurrentStoreName {
    return _currentStore.name;
}

- (void)share_setCurrentStore:(Store *)aStore {
    self.currentStore = aStore;
}

#pragma mark - Current Food

- (Food *)share_getCurrentFood {
    return _currentFood;
}

- (void)share_setCurrentFood:(Food *)aFood {
    self.currentFood = aFood;
}

#pragma mark - Current Order

- (Order *)share_getCurrentOrder {
    return _currentOrder;
}

- (void)share_setCurrentOrder:(Order *)aOrder {
    self.currentOrder = aOrder;
}

@end
