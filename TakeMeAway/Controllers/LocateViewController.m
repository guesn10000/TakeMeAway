//
//  LocateViewController.m
//  TakeMeAway
//
//  Created by Jymn_Chen on 14-4-28.
//  Copyright (c) 2014年 Jymn_Chen. All rights reserved.
//

#import "LocateViewController.h"
#import "AppDelegate.h"
#import "LocalCache.h"
#import "LocationManager.h"
#import "SearchDisplayDelegate.h"
#import "RootTabBarController.h"
#import "JCUIComponents.h"
#import "JCAlert.h"
#import "HYCircleLoadingView.h"

@import CoreLocation;

static NSString * const kLocationCellIdentifier = @"LocationCellIdentifier";

@interface LocateViewController () <UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate>
{
    /* 如果页面已经消失，那么恢复UI到定位前的状态，并忽略定位返回的数据 */
    BOOL p_viewDidDisapper;
    BOOL p_animating;    // 动画正在执行
    BOOL p_tableDragged; // 防止二次刷新
}

@property (weak,   nonatomic) IBOutlet UISearchBar               *locate_searchBar;
@property (strong, nonatomic) IBOutlet UISearchDisplayController *locationSearchDisplayController;

@property (weak,   nonatomic) IBOutlet UIBarButtonItem         *locate_barButtonItem;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *locating_activityIndicator;
@property (strong, nonatomic) HYCircleLoadingView              *locating_circleLodingView;

#warning - Unfinished
@property (strong, nonatomic) NSMutableArray *searchResults; // 数组中的对象为NSString类型，添加网络功能后对象为JSON字典

@property (strong, nonatomic) SearchDisplayDelegate *searchDisplayDelegate;

@property (strong, nonatomic) LocationManager *locationManager;

#warning - Just for local test
@property (copy, nonatomic) NSArray *allLocations;

@end

@implementation LocateViewController

#pragma mark - View life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.locationManager = [[LocationManager alloc] init];
    _locationManager.delegate = self;
    
#ifdef LOCAL_TEST
    self.allLocations = @[@"华南师范大学石牌校区", @"华南理工大学五山校区", @"华南农业大学", @"暨南大学", @"广东工业大学大学城校区", @"中山大学", @"华南师范大学大学城校区", @"华南理工大学大学城校区", @"广东工业大学龙洞校区", @"广东工业大学东风路校区", @"广东金融大学", @"广东财经大学", @"广州大学", @"广东医药大学"];
#endif
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.tintColor = [UIColor lightGrayColor];
    [self.refreshControl addTarget:self
                            action:@selector(controlEventValueChanged:)
                  forControlEvents:UIControlEventValueChanged];
    
    self.locating_circleLodingView = [[JCUIComponents sharedInstance] circleLoadingView];
    
    [self setupSearchDisplayController];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    RootTabBarController *rootTabController = [AppDelegate sharedDelegate].app_rootTabBarController;
    [rootTabController unenableMainSideViewPanGesture];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    p_viewDidDisapper = NO;
    p_animating = NO;
    p_tableDragged = NO;
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    p_viewDidDisapper = YES;
    
    [self stopAllAnimations];
    
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

/**
 *  在定位成功，定位失败，视图将要消失时，该方法都会被调用
 */
- (void)stopAllAnimations {
    if (p_animating) { // 关闭动画
        [self.refreshControl endRefreshing];
        [_locate_barButtonItem setCustomView:nil];
        [_locating_circleLodingView stopAnimation];
    }
    
    p_tableDragged = NO;
    p_animating = NO;
    
    if (_locationSearchDisplayController.isActive) { // 关闭搜索结果显示
        [_locationSearchDisplayController setActive:NO animated:NO];
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == _locationSearchDisplayController.searchResultsTableView) {
        return _searchResults.count;
    }
    else {
        return [_locationManager.locations count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kLocationCellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kLocationCellIdentifier];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == _locationSearchDisplayController.searchResultsTableView) {
        cell.textLabel.text = _searchResults[indexPath.row];
    }
    else {
        Location *loc = _locationManager.locations[indexPath.row];
        cell.textLabel.text = loc.name;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (tableView == self.tableView) {
        return @"您曾经使用过的位置";
    }
    
    return nil;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return (tableView == self.searchDisplayController.searchResultsTableView) ? NO : YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [_locationManager deleteLocatonFromCacheAtIndex:indexPath.row];
        
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Location *tmpLocation;
    
    // 为了防止突然的定位成功并调用跳转方法（同时调用两次跳转方法会崩溃），这里要立即停掉定位服务
    [_locationManager stopUpdatingLocation];
    
    if (tableView == _locationSearchDisplayController.searchResultsTableView) { // 点击的是搜索列表
        NSString *tmpLocationName = _searchResults[indexPath.row];
#warning - Unfinished
        // 将下面的经纬度补全为JSON中的数据
        tmpLocation = [_locationManager insertLocationToCacheWithName:tmpLocationName
                                                            longitude:0.0
                                                             latitude:0.0];
    }
    else { // 用户点击的是历史地址列表，直接更新其搜索时间
        tmpLocation = [_locationManager updateLocationFromCacheAtIndex:indexPath.row];
    }
    
    [self performSegueToRootTabBarControllerWithCurrentLocation:tmpLocation];
}

#pragma mark - Setup SearchDisplayController

- (void)setupSearchDisplayController {
    self.searchResults = [NSMutableArray array];
    
    SearchForTextBlock block = ^(NSString *searchText, NSString *scope, LocateViewController *b_self) {
        [b_self filterContentForSearchText:searchText scope:scope];
    };
    self.searchDisplayDelegate = [[SearchDisplayDelegate alloc] initWithSearchBar:_locate_searchBar
                                                               searchForTextBlock:block
                                                                       controller:self
                                                                    searchResults:_searchResults];
    _locationSearchDisplayController.delegate = _searchDisplayDelegate;
}

- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope {
    
#ifdef LOCAL_TEST
    NSMutableArray *tempResults = [NSMutableArray array];
    NSUInteger searchOptions = NSCaseInsensitiveSearch | NSDiacriticInsensitiveSearch;
    
    for (int i = 0; i < _allLocations.count; i++) {
        NSString *storeString = _allLocations[i];
        NSRange storeRange = NSMakeRange(0, storeString.length);
        NSRange foundRange = [storeString rangeOfString:searchText options:searchOptions range:storeRange];
        if (foundRange.length) {
            [tempResults addObject:storeString];
        }
    }
    [_searchResults removeAllObjects];
    [_searchResults addObjectsFromArray:tempResults];
#else
#warning - Unfinished
    /*
     * 向服务器发送查询请求
     *
     接口设计：
     HTTP Method: GET
     请求参数：地址名locationName（全部或部分，字符串形式）
     返回结果：搜索到的地址数组（JSON格式，地址内容包括地址名、经纬度）
     返回结果示例：
     [
     {“name” : “华南师范大学西门”, “latitude” : “100.0”, “longitude” : “100.0”},
     {“name” : “华南师范大学正门”, “latitude” : “100.0”, “longitude” : “100.0”}
     ]
     */
#endif
    
}

#pragma mark - Button Actions

- (void)fetchLocation {
    if (!p_viewDidDisapper) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{ // 定位动作在后台执行，这样页面不会卡顿
            [_locationManager startUpdatingLocation];
        });
    }
}

- (IBAction)locateAction:(id)sender {
    p_animating = YES;
    
    // 先执行划到表格顶部的动画
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.25];
    self.tableView.contentOffset = CGPointZero;
    [UIView commitAnimations];
    
    // 再执行下拉动画
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.25];
    self.tableView.contentOffset = CGPointMake(0.0, -146.0); // 注意位移点的y值为负值
    [UIView commitAnimations];
    
    // 改变refreshControl的状态
    [self.refreshControl beginRefreshing];
    
    // 主动调用刷新控件事件方法
    [self controlEventValueChanged:nil];
}

- (void)controlEventValueChanged:(id)sender {
    if (p_tableDragged) { // 防止重复拖拽表格刷新
        return;
    }
    
    if (self.refreshControl.refreshing) {
        p_animating = YES;
        p_tableDragged = YES;
        
        self.refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"正在定位中..."];
        [_locate_barButtonItem setCustomView:_locating_circleLodingView];
        [_locating_circleLodingView startAnimation];
        
        [self performSelector:@selector(fetchLocation) withObject:nil afterDelay:2.0];
    }
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    if (locations && locations.count) {
        CLLocation *firstLocation = locations[0];
        CGFloat longitude = firstLocation.coordinate.longitude;
        CGFloat latitude = firstLocation.coordinate.latitude;
        NSString *locName = [_locationManager bmk_reverseGeocodeLocationWithLongitude:longitude latitude:latitude];
        if (locName)
        {
            Location *tmpLocation = [_locationManager insertLocationToCacheWithName:locName
                                                                          longitude:longitude
                                                                           latitude:latitude];
            
            [self performSegueToRootTabBarControllerWithCurrentLocation:tmpLocation];
        }
        else
        {
            [JCAlert alertWithMessage:@"定位失败，请检查您的网络情况并重试"];
        }
    }
    else {
        [JCAlert alertWithMessage:@"定位失败，请检查您的网络情况并重试"];
    }
    
    [self stopAllAnimations];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    [JCAlert alertWithMessage:@"定位失败，请确保定位功能已经打开"];
    [self stopAllAnimations];
}

/**
 *  执行跳转只有三种情况：
 *  1.定位成功后
 *  2.搜索地理位置，然后点击搜索结果
 *  3.点击历史位置
 *
 *  对应两种方法：
 *  1.didUpdateLocations
 *  2.didSelectRowAtIndexPath
 *
 */
- (void)performSegueToRootTabBarControllerWithCurrentLocation:(Location *)curLocation {
    [_locationManager stopUpdatingLocation];
    
    [[ShareDataZone shareDataZone] share_setCurrentLocation:curLocation];
    
    AppDelegate *appDelegate = [AppDelegate sharedDelegate];
    [self presentViewController:(UIViewController *)appDelegate.app_frostedViewController animated:YES completion:nil];
}

@end
