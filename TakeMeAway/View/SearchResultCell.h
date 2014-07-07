//
//  SearchResultCell.h
//  TakeMeAway
//
//  Created by Jymn_Chen on 14-5-3.
//  Copyright (c) 2014年 Jymn_Chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Store;
@class Food;

@interface SearchResultCell : UITableViewCell

- (void)configureCellForStoreSearchResult:(Store *)store;

- (void)configureCellForFoodSearchResult:(Food *)food;

+ (UINib *)nib;

@end
