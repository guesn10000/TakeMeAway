//
//  LocationManager.h
//  TakeMeAway
//
//  Created by Jymn_Chen on 14-5-12.
//  Copyright (c) 2014年 Jymn_Chen. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
#import "Location.h"

@interface LocationManager : CLLocationManager

@property (copy, readonly, nonatomic) NSMutableArray *locations;

/* 
 * Insert 
 * 
 * 如果Location对象已经存在，则只需更新其搜索时间
 * 否则将该对象作为新对象插入到数据库中
 */
- (Location *)insertLocationToCacheWithName:(NSString *)aName
                                  longitude:(CGFloat)alongitude
                                   latitude:(CGFloat)alatitude;

/* Delete */
- (void)deleteLocatonFromCache:(Location *)aLocation;
- (void)deleteLocatonFromCacheAtIndex:(NSUInteger)aIndex;

/* 
 * Update 
 *
 * 更新操作，只更新地址的搜索时间
 */
- (Location *)updateLocationFromCache:(Location *)aLocation;
- (Location *)updateLocationFromCacheAtIndex:(NSUInteger)aIndex;

/**
 *  调用百度地图API进行地址查询
 *
 *  @param aLongitude 经度
 *  @param aLatitude  纬度
 *
 *  @return 地址名称
 */
- (NSString *)bmk_reverseGeocodeLocationWithLongitude:(CGFloat)aLongitude latitude:(CGFloat)aLatitude;

@end
