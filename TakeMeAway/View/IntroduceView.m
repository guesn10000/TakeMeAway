//
//  IntroduceView.m
//  TakeMeAway
//
//  Created by Jymn_Chen on 14-4-27.
//  Copyright (c) 2014年 Jymn_Chen. All rights reserved.
//

#import "IntroduceView.h"
#import "JuliaCore.h"
#import "AppMarcos.h"

static const CGFloat kPageControlDotWidth  = 20.0;
static const CGFloat kPageControlDotHeight = 20.0;

@interface IntroduceView () <UIScrollViewDelegate>

@property (assign, nonatomic) BOOL isPageChanged_;

@end

@implementation IntroduceView

#pragma mark Initialization

/* 设置视图的一些基本属性 */
- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        self.baseFrame = frame;
        self.backgroundColor = [UIColor whiteColor];
        
        self.scrollViewForContent = [[UIScrollView alloc] initWithFrame:CGRectMake(0.0, 0.0, frame.size.width, frame.size.height)];
        self.scrollViewForContent.backgroundColor = [UIColor whiteColor];
        self.scrollViewForContent.delegate = self;
        self.scrollViewForContent.autoresizesSubviews = YES;
        self.scrollViewForContent.contentOffset = CGPointZero;
        self.scrollViewForContent.directionalLockEnabled = NO;
        self.scrollViewForContent.pagingEnabled = YES;
        self.scrollViewForContent.showsHorizontalScrollIndicator = NO;
        self.scrollViewForContent.showsVerticalScrollIndicator = NO;
        self.scrollViewForContent.bounces = NO;
        [self addSubview:self.scrollViewForContent];
        
        self.pageControl = [[UIPageControl alloc] init];
        UIColor *tintColor = [UIColor colorWithRed:203.f/255.f green:86.f/255.f blue:142.f/255.f alpha:1.f];
        self.pageControl.currentPageIndicatorTintColor = tintColor;
        self.pageControl.pageIndicatorTintColor = [UIColor darkGrayColor];
        self.pageControl.hidesForSinglePage = YES;
        [self.pageControl addTarget:self action:@selector(changePage:) forControlEvents:UIControlEventValueChanged];
        [self addSubview:self.pageControl];
    }
    return self;
}

/* 当UIPageControl的值改变时触发的方法 */
- (void)changePage:(UIPageControl *)sender {
    // 设置pageControl翻页后页面的位置
    CGRect frame = self.baseFrame;
    frame.origin.x = frame.size.width * self.pageControl.currentPage; // 设置水平位移
    frame.origin.y = 0.0;
    frame.size = self.baseFrame.size;
    [self.scrollViewForContent scrollRectToVisible:frame animated:YES];
    self.isPageChanged_ = YES; // 翻页成功
}

/* 设置scrollView的内容视图 */
- (void)setContentViews:(NSArray *)viewsForContent {
    // 移除之前在scrollView中的子视图
    for (UIView *subView in [self.scrollViewForContent subviews]) {
        [subView removeFromSuperview];
    }
    
    if (viewsForContent.count <= 0) {
        self.pageControl.numberOfPages = 0;
        return;
    }
    
    
    self.scrollViewForContent.contentSize = CGSizeMake(self.baseFrame.size.width * viewsForContent.count, self.baseFrame.size.height);
    
    // 设置views中各个元素的frame并将其添加到scrollView中，注意当前的各个子视图尚未进行布局
    [viewsForContent enumerateObjectsUsingBlock:^(UIView *v, NSUInteger i, BOOL *stop) {
        v.frame = CGRectMake(self.frame.size.width * i, v.frame.origin.y, v.frame.size.width, v.frame.size.height);
        [self.scrollViewForContent addSubview:viewsForContent[i]];
    }];
    
    
    // 设置pageControl的位置
    self.pageControl.numberOfPages = viewsForContent.count;
    CGFloat width = kPageControlDotWidth * self.pageControl.numberOfPages;
    self.pageControl.frame = CGRectMake((self.scrollViewForContent.frame.size.width - width) / 2,
                                        self.scrollViewForContent.frame.size.height - kPageControlDotHeight,
                                        width,
                                        kPageControlDotHeight);
}

/* 设置scrollView中各个子视图的位置 */
- (void)layoutContentViews {
    // 设置当前pageControl停在第一页
    self.pageControl.currentPage = 0;
    CGRect currentFrame = CGRectMake(self.baseFrame.size.width * self.pageControl.currentPage,
                                     0.0f,
                                     self.baseFrame.size.width, self.baseFrame.size.height);
    [self.scrollViewForContent scrollRectToVisible:currentFrame animated:YES];
    
    
    // 初始化isPageControlling_为YES
    self.isPageChanged_ = YES;
    
    
    // 将scrollView的各个子视图分别布局到scrollView中
    [self.scrollViewForContent.subviews enumerateObjectsUsingBlock:^(UIView *v, NSUInteger i, BOOL *stop) {
        v.frame = CGRectMake(self.frame.size.width * i, 0.f, self.frame.size.width, self.frame.size.height);
        [v setNeedsLayout]; // 立即刷新v当前的位置
    }];
    
    /* 设置入门教程中的按钮 */
    CGFloat buttonCenter_Y = self.pageControl.frame.origin.y - 60.0;
    self.passIntroduction_button = [JCUIComponents buttonWithType:JCNormalButton title:@"跳过教程" action:@selector(passIntroduction:) target:self];
    _passIntroduction_button.center = CGPointMake(self.bounds.size.width / 2, buttonCenter_Y);
    [self.scrollViewForContent addSubview:_passIntroduction_button];
    
    self.finishIntroduction_button = [JCUIComponents buttonWithType:JCNormalButton title:@"马上体验" action:@selector(finishIntroduction:) target:self];
    _finishIntroduction_button.center = CGPointMake(self.bounds.size.width * 2.5, buttonCenter_Y);
    [self.scrollViewForContent addSubview:_finishIntroduction_button];
}

#pragma mark - UIScrollViewDelegate

/* 用户drag scrollView动作即将发生时 */
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    self.isPageChanged_ = NO; // 将isPageChanged重置为NO
}

/* scroll事件尚未停止，即scrollView还没完成减速 */
- (void)scrollViewDidScroll:(UIScrollView *)ascrollView {
    if (self.isPageChanged_) {
        return;
    }
    else { // 如果翻页尚未完成
        // 如果当前scrollView的位移点大于当前页面的一半就跳转到下一个页面
        CGFloat pageWidth = ascrollView.frame.size.width;
        int page = floor((ascrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1; // 向下取整
        self.pageControl.currentPage = page;
    }
}

/* scrollView完成减速 */
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    self.isPageChanged_ = NO;
}

#pragma mark - Button actions

- (void)passIntroduction:(id)sender {
    if ([_delegate respondsToSelector:@selector(introductionDidFinishReading:)]) {
        [_delegate introductionDidFinishReading:self];
    }
}

- (void)finishIntroduction:(id)sender {
    if ([_delegate respondsToSelector:@selector(introductionDidFinishReading:)]) {
        [_delegate introductionDidFinishReading:self];
    }
}

@end
