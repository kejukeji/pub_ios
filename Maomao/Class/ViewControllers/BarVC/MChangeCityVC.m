//
//  MChangeCityVC.m
//  Maomao
//
//  Created by maochengfang on 14-1-7.
//  Copyright (c) 2014年 BangQu. All rights reserved.
//

#import "MChangeCityVC.h"
#import "MHomeView.h"
#import "MTitleView.h"
#import "MCityModel.h"
#import "MBackBtn.h"
#import "Utils.h"
#import "JSON.h"
#import "AIMTableViewIndexBar.h"
#import "MAreaModel.h"

@interface MChangeCityVC ()<UITableViewDataSource, UITableViewDelegate,AIMTableViewIndexBarDelegate>
{
     BOOL       isNetWork;
    int         currentIndex;
    NSArray      *sectons;
    
    __weak IBOutlet AIMTableViewIndexBar *indexBar;
    CLLocationManager   *locationManager;
    CLGeocoder          *currentCityGeocoder;
    
    
}
@end

@implementation MChangeCityVC

@synthesize cityNameTF;
@synthesize currentCityName;
@synthesize sendRequest;
@synthesize refreshHeaderView;
@synthesize cityTV;
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
    // Do any additional setup after loading the view from its nib.
    MTitleView  *cityTitleView = [[MTitleView alloc] initWithFrame:CGRectMake(0, 0, 160, 44)];
    cityTitleView.titleName.text = @"城市切换";
    
    self.navigationItem.titleView = cityTitleView;
    
    MBackBtn *backBtn = [MBackBtn  buttonWithType:UIButtonTypeCustom];
    [backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    //添加section
    sectons = @[@"#", @"A", @"B", @"C",
                @"D", @"E", @"F", @"G",
                @"H", @"I", @"J", @"K",
                @"L", @"M", @"N", @"O",
                @"P", @"Q", @"R", @"S",
                @"T", @"U", @"V", @"W",
                @"X", @"Y", @"Z"];
    
    indexBar.delegate = self; //设立代理
    
     /*******************定位城市********************/
    currentCityGeocoder = [[CLGeocoder alloc] init];
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.distanceFilter = 1000.0f; //用来控制定位服务更新频率。单位是“米”
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;////这个属性用来控制定位精度，精度越高耗电量越大。
    [locationManager startUpdatingLocation];
    
    /***************************************************/
    citySource = [NSMutableArray arrayWithCapacity:0];
    currentIndex = 1;
    
    cityTV = [[UITableView alloc] initWithFrame:CGRectMake(0, 160, 300, 300+(iPhone5?+88:0)) style:UITableViewStylePlain];
    [cityTV setDelegate:self];
    [cityTV setDataSource:self];
    [cityTV setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [cityTV setBackgroundColor:[UIColor clearColor]];
    [cityTV setBackgroundView:nil];
    [cityTV setRowHeight:40.0f];
    [self.view addSubview:cityTV];
    
    NSString *url = [NSString stringWithFormat:@"%@/restful/area",MM_URL];
    
    NSLog(@"area url == %@",url);
    [self sendRequestByUrlString:url];
    
    if (!noiOS7) {
        for( UIView *view in self.view.subviews)
        {
             [view setFrame:CGRectMake(view.frame.origin.x, view.frame.origin.y+64, view.frame.size.width, view.frame.size.height)];
        }
    }
}


- (void)back
{
    [sendRequest clearDelegatesAndCancel];
    [self.navigationController popViewControllerAnimated:YES];
}

-  (void)initWithRequestUrl:(NSString *)urlString
{
    self.lastUrlString = urlString;
    
    if (refreshHeaderView == nil) {
        EGORefreshTableHeaderView *view = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0, -70.0f, cityTV.frame.size.width, 70)];
        view.delegate = self;
        view.backgroundColor = [UIColor clearColor];
        self.refreshHeaderView = view;
    }
    
    [cityTV setContentOffset:CGPointMake(0, -65) animated:NO];
    
    [refreshHeaderView egoRefreshScrollViewDidScroll:cityTV];
    [refreshHeaderView egoRefreshScrollViewDidEndDragging:cityTV];
    
}

- (void)refaushTableViewData
{
    if (lastUrlString == nil) {
        return;
    }
    
    [self sendRequestByUrlString:lastUrlString];
    
    NSLog(@"url == %@",lastUrlString);
    
    NSLog(@"网络流量过去5秒的平均流量字节/秒 ==%lu",[ASIHTTPRequest averageBandwidthUsedPerSecond]);
}



#pragma mark - EGORefreshTableHeaderDelegate

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view
{
    currentIndex = 1;
    [citySource removeAllObjects];
    [cityTV reloadData];
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
	[refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:cityTV];
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
    
    NSURL *url = [NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
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
    
    NSDictionary *responseDict = [response JSONValue];
    
    NSInteger   status = [[responseDict objectForKey:@"status"] integerValue];
    NSArray     *list = [responseDict objectForKey:@"list"];

    
    if (status == 0) {
        for( NSDictionary *dict in list)
        {
            MAreaModel *model = [[MAreaModel alloc] init];
            model.code = [dict objectForKey:@"code"];
            model.name = [dict objectForKey:@"name"];
            model.country = [dict objectForKey:@"country"];
            model.city_list = [dict objectForKey:@"city_list"];
            model.areaId = [dict objectForKey:@"id"];
            [citySource addObject:model];
        }
        [cityTV reloadData];
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


-  (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  
    return [citySource count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    MAreaModel *model = [citySource objectAtIndex:section];
    NSArray *citys = model.city_list;
    
    return [citys count];
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    MAreaModel *model = [citySource objectAtIndex:section];
    NSString *name = model.name;
    return name;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString     *cellIndentify = @"cell";
    
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIndentify];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentify];
    }
    
    if (!noiOS7) {
        [cell setBackgroundColor:[UIColor clearColor]];
    }
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    MAreaModel *model = [citySource objectAtIndex:indexPath.section];
    
    if ([model.name isEqualToString:@"北京市"] || [model.name isEqualToString:@"天津市"]||[model.name isEqualToString:@"重庆市"]||[model.name isEqualToString:@"上海市"]) {
        [cell.textLabel setText:model.name];
    }
    else
    {
    NSArray *citys = model.city_list;
    NSDictionary *city = [citys objectAtIndex:indexPath.row];
    
    NSString *name = [city objectForKey:@"name"];
    [cell.textLabel setText:name];
    }
    [cell.textLabel setFont:[UIFont systemFontOfSize:15]];
    return cell;
    
}

#pragma makr - mapDelgate

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    [locationManager stopUpdatingLocation];
    NSString *strLat = [NSString stringWithFormat:@"%.4f", newLocation.coordinate.latitude];
    NSString *strLng = [NSString stringWithFormat:@"%.4f",newLocation.coordinate.longitude];
    NSLog(@"Lat: %@ Lng:%@",strLat,strLng);
    [currentCityGeocoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray *placemarks, NSError *error)
    {
        CLPlacemark *placeMark = [placemarks objectAtIndex:0];
        NSString *currentCityStr = [placeMark locality];
        NSLog(@"当前省份为：%@",placeMark.administrativeArea);
        NSLog(@"当前城市为：%@",currentCityStr);
        currentCityName.text = currentCityStr;//placeMark.administrativeArea;
        
    }];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    //获取用户城市失败
    NSString *errorMsg = nil;
    
    if ([error code] == kCLErrorDenied) {
        errorMsg = @"访问被拒绝";
    }
    
    if ([error code] == kCLErrorLocationUnknown) {
        errorMsg = @"获取位置信息失败";
    }
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Location" message:errorMsg delegate:self cancelButtonTitle:@"ok" otherButtonTitles: nil];
    
    [alertView show];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)searchCityBtn:(UIButton *)sender
{
  
    MCityModel *model = [[MCityModel alloc] init];

    
    //筛选出符合的城市
    
    for (int i =0; i < [citySource count]; i++) {
       model  = [citySource objectAtIndex:i];
        //if ([cityNameTF.text isEqualToString:model.name]) {
        //if ([string rangeOfString:@"http:"].length > 0
        if ([cityNameTF.text rangeOfString:model.name].length > 0) {
        
            prompting = [[GPPrompting alloc] initWithView:self.view Text:@"恭喜你找到你喜欢的城市" Icon:nil];
            [self.view addSubview:prompting];
            break;
            [prompting show];
        }
        else
        {
            prompting = [[GPPrompting alloc] initWithView:self.view Text:@"不好意思没有找到您喜欢的城市" Icon:nil];
            [self.view addSubview:prompting];
            [prompting show];
           
            NSString *url = [NSString stringWithFormat:@"%@/restful/pub/home",MM_URL];
            MHomeView *homeView = [[MHomeView alloc] init];
            
            [homeView changeCityName:model.name];
            [homeView initWithRequestByUrl:url];
            
            [self.navigationController popViewControllerAnimated:YES];
           
            
           // [self.view addSubview:homeView];
           
        }
    }
    
    [self.sendRequest clearDelegatesAndCancel];
    [cityNameTF resignFirstResponder];
}

#pragma mark - AIMTableViewIndexBarDelegate

- (void)tableViewIndexBar:(AIMTableViewIndexBar *)indexBar didSelectSectionAtIndex:(NSInteger)index{
    if ([cityTV numberOfSections] > index && index > -1){   // for safety, should always be YES
        [cityTV scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:index]
                              atScrollPosition:UITableViewScrollPositionTop
                                      animated:YES];
    }
}

@end
