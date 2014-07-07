//
//  ShoppingViewController.m
//  TakeMeAway
//
//  Created by Jymn_Chen on 14-4-23.
//  Copyright (c) 2014年 Jymn_Chen. All rights reserved.
//

#import "ShoppingViewController.h"

#import "AppDelegate.h"
#import "REFrostedViewController.h"

#import "Food.h"
#import "FoodCell.h"
#import "ShopCell.h"
#import "SearchResultCell.h"
#import "TableDataSource.h"
#import "SearchDisplayDelegate.h"

#import "LocalCache.h"
#import "JCAlert.h"

static NSString * const kFoodCellIdentifier          = @"FoodCellIdentifier";
static NSString * const kShopCellIdentifier          = @"ShopCellIdentifier";
static NSString * const kSearchResultCellIdentifier  = @"SearchResultCellIdentifier";
static NSString * const kShoppingToFoodDetailSegue   = @"ShoppingToFoodDetail_segue";
static NSString * const kShoppingToStoreDetailSegue  = @"ShoppingToStoreDetail_segue";
static NSString * const kShoppingToConfirmOrderSegue = @"ShoppingToConfirmOrder_segue";

@interface ShoppingViewController () <UITableViewDelegate, UIScrollViewDelegate>
{
    REFrostedViewController *p_frostedViewController;
}

/* 视图的总体布局 */
@property (weak, nonatomic)   IBOutlet UIButton           *storeTitle_button;
@property (weak, nonatomic)   IBOutlet UISegmentedControl *menuOrShop_segmentedControl;
@property (strong, nonatomic) IBOutlet UIScrollView       *contents_scrollView;
@property (strong, nonatomic) UIView                      *leftSideView;
@property (strong, nonatomic) UIPanGestureRecognizer      *panGesture;

/* 搜索功能 */
@property (strong, nonatomic)          NSMutableArray            *searchFoods;
@property (strong, nonatomic)          TableDataSource           *searchResultDataSource;
@property (strong, nonatomic)          SearchDisplayDelegate     *searchDisplayDelegate;
@property (strong, nonatomic) IBOutlet UISearchDisplayController *foodSearchDisplayController;
@property (weak,   nonatomic) IBOutlet UISearchBar               *food_searchBar;

/* 美食列表 */
@property (copy,   nonatomic) NSArray              *foods;
@property (strong, nonatomic) TableDataSource      *foodDataSource;
@property (strong, nonatomic) IBOutlet UITableView *menu_tableView;

/* 购物车 */
@property (strong, nonatomic) NSMutableArray       *shoppingList;
@property (strong, nonatomic) TableDataSource      *shoppingDataSource;
@property (weak,   nonatomic) IBOutlet UITableView *shoppingList_tableView;
@property (strong, nonatomic) IBOutlet UIView      *shopping_view;
@property (weak,   nonatomic) IBOutlet UILabel     *totalPrice_label;
@property (weak,   nonatomic) IBOutlet UIButton    *confirmShoppingList_button;

@end

@implementation ShoppingViewController

#pragma mark - View life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    /* 基本视图布局：设置底层的scroll view */
    self.contents_scrollView.contentSize = CGSizeMake(self.view.bounds.size.width * 2, self.view.bounds.size.height - 106.0);
    _contents_scrollView.delegate = self;
    
    /* 加载第一页：配置菜单列表视图 */
    NSArray *shoppingNibs = [[NSBundle mainBundle] loadNibNamed:ShoppingViews_XIB owner:self options:nil];
    self.menu_tableView = (UITableView *)shoppingNibs[0];
    _menu_tableView.frame = CGRectMake(0.0, 0.0, _menu_tableView.frame.size.width, _contents_scrollView.frame.size.height);
    [_menu_tableView registerNib:[FoodCell nib] forCellReuseIdentifier:kFoodCellIdentifier];
    [_contents_scrollView addSubview:_menu_tableView];
    [self setupMenuTableView];
    
    /* 加载第二页：配置购物车视图 */
    self.shopping_view = (UIView *)shoppingNibs[1];
    // 下面frame中的-25.0是为了缩小表格和segment控件之间的距离
    _shopping_view.frame = CGRectMake(_menu_tableView.frame.size.width, -25.0, _shopping_view.frame.size.width, _contents_scrollView.frame.size.height);
    [_shoppingList_tableView registerNib:[ShopCell nib] forCellReuseIdentifier:kShopCellIdentifier];
    [_contents_scrollView addSubview:_shopping_view];
    [self setupShoppingListView];
    
    /* 顶部导航栏：设置导航栏的颜色 */
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0]];
    
    /* 顶部的搜索栏：配置搜索结果视图 */
    [self setupSearchDisplayController];
    
    /* 侧边菜单：配置侧边栏视图 */
    p_frostedViewController = [AppDelegate sharedDelegate].app_typeFrostedViewController;
    self.leftSideView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 40.0, _contents_scrollView.bounds.size.height)];
#ifdef SIDE_VIEW_LOCAL_TEST
    _leftSideView.backgroundColor = [UIColor redColor];
    _leftSideView.alpha = 0.1;
#endif
    [_contents_scrollView addSubview:_leftSideView];
    self.panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(openFoodTypeSideMenu)];
    [_leftSideView addGestureRecognizer:_panGesture];
    
    /* 接收购物通知 */
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(foodDidAddToShoppingList:)
                                                 name:UIFoodDidAddToShoppingListNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(orderDidConfirm:)
                                                 name:UIOrderDidConfirmNotification
                                               object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // 设置导航栏标题
    NSString *storeName = [[ShareDataZone shareDataZone] share_getCurrentStoreName];
    [_storeTitle_button setTitle:storeName forState:UIControlStateNormal];
    
    // 设置分段器和还原scroll view到起点
    _menuOrShop_segmentedControl.selectedSegmentIndex = 0;
    _contents_scrollView.contentOffset = CGPointZero;
    
    // 重新从网络抓取数据并更新菜单列表视图
    [self setupFoods];
    [self reloadMenuTableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Setup Menu table view

- (void)setupMenuTableView {
    TableViewCellConfigureBlock configureCell = ^(FoodCell *cell, Food *food) {
        [cell configureCellForFood:food];
    };
    
    self.foods = [NSMutableArray array];
    self.foodDataSource = [[TableDataSource alloc] initWithItems:_foods
                                                  cellIdentifier:kFoodCellIdentifier
                                              configureCellBlock:configureCell];
    _menu_tableView.dataSource = _foodDataSource;
    _menu_tableView.delegate = self;
}

- (void)setupFoods {
    
#ifdef LOCAL_TEST
    Food *food1 = [[Food alloc] initWithFoodID:@"0001" name:@"叉烧粉" sales:@"100" price:@"10" score:@"4.5" state:@"1" foodType:@"粉"];
    Food *food2 = [[Food alloc] initWithFoodID:@"0002" name:@"锅烧粉" sales:@"200" price:@"10" score:@"4.4" state:@"1" foodType:@"粉"];
    Food *food3 = [[Food alloc] initWithFoodID:@"0003" name:@"瘦肉粉" sales:@"300" price:@"10" score:@"4.3" state:@"1" foodType:@"粉"];
    Food *food4 = [[Food alloc] initWithFoodID:@"0004" name:@"炒饭" sales:@"400" price:@"10" score:@"4.2" state:@"1" foodType:@"饭"];
    Food *food5 = [[Food alloc] initWithFoodID:@"0005" name:@"叉烧面" sales:@"500" price:@"10" score:@"4.1" state:@"0" foodType:@"面"];
    self.foods = @[food1, food2, food3, food4, food5];
#else
#warning - Unfinished
    // 以商家的信息发起网络请求获取美食列表
#endif
    
}

- (void)reloadMenuTableView {
    [_foodDataSource updateItems:_foods];
    [_menu_tableView reloadData];
}

#pragma mark - Setup ShoppingList view

- (void)setupShoppingListView {
    NSString *storeID = [[ShareDataZone shareDataZone] share_getCurrentStoreID];
    self.shoppingList = [[LocalCache shareLocalCache] getUnconfirmShoppingListFromeCache:storeID];
    TableViewCellConfigureBlock configureCellForShop = ^(ShopCell *cell, Food *item) {
        [cell configureCellForShopItem:item];
    };
    _shoppingDataSource = [[TableDataSource alloc] initWithItems:_shoppingList
                                                  cellIdentifier:kShopCellIdentifier
                                              configureCellBlock:configureCellForShop];
    _shoppingList_tableView.dataSource = _shoppingDataSource;
    _shoppingList_tableView.delegate = self;
}

- (void)reloadShoppingListView {
    [_shoppingDataSource updateItems:_shoppingList];
    [_shoppingList_tableView reloadData];
    
    CGFloat totalCost = 0.0f;
    for (Food *food in _shoppingList) {
        totalCost += [food getTotalPrice];
    }
    _totalPrice_label.text = [NSString stringWithFormat:@"共 %.1f 元", totalCost];
}

#pragma mark - Setup SearchDisplayController

- (void)setupSearchDisplayController {
    self.searchFoods = [NSMutableArray array];
    
    TableViewCellConfigureBlock configureCell = ^(SearchResultCell *cell, Food *food) {
        [cell configureCellForFoodSearchResult:food];
    };
    [_foodSearchDisplayController.searchResultsTableView registerNib:[SearchResultCell nib] forCellReuseIdentifier:kSearchResultCellIdentifier];
    self.searchResultDataSource = [[TableDataSource alloc] initWithItems:_searchFoods
                                                          cellIdentifier:kSearchResultCellIdentifier
                                                      configureCellBlock:configureCell];
    _foodSearchDisplayController.searchResultsTableView.dataSource = _searchResultDataSource;
    _foodSearchDisplayController.searchResultsTableView.delegate = self;
    
    SearchForTextBlock block = ^(NSString *searchText, NSString *scope, ShoppingViewController *b_self) {
        [b_self filterContentForSearchText:searchText scope:scope];
    };
    self.searchDisplayDelegate = [[SearchDisplayDelegate alloc] initWithSearchBar:_food_searchBar
                                                               searchForTextBlock:block
                                                                       controller:self
                                                                    searchResults:_searchFoods];
    _foodSearchDisplayController.delegate = _searchDisplayDelegate;
}

-(void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope {
    NSMutableArray *tempResults = [NSMutableArray array];
    NSUInteger searchOptions = NSCaseInsensitiveSearch | NSDiacriticInsensitiveSearch;
    
    for (int i = 0; i < _foods.count; i++) {
        Food *food = _foods[i];
        NSString *foodString = food.name;
        NSRange foodRange = NSMakeRange(0, foodString.length);
        NSRange foundRange = [foodString rangeOfString:searchText options:searchOptions range:foodRange];
        if (foundRange.length) {
            [tempResults addObject:food];
        }
    }
    [_searchFoods removeAllObjects];
    [_searchFoods addObjectsFromArray:tempResults];
    
    [_searchResultDataSource updateItems:_searchFoods];
}

#pragma mark - Notification handlers

/* 有美食加入到购物车中 */
- (void)foodDidAddToShoppingList:(NSNotification *)noti {
    Food *food = (Food *)[noti object];
    NSString *storeID = [[ShareDataZone shareDataZone] share_getCurrentStoreID];
    LocalCache *cache = [LocalCache shareLocalCache];
    
    /* 如果美食在购物车中，那么直接更新美食在购物车中的数量 */
    for (Food *item in _shoppingList) {
        if ([food.name isEqualToString:item.name]) {
            [item addToShoppingList]; // 注意这里是item而不是food
            [cache setUnconfirmShoppingListToCache:_shoppingList storeID:storeID];
            [JCAlert alertWithMessage:@"成功添加美食到购物车"];
            [self reloadShoppingListView];
//            [self reloadMenuTableView]; // 因为是item addToShoppingList，因此这里不用刷新menu table view了
            return;
        }
    }
    
    /* 否则将新的美食添加到购物车中 */
    [food addToShoppingList];
    [_shoppingList addObject:food];
    [cache setUnconfirmShoppingListToCache:_shoppingList storeID:storeID];
    [JCAlert alertWithMessage:@"成功添加美食到购物车"];
    [self reloadShoppingListView];
    
    // 这里刷新menu table view是为了确保menu table view的data source中的美食订购数量保持同步
    [self reloadMenuTableView];
}

/* 购物车中的订单已经被确认 */
- (void)orderDidConfirm:(NSNotification *)noti {
    LocalCache *cache = [LocalCache shareLocalCache];
    NSString *storeID = [[ShareDataZone shareDataZone] share_getCurrentStoreID];
    [cache removeUnconfirmShoppingListFromCache:storeID];
    
    [_shoppingList removeAllObjects];
    [self reloadShoppingListView];
    
    // 重置所有美食的订购数量，并重新载入menu table view
    [self setupFoods];
    [self reloadMenuTableView];
}

#pragma mark - Actions

/* 点击左上角的返回按钮的动作 */
- (IBAction)goBackToStoresView:(id)sender {
    [p_frostedViewController dismissViewControllerAnimated:YES completion:nil];
}

/* 点击分段器的动作 */
- (IBAction)showMenuOrShopping:(id)sender {
    CGFloat x = (_menuOrShop_segmentedControl.selectedSegmentIndex) ? 1 : 0;
    [_contents_scrollView setContentOffset:CGPointMake(self.view.frame.size.width * x, 0) animated:YES];
}

/* 确认购物清单的动作 */
- (IBAction)confirmShoppingList:(id)sender {
    [self performSegueWithIdentifier:kShoppingToConfirmOrderSegue sender:nil];
}

/* 通过pan手势打开左边的食物类型菜单 */
- (void)openFoodTypeSideMenu {
    [p_frostedViewController panGestureRecognized:_panGesture];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Food *food;
    if (tableView == _menu_tableView) {
        food = _foods[indexPath.row];
    }
    else if (tableView == _shoppingList_tableView) {
        food = _shoppingList[indexPath.row];
    }
    else if (tableView == _foodSearchDisplayController.searchResultsTableView) {
        food = _searchFoods[indexPath.row];
    }
    
    [[ShareDataZone shareDataZone] share_setCurrentFood:food];
    
    [self performSegueWithIdentifier:kShoppingToFoodDetailSegue sender:self];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == _menu_tableView) {
        return 80.0;
    }
    else if (tableView == _shoppingList_tableView) {
        return 44.0;
    }
    else if (tableView == _foodSearchDisplayController.searchResultsTableView) {
        return 44.0;
    }
    else {
        return 0.0;
    }
}

#pragma mark - UIScrollViewDelegate

/* 水平翻页动画 */
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.25];
    int x = _contents_scrollView.contentOffset.x / self.view.frame.size.width;
    _menuOrShop_segmentedControl.selectedSegmentIndex = x;
    [UIView commitAnimations];
}

@end
