//
//  SearchDisplayDelegate.h
//  TakeMeAway
//
//  Created by Jymn_Chen on 14-5-4.
//  Copyright (c) 2014年 Jymn_Chen. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^SearchForTextBlock)(NSString *searchText, NSString *scope, id controller);

@interface SearchDisplayDelegate : NSObject <UISearchDisplayDelegate>

- (instancetype)initWithSearchBar:(UISearchBar *)aSearchBar
               searchForTextBlock:(SearchForTextBlock)aBlock
                       controller:(id)aController
                    searchResults:(NSMutableArray *)aResults;

@end
