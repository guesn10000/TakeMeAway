//
//  LocationManager.m
//  TakeMeAway
//
//  Created by Jymn_Chen on 14-5-12.
//  Copyright (c) 2014年 Jymn_Chen. All rights reserved.
//

#import "LocationManager.h"
#import "PersistentStack.h"

static NSString * const kBaiduMapAppKey = @"4OVbtGElGHr9ASc2FlcSmBQC";
static NSInteger const LocationNotExist = -1;

@interface LocationManager ()

@property (copy, readwrite, nonatomic) NSMutableArray *locations;

@end

@implementation LocationManager

#pragma mark - Initialization

- (instancetype)init {
    self = [super init];
    
    if (self) {
        self.desiredAccuracy = kCLLocationAccuracyBest;
        self.distanceFilter = 1000.0f;
    }
    
    return self;
}

#pragma mark - Location Operations

- (NSMutableArray *)locations {
    // 从本地数据库中抓取数据
    if (!_locations) { // lazy loading
        NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"searchTime" ascending:NO];
        NSArray *tmpArray = [[PersistentStack sharedPersistentStack] executeFetchWithEntityName:[Location entityName]
                                                                                      predicate:nil
                                                                                 sortDescriptor:@[sortDescriptor]];
        
        _locations = [tmpArray mutableCopy];
        if (!_locations) {
            _locations = [NSMutableArray array];
        }
    }
    
    return _locations;
}

- (Location *)insertLocationToCacheWithName:(NSString *)aName
                                  longitude:(CGFloat)alongitude
                                   latitude:(CGFloat)alatitude
{
    PersistentStack *stack = [PersistentStack sharedPersistentStack];
    Location *tmpLocation;
    
    NSInteger index = [self locationExistInCache:aName];
    if (index == LocationNotExist) { // 该地址不在缓存中，必须作为新对象插入到数据库中
        // 写入数据库中
        tmpLocation = [Location insertLocationWithName:aName
                                             longitude:alongitude
                                              latitude:alatitude
                                            searchTime:[NSDate date]
                                inManagedObjectContext:stack.managedObjectContext];
        [_locations insertObject:tmpLocation atIndex:0];
    }
    else { // 该地址已经存在于缓存中，只需更新其搜索时间
        tmpLocation = [self updateLocationFromCacheAtIndex:index];
    }
    
#ifdef LOCAL_TEST
    NSError *error = nil;
    [stack save:&error];
    // 程序退出时会自动保存
#endif
    
    return tmpLocation;
}

/*
 * 在下面的API中，如果参数为Location类，那么需要判断该对象是否已经存在于缓存中
 * 如果参数为NSUInteger类型，那么只需要判断该参数是否越界，无需检测对象是否存在于缓存中
 * 因为后者通常被前者调用，此时已经可以肯定地址必定存在于缓存中
 */

- (void)deleteLocatonFromCache:(Location *)aLocation {
    NSInteger index = [self locationExistInCache:aLocation.name];
    if (index == LocationNotExist) { // 如果地址不存在于缓存中，那么删除操作将为空操作
        return;
    }
    else { // 否则将地址从缓存中移除
        // 写入数据库中
        PersistentStack *stack = [PersistentStack sharedPersistentStack];
        [stack deleteManagedObject:_locations[index]];
        
        [_locations removeObjectAtIndex:index];
    }
}

- (void)deleteLocatonFromCacheAtIndex:(NSUInteger)aIndex {
    if (aIndex >= _locations.count) { // 防止数组越界，注意aIndex >=0 必定成立
        return;
    }
    
    [self deleteLocatonFromCache:_locations[aIndex]];
}

- (Location *)updateLocationFromCache:(Location *)aLocation {
    NSInteger index = [self locationExistInCache:aLocation.name];
    if (index == LocationNotExist) { // 地址不在缓存中，无需更新
        return nil;
    }
    else { // 否则，更新地址的搜索时间并写入数据库中
        return [self updateLocationFromCacheAtIndex:index];
    }
}

- (Location *)updateLocationFromCacheAtIndex:(NSUInteger)aIndex {
    if (aIndex >= _locations.count) { // 防止数组越界，注意aIndex >=0 必定成立
        return nil;
    }
    
    // 更新地址的搜索时间
    Location *tmpLocation = _locations[aIndex];
    tmpLocation.searchTime = [NSDate date];
    [_locations removeObjectAtIndex:aIndex];
    [_locations insertObject:tmpLocation atIndex:0];
    
    // 写入数据库中
    PersistentStack *stack = [PersistentStack sharedPersistentStack];
    [stack updateManagedObject:tmpLocation mergeChanges:YES];
    return tmpLocation;
}

- (NSInteger)locationExistInCache:(NSString *)aLocName {
    int i = 0;
    for (; i < _locations.count; i++) {
        Location *loc = _locations[i];
        if ([loc.name isEqualToString:aLocName]) {
            break;
        }
    }
    
    return (i >= _locations.count) ? LocationNotExist : i;
}

#pragma mark - BaiduMap LBS

- (NSString *)bmk_reverseGeocodeLocationWithLongitude:(CGFloat)aLongitude latitude:(CGFloat)aLatitude {
    NSString *locParam = [NSString stringWithFormat:@"location=%f,%f", aLatitude, aLongitude];
    NSString *urlString = [NSString stringWithFormat:@"http://api.map.baidu.com/geocoder?%@&output=json&key=%@", locParam, kBaiduMapAppKey];
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:urlString]];
    if (data) { // 如果不进行异常检测，这里可能会崩溃
        NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
        NSDictionary *resultDic = jsonDic[@"result"];
        NSString *locString = resultDic[@"formatted_address"];
        return locString;
    }
    
    return nil;
}

@end
