//
//  MHomeView.m
//  Maomao
//
//  Created by  zhao on 13-11-6.
//  Copyright (c) 2013年 BangQu. All rights reserved.
//

#import "MHomeView.h"

@implementation MHomeView

@synthesize delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        UIImageView *topBar = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
        [topBar setImage:[UIImage imageNamed:@"common_barBg_top.png"]];
        [self setBackgroundColor:[UIColor whiteColor]];
        [topBar setUserInteractionEnabled:YES];
        [self addSubview:topBar];
        
        UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [leftBtn setFrame:CGRectMake(14, 10, 30, 24)];
        [leftBtn setImage:[UIImage imageNamed:@"common_btn_left.png"] forState:UIControlStateNormal];
        [leftBtn addTarget:self action:@selector(leftSlider) forControlEvents:UIControlEventTouchUpInside];
        [topBar addSubview:leftBtn];
        
        UIButton *middleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [middleBtn setFrame:CGRectMake(14, 100, 30, 24)];
        [middleBtn setImage:[UIImage imageNamed:@"common_btn_left.png"] forState:UIControlStateNormal];
        [middleBtn addTarget:self action:@selector(gotoBarListVC) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:middleBtn];
        
    }
    return self;
}

- (void)leftSlider
{
    [delegate leftSlider];
}

- (void)gotoBarListVC
{
    [delegate gotoBarListVC];
}

@end
