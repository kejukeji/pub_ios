//
//  MPictureVC.m
//  Maomao
//
//  Created by  zhao on 13-11-12.
//  Copyright (c) 2013年 BangQu. All rights reserved.
//

#import "MPictureVC.h"
#import "UIImageView+WebCache.h"
#import "MBackBtn.h"

@interface MPictureVC ()

@end

@implementation MPictureVC

@synthesize picPath;
@synthesize picImg;

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
	// Do any additional setup after loading the view.
    
    [self.view setBackgroundColor:[UIColor colorWithRed:0.89 green:0.89 blue:0.91 alpha:1.0]];

    MBackBtn *backBtn = [MBackBtn buttonWithType:UIButtonTypeCustom];
    [backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    
    picImg = [[UIImageView alloc] initWithFrame:CGRectMake(60, 60, 200, 200)];
    [picImg setImageWithURL:[NSURL URLWithString:picPath]];
    [self.view addSubview:picImg];
    
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

@end
