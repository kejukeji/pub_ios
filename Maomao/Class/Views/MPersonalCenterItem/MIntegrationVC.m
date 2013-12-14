//
//  MIntegrationVC.m
//  Maomao
//
//  Created by maochengfang on 13-12-11.
//  Copyright (c) 2013年 BangQu. All rights reserved.
//

#import "MIntegrationVC.h"

@interface MIntegrationVC ()

@end

@implementation MIntegrationVC

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
    
    MTitleView *integrationTitleView = [[MTitleView alloc] initWithFrame:CGRectMake(0, 0, 160, 44)];
    integrationTitleView.titleName.text = @"积分规则";
    
    self.navigationItem.titleView = integrationTitleView;
    
    MBackBtn *backBtn = [MBackBtn buttonWithType:UIButtonTypeCustom];
    [backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn   ];
    
    if (!noiOS7) {
        for(UIView *view in self.view.subviews)
        {
            //[view setFrame:CGRectMake(view.frame.origin.x, view.frame.origin.y+64, view.frame.size.width, view.frame.size.height)];
            [view setFrame:CGRectMake(view.frame.origin.x, view.frame.origin.y + 64, view.frame.size.width, view.frame.size.height)];
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

@end
