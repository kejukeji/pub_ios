//
//  MChangeCountyVC.h
//  Maomao
//
//  Created by maochengfang on 14-1-6.
//  Copyright (c) 2014年 BangQu. All rights reserved.
//

@protocol changeCountyDelegate <NSObject>

//该函数实现选择区域就在就把列表中页面中刷新
- (void)changeBarListVC:(NSString *)countyId tpye:(NSInteger) barTpye;


@end

#import <UIKit/UIKit.h>
#import "MChangeCountyCell.h"
#import "ASIHTTPRequest.h"
#import "EGORefreshTableHeaderView.h"

@interface MChangeCountyVC : UIViewController<ASIHTTPRequestDelegate, EGORefreshTableHeaderDelegate>
{
    IBOutlet MChangeCountyCell *countyListCell;
    BOOL                        reloading;
     NSMutableArray               *countySource;
     BOOL                       isNetWork;
    
}

@property (nonatomic, strong)   id<changeCountyDelegate> delegate;

@property (nonatomic, strong) ASIHTTPRequest    *sendRequest;
@property (nonatomic, strong) UITableView       *countyTV;
@property (nonatomic, copy)     NSString        *lastUrlString;
@property (nonatomic, strong) EGORefreshTableHeaderView *refreshHeaderView;
@property (nonatomic, assign)   NSInteger       barTypeId;
@property (nonatomic, copy)     NSString        *titleName;

- (void)initWithRequestByUrl:(NSString *)urlString;

@end
