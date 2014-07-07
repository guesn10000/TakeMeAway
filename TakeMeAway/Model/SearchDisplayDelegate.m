//
//  SearchDisplayDelegate.m
//  TakeMeAway
//
//  Created by Jymn_Chen on 14-5-4.
//  Copyright (c) 2014年 Jymn_Chen. All rights reserved.
//

#import "SearchDisplayDelegate.h"

@interface SearchDisplayDelegate ()

@property (strong, nonatomic) UISearchBar *searchBar;

@property (copy, nonatomic) SearchForTextBlock searchBlock;

@property (weak, nonatomic) id controller;

@property (strong, nonatomic) NSMutableArray *searchResults;

@end

@implementation SearchDisplayDelegate

#pragma mark - Initialization

- (instancetype)init {
    return nil;
}

- (instancetype)initWithSearchBar:(UISearchBar *)aSearchBar
               searchForTextBlock:(SearchForTextBlock)aBlock
                       controller:(id)aController
                    searchResults:(NSMutableArray *)aResults
{
    self = [super init];
    
    if (self) {
        _searchBar   = aSearchBar;
        _searchBlock = [aBlock copy];
        _controller = aController;
        _searchResults = aResults;
    }
    
    return self;
}

#pragma mark - UISearchDisplayDelegate

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {
    [self filterContentForSearchText:searchString
                               scope:[_searchBar scopeButtonTitles][_searchBar.selectedScopeButtonIndex]];
    
    return YES;
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption {
    [self filterContentForSearchText:_searchBar.text
                               scope:_searchBar.scopeButtonTitles[searchOption]];
    
    return YES;
}

- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope {
    _searchBlock(searchText, scope, _controller);
}

- (void)searchDisplayController:(UISearchDisplayController *)controller didHideSearchResultsTableView:(UITableView *)tableView {
    // 在搜索栏消失后，清空搜索结果数组中的所有对象，从而释放掉多余的内存
    [_searchResults removeAllObjects];
}

@end
