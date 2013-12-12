//
//  MMyTeaserVC.m
//  Maomao
//
//  Created by maochengfang on 13-12-11.
//  Copyright (c) 2013年 BangQu. All rights reserved.
//

#import "MMyTeaserListVC.h"
#import "Utils.h"
#import "JSON.h"
#import "MBackBtn.h"
#import "MTitleView.h"

@interface MMyTeaserListVC ()

@end

@implementation MMyTeaserListVC

@synthesize sendRequest;
@synthesize refreshHeaderView;
@synthesize teaserListTV;
@synthesize teaserId;

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
    MTitleView *myTeaserTitleView = [[MTitleView alloc] initWithFrame:CGRectMake(0, 0, 160, 44)];
    myTeaserTitleView.titleName.text = @"媚眼传情";
    self.navigationItem.titleView =myTeaserTitleView;
    [self.view setBackgroundColor:[UIColor colorWithRed:0.89 green:0.89 blue:0.91 alpha:1.0]];
    
    MBackBtn *backBtn = [MBackBtn buttonWithType:UIButtonTypeCustom];
    
    [backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    
    teaserListSource = [NSMutableArray arrayWithCapacity:0];
    currentIndex    = 1;
    
    teaserListTV = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, 416+(iPhone5? 88:0)) style:UITableViewStylePlain];
    
    [teaserListTV setDelegate:self];
    [teaserListTV setDataSource:self];
    [teaserListTV setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [teaserListTV setBackgroundColor:[UIColor clearColor]];
    [teaserListTV setBackgroundView:nil];
    [teaserListTV setRowHeight:80.0f];
    [self.view addSubview:teaserListTV];
    
    if (!noiOS7) {
        for (UIView *view in self.view.subviews) {
            [view setFrame:CGRectMake(view.frame.origin.x, view.frame.origin.y+64, view.frame.size.width, view.frame.size.height)];
        }
    }
    //等待接口url
//    NSString *userid = [[NSUserDefaults standardUserDefaults] stringForKey:USERID];
//    NSString *url = [NSString stringWithFormat:@"%@/restful/user/collect?user_id=%@",MM_URL, userid];
//    [self initWithRequestByUrl:url];
    
}

- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 
#pragma mark - Send Request Method

- (void)initWithRequestByUrl:(NSString *)urlString
{
    self.teaserId = urlString;
    
    if (refreshHeaderView == nil) {
        EGORefreshTableHeaderView *view = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, -70.0f, teaserListTV.frame.size.width, 70.0f)];
        view.delegate = self;
        view.backgroundColor = [UIColor clearColor];
        [teaserListTV addSubview:view];
        self.refreshHeaderView = view;
    }
    
    [teaserListTV setContentOffset:CGPointMake(0, -65) animated:NO];
    [refreshHeaderView egoRefreshScrollViewDidScroll:teaserListTV];
    [refreshHeaderView egoRefreshScrollViewDidEndDragging:teaserListTV];
}

- (void)refaushTableViewData
{
    if (teaserId ==nil) {
        return;
    }
    
//    NSString *url = [NSString stringWithFormat:@"%@&page=%d",collectId, currentIndex];
//    [self sendRequestByUrlString:url];
//    NSLog(@"url === %@",url);
    
    NSLog(@"网络流量过去5秒的平均流量字节/秒 ==%lu",[ASIHTTPRequest averageBandwidthUsedPerSecond]);
}

#pragma mark - EGORefreshTableHeaderDelegate

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view
{
    currentIndex = 1;
    [teaserListSource removeAllObjects];
    [teaserListTV reloadData];
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
	[refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:teaserListTV];
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
#pragma mark - Custom Private Method

- (void)sendRequestByUrlString:(NSString *)urlString
{
    isNetWork = [Utils checkCurrentNetWork];
    
    if (!isNetWork) {
        if (prompting != nil) {
            [prompting removeFromSuperview];
            prompting = nil;
        }
        prompting = [[GPPrompting alloc] initWithView:self.view Text:@"网络中断" Icon:nil];
        [self.view addSubview:prompting];
        return;
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
    
    NSString *response = [request responseString];
    
    if (response == nil || [response JSONValue] ==nil) {
        return;
    }
    
    NSDictionary *responseDict = [response JSONValue];
    
    NSInteger status = [[responseDict objectForKey:@"status"] integerValue];
    NSArray *teaserList = [responseDict objectForKey:@"list"];
    if (status == 0) {
        for(NSDictionary *dict in teaserList)
        {
            //model = .......
            //model.value=....
            
            
            //[teaserListSource addObject:model];
        }
        currentIndex++;
        [teaserListTV reloadData];
    }
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    [self doneLoadingTableViewData];
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"网络无法连接，请检查网络连接!" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles: nil];
    
    [alertView show];
}

#pragma mark -
#pragma mark - UITableView Delegate DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@" row = %d",[teaserListSource count]);
    return [teaserListSource count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentify = @"cell";
    MTeaserCell *cell = (MTeaserCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentify];
    
    if (cell ==nil) {
        [[NSBundle mainBundle] loadNibNamed:@"MTeaserCell" owner:self options:nil];
        cell = teaserCell;
    }
    
    if (!noiOS7) {
        [cell setBackgroundColor:[UIColor clearColor]];
    }
    
    if ([teaserListSource count] > 0 && indexPath.row == [teaserListSource count]-1) {
        //等待接口
//        NSString *url = [NSString stringWithFormat:@"%@&page=%d",teaserId, currentIndex];
//        [self sendRequestByUrlString:url];
//        NSLog(@"url === %@",url);

    }
    //等待接口
//    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
//    
//    MBarCollectModel *model =[barListSources objectAtIndex:indexPath.row];
//    [cell setCellInfoWithModel:model];
    return  cell;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
