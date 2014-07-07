//
//  OrderCell.h
//  TakeMeAway
//
//  Created by Jymn_Chen on 14-4-23.
//  Copyright (c) 2014年 Jymn_Chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Order;

@interface OrderCell : UITableViewCell

- (void)configureCellForOrder:(Order *)anOrder;

@end
