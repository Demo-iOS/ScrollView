//
//  ECScrollView.m
//  ScrollViewDemo
//
//  Created by cezr on 15/4/21.
//  Copyright (c) 2015年 云之彼端. All rights reserved.
//

#import "ECScrollView.h"


@interface ECPageView : UIView

@property(strong, nonatomic)UIView *view;
-(void)addView:(UIView *)view;
-(void)delView;

@end


@interface UIPageControl (Next_Lase)

-(void)next;
-(void)lase;

@end

@implementation ECPageView

-(void)addView:(UIView *)view {
    self.view = view;
    [self addSubview:view];
}

-(void)delView {
    [self.view removeFromSuperview];
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    ECScrollView *scrollView = (ECScrollView *)self.superview.superview;
    [scrollView.delegate clickViewWithECScrollView:scrollView];
}

@end


@implementation UIPageControl (Next_Lase)

-(void)next {
    self.currentPage = self.currentPage > self.numberOfPages-2 ? 0 : self.currentPage+1;
}
-(void)lase {
    self.currentPage = self.currentPage < 1 ? self.numberOfPages-1 : self.currentPage - 1;
}

@end

@interface ECScrollView ()
<UIScrollViewDelegate>

@property(strong, nonatomic) UIScrollView *scrollView;
@property(strong, nonatomic) UIPageControl *pageControl;
@property(strong, nonatomic) ECPageView *leftView;
@property(strong, nonatomic) ECPageView *centerView;
@property(strong, nonatomic) ECPageView *rightView;
@property(assign, nonatomic) NSInteger sIndex;
@property(assign, nonatomic) BOOL nx;
@property(strong, nonatomic) NSTimer *timer;

@end

@implementation ECScrollView

-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        //
        self.scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        self.scrollView.pagingEnabled = YES;
        self.scrollView.delegate = self;
        self.scrollView.contentSize = CGSizeMake(self.bounds.size.width*3, self.frame.size.height);
        [self.scrollView setContentOffset:CGPointMake(self.bounds.size.width, 0)];
        self.scrollView.showsHorizontalScrollIndicator = NO;
        [self addSubview:self.scrollView];
        
        self.pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, frame.size.height*0.8, frame.size.width, frame.size.height*0.2)];
        [self addSubview:self.pageControl];
        
        
        self.leftView = [[ECPageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        self.centerView = [[ECPageView alloc] initWithFrame:CGRectMake(frame.size.width*1, 0, frame.size.width, frame.size.height)];
        self.rightView = [[ECPageView alloc] initWithFrame:CGRectMake(frame.size.width*2, 0, frame.size.width, frame.size.height)];
        self.leftView.tag = 0;
        self.centerView.tag = 1;
        self.rightView.tag = 2;
        [self.scrollView addSubview:self.leftView];
        [self.scrollView addSubview:self.centerView];
        [self.scrollView addSubview:self.rightView];
    }
    return self;
}


-(void)setViews:(NSArray *)views {
    _views = views;
    for (UIView *view in _views) {
        view.frame = self.bounds;
    }
    self.pageControl.numberOfPages = views.count;
    self.pageControl.contentScaleFactor = 0;
    
    self.index = 0;
}


#pragma mark - Index
-(NSInteger)nextIndex {
    return self.index > (_views.count-1 - 1) ? 0 : self.index+1;
}
-(NSInteger)laseIndex {
    return self.index < 1 ? _views.count-1 : self.index - 1;
}

-(void)setIndex:(NSInteger)index {
    _index = index;
    
    [self.leftView delView];
    [self.centerView delView];
    [self.rightView delView];
    
    [self.leftView addView:_views[[self laseIndex]]];
    [self.centerView addView:_views[self.index]];
    [self.rightView addView:_views[[self nextIndex]]];
}



#pragma mark - UIScrollView
-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    NSInteger curr = round(scrollView.contentOffset.x / self.bounds.size.width);
    if (curr != _sIndex) {
        if (_nx) {
            if (curr == 2) {
                [self.pageControl next];
                _nx = false;
            }
            else if (curr == 0) {
                [self.pageControl lase];
                _nx = false;
            }
        }
    }
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSInteger curr = round(scrollView.contentOffset.x / self.bounds.size.width);
    if (curr != _sIndex) {
        _sIndex = curr;
        if (curr == 2) {
            self.index = [self nextIndex];
        }
        else if (curr == 0) {
            self.index = [self laseIndex];
        }
        [scrollView setContentOffset:CGPointMake(self.bounds.size.width, 0)];
        _sIndex = 1;
        _nx = YES;
        self.pageControl.currentPage = self.index;
        NSLog(@"%ld", self.index);
    }
}



#pragma mark - 自动滚动
-(void)setAutoScroll:(BOOL)autoScroll {
    _autoScroll = autoScroll;
    if (_autoScroll) {
        self.interval = self.interval == 0 ? 2 : self.interval;
        self.timer = [NSTimer scheduledTimerWithTimeInterval:self.interval target:self selector:@selector(scroll) userInfo:nil repeats:YES];
    }
    else {
        [self.timer invalidate];
        self.timer = nil;
    }
}

-(void)scroll {
    [self.scrollView setContentOffset:CGPointMake(self.frame.size.width * 2, 0) animated:YES];
}

-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1*NSEC_PER_SEC / 10), dispatch_get_main_queue(), ^{
        [self scrollViewDidEndDecelerating:scrollView];
    });
}

@end
