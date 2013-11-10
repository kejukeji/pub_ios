//
//  MBarListVC.m
//  Maomao
//
//  Created by  zhao on 13-10-17.
//  Copyright (c) 2013年 BangQu. All rights reserved.
//

#import "MBarListVC.h"
#import "MBackBtn.h"
#import "MBarPicListModel.h"
#import "MBarListModel.h"
#import "Utils.h"
#import "JSON.h"
#import "UIButton+WebCache.h"
#import "MBarDetailsVC.h"

@interface MBarListVC () <UITableViewDataSource, UITableViewDelegate>
{
    MBProgressHUD   *hud;
    GPPrompting     *prompting;
    NSMutableArray  *barPicSources;
    NSMutableArray  *barListSources;
    UITableView     *barListTV;
    BOOL             isNetWork;
    int              currentIndex;
}

@end

@implementation MBarListVC

@synthesize sendRequest;
@synthesize recommendScrollView;
@synthesize refreshHeaderView;
@synthesize lastUrlString;

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
    
    barPicSources = [NSMutableArray arrayWithCapacity:0];
    barListSources = [NSMutableArray arrayWithCapacity:0];
    currentIndex = 1;

    barListTV = [[UITableView alloc] initWithFrame:CGRectMake(0, 126, 320, 290+(iPhone5?88:0)) style:UITableViewStylePlain];
    [barListTV setDelegate:self];
    [barListTV setDataSource:self];
    [barListTV setBackgroundColor:[UIColor clearColor]];
    [barListTV setBackgroundView:nil];
    [barListTV setRowHeight:108.0f];
    [self.view addSubview:barListTV];
    
}

- (void)back
{
    [self.sendRequest clearDelegatesAndCancel];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)initWithRequestByUrl:(NSString *)urlString
{
    self.lastUrlString = urlString;
    
    if (refreshHeaderView == nil) {
        EGORefreshTableHeaderView *view = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, -70.0f, barListTV.frame.size.width,70.0f)];
        view.delegate = self;
        view.backgroundColor = [UIColor clearColor];
        [barListTV addSubview:view];
        self.refreshHeaderView = view;
    }
    
    [barListTV setContentOffset:CGPointMake(0, -65) animated:NO];
    [refreshHeaderView egoRefreshScrollViewDidScroll:barListTV];
    [refreshHeaderView egoRefreshScrollViewDidEndDragging:barListTV];
    
}

-(void)refaushTableViewData
{
    if(lastUrlString == nil)
    {
        return;
    }
    
    NSString *url = [NSString stringWithFormat:@"%@&page=%d",lastUrlString, currentIndex];
    [self sendRequestByUrlString:url];
    NSLog(@"url === %@",url);
    
    NSLog(@"网络流量过去5秒的平均流量字节/秒 ==%lu",[ASIHTTPRequest averageBandwidthUsedPerSecond]);
}

#pragma mark - EGORefreshTableHeaderDelegate

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view
{
    currentIndex = 1;
    [barListSources removeAllObjects];
    [barListTV reloadData];
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
	[refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:barListTV];
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
        prompting = [[GPPrompting alloc] initWithView:self.view Text:@"网络链接中断" Icon:nil];
        [self.view addSubview:prompting];
        [prompting show];
        return;
    }
    
    if (self.sendRequest != nil) {
        [self.sendRequest clearDelegatesAndCancel];
        self.sendRequest = nil;
    }
    
    NSURL * url = [NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
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
    NSLog(@"response == %@",response);
    if (response == nil || [response JSONValue] == nil) {
        return;
    }
    
    NSDictionary *responseDict = [response JSONValue];
    
    NSInteger status = [[responseDict objectForKey:@"status"] integerValue];
    NSArray *picList = [responseDict objectForKey:@"picture_list"];
    NSArray *pubList = [responseDict objectForKey:@"pub_list"];
    if (status == 0) {
        for (NSDictionary *dict in picList) {
            MBarPicListModel *model = [[MBarPicListModel alloc] init];
            
            model.base_path = [dict objectForKey:@"base_path"];
            model.cover = [dict objectForKey:@"cover"];
            model.picId = [dict objectForKey:@"id"];
            model.intro = [dict objectForKey:@"intro"];
            model.latitude = [dict objectForKey:@"latitude"];
            model.longitude = [dict objectForKey:@"longitude"];
            model.name = [dict objectForKey:@"name"];
            model.pic_name = [dict objectForKey:@"pic_name"];
            model.pic_path = [dict objectForKey:@"pic_path"];
            model.rel_path = [dict objectForKey:@"rel_path"];
            
            model.thumbnail = [dict objectForKey:@"thumbnail"];
            model.type_name = [dict objectForKey:@"type_name"];
            model.upload_name = [dict objectForKey:@"upload_name"];
            model.view_number = [dict objectForKey:@"view_number"];
            
            [barPicSources addObject:model];
        }
        
        for (NSDictionary *dict in pubList) {
            MBarListModel *model = [[MBarListModel alloc] init];
            
            model.city_id = [dict objectForKey:@"city_id"];
            model.county_id = [dict objectForKey:@"county_id"];
            model.email = [dict objectForKey:@"email"];
            model.fax = [dict objectForKey:@"fax"];
            model.barListId = [dict objectForKey:@"id"];
            model.intro = [dict objectForKey:@"intro"];
            model.latitude = [dict objectForKey:@"latitude"];
            model.longitude = [dict objectForKey:@"longitude"];
            model.mobile_list = [dict objectForKey:@"mobile_list"];
            model.name = [dict objectForKey:@"name"];
            
            model.pic_path = [dict objectForKey:@"pic_path"];
            model.province_id = [dict objectForKey:@"province_id"];
            model.recommend = [[dict objectForKey:@"recommend"] boolValue];
            model.street = [dict objectForKey:@"street"];
            model.tel_list = [dict objectForKey:@"tel_list"];
            model.type_name = [dict objectForKey:@"type_name"];
            model.view_number = [dict objectForKey:@"view_number"];
            model.web_url = [dict objectForKey:@"web_url"];
            
            [barListSources addObject:model];
            NSLog(@"barListSources count == %d",[barListSources count]);
        }
        
        currentIndex++;
        [barListTV reloadData];
    }
    
    [self setPicListConten];
    
    [hud hide:YES];
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    [hud hide:YES];
    
    [self doneLoadingTableViewData];

    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"温馨提示"
                                                       message:@"网络无法连接,请检查网络连接!"
                                                      delegate:self
                                             cancelButtonTitle:@"知道了"
                                             otherButtonTitles:nil];
    [alertView show];
}

- (void)setPicListConten
{
    for (int i = 0; i < [barPicSources count]; i++) {
        MBarPicListModel *model = [barPicSources objectAtIndex:i];
        
        UIButton *picBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [picBtn addTarget:self action:@selector(gotoBarDetails:) forControlEvents:UIControlEventTouchUpInside];
        [picBtn setTag:[model.picId integerValue]];
        [picBtn setTitle:model.name forState:UIControlStateNormal];
        [picBtn setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
        NSString *picPath = [NSString stringWithFormat:@"%@%@",MM_URL, model.pic_path];
        [picBtn setImageWithURL:[NSURL URLWithString:picPath] forState:UIControlStateNormal];
        [picBtn setFrame:CGRectMake(i*82, 0, 72, 72)];
        [recommendScrollView addSubview:picBtn];
    }
    
    [recommendScrollView setContentSize:CGSizeMake([barPicSources count] * 82, 72)];
}

- (void)gotoBarDetails:(UIButton *)button
{
    NSString *userid = [[NSUserDefaults standardUserDefaults] stringForKey:USERID];
    MBarDetailsVC *detailsVC = [[MBarDetailsVC alloc] init];
    detailsVC.title = button.titleLabel.text;
    NSString *url = [NSString stringWithFormat:@"%@/restful/pub/detail?pub_id=%d&user_id=%@", MM_URL, button.tag, userid];
    [detailsVC initWithRequestByUrl:url];
    [self.navigationController pushViewController:detailsVC animated:YES];
}

#pragma mark - 
#pragma mark UITabelView Delegate DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [barListSources count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentify = @"cell";
    MBarListCell *cell = (MBarListCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentify];
    if (cell == nil) {
        [[NSBundle mainBundle] loadNibNamed:@"MBarListCell" owner:self options:nil];
        cell = barListCell;
    }
    
    if ([barListSources count] > 0 && indexPath.row == [barListSources count]-1) {
        
        NSString *url = [NSString stringWithFormat:@"%@&page=%d",lastUrlString, currentIndex];
        [self sendRequestByUrlString:url];
        NSLog(@"url === %@",url);
    }
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    MBarListModel *model =[barListSources objectAtIndex:indexPath.row];
    [cell setCellInfoWithModel:model];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MBarListModel *model = [barListSources objectAtIndex:indexPath.row];
    
    NSString *userid = [[NSUserDefaults standardUserDefaults] stringForKey:USERID];
    MBarDetailsVC *detailsVC = [[MBarDetailsVC alloc] init];
    NSString *url = [NSString stringWithFormat:@"%@/restful/pub/detail?pub_id=%@&user_id=%@", MM_URL, model.barListId, userid];
    detailsVC.title = model.name;
    [detailsVC initWithRequestByUrl:url];
    [self.navigationController pushViewController:detailsVC animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
