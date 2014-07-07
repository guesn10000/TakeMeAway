//
//  Food.m
//  TakeMeAway
//
//  Created by Jymn_Chen on 14-4-23.
//  Copyright (c) 2014年 Jymn_Chen. All rights reserved.
//

#import "Food.h"

@interface Food ()

@property (copy,   readwrite, nonatomic) NSString   *foodID;
@property (copy,   readwrite, nonatomic) NSString   *name;
@property (assign, readwrite, nonatomic) NSUInteger sales;
@property (assign, readwrite, nonatomic) CGFloat    price;
@property (assign, readwrite, nonatomic) CGFloat    score;
@property (assign, readwrite, nonatomic) NSUInteger state;
@property (copy,   readwrite, nonatomic) NSString   *foodType;

@property (assign, readwrite, nonatomic) NSUInteger     orderedQuantity;
@property (copy,   readwrite, nonatomic) NSString       *detailPhotoURL;
@property (strong, readwrite, nonatomic) NSMutableArray *comments;

@end

@implementation Food

#pragma mark - Initialization

- (instancetype)initWithFoodID:(NSString *)aID
                          name:(NSString *)aName
                         sales:(NSString *)aSales
                         price:(NSString *)aPrice
                         score:(NSString *)aScore
                         state:(NSString *)aState
                      foodType:(NSString *)aType
{
    self = [super init];
    
    if (self) {
        _foodID   = aID;
        _name     = aName;
        _sales    = (NSUInteger)[aSales integerValue];
        _price    = [aPrice floatValue];
        _score    = [aScore floatValue];
        _state    = (NSUInteger)[aState integerValue];
        _foodType = aType;
        
        _orderedQuantity = 0;
        _detailPhotoURL  = nil;
        _comments        = nil;
    }
    
    return self;
}

#pragma mark - Shopping

- (void)addToShoppingList {
    _orderedQuantity++;
}

- (CGFloat)getTotalPrice {
    return _price * _orderedQuantity;
}

#pragma mark - Get details

- (void)getFoodDetails {
#warning - Unfinished
    // 以美食ID从网络获取美食的完整信息，包括_detailPhotoURL和_comments
}

@end
