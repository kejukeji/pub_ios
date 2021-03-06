//
//  MMyActivityCollectVC.m
//  Maomao
//
//  Created by maochengfang on 13-12-11.
//  Copyright (c) 2013年 BangQu. All rights reserved.
//

#import "MMyActivityCollectVC.h"
#import "Utils.h"
#import "MBackBtn.h"
#import "JSON.h"
#import "MTitleView.h"
#import "MActivityCollectModel.h"
#import "MBarActivityVC.h"

@interface MMyActivityCollectVC ()

@end

@implementation MMyActivityCollectVC
@synthesize titleNameString;
@synthesize activityCollectId;
@synthesize sendRequest;
@synthesize refreshHeaderView;
@synthesize activityListTV;

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
    MTitleView *myActivityTitleView = [[MTitleView alloc] initWithFrame:CGRectMake(0, 0, 160, 44)];
    myActivityTitleView.titleName.text =@"活动收藏";
    self.navigationItem.titleView = myActivityTitleView;
    
    [self.view setBackgroundColor:[UIColor colorWithRed:0.89 green:0.89 blue:0.91 alpha:1.0]];
    
    MBackBtn *backBtn = [MBackBtn buttonWithType:UIButtonTypeCustom];
    
    [backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    
    activityListTV = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, 416+(iPhone5?88:0)) style:UITableViewStylePlain];
    [activityListTV setDelegate:self];
    [activityListTV setDataSource:self];
    [activityListTV setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [activityListTV setBackgroundColor:[UIColor clearColor]];
    [activityListTV setBackgroundView:nil];
    [activityListTV setRowHeight:80.0f];
    
    [self.view addSubview:activityListTV];
    
    activityListSource = [NSMutableArray arrayWithCapacity:0];
    currentIndex = 0;
    
    NSString *userid = [[NSUserDefaults standardUserDefaults] stringForKey:USERID];
    NSString *url = [NSString stringWithFormat:@"%@/restful/collect/activity/list?user_id=%@",MM_URL, userid];
    
    NSLog(@"URL @@@@@@ = %@",url);
    [self initWithRequestByUrl:url];
    
    if (!noiOS7) {
        for (UIView *view in self.view.subviews) {
            [view setFrame:CGRectMake(view.frame.origin.x, view.frame.origin.y+64, view.frame.size.width, view.frame.size.height)];
        }
    }
}

- (void)back
{
    [self.sendRequest clearDelegatesAndCancel];
    
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark -
#pragma mark - Send Request Method

- (void)initWithRequestByUrl:(NSString *)urlString
{
    self.activityCollectId = urlString;
    
    if (refreshHeaderView == nil) {
        EGORefreshTableHeaderView   *view = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, -70.0f, activityListTV.frame.size.width, 70.0f)];
        view.delegate = self;
        view.backgroundColor = [UIColor clearColor];
        [activityListTV addSubview:view];
        self.refreshHeaderView = view;
    }
    
    [activityListTV setContentOffset:CGPointMake(0, -65) animated:NO];
    [refreshHeaderView egoRefreshScrollViewDidScroll:activityListTV];
    [refreshHeaderView egoRefreshScrollViewDidEndDragging:activityListTV];
}

- (void)refaushTableViewData
{
    if (activityCollectId ==nil) {
        return;
    }
    // 等待接口http://42.121.108.142:6001/restful/collect/activity/list？user_id =1&page=1
    NSString *url = [NSString stringWithFormat:@"%@&page=%d",activityCollectId,currentIndex];
    [self sendRequestByUrlString:url];
    
    
    NSLog(@"网络流量过去5秒的平均流量字节/秒 ==%lu",[ASIHTTPRequest averageBandwidthUsedPerSecond]);
}

#pragma mark - EGORefreshTableHeaderDelegate

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view
{
    currentIndex = 1;
    [activityListSource removeAllObjects];
    [activityListTV reloadData];
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
	[refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:activityListTV];
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


- (void)sendRequestByUrlString:(NSString *)urlString
{
    isNetWork = [Utils checkCurrentNetWork];
    if (!isNetWork) {
        if (prompting != nil) {
            prompting = nil;
        }
        prompting = [[GPPrompting alloc] initWithView:self.view Text:@"网络中断" Icon:nil];
        [self.view addSubview:prompting];
        [prompting show];
        return;
    }
    
    if (self.sendRequest != nil) {
        [self.sendRequest clearDelegatesAndCancel];
        self.sendRequest =nil;
    }
    
    NSURL *url = [NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding ]];
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
    
    if (response == nil || [response JSONValue] == nil) {
        return;
    }
    
    NSDictionary *responseDict = [response JSONValue];
    
    NSInteger status = [[responseDict objectForKey:@"status"] integerValue];
    
    NSArray   *activityCollectList = [responseDict objectForKey:@"activity_collect"];
    
    if (status ==0)
    {
        for(NSDictionary *dict in activityCollectList)
        {

            MActivityCollectModel *model = [[MActivityCollectModel alloc] init];
            model.activity_info = [dict objectForKey:@"activity_info"];
            model.base_path = [dict objectForKey:@"base_path"];
            model.collect_time = [dict objectForKey:@"collect_time"];
            model.end_date = [dict objectForKey:@"end_date"];
            model.hot = [[dict objectForKey:@"hot"] boolValue];
            model.activity_collect_id = [dict objectForKey:@"id"];
            model.join_people_number  = [dict objectForKey:@"join_people_number"];
            model.pic_path = [dict objectForKey:@"pic_path"];
            model.pic_name = [dict objectForKey:@"pic_name"];
            model.pub_id   = [dict objectForKey:@"pub_id"];
            model.pub_name = [dict objectForKey:@"pub_name"];
            model.rel_path = [dict objectForKey:@"rel_path"];
            model.start_date = [dict objectForKey:@"start_date"];
            model.title    = [dict objectForKey:@"title"];
            
            [activityListSource addObject:model];
        }
        currentIndex++;
        [activityListTV reloadData];
    }
    
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    [self doneLoadingTableViewData];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"网络无法连接，请检查网络连接" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles: nil];
    [alertView show];
}

#pragma mark -
#pragma mark - UITableView Delegate DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"Rowa == %d",[activityListSource count]);
    return [activityListSource count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentify = @"cell";
    MBarAciivityCollectCell *cell = (MBarAciivityCollectCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentify];
    if (cell == nil) {
        [[NSBundle mainBundle] loadNibNamed:@"MBarAciivityCollectCell" owner:self options:nil];
        cell = activityCollectCell;
    }
    
    if (!noiOS7) {
        [cell setBackgroundColor:[UIColor clearColor]];
    }
    NSLog(@"indexPath.row =%d",indexPath.row);
    NSLog(@"[activityListSource count] == %d",[activityListSource count]);
    NSLog(@"currentIndex == %d",currentIndex);

    if ([activityListSource count] > 0 && indexPath.row == [activityListSource count] -1) {
        
        if (currentIndex < [activityListSource count]) {
            
            NSString *url = [NSString stringWithFormat:@"%@&page=%d",activityCollectId,currentIndex];
            [self sendRequestByUrlString:url];
            NSLog(@"url  in ^^^^^^^^^^== %@",url);
        }
        
        
    }
    
    [cell setSelectionStyle: UITableViewCellSelectionStyleNone];
    
    MActivityCollectModel   *model = [activityListSource objectAtIndex:indexPath.row];
    [cell setCellInfoWithModel:model];

    
    return  cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    MActivityCollectModel *model = [activityListSource objectAtIndex:indexPath.row];
    NSString *userid = [[NSUserDefaults standardUserDefaults] stringForKey:USERID];
    MBarActivityVC *activityVC = [[MBarActivityVC alloc] init];
    
    NSString *url = [NSString stringWithFormat:@"%@/restful/activity/info?activity_id=%@&user_id=%@", MM_URL, model.activity_collect_id, userid];
    
    MTitleView *titleView = [[MTitleView alloc] initWithFrame:CGRectMake(0, 0, 160, 44)];
    titleView.titleName.text = model.pub_name;
    activityVC.navigationItem.titleView = titleView;
    [activityVC initWithRequestByUrl:url];
    [self.navigationController pushViewController:activityVC animated:YES];

}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
