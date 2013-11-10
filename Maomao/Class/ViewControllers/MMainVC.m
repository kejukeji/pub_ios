//
//  MMainVC.m
//  Maomao
//
//  Created by  zhao on 13-11-6.
//  Copyright (c) 2013年 BangQu. All rights reserved.
//

#import "MMainVC.h"
#import "MBarListVC.h"

@interface MMainVC ()

@end

@implementation MMainVC

@synthesize touchView;
@synthesize myHomeView;
@synthesize homeView;
@synthesize collectView;
@synthesize messageView;
@synthesize settingView;
@synthesize leftMenuView;

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
    [[NSBundle mainBundle] loadNibNamed:@"MLeftMenuView" owner:self options:nil];
    leftMenuView = leftMenuNib;
    leftMenuView.delegate = self;
    [self.view addSubview:leftMenuView];
    
    touchView = [[MTouchSuperView alloc] initWithFrame:CGRectMake(0, 0, 320, 460+(iPhone5?88:0))];
    [self.view addSubview:touchView];
    
    homeView = [[MHomeView alloc] initWithFrame:CGRectMake(0, 0, 320, 460+(iPhone5?88:0))];
    NSString *url = [NSString stringWithFormat:@"%@/restful/pub/home",MM_URL];
    [homeView initWithRequestByUrl:url];
    NSLog(@"url == %@",url);
    [homeView setDelegate:self];
    [touchView setCurrentView:homeView];
}

#pragma mark - 
#pragma mark MLetMenuViewDelegate

- (void)gotoNextVC:(NSInteger)type
{
    NSLog(@"type==%d",type);
    [touchView setHidden:YES];
    switch (type) {
        case 10:
            if (myHomeView == nil) {
                myHomeView = [[MMyHomeView alloc] initWithFrame:CGRectMake(0, 0, 320, 460+(iPhone5?88:0))];
            }
            [touchView setCurrentView:myHomeView];
            break;
        case 11:
            [touchView setCurrentView:homeView];
            break;
        case 12:
            if (collectView == nil) {
                collectView = [[MCollectView alloc] initWithFrame:CGRectMake(0, 0, 320, 460+(iPhone5?88:0))];
            }
            [touchView setCurrentView:collectView];
            break;
        case 13:
            if (messageView == nil) {
                messageView = [[MMessageView alloc] initWithFrame:CGRectMake(0, 0, 320, 460+(iPhone5?88:0))];

            }
            [touchView setCurrentView:messageView];
            break;
        case 14:
            if (settingView == nil) {
                settingView = [[MSettingView alloc] initWithFrame:CGRectMake(0, 0, 320, 460+(iPhone5?88:0))];
            }
            [touchView setCurrentView:settingView];
            break;
        default:
            break;
    }
}

#pragma mark -
#pragma mark MHomeViewDelegate

- (void)leftSlider
{
    if (touchView.currentState == NormalState) {
        [touchView setHidden:NO];
    } else {
        [touchView setHidden:YES];
    }
}

- (void)gotoBarListVC:(NSInteger)typeId type:(NSString *)name;
{
    NSLog(@"typeid === %d",typeId);
    NSLog(@"name == %@",name);
    MBarListVC *barListVC = [[MBarListVC alloc] init];
    [self.navigationController pushViewController:barListVC animated:YES];
    barListVC.title = name;
    NSString *url = [NSString stringWithFormat:@"%@/restful/pub/list/detail?type_id=%d",MM_URL, typeId];
    [barListVC initWithRequestByUrl:url];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
