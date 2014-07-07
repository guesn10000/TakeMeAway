//
//  Location.m
//  TakeMeAway
//
//  Created by Jymn_Chen on 14-5-14.
//  Copyright (c) 2014年 Jymn_Chen. All rights reserved.
//

#import "Location.h"

@implementation Location

@dynamic name;
@dynamic longitude;
@dynamic latitude;
@dynamic searchTime;

+ (NSString *)entityName {
    return @"Location";
}

+ (instancetype)insertLocationWithName:(NSString *)aName
                             longitude:(CGFloat)aLongitude
                              latitude:(CGFloat)aLatitude
                            searchTime:(NSDate *)aDate
                inManagedObjectContext:(NSManagedObjectContext *)managedObjectContext
{    
    Location *location = [NSEntityDescription insertNewObjectForEntityForName:[[self class] entityName]
                                                       inManagedObjectContext:managedObjectContext];
    location.name = aName;
    location.longitude = @(aLongitude);
    location.latitude = @(aLatitude);
    location.searchTime = aDate;
    
    return location;
}

@end
