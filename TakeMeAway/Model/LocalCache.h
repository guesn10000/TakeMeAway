//
//  LocalCache.h
//  TakeMeAway
//
//  Created by Jymn_Chen on 14-4-23.
//  Copyright (c) 2014年 Jymn_Chen. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Order;

@interface LocalCache : NSObject

+ (instancetype)shareLocalCache;

- (NSMutableArray *)getUnconfirmShoppingListFromeCache:(NSString *)aStoreID;
- (void)setUnconfirmShoppingListToCache:(NSMutableArray *)aList storeID:(NSString *)aStoreID;
- (void)removeUnconfirmShoppingListFromCache:(NSString *)aStoreID;

- (NSArray *)getLocalOrdersFromCache;
- (void)addLocalOrderToCache:(Order *)order;
- (void)removeLocalOrderFromCache:(Order *)order;

@end


@class Location;
@class Store;
@class Food;
@class Order;

@interface ShareDataZone : NSObject

+ (instancetype)shareDataZone;

@property (assign, readwrite, nonatomic) BOOL isLocationChanged;

- (Location *)share_getCurrentLocation;
- (NSString *)share_getCurrentLocationName;
- (void)share_setCurrentLocation:(Location *)aLocation;

- (Store *)share_getCurrentStore;
- (NSString *)share_getCurrentStoreID;
- (NSString *)share_getCurrentStoreName;
- (void)share_setCurrentStore:(Store *)aStore;

- (Food *)share_getCurrentFood;
- (void)share_setCurrentFood:(Food *)aFood;

- (Order *)share_getCurrentOrder;
- (void)share_setCurrentOrder:(Order *)aOrder;

@end
