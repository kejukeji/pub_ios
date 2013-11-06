//
//  MLoginVC.m
//  Maomao
//
//  Created by  zhao on 13-10-17.
//  Copyright (c) 2013年 BangQu. All rights reserved.
//

#import "MLoginVC.h"
#import "MMainVC.h"

@interface MLoginVC () <UINavigationControllerDelegate>
{
    MMainVC *mainVC;
}

@end

@implementation MLoginVC

@synthesize usernameTF;
@synthesize passwdTF;

@synthesize formDataRequest;
@synthesize navigat;


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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)loginAccount:(UIButton *)sender
{
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstLaunchTag"]; //标记已登陆

//    [self dismissViewControllerAnimated:YES completion:nil];
    
    mainVC = [[MMainVC alloc] init];
    navigat = [[UINavigationController alloc] initWithRootViewController:mainVC];
    navigat.delegate = self;
    [navigat.navigationBar setBackgroundImage:[UIImage imageNamed:@"common_barBg_top.png"] forBarMetrics:UIBarMetricsDefault];
    
    [self presentViewController:navigat animated:NO completion:nil];
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (viewController == mainVC) {
        [navigationController setNavigationBarHidden:YES animated:YES];
    } else if ([navigationController isNavigationBarHidden]) {
        [navigationController setNavigationBarHidden:NO animated:YES];
    }
}

@end
