//
//  ShopItem.m
//  TakeMeAway
//
//  Created by Jymn_Chen on 14-4-23.
//  Copyright (c) 2014年 Jymn_Chen. All rights reserved.
//

#import "ShopItem.h"

@implementation ShopItem

- (instancetype)initWithFood:(Food *)aFood quantity:(NSUInteger)aQuantity cost:(CGFloat)aCost {
    self = [super init];
    
    if (self) {
        self.food = aFood;
        self.quantity = aQuantity;
        self.cost = aCost;
    }
    
    return self;
}

@end
