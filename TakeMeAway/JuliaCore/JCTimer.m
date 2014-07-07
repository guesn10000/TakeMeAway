//
//  JCTimer.m
//  SCNUPaper
//
//  Created by Jymn_Chen on 14-1-22.
//  Copyright (c) 2014年 Jymn_Chen. All rights reserved.
//

#import "JCTimer.h"

static NSString * const yyyyMMdd_DateFormat       = @"yyyy年MM月dd日";
static NSString * const yyyyMMddhh_DateFormat     = @"yyyy年MM月dd日hh时";
static NSString * const yyyyMMddhhmm_DateFormat   = @"yyyy年MM月dd日hh时mm分";
static NSString * const yyyyMMddhhmmss_DateFormat = @"yyyy年MM月dd日hh时mm分ss秒";

@interface JCTimer ()

@property (strong, nonatomic) NSDateFormatter *_dateFormatter;

@end

@implementation JCTimer
@synthesize _dateFormatter;

#pragma mark - Singleton

+ (instancetype)sharedInstance {
    static JCTimer *timer = nil;
    static dispatch_once_t onceToken = 0;
    dispatch_once(&onceToken, ^{
        timer = [[super allocWithZone:NULL] init];
        timer._dateFormatter = [[NSDateFormatter alloc] init];
    });
    
    return timer;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    return [self sharedInstance];
}

- (instancetype)copyWithZone:(NSZone *)zone {
    return self;
}

#pragma mark - String of Date

- (NSString *)get_yyMMdd_StringOfCurrentTime {
    [_dateFormatter setDateFormat:yyyyMMdd_DateFormat];
    return [_dateFormatter stringFromDate:[NSDate date]];
}

- (NSString *)get_yyMMddhh_StringOfCurrentTime {
    [_dateFormatter setDateFormat:yyyyMMddhh_DateFormat];
    return [_dateFormatter stringFromDate:[NSDate date]];
}

- (NSString *)get_yyMMddhhmm_StringOfCurrentTime {
    [_dateFormatter setDateFormat:yyyyMMddhhmm_DateFormat];
    return [_dateFormatter stringFromDate:[NSDate date]];
}

- (NSString *)get_yyMMddhhmmss_StringOfCurrentTime {
    [_dateFormatter setDateFormat:yyyyMMddhhmmss_DateFormat];
    return [_dateFormatter stringFromDate:[NSDate date]];
}

#pragma mark - Date from String

- (NSDate *)getDateFrom_yyMMdd_String:(NSString *)dateString {
    [_dateFormatter setDateFormat:yyyyMMdd_DateFormat];
    return [_dateFormatter dateFromString:dateString];
}

- (NSDate *)getDateFrom_yyMMddhh_String:(NSString *)dateString {
    [_dateFormatter setDateFormat:yyyyMMddhh_DateFormat];
    return [_dateFormatter dateFromString:dateString];
}

- (NSDate *)getDateFrom_yyMMddhhmm_String:(NSString *)dateString {
    [_dateFormatter setDateFormat:yyyyMMddhhmm_DateFormat];
    return [_dateFormatter dateFromString:dateString];
}

- (NSDate *)getDateFrom_yyMMddhhmmss_String:(NSString *)dateString {
    [_dateFormatter setDateFormat:yyyyMMddhhmmss_DateFormat];
    return [_dateFormatter dateFromString:dateString];
}

#pragma mark - Compare NSDate

- (JCTimeCompareResult)compareDate:(NSDate *)firstDate toDate:(NSDate *)nextDate {
    NSTimeInterval timeInterval = [firstDate timeIntervalSinceDate:nextDate];
    if (timeInterval > 0) {
        return kJCLater;
    }
    else if (timeInterval < 0) {
        return kJCEarlier;
    }
    else {
        return kJCSame;
    }
}

@end
