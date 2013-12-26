//
//  MMyTeaserVC.h
//  Maomao
//  传情列表 ＝＝greeting
//  Created by maochengfang on 13-12-11.
//  Copyright (c) 2013年 BangQu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MTeaserCell.h"
#import "ASIHTTPRequest.h"
#import "GPPrompting.h" 
#import "EGORefreshTableHeaderView.h"

@interface MMyTeaserListVC : UIViewController <ASIHTTPRequestDelegate, EGORefreshTableHeaderDelegate, UITableViewDataSource, UITableViewDelegate>
{
    IBOutlet MTeaserCell    *teaserCell;
    GPPrompting             *prompting;
    UITableView             *teaserListTV;
    NSMutableArray          *teaserListSource;
    BOOL                    isNetWork;
    int                     currentIndex;
    BOOL                    reloading;
}

@property (nonatomic, strong) ASIHTTPRequest     *sendRequest;
@property (nonatomic, strong) UITableView        *teaserListTV;
@property (nonatomic, strong) EGORefreshTableHeaderView     *refreshHeaderView;
@property (nonatomic, copy) NSString             *teaserId;
- (void)initWithRequestByUrl:(NSString *)urlString;

@end
