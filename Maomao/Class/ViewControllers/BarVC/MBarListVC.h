//
//  MBarListVC.h
//  Maomao
//
//  Created by  zhao on 13-10-17.
//  Copyright (c) 2013年 BangQu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIHTTPRequest.h"
#import "MBProgressHUD.h"
#import "GPPrompting.h"
#import "MBarListCell.h"
#import "EGORefreshTableHeaderView.h"
#import "MChangeCountyVC.h"

@interface MBarListVC : UIViewController <ASIHTTPRequestDelegate, EGORefreshTableHeaderDelegate,UIScrollViewDelegate,changeCountyDelegate>
{
    IBOutlet MBarListCell *barListCell;
    BOOL                   reloading;
    NSTimer                 *timeLoop;
}

@property (weak, nonatomic) IBOutlet UIScrollView       *recommendScrollView;
@property (weak, nonatomic) IBOutlet UILabel *barCountLabel;

@property (nonatomic, strong)   UIPageControl          *recommendPage;
@property (nonatomic, strong) ASIHTTPRequest            *sendRequest;
@property (nonatomic, strong) EGORefreshTableHeaderView *refreshHeaderView;
@property (nonatomic, copy)   NSString                  *urlStr;
@property (nonatomic, copy)   NSString                  *lastUrlString;
@property (nonatomic, strong) UITableView               *barListTV;
@property (nonatomic, assign) BOOL                       isNoBarList;
@property (nonatomic, assign) NSInteger                 barID;
@property (nonatomic, copy)   NSString                  *titleName;
@property (nonatomic, strong) UIButton                  *changeCountyBtn;

@property (nonatomic, assign) NSInteger                nearTag; // 标记附近酒吧按钮tag

- (void)initWithRequestByUrl:(NSString *)urlString;
- (IBAction)gotoNearBar:(UIButton *)sender;

@end
