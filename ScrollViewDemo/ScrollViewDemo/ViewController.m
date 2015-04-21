//
//  ViewController.m
//  ScrollViewDemo
//
//  Created by cezr on 15/4/21.
//  Copyright (c) 2015年 云之彼端. All rights reserved.
//

#import "ViewController.h"
#import "ECScrollView.h"

@interface ViewController ()
<ECScrollViewDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    ECScrollView *scrollView = [[ECScrollView alloc] initWithFrame:CGRectMake(0, 200, 375, 200)];
    [self.view addSubview:scrollView];
    
    
    NSMutableArray *views = [NSMutableArray arrayWithCapacity:4];
    for (int i=0; i<4; i++) {
        UIView *vi = [[UIView alloc] init];
        vi.backgroundColor = [UIColor colorWithRed:arc4random_uniform(255)/255.0 green:arc4random_uniform(255)/255.0 blue:arc4random_uniform(255)/255.0 alpha:1.0];
        [views addObject:vi];
    }
    scrollView.views = views;
    
    
    scrollView.delegate =self;
    scrollView.autoScroll = YES;
    
    
}

-(void)clickViewWithECScrollView:(ECScrollView *)scrollView {
    
    NSLog(@"XXXXXXXX");
    scrollView.autoScroll = !scrollView.autoScroll;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
