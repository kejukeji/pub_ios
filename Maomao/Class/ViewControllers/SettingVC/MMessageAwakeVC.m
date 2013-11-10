//
//  MBarMessageNotic.m
//  Maomao
//
//  Created by maochengfang on 13-10-20.
//  Copyright (c) 2013年 BangQu. All rights reserved.
//

#import "MMessageAwakeVC.h"
#import "MBackBtn.h"

@interface MMessageAwakeVC ()

@end

@implementation MMessageAwakeVC

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
    self.title = @"消息提醒";
    [self.view setBackgroundColor:[UIColor colorWithRed:0.89 green:0.89 blue:0.91 alpha:1.0]];
    
    MBackBtn *backBtn = [MBackBtn buttonWithType:UIButtonTypeCustom];
    [backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
}

- (void) back
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)setMessageAwake:(id)sender
{
    NSLog(@"this button is clicked");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
