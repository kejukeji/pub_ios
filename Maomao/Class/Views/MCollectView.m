//
//  MCollectView.m
//  Maomao
//
//  Created by  zhao on 13-11-6.
//  Copyright (c) 2013年 BangQu. All rights reserved.
//

#import "MCollectView.h"

@implementation MCollectView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 44, 320, 460)];
        [label setText:@"收藏"];
        [self addSubview:label];
        
        UIImageView *topBar = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
        [topBar setImage:[UIImage imageNamed:@"common_barBg_top.png"]];
        [self addSubview:topBar];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
