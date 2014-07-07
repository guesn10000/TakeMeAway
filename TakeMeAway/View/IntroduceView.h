//
//  IntroduceView.h
//  TakeMeAway
//
//  Created by Jymn_Chen on 14-4-27.
//  Copyright (c) 2014年 Jymn_Chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@class IntroduceView;

@protocol IntroductionDelegate <NSObject>
- (void)introductionDidFinishReading:(IntroduceView *)anIntroView;
@end

@interface IntroduceView : UIView

@property (strong, nonatomic) UIScrollView *scrollViewForContent;

@property (strong, nonatomic) UIPageControl *pageControl;

@property (assign, nonatomic) CGRect baseFrame;

@property (weak, nonatomic) id<IntroductionDelegate> delegate;

@property (strong, nonatomic) UIButton *passIntroduction_button;

@property (strong, nonatomic) UIButton *finishIntroduction_button;

- (void)setContentViews:(NSArray *)viewsForContent;

- (void)layoutContentViews;

@end
