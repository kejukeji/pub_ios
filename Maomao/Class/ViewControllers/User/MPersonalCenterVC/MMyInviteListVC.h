//
//  MMyInviteListVC.h
//  Maomao
//
//  Created by maochengfang on 13-12-11.
//  Copyright (c) 2013年 BangQu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MInviteCell.h"
#import "ASIHTTPRequest.h"
#import "GPPrompting.h"
#import "EGORefreshTableHeaderView.h"

@interface MMyInviteListVC : UIViewController <ASIHTTPRequestDelegate, EGORefreshTableHeaderDelegate, UITableViewDataSource, UITableViewDelegate>
{
    IBOutlet    MInviteCell *inviteCell;
    GPPrompting             *prompting;
    UITableView             *inviteListTV;
    NSMutableArray          *inviteListSource;
    BOOL                    isNetWork;
    int                     currentIndex;
    BOOL                    reloading;
}

@property (nonatomic, copy) NSString    *inviteId;
@property (nonatomic, strong) ASIHTTPRequest    *sendRequest;
@property (nonatomic, strong) EGORefreshTableHeaderView *refreshHeaderView;
@property (nonatomic, strong) UITableView       *inviteListTV;

- (void)initWithRequestByUrl:(NSString *)urlString;


@end
