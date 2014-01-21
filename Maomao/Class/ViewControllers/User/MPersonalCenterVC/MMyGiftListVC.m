//
//  MMyGiftListVC.m
//  Maomao
//
//  Created by maochengfang on 13-12-11.
//  Copyright (c) 2013年 BangQu. All rights reserved.
//

#import "MMyGiftListVC.h"
#import "Utils.h"
#import "JSON.h"
#import "MBackBtn.h"
#import "MTitleView.h"
#import "MGiftModel.h"

@interface MMyGiftListVC ()

@end

@implementation MMyGiftListVC

@synthesize tiltleNameString;
@synthesize giftId;
@synthesize sendRequest;
@synthesize refreshHeaderView;
@synthesize giftListTV;

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
    MTitleView *myGiftTitleView  = [[MTitleView alloc] initWithFrame:CGRectMake(0, 0, 160, 44)];
    
    self.navigationItem.titleView = myGiftTitleView;
    
    [self.view setBackgroundColor:[UIColor colorWithRed:0.89 green:0.89 blue:0.91 alpha:1.0]];
    
    MBackBtn *backBtn = [MBackBtn buttonWithType:UIButtonTypeCustom];
    [backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    
    giftListSource = [NSMutableArray arrayWithCapacity:0];
    currentIndex  = 0;
    
    giftListTV = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, 416+(iPhone5?88:0)) style:UITableViewStylePlain];
    [giftListTV setDelegate:self];
    [giftListTV setDataSource:self];
    [giftListTV setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [giftListTV setBackgroundColor:[UIColor clearColor]];
    [giftListTV setBackgroundView:nil];
    [giftListTV setRowHeight:80.0f];
    [self.view addSubview:giftListTV];
    
    if (!noiOS7) {
        for (UIView *view in self.view.subviews) {
            [view setFrame:CGRectMake(view.frame.origin.x, view.frame.origin.y+64, view.frame.size.width, view.frame.size.height)];
        }
    }

    myGiftTitleView.titleName.text = @"礼物";
    NSString *userid = [[NSUserDefaults standardUserDefaults] stringForKey:USERID];
    //等待接口
    NSString *url = [NSString stringWithFormat:@"%@/restful/gift/receiver?user_id=%@",MM_URL, userid];
    [self initWithRequestByUrl:url];
    
}

- (void)back
{
    [self.sendRequest clearDelegatesAndCancel];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark
#pragma mark - Send Request Method

- (void)initWithRequestByUrl:(NSString *)urlString
{
    self.giftId = urlString;
    
    if (refreshHeaderView == nil) {
        EGORefreshTableHeaderView *view = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, -70.0f, giftListTV.frame.size.width, 70.0f)];
        view.delegate = self;
        view.backgroundColor = [UIColor clearColor];
        [giftListTV addSubview:view];
        self.refreshHeaderView = view;
    }
}

- (void)refaushTableViewData
{
    if (giftId == nil) {
        return;
    }
    
    NSString *url = [NSString stringWithFormat:@"%@&page=%d&gift_type=personal",giftId,currentIndex];
    [self sendRequestByUrlString:url];
    NSLog(@"url == %@",url);
    
    NSLog(@"网络流量过去5秒的平均流量字节/秒 ==%lu",[ASIHTTPRequest averageBandwidthUsedPerSecond]);
}

#pragma mark - EGORefreshTableHeaderDelegate

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view
{
    currentIndex = 1;
    [giftListSource removeAllObjects];
    [giftListTV reloadData];
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
	[refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:giftListTV];
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
#pragma mark - Custom Private Method

- (void)sendRequestByUrlString:(NSString *)urlString
{
    isNetWork = [Utils checkCurrentNetWork];
    
    if (!isNetWork) {
        if (prompting != nil) {
            [prompting removeFromSuperview];
            prompting = nil;
        }
        prompting = [[GPPrompting alloc] initWithView:self.view Text:@"网络连接中断" Icon:nil];
        [prompting show];
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

- (void)requestFinished:(ASIHTTPRequest *)request
{
    [self doneLoadingTableViewData];
    
    NSString *response = [request responseString];
    if (response == nil || [response JSONValue] == nil) {
        return;
    }
    NSDictionary *responseDict = [response JSONValue];
    
    NSInteger status = [[responseDict objectForKey:@"status"] integerValue];
    NSArray     *giftList = [responseDict objectForKey:@"gift"];
    NSString    *msg = [responseDict objectForKey:@"message"];
    NSLog(@"message == %@",msg);
    if (status == 0) {
        for(NSDictionary *dict in giftList)
        {
            
            MGiftModel *model = [[MGiftModel alloc] init];
            model.gift_id = [[dict objectForKey:@"gift_id"] integerValue];
            model.gift_id_id = [[dict objectForKey:@"id"] integerValue];
            model.nick_name = [dict objectForKey:@"nick_name"];
            model.gift_pic_path = [dict objectForKey:@"gift_pic_path"];
            model.gift_name = [dict objectForKey:@"gift_name"];
            model.pic_path  = [dict objectForKey:@"pic_path"];
            model.receiver_id = [[dict objectForKey:@"receiver_id"] integerValue];
            model.sender_id = [[dict objectForKey:@"sender_id"] integerValue];
            model.time = [dict objectForKey:@"time"];
            model.words = [dict objectForKey:@"words"];
            /*
             ..........
             */
            [giftListSource addObject:model];
        }
        currentIndex++;
        [giftListTV reloadData];
    }
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    [self doneLoadingTableViewData];
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"网络无法连接,请检查网络连接!" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles: nil];
    [alertView show];
}

#pragma mark -
#pragma mark - UITableVIew Delegate DataSource

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"礼物数量==%d",[giftListSource count]);
    return [giftListSource count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentfy = @"cell";
    MGiftCell *cell = (MGiftCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentfy];
    if (cell == nil) {
        [[NSBundle mainBundle] loadNibNamed:@"MGiftCell" owner:self options:nil];
        cell = giftCell;
    }
    
    if (!noiOS7) {
        [cell setBackgroundColor:[UIColor clearColor]];
    }
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    MGiftModel *model = [giftListSource objectAtIndex:indexPath.row];
    [cell setCellInfoWithModel:model];
    return cell;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
