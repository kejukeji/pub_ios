//
//  MHaveDrinkView.m
//  Maomao
//
//  Created by maochengfang on 13-12-10.
//  Copyright (c) 2013年 BangQu. All rights reserved.
//

#import "MHaveDrinkView.h"
#import "MTitleView.h"
#import "MBackBtn.h"

@interface MHaveDrinkView ()

@end

@implementation MHaveDrinkView

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
    MTitleView *drinkTitleView = [[MTitleView alloc] initWithFrame:CGRectMake(0, 0, 160, 44)];
    drinkTitleView.titleName.text =@"喝一杯";
    
    self.navigationItem.titleView = drinkTitleView;
    
    MBackBtn *backBtn = [MBackBtn buttonWithType:UIButtonTypeCustom];
    [backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    
    if (!noiOS7) {
        for(UIView *view in self.view.subviews)
        {
            [view setFrame:CGRectMake(view.frame.origin.x, view.frame.origin.y+64, view.frame.size.width, view.frame.size.height)];
        }
    }
}

- (void) back
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)sendInviteBtn:(UIButton *)sender
{
    prompting = [[GPPrompting alloc] initWithView:self.view Text:@"邀请已发送" Icon:nil];
    [self.view addSubview:prompting];
    [prompting show];
}
@end
