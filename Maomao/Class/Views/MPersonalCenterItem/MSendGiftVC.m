//
//  MSendGiftVC.m
//  Maomao
//
//  Created by maochengfang on 13-12-10.
//  Copyright (c) 2013年 BangQu. All rights reserved.
//

#import "MSendGiftVC.h"

@interface MSendGiftVC ()

@end

@implementation MSendGiftVC

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
    
    MTitleView *sendGiftTitleView = [[MTitleView alloc] initWithFrame:CGRectMake(0, 0, 160, 44)];
    sendGiftTitleView.titleName.text = @"送小礼物";
    self.navigationItem.titleView = sendGiftTitleView;
    
    MBackBtn *backBtn = [MBackBtn buttonWithType:UIButtonTypeCustom];
    
    [backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    
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
