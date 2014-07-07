//
//  ShopItem.h
//  TakeMeAway
//
//  Created by Jymn_Chen on 14-4-23.
//  Copyright (c) 2014年 Jymn_Chen. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Food;

@interface ShopItem : NSObject

@property (strong, nonatomic) Food *food;

@property (assign, nonatomic) NSUInteger quantity;

@property (assign, nonatomic) CGFloat cost;

- (instancetype)initWithFood:(Food *)aFood quantity:(NSUInteger)aQuantity cost:(CGFloat)aCost;

@end
