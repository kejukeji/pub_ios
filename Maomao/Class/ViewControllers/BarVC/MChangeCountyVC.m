//
//  MChangeCountyVC.m
//  Maomao
//
//  Created by maochengfang on 14-1-6.
//  Copyright (c) 2014年 BangQu. All rights reserved.
//

#import "MChangeCountyVC.h"
#import "Utils.h"
#import "JSON.h"
#import "MBarListVC.h"
#import "MCountyModel.h"
#import "MTitleView.h"

@interface MChangeCountyVC ()<UITableViewDataSource, UITableViewDelegate>
{
   
   
    int             currentIndex;
    
}

@end

@implementation MChangeCountyVC

@synthesize sendRequest;
@synthesize countyTV;
@synthesize lastUrlString;
@synthesize refreshHeaderView;
@synthesize barTypeId;
@synthesize titleName;
@synthesize delegate;

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
    [self.view setBackgroundColor:[UIColor colorWithRed:0.94 green:0.94 blue:0.94 alpha:1.0]];
    
    UIImageView *bgImg = [[UIImageView alloc] init];
    bgImg.frame = CGRectMake(1, -5, 319, 50);
    [bgImg setImage:[UIImage imageNamed:@"barListCountyChange_bg.png"]];
    [self.view addSubview:bgImg];

    UILabel *label = [[UILabel alloc] init];
    label.frame = CGRectMake(10, 10, 80, 30);
    [label setText:@"全部地区"];
    [label setTextAlignment:NSTextAlignmentCenter];
    [label setTextColor:[UIColor colorWithRed:0.19 green:0.41 blue:0.47 alpha:1.0]];
    [self.view addSubview:label];
    
    UIImageView *lineImg = [[UIImageView alloc] init];
    lineImg.frame = CGRectMake(10, 35, 300, 3);
    [lineImg setImage:[UIImage imageNamed:@"barListCountyChange_line_img.png"]];
    [self.view addSubview:lineImg];
    
    countySource = [NSMutableArray arrayWithCapacity:0];
    currentIndex = 1;
    
    countyTV = [[UITableView alloc] initWithFrame:CGRectMake(0, 50, 320, 416 + (iPhone5?88:0)) style:UITableViewStylePlain];
    
    [countyTV setDelegate:self];
    [countyTV setDataSource:self];
    [countyTV setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [countyTV setBackgroundColor:[UIColor clearColor]];
    [countyTV setBackgroundView:nil];
    [countyTV setRowHeight:30.0f];
    [self.view addSubview:countyTV];
    
}


- (void)initWithRequestByUrl:(NSString *)urlString
{
    
    self.lastUrlString = urlString;
    
    if (refreshHeaderView == nil)
    {
        EGORefreshTableHeaderView *view = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, -70.0f, countyTV.frame.size.width, 70)];
        view.delegate = self;
        view.backgroundColor  = [UIColor clearColor];
        [countyTV addSubview:view];
        self.refreshHeaderView = view;
    }
    
    [countyTV setContentOffset:CGPointMake(0, -65) animated:NO];
    
    [refreshHeaderView egoRefreshScrollViewDidScroll:countyTV];
    [refreshHeaderView egoRefreshScrollViewDidEndDragging:countyTV];
    
}

- (void)refaushTableViewData
{
    if (lastUrlString == nil) {
        return;
    }
    
    NSString *url = [NSString stringWithFormat:@"%@&page=%d",lastUrlString, currentIndex];
    
    [self sendRequestByUrlString:url];
    NSLog(@"url ####  === %@",url);
    
    NSLog(@"网络流量过去5秒的平均流量字节/秒 ==%lu",[ASIHTTPRequest averageBandwidthUsedPerSecond]);
}

#pragma mark - EGORefreshTableHeaderDelegate

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view
{
    currentIndex = 1;
    [countySource removeAllObjects];
    [countyTV reloadData];
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
	[refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:countyTV];
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

#pragma mark - Custom Private Method

- (void)sendRequestByUrlString:(NSString *)urlString
{
    NSLog(@"urlString == %@",urlString);
    
    isNetWork = [Utils checkCurrentNetWork];
    NSLog(@" isNetWork == %d",isNetWork);
    
    if (self.sendRequest != nil) {
        [self.sendRequest clearDelegatesAndCancel];
        self.sendRequest = nil;
    }
    
    NSURL * url = [NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSLog(@"url == %@",url);
    sendRequest = [ASIHTTPRequest requestWithURL:url];
    [sendRequest setTimeOutSeconds:kRequestTime];
    [sendRequest setDelegate:self];
    [sendRequest startAsynchronous];
    
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
    
    NSDictionary    *responseDict = [response JSONValue];
    
    NSLog(@"responseDict == %@",responseDict);
    
    NSInteger status = [[responseDict objectForKey:@"status"] integerValue];
    NSArray    *county = [responseDict objectForKey:@"county"];
    
    if (status == 0) {
        for ( NSDictionary *dict in county) {
            MCountyModel *model = [[MCountyModel alloc] init];
            
            model.city_id = [dict objectForKey:@"city_id"];
            model.county_id = [dict objectForKey:@"id"];
            model.name = [dict objectForKey:@"name"];
            model.code = [dict objectForKey:@"code"];
            
            [countySource addObject:model];
            
            NSLog(@"countySource == %d",[countySource count]);
        }
        currentIndex++;
        [countyTV reloadData];
    }
    
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    
    [self doneLoadingTableViewData];

    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"网络无法连接。请检查网络连接" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles: nil];
    
    [alertView show];
    
}

#pragma mark -
#pragma mark - UITableViewDelegate

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
   
    return  [countySource count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentify = @"cell";
    
    MChangeCountyCell *cell = (MChangeCountyCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentify];
    if (cell == nil) {
        [[NSBundle mainBundle] loadNibNamed:@"MChangeCountyCell" owner:self options:nil];
        cell = countyListCell;
    }
    
    if ([countySource count] > 0 && indexPath.row == [countySource count] - 1) {
     
        NSString *url = [NSString stringWithFormat:@"%@&page=%d",lastUrlString, currentIndex];
        [self sendRequestByUrlString:url];
    }
    
    [cell  setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    MCountyModel *model = [countySource objectAtIndex:indexPath.row];
    [cell setCellInfoWithModel:model];
    
    return  cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MCountyModel *model = [countySource objectAtIndex:indexPath.row];
    
   // NSString *url = [NSString stringWithFormat:@"%@/restful/pub/list/detail?type_id=%d&province_id=9&page=%d&city_id=%@",MM_URL, barTypeId,indexPath.row,model.county_id];
    
   // NSLog(@" optional county url == %@", url);
    
    //下面注释的代码 本以为可以改变barListVC下方的TV的数值，结果还是无法实现重新请求加载。
    [delegate changeBarListVC:model.county_id tpye:barTypeId];
    
    //下面注释的代码 本以为可以改变barListVC下方的TV的数值，结果还是无法实现重新请求加载。
//    MBarListVC  *barListVC = [[MBarListVC alloc] init];
//    MTitleView *titleView = [[MTitleView alloc] initWithFrame:CGRectMake(0, 0, 160, 44)];
//    titleView.titleName.text = titleName;
//    barListVC.navigationItem.titleView = titleView;
//    barListVC.isNoBarList = NO;
//    [barListVC initWithRequestByUrl:url];
//    [self.navigationController pushViewController:barListVC animated:YES];

    [self.sendRequest clearDelegatesAndCancel];
    [self.view removeFromSuperview];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
