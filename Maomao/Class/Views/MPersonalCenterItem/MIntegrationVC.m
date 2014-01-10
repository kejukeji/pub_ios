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

@synthesize creditLabel;
@synthesize reputationLabel;
@synthesize credit;
@synthesize reputation;
@synthesize levelImg;

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
    
    UIImageView  *img = [[UIImageView alloc] init];
    img.frame = CGRectMake(37, 164, levelImg.frame.size.width - 180, levelImg.frame.size.height);
    [img setImage:[UIImage imageNamed:@"integration_value_blue.png"]];
    
    [self.view addSubview:img];
    reputationLabel.text = [NSString stringWithFormat:@"经验值：%@",reputation];
    creditLabel.text = credit;
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
