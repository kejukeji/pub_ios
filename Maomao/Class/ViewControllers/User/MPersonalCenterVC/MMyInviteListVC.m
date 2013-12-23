//
//  MMyInviteListVC.m
//  Maomao
//
//  Created by maochengfang on 13-12-11.
//  Copyright (c) 2013年 BangQu. All rights reserved.
//

#import "MMyInviteListVC.h"
#import "Utils.h"
#import "JSON.h"
#import "MBackBtn.h"
#import "MTitleView.h"

#import "MInviteCell.h"
#import "MInvitationModel.h"

@interface MMyInviteListVC ()

@end

@implementation MMyInviteListVC

@synthesize inviteId;
@synthesize inviteListTV;
@synthesize sendRequest;
@synthesize refreshHeaderView;

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
    
    MTitleView *myInviteTitleView = [[MTitleView alloc] initWithFrame:CGRectMake(0, 0, 160, 44)];
    myInviteTitleView.titleName.text = @"邀约";
    self.navigationItem.titleView = myInviteTitleView;
    
    MBackBtn *backBtn = [MBackBtn buttonWithType:UIButtonTypeCustom];
    [backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    
    inviteListSource = [NSMutableArray arrayWithCapacity:0];
    currentIndex = 0;
    
    inviteListTV = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, 414+(iPhone5?88:0)) style:UITableViewStylePlain];
    [inviteListTV setDelegate:self];
    [inviteListTV setDataSource:self];
    [inviteListTV setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [inviteListTV setBackgroundColor:[UIColor clearColor]];
    [inviteListTV setBackgroundView:nil];
    [inviteListTV setRowHeight:80.0f];
    
    [self.view addSubview:inviteListTV];
    
    if (!noiOS7) {
        for (UIView *view in self.view.subviews) {
            [view setFrame:CGRectMake(view.frame.origin.x, view.frame.origin.y+64, view.frame.size.width, view.frame.size.height)];
        }
    }
    
    //等待接口
  NSString *userid = [[NSUserDefaults standardUserDefaults] stringForKey:USERID];
    NSString *url = [NSString stringWithFormat:@"%@/restful/invitation/receiver?user_id=%@",MM_URL, userid];
    [self initWithRequestByUrl:url];
    
}

- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 
#pragma mark - Send Request Method

- (void)initWithRequestByUrl:(NSString *)urlString
{
    self.inviteId = urlString;
    
    if (refreshHeaderView == nil) {
        EGORefreshTableHeaderView *view = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, -70.0f,inviteListTV.frame.size.width, 70.0f)];
        view.delegate = self;
        view.backgroundColor = [UIColor clearColor];
        [inviteListTV addSubview:view];
        self.refreshHeaderView = view;
    }
    
    [inviteListTV setContentOffset:CGPointMake(0, -65) animated:NO];
    [refreshHeaderView egoRefreshScrollViewDidScroll:inviteListTV];
    [refreshHeaderView egoRefreshScrollViewDidEndDragging:inviteListTV];
    
}

- (void)refaushTableViewData
{
    if (inviteId ==nil) {
        return;
    }
    
    // 等待接口
    NSString *url = [NSString stringWithFormat:@"%@&page=%d",inviteId, currentIndex];
    [self sendRequestByUrlString:url];
    NSLog(@"url === %@",url);
    NSLog(@"网络流量过去5秒的平均流量字节/秒 ==%lu",[ASIHTTPRequest averageBandwidthUsedPerSecond]);
}

#pragma mark - EGORefreshTableHeaderDelegate

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view
{
    currentIndex = 1;
    [inviteListSource removeAllObjects];
    [inviteListTV reloadData];
    [self reloadTableViewDataSource];
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view
{
    return reloading;
}

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view
{
    return [NSDate date];
}

/**
 *	@brief	 开始下拉刷新
 */
- (void)reloadTableViewDataSource
{
    [self refaushTableViewData];
	reloading = YES;
}

/**
 *	@brief	结束下拉刷新
 */
- (void)doneLoadingTableViewData
{
	reloading = NO;
	[refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:inviteListTV];
}

- (void)drawRect:(CGRect)rect
{
    [super.view drawRect:rect];
    /***************** 下拉刷新 *****************/
    
    
    // Drawing code
}

/************************************   下拉刷新部分 *****************************************/
#pragma mark - UITableView -> UIScrollviewDelegate
/**
 *	@brief	表格滚动时自动调用
 */
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
}

/**
 *	@brief	结束拖拽时自动调用
 */
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
}


#pragma mark -
#pragma mark - Custom  Privte Method

- (void)sendRequestByUrlString:(NSString *)urlString
{
    isNetWork = [Utils checkCurrentNetWork];
    
    if (!isNetWork) {
        if (prompting != nil) {
            [prompting removeFromSuperview];
            prompting = nil;
        }
        prompting = [[GPPrompting alloc] initWithView:self.view Text:@"网络连接zhduan" Icon:nil];
    }
    
    if (self.sendRequest != nil) {
        [self.sendRequest clearDelegatesAndCancel];
        self.sendRequest = nil;
    }
    
    NSURL *url = [NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    self.sendRequest = [ASIHTTPRequest requestWithURL:url];
    [self.sendRequest setTimeOutSeconds:kRequestTime];
    [self.sendRequest setDelegate:self];
    [self.sendRequest startAsynchronous];
                  
}

#pragma mark -
#pragma mark - ASIHTTPRequestDelegate

- (void)requestFinished:(ASIHTTPRequest *)request
{
    [self doneLoadingTableViewData];
    
    NSString *response  = [request responseString];
    
    if (response == nil || [response JSONValue] ==nil) {
        return;
    }
    
    NSDictionary   *responseDict = [response JSONValue];
    NSInteger status = [[responseDict objectForKey:@"status"] integerValue];
    NSString   *msg = [responseDict objectForKey:@"message"];
    NSLog(@"message == %@",msg);
    
    NSArray *inviteList = [responseDict objectForKey:@"invitation"];
    
    if (status == 0) {
        for(NSDictionary *dict in inviteList)
        {
            MInvitationModel *model = [[MInvitationModel alloc] init];
            model.invitation_id = [[dict objectForKey:@"id"] integerValue];
            model.pic_path = [dict objectForKey:@"pic_path"];
            
            model.receiver_id = [[dict objectForKey:@"receiver_id"] integerValue];
            model.sender_id = [[dict objectForKey:@"sender_id"] integerValue];
            model.time = [dict objectForKey:@"time"];
            
            [inviteListSource addObject:model];

        }
        currentIndex++;
        [inviteListTV reloadData];
    }
    
    
    
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    [self doneLoadingTableViewData];
    
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"温馨提示"
                                                       message:@"网络无法连接,请检查网络连接!"
                                                      delegate:self
                                             cancelButtonTitle:@"知道了"
                                             otherButtonTitles:nil];
    [alertView show];
}

#pragma mark -
#pragma mark UITabelView Delegate DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@" invite row ==%d",[inviteListSource count]);
    return [inviteListSource count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentify = @"cell";
    MInviteCell * cell = (MInviteCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentify];
    if (cell == nil) {
        [[NSBundle mainBundle] loadNibNamed:@"MInviteCell" owner:self options:nil];
        cell = inviteCell;
    }
    
    if (!noiOS7) {
        [cell setBackgroundColor:[UIColor clearColor]];
    }
         
    if ([inviteListSource count] > 0 && indexPath.row == [inviteListSource count] -1) {
        //等待接口
        NSString *url = [NSString stringWithFormat:@"%@&page=%d",inviteId, currentIndex];
        [self sendRequestByUrlString:url];
        NSLog(@"url === %@",url);
    }
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    MInvitationModel *model = [inviteListSource objectAtIndex:indexPath.row];
    
    [cell setCellInfoWithModel:model];
    
    return cell;

}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
