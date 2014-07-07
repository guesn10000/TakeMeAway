//
//  JCUserDefaults.h
//  TakeMeAway
//
//  Created by Jymn_Chen on 14-4-27.
//  Copyright (c) 2014年 Jymn_Chen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JCUserDefaults : NSObject

+ (id)objectForKey:(NSString *)aKey;

+ (void)setObject:(id)obj forKey:(NSString *)aKey;

@end
