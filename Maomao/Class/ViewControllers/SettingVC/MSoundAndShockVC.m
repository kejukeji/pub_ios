//
//  MMBarSoundAndShockVC.m
//  Maomao
//
//  Created by maochengfang on 13-10-29.
//  Copyright (c) 2013年 BangQu. All rights reserved.
//

#import "MSoundAndShockVC.h"
#import "MBackBtn.h"
#import "MTitleView.h"

@interface MSoundAndShockVC ()
{
    BOOL    isAcceptMsg;
    BOOL    isNoticeShock;
    BOOL    isSilent;
    UIView   *coverView;
    
}


@end

@implementation MSoundAndShockVC
@synthesize firstHook;
@synthesize secondHook;
@synthesize thirdHook;
@synthesize secondBtn;
@synthesize thirdBtn;
@synthesize fourthBtn;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    coverView = [[UIView alloc] initWithFrame:CGRectMake(0, 50+64, 320, 200)];
    [coverView setBackgroundColor:[UIColor colorWithRed:0.89 green:0.89 blue:0.91 alpha:1.0]];
    MTitleView *titleView = [[MTitleView alloc] initWithFrame:CGRectMake(0, 0, 160, 44)];
    titleView.titleName.text = @"新消息提醒";
    self.navigationItem.titleView = titleView;
    
    [self.view setBackgroundColor:[UIColor colorWithRed:0.89 green:0.89 blue:0.91 alpha:1.0]];

    MBackBtn *backBtn = [MBackBtn buttonWithType:UIButtonTypeCustom];
    [backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    
    if (!noiOS7) {
        for (UIView *view in self.view.subviews) {
            [view setFrame:CGRectMake(view.frame.origin.x, view.frame.origin.y+64, view.frame.size.width, view.frame.size.height)];
        }
    }
}

- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)silentNotice:(id)sender
{
    [coverView setFrame:CGRectMake(0, 220, 320, 60)];
    if (isSilent == YES) {
        isSilent = NO;
        fourthBtn.enabled = YES;
        [coverView removeFromSuperview];
        [thirdHook setImage:[UIImage imageNamed:@"setting_img_blueHook.png"]];
    }
    else
    {
        isSilent =YES;
        fourthBtn.enabled = NO;
        [thirdHook setImage:[UIImage imageNamed:@""]];
        [self.view addSubview:coverView];
        
    }

}

- (IBAction)acceptMsg:(UIButton *)sender
{
   
    if (isAcceptMsg == YES) {
        [firstHook setImage:[UIImage imageNamed:@"setting_img_blueHook.png"]];
        
        [coverView removeFromSuperview];
        isAcceptMsg = NO;
        secondBtn.enabled = YES;
        thirdBtn.enabled = YES;
        fourthBtn.enabled = YES;
    }
    else
    {
        secondBtn.enabled = NO;
        thirdBtn.enabled = NO;
        fourthBtn.enabled = NO;
        [firstHook setImage:[UIImage imageNamed:@""]];
        [self.view addSubview:coverView];
        isAcceptMsg = YES;
        
    }
}

- (IBAction)noticeShock:(UIButton *)sender
{
    if (isNoticeShock == YES) {
        
        [secondHook setImage:[UIImage imageNamed:@"setting_img_blueHook.png"]];
        isNoticeShock = NO;
    }
    else
    {
        [secondHook setImage:[UIImage imageNamed:@""]];
        
        isNoticeShock = YES;
    }

}

- (IBAction)pushRingBtn:(id)sender
{
    
}

@end
