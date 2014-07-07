//
//  JCUIComponents.m
//  TakeMeAway
//
//  Created by Jymn_Chen on 14-4-27.
//  Copyright (c) 2014年 Jymn_Chen. All rights reserved.
//

#define kDodgerBlueColor [UIColor colorWithRed:0.117 green:0.564 blue:1.0 alpha:1.0]
#define kTranslucentBlackColor [UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:0.5]

#import "JCUIComponents.h"
#import "HYCircleLoadingView.h"

@interface JCUIComponents ()

@property (strong, nonatomic) HYCircleLoadingView *circleLoadingView;

@end

@implementation JCUIComponents
@synthesize circleLoadingView = _circleLoadingView;

#pragma mark - Singleton

+ (instancetype)sharedInstance {
    static JCUIComponents *components = nil;
    static dispatch_once_t onceToken = 0;
    dispatch_once(&onceToken, ^{
        components = [[super allocWithZone:NULL] init];
        components.circleLoadingView = [[HYCircleLoadingView alloc] initWithFrame:CGRectMake(0.0, 0.0, 35.0, 35.0)];
    });
    
    return components;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    return [self sharedInstance];
}

- (instancetype)copyWithZone:(NSZone *)zone {
    return self;
}

#pragma mark - UI Components Factory

+ (UIButton *)buttonWithType:(JCButtonType)aType title:(NSString *)aTitle action:(SEL)aSel target:(id)aTarget {
    /* 设置边界大小 */
    CGRect rect = CGRectMake(0.0, 0.0, 120.0, 44.0);
    UIButton *button = [[UIButton alloc] initWithFrame:rect];
    
    /* 设置颜色 */
    [button setBackgroundColor:kDodgerBlueColor];
    [button setTintColor:[UIColor whiteColor]];
    
    /* 设置响应动作 */
    [button setTitle:aTitle forState:UIControlStateNormal];
    [button setTitleColor:kTranslucentBlackColor forState:UIControlStateHighlighted];
    [button addTarget:aTarget action:aSel forControlEvents:UIControlEventTouchUpInside];
    
    /* 设置圆角按钮 */
    [button.layer setMasksToBounds:YES];
    [button.layer setCornerRadius:10.0];
    
    return button;
}

#pragma mark - Single UI Components

- (HYCircleLoadingView *)circleLoadingView {
    return _circleLoadingView;
}

@end
