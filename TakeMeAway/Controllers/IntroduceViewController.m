//
//  IntroduceViewController.m
//  TakeMeAway
//
//  Created by Jymn_Chen on 14-4-23.
//  Copyright (c) 2014年 Jymn_Chen. All rights reserved.
//

#import "IntroduceViewController.h"
#import "JCUserDefaults.h"
#import "IntroduceView.h"

static NSString * const IntroducePageOneImageName   = @"Intro_Sample_1.png";
static NSString * const IntroducePageTwoImageName   = @"Intro_Sample_2.png";
static NSString * const IntroducePageThreeImageName = @"Intro_Sample_3.png";
static NSString * const kIntroductionToRootNavigationSegue = @"IntroductionToRootNavigation_segue";

@interface IntroduceViewController () <IntroductionDelegate>

@property (strong, nonatomic) IBOutlet IntroduceView *contentView;

@end

@implementation IntroduceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    /* 初始化contentView */
    CGRect contentFrame = self.view.bounds;
    self.contentView = [[IntroduceView alloc] initWithFrame:contentFrame];
    
    /* 初始化视图数组viewsForContent */
    NSMutableArray *viewsForContent = [NSMutableArray arrayWithCapacity:3];
    NSArray *imageNames = @[IntroducePageOneImageName, IntroducePageTwoImageName, IntroducePageThreeImageName];
    for (NSString *name in imageNames) {
        UIView *contentBackground = [[UIView alloc] initWithFrame:contentFrame];
        contentBackground.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin |  UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
        
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:name]];
        imageView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin; // 控件的宽度和高度随着父视图的宽度按比例改变；
        imageView.frame = self.view.bounds;
        [contentBackground addSubview:imageView];
        
        [viewsForContent addObject:contentBackground];
    }
    
    /* 设置ContentView中的各个内容视图 */
    [_contentView setContentViews:viewsForContent];
    [self.view addSubview:_contentView];
    
    _contentView.delegate = self;
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    self.contentView = nil;
}

/* 对pagedScrollView的scrollView中的各个子视图的位置进行布局 */
- (void)viewWillLayoutSubviews {
    [_contentView layoutContentViews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    self.contentView = nil;
}

#pragma mark - Introduction Delegate

- (void)introductionDidFinishReading:(IntroduceView *)anIntroView {
    [JCUserDefaults setObject:@"NO" forKey:kAppInitialize];
    [self performSegueWithIdentifier:kIntroductionToRootNavigationSegue sender:nil];
}

@end
