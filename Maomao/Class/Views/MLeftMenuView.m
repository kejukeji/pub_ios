//
//  MLeftMenu.m
//  Maomao
//
//  Created by  zhao on 13-11-6.
//  Copyright (c) 2013年 BangQu. All rights reserved.
//

#import "MLeftMenuView.h"

@implementation MLeftMenuView

@synthesize delegate;
@synthesize signLabel;
@synthesize nameLabel;
@synthesize btn11;//首页按钮
@synthesize btn12;//收藏按钮
@synthesize btn13;//信息按钮
@synthesize btnState;//设置按钮

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        //leftmenu_deepgray_img.png
        
            }
    return self;
}

/*
     按下某个按钮就变成深灰色，其他按钮还是保持原来的状态
 */

- (IBAction)gotoNextVC:(UIButton *)sender
{
    NSLog(@"sender==%d",sender.tag);
    
    if (sender.tag == 11)////判断是那个按钮按下
    {
        [sender setBackgroundImage:[UIImage imageNamed:@"leftmenu_deepgray_img.png"] forState:UIControlStateNormal];
        [sender setBackgroundImage:[UIImage imageNamed:@"leftmenu_deepgray_img.png"] forState:UIControlStateHighlighted];
        
        //其他按钮就没有背景颜色
        [btn12 setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        [btn13 setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        [btnState setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    }
    
    if (sender.tag == 12)
    {
        [sender setBackgroundImage:[UIImage imageNamed:@"leftmenu_deepgray_img.png"] forState:UIControlStateNormal];
        [sender setBackgroundImage:[UIImage imageNamed:@"leftmenu_deepgray_img.png"] forState:UIControlStateHighlighted];
        
        //其他按钮就没有背景颜色
        [btn11 setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        [btn13 setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        [btnState setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    }
    
    if (sender.tag == 13)
    {
        [sender setBackgroundImage:[UIImage imageNamed:@"leftmenu_deepgray_img.png"] forState:UIControlStateNormal];
        [sender setBackgroundImage:[UIImage imageNamed:@"leftmenu_deepgray_img.png"] forState:UIControlStateHighlighted];
        
        //其他按钮就没有背景颜色
        [btn11 setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        [btn12 setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        [btnState setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    }
    
    if (sender.tag == 14)
    {
        [sender setBackgroundImage:[UIImage imageNamed:@"leftmenu_deepgray_img.png"] forState:UIControlStateNormal];
        [sender setBackgroundImage:[UIImage imageNamed:@"leftmenu_deepgray_img.png"] forState:UIControlStateHighlighted];
        
        //其他按钮就没有背景颜色
        [btn11 setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        [btn13 setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        [btn12 setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    }
    
    //去相应的VC
    [delegate gotoNextVC:sender.tag];
}

@end
