//
//  Food.h
//  TakeMeAway
//
//  Created by Jymn_Chen on 14-4-23.
//  Copyright (c) 2014年 Jymn_Chen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Food : NSObject

#pragma mark -

- (instancetype)initWithFoodID:(NSString *)aID
                          name:(NSString *)aName
                         sales:(NSString *)aSales
                         price:(NSString *)aPrice
                         score:(NSString *)aScore
                         state:(NSString *)aState
                      foodType:(NSString *)aType;

/* 美食的唯一标识 */
@property (copy, readonly, nonatomic) NSString *foodID;

/* 美食名称 */
@property (copy, readonly, nonatomic) NSString *name;

/* 美食的月销量 */
@property (assign, readonly, nonatomic) NSUInteger sales;

/* 美食的价格 */
@property (assign, readonly, nonatomic) CGFloat price;

/* 美食的评分，根据美食的评分来描绘1-5星本地图像 */
@property (assign, readonly, nonatomic) CGFloat score;

/* 美食的当前供应状态，1表示还有库存，0表示已经卖完 */
@property (assign, readonly, nonatomic) NSUInteger state;

/* 美食所属类型，例如瘦肉粉属于粉类 */
@property (copy, readonly, nonatomic) NSString *foodType;

#pragma mark -

/* 美食详细信息的图片 */
@property (copy, readonly, nonatomic) NSString *detailPhotoURL;

/* 订单中该美食的订购数量 */
@property (assign, readonly, nonatomic) NSUInteger orderedQuantity;

/* 游客或用户对美食的评论 */
@property (strong, readonly, nonatomic) NSMutableArray *comments;

/* 将该美食添加到购物车中 */
- (void)addToShoppingList;

/* 获取美食的总价：单价 * 订购数量 */
- (CGFloat)getTotalPrice;

@end
