//
//  JCUIComponents.h
//  TakeMeAway
//
//  Created by Jymn_Chen on 14-4-27.
//  Copyright (c) 2014年 Jymn_Chen. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, JCButtonType) {
    JCNormalButton
};

@class HYCircleLoadingView;

@interface JCUIComponents : NSObject

+ (instancetype)sharedInstance;

+ (UIButton *)buttonWithType:(JCButtonType)aType title:(NSString *)aTitle action:(SEL)aSel target:(id)aTarget;

- (HYCircleLoadingView *)circleLoadingView;

@end
