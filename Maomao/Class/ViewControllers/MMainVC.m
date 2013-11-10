//
//  MMainVC.m
//  Maomao
//
//  Created by  zhao on 13-11-6.
//  Copyright (c) 2013年 BangQu. All rights reserved.
//

#import "MMainVC.h"
#import "MBarListVC.h"
#import "MBarDetailsVC.h"
#import "MBarListModel.h"
#import "MMessageAwakeVC.h"
#import "MSoundAndShockVC.h"
#import "MFeedbackVC.h"
#import "MAboutVC.h"

@interface MMainVC ()
{
    MMessageAwakeVC    *messageAwakeVC;
    MSoundAndShockVC   *soundAndShockVC;
    MFeedbackVC        *feedbackVC;
    MAboutVC           *aboutVC;
}

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
    
    touchView = [[MTouchSuperView alloc] initWithFrame:CGRectMake(0, 0, 320, 480+(iPhone5?88:0))];
    [self.view addSubview:touchView];
    
    homeView = [[MHomeView alloc] initWithFrame:CGRectMake(0, 0, 320, 460+(iPhone5?88:0)+(noiOS7?0:20))];
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
                myHomeView = [[MMyHomeView alloc] initWithFrame:CGRectMake(0, 0, 320, 460+(iPhone5?88:0)+(noiOS7?0:20))];
                [myHomeView setDelegate:self];
            }
            [touchView setCurrentView:myHomeView];
            break;
        case 11:
            [touchView setCurrentView:homeView];
            break;
        case 12:
            if (collectView == nil) {
                collectView = [[MCollectView alloc] initWithFrame:CGRectMake(0, 0, 320, 460+(iPhone5?88:0)+(noiOS7?0:20))];
                [collectView setDelegate:self];
                
                NSString *userid = [[NSUserDefaults standardUserDefaults] stringForKey:USERID];
                NSString *url = [NSString stringWithFormat:@"%@/restful/user/collect?user_id=%@",MM_URL, userid];
                [collectView initWithRequestByUrl:url];
            }
            [touchView setCurrentView:collectView];
            break;
        case 13:
            if (messageView == nil) {
                messageView = [[MMessageView alloc] initWithFrame:CGRectMake(0, 0, 320, 460+(iPhone5?88:0)+(noiOS7?0:20))];
                [messageView setDelegate:self];
            }
            [touchView setCurrentView:messageView];
            break;
        case 14:
            if (settingView == nil) {
                settingView = [[MSettingView alloc] initWithFrame:CGRectMake(0, 0, 320, 460+(iPhone5?88:0)+(noiOS7?0:20))];
                [settingView setDelegate:self];
            }
            [touchView setCurrentView:settingView];
            break;
        default:
            break;
    }
}

#pragma mark -
#pragma mark MHomeViewDelegate

- (void)homeLeftSlider
{
    [self leftSlider];
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

#pragma mark -
#pragma mark MMyHomeViewDelegate

- (void)myHomeLeftSlider
{
    [self leftSlider]; 
}

#pragma mark -
#pragma mark MCollectViewDelegate

- (void)collectLeftSlider
{
    [self leftSlider];
}

- (void)gotoBarDetail:(MBarListModel *)model
{
    NSString *userid = [[NSUserDefaults standardUserDefaults] stringForKey:USERID];
    MBarDetailsVC *detailsVC = [[MBarDetailsVC alloc] init];
    NSString *url = [NSString stringWithFormat:@"%@/restful/pub/detail?pub_id=%@&user_id=%@", MM_URL, model.barListId, userid];
    detailsVC.title = model.name;
    [detailsVC initWithRequestByUrl:url];
    [self.navigationController pushViewController:detailsVC animated:YES];
}

#pragma mark -
#pragma mark MMessageViewDelegate

- (void)messageLeftSlider
{
    [self leftSlider];
}

- (void)gotoMessageDetails:(NSInteger)number
{
    NSLog(@"number == %d",number);
    
}

#pragma mark -
#pragma mark MSettingViewDelegate

- (void)settingLeftSlider
{
    [self leftSlider];
}

- (void)gotoNextSetting:(NSInteger)number
{
    switch (number) {
        case 11:
            messageAwakeVC = [[MMessageAwakeVC alloc] init];
            [self.navigationController pushViewController:messageAwakeVC animated:YES];
            break;
        case 12:
            soundAndShockVC = [[MSoundAndShockVC alloc] init];
            [self.navigationController pushViewController:soundAndShockVC animated:YES];
            break;
        case 13:
            NSLog(@"更新");
            break;
        case 14:
            feedbackVC = [[MFeedbackVC alloc] init];
            [self.navigationController pushViewController:feedbackVC animated:YES];
            break;
        case 15:
            aboutVC = [[MAboutVC alloc] init];
            [self.navigationController pushViewController:aboutVC animated:YES];
            break;
        case 16:
            NSLog(@"设置");
            [self dismissViewControllerAnimated:YES completion:nil]; //第一次登陆时退出有此，需更改
            break;
        default:
            break;
    }
}


- (void)leftSlider
{
    if (touchView.currentState == NormalState) {
        [touchView setHidden:NO];
    } else {
        [touchView setHidden:YES];
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
