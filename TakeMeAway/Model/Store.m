//
//  Store.m
//  TakeMeAway
//
//  Created by Jymn_Chen on 14-4-23.
//  Copyright (c) 2014年 Jymn_Chen. All rights reserved.
//

#import "Store.h"

@interface Store ()

@property (copy, readwrite, nonatomic) NSString *storeID;
@property (copy, readwrite, nonatomic) NSString *logoImageURL;
@property (copy, readwrite, nonatomic) NSString *name;
@property (assign, readwrite, nonatomic) CGFloat score;
@property (copy, readwrite, nonatomic) NSString *detail;
/*
 detail字符串的使用方法：
 NSArray *strs = [detail componentsSeparatedByString:@" / "];
 商家到本地的距离 = strs[0];
 多少钱起送 = strs[1];
 大概的送达时间 = strs[2];
 */

@property (copy, readwrite, nonatomic) NSString *detailPhotoURL;
@property (copy, readwrite, nonatomic) NSString *locationName;
@property (copy, readwrite, nonatomic) NSString *telephoneNumber;
@property (copy, readwrite, nonatomic) NSString *introduction;

@end

@implementation Store

#pragma mark - Initialization

- (instancetype)initWithID:(NSString *)anID
              logoImageURL:(NSString *)aURL
                      name:(NSString *)aName
                     score:(NSString *)aScore
                    detail:(NSString *)aDetail
{
    self = [super init];
    
    if (self) {
        _storeID = anID;
        _logoImageURL = aURL;
        _name = aName;
        _score = aScore.floatValue;
        _detail = aDetail;
        
        _detailPhotoURL = nil;
        _locationName = nil;
        _telephoneNumber = nil;
        _introduction = nil;
    }
    
    return self;
}

#pragma mark - Store Details

- (void)getStoreDetails {
#warning - Unfinished
    // 根据唯一标识商家的ID从网络中获取细节信息，包括detailPhotoURL locationName telephoneNumber introduction
}

@end
