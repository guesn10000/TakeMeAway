//
//  StoresTableViewController.m
//  TakeMeAway
//
//  Created by Jymn_Chen on 14-4-23.
//  Copyright (c) 2014年 Jymn_Chen. All rights reserved.
//

#import "StoresTableViewController.h"

#import "AppDelegate.h"
#import "LocalCache.h"

#import "Store.h"
#import "StoreCell.h"
#import "TableDataSource.h"

#import "SearchDisplayDelegate.h"
#import "SearchResultCell.h"

#import "RootTabBarController.h"
#import "FoodTypeSideViewController.h"
#import "REFrostedViewController.h"

static NSString * const kStoreCellIdentifier        = @"StoreCellIdentifier";
static NSString * const kSearchResultCellIdentifier = @"SearchResultCellIdentifier";

@class ShoppingViewController; // 不能删除本行，因为本例中要使用ShoppingViewController，但是又不需要用到其细节

@interface StoresTableViewController ()
{
    REFrostedViewController *p_frostedViewController;
}

/* 搜索商家功能相关 */
@property (strong, readwrite, nonatomic) NSMutableArray        *searchStores;
@property (strong, readwrite, nonatomic) TableDataSource       *searchResultDataSource;
@property (strong, readwrite, nonatomic) SearchDisplayDelegate *searchDisplayDelegate;
@property (weak,   nonatomic) IBOutlet UISearchBar               *store_searchBar;
@property (strong, nonatomic) IBOutlet UISearchDisplayController *stores_searchDisplayController;

/* 存储和显示所有的商家 */
@property (strong, readwrite, nonatomic) TableDataSource *storeDataSource;
@property (copy,   readwrite, nonatomic) NSArray         *stores;

@property (weak, nonatomic) IBOutlet UIButton *changeLocation_button;

@end

@implementation StoresTableViewController

#pragma mark - View life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupTableView];
    
    [self setupSearchDisplayController];
    
    [self setupMenuFrostedViewController];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if ((BOOL)([ShareDataZone shareDataZone].isLocationChanged)) {
        NSString *locationName = [[ShareDataZone shareDataZone] share_getCurrentLocationName];
        [_changeLocation_button setTitle:locationName forState:UIControlStateNormal];
        
        [self loadStores];
        [self.tableView reloadData];
        
        // 完成位置改变后的视图刷新工作，关闭位置更新
        [ShareDataZone shareDataZone].isLocationChanged = NO;
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    RootTabBarController *rootTabController = [AppDelegate sharedDelegate].app_rootTabBarController;
    [rootTabController enableMainSideViewPanGesture];
}

- (void)setupMenuFrostedViewController {
    FoodTypeSideViewController *foodTypeController = (FoodTypeSideViewController *)StoryboardViewController(FoodTypeSideViewController_ID);
    ShoppingViewController *shoppingController = (ShoppingViewController *)StoryboardViewController(ShoppingViewController_ID);
    UINavigationController *naviController = [[UINavigationController alloc] initWithRootViewController:(UIViewController *)shoppingController];
    
    REFrostedViewController *frostedController = [[REFrostedViewController alloc] initWithContentViewController:naviController menuViewController:foodTypeController];
    [AppDelegate sharedDelegate].app_typeFrostedViewController = frostedController;
    
    p_frostedViewController = frostedController;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Setup Table View

- (void)loadStores {
#ifdef LOCAL_TEST
    Store *store1 = [[Store alloc] initWithID:@"1" logoImageURL:nil name:@"牛魔王" score:@"4.1" detail:@"10m / 10元起送 / 10分钟"];
    Store *store2 = [[Store alloc] initWithID:@"2" logoImageURL:nil name:@"辣尚瘾" score:@"4.0" detail:@"20m / 10元起送 / 10分钟"];
    Store *store3 = [[Store alloc] initWithID:@"3" logoImageURL:nil name:@"酸菜鱼" score:@"3.8" detail:@"30m / 10元起送 / 20分钟"];
    Store *store4 = [[Store alloc] initWithID:@"4" logoImageURL:nil name:@"麻辣烫" score:@"3.6" detail:@"40m / 10元起送 / 40分钟"];
    Store *store5 = [[Store alloc] initWithID:@"5" logoImageURL:nil name:@"橘果子" score:@"3.2" detail:@"100m / 10元起送 / 10分钟"];
    Store *store6 = [[Store alloc] initWithID:@"6" logoImageURL:nil name:@"化州糖水" score:@"4.8" detail:@"10m / 10元起送 / 10分钟"];
    
    store1.logoImage = [UIImage imageNamed:@"store5.png"];
    store2.logoImage = [UIImage imageNamed:@"store2.png"];
    store3.logoImage = [UIImage imageNamed:@"store3.png"];
    store4.logoImage = [UIImage imageNamed:@"store4.png"];
    store5.logoImage = [UIImage imageNamed:@"store1.png"];
    store6.logoImage = [UIImage imageNamed:@"store6.png"];
    
    self.stores = @[store1, store2, store3, store4, store5, store6];
#else
#warning - Unfinished
    // 根据地址向服务器查询附近的商家列表
#endif
    
    [_storeDataSource updateItems:_stores];
    [self.tableView reloadData];
}

- (void)setupTableView {
    TableViewCellConfigureBlock configureCell = ^(StoreCell *cell, Store *store) {
        [cell configureCellForStore:store];
    };
    
    self.storeDataSource = [[TableDataSource alloc] initWithItems:_stores
                                                   cellIdentifier:kStoreCellIdentifier
                                               configureCellBlock:configureCell];
    self.tableView.dataSource = _storeDataSource;
}

#pragma mark - Setup SearchDisplayController

- (void)setupSearchDisplayController {
    self.searchStores = [NSMutableArray array];
    
    TableViewCellConfigureBlock configureCell = ^(SearchResultCell *cell, Store *store) {
        [cell configureCellForStoreSearchResult:store];
    };
    
    [_stores_searchDisplayController.searchResultsTableView registerNib:[SearchResultCell nib] forCellReuseIdentifier:kSearchResultCellIdentifier];
    self.searchResultDataSource = [[TableDataSource alloc] initWithItems:_searchStores // 这里的items直接本地搜索，不需要发起网络请求
                                                          cellIdentifier:kSearchResultCellIdentifier
                                                      configureCellBlock:configureCell];
    _stores_searchDisplayController.searchResultsTableView.dataSource = _searchResultDataSource;
    _stores_searchDisplayController.searchResultsTableView.delegate = self;
    
    SearchForTextBlock block = ^(NSString *searchText, NSString *scope, StoresTableViewController *b_self) {
        [b_self filterContentForSearchText:searchText scope:scope];
    };
    self.searchDisplayDelegate = [[SearchDisplayDelegate alloc] initWithSearchBar:_store_searchBar
                                                               searchForTextBlock:block
                                                                       controller:self
                                                                    searchResults:_searchStores];
    _stores_searchDisplayController.delegate = _searchDisplayDelegate;
}

-(void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope {
    NSMutableArray *tempResults = [NSMutableArray array];
    NSUInteger searchOptions = NSCaseInsensitiveSearch | NSDiacriticInsensitiveSearch;
    
    for (int i = 0; i < _stores.count; i++) {
        Store *store = _stores[i];
        NSString *storeString = store.name;
        NSRange storeRange = NSMakeRange(0, storeString.length);
        NSRange foundRange = [storeString rangeOfString:searchText options:searchOptions range:storeRange];
        if (foundRange.length) {
            [tempResults addObject:store];
        }
    }
    [_searchStores removeAllObjects];
    [_searchStores addObjectsFromArray:tempResults];
    
    [_searchResultDataSource updateItems:_searchStores];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Store *tmpStore;
    if (tableView == _stores_searchDisplayController.searchResultsTableView) {
        tmpStore = _searchStores[indexPath.row];
    }
    else {
        tmpStore = _stores[indexPath.row];
    }
    
    [[ShareDataZone shareDataZone] share_setCurrentStore:tmpStore];
    
    RootTabBarController *rootTabController = [AppDelegate sharedDelegate].app_rootTabBarController;
    [rootTabController unenableMainSideViewPanGesture];
    
    [self presentViewController:p_frostedViewController animated:YES completion:nil];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return (tableView == _stores_searchDisplayController.searchResultsTableView) ? 44.0 : 90.0;
}

#pragma mark - Button Actions

- (IBAction)changeLocation:(id)sender {
    [[AppDelegate sharedDelegate].app_frostedViewController dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)openSideMenu:(id)sender {
    [[AppDelegate sharedDelegate].app_frostedViewController presentMenuViewController];
}

@end
