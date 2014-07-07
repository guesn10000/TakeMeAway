//
//  Location.h
//  TakeMeAway
//
//  Created by Jymn_Chen on 14-5-14.
//  Copyright (c) 2014年 Jymn_Chen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface Location : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * longitude;
@property (nonatomic, retain) NSNumber * latitude;
@property (nonatomic, retain) NSDate * searchTime;

+ (NSString *)entityName;

+ (instancetype)insertLocationWithName:(NSString *)aName
                             longitude:(CGFloat)aLongitude
                              latitude:(CGFloat)aLatitude
                            searchTime:(NSDate *)aDate
                inManagedObjectContext:(NSManagedObjectContext *)managedObjectContext;

@end
