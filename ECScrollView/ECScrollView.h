//
//  ECScrollView.h
//  ScrollViewDemo
//
//  Created by cezr on 15/4/21.
//  Copyright (c) 2015年 云之彼端. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ECScrollView;
@protocol ECScrollViewDelegate <NSObject>
// 点击视图回调
-(void)clickViewWithECScrollView:(ECScrollView *)scrollView;

@end

@interface ECScrollView : UIView

@property(strong, nonatomic) NSArray *views;
@property(assign, nonatomic) NSInteger index;
@property(assign, nonatomic) id<ECScrollViewDelegate> delegate;
@property(assign, nonatomic) BOOL autoScroll;
@property(assign, nonatomic) NSUInteger interval;


@end
