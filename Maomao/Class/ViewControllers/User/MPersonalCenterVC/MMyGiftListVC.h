//
//  MMyGiftListVC.h
//  Maomao
//
//  Created by maochengfang on 13-12-11.
//  Copyright (c) 2013年 BangQu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MGiftCell.h"
#import "ASIHTTPRequest.h"
#import "GPPrompting.h"
#import "EGORefreshTableHeaderView.h"

@interface MMyGiftListVC : UIViewController <ASIHTTPRequestDelegate, EGORefreshTableHeaderDelegate, UITableViewDataSource, UITableViewDelegate>
{
    IBOutlet MGiftCell  *giftCell;
    GPPrompting         *prompting;
    UITableView         *giftListTV;
    NSMutableArray      *giftListSource;
    BOOL                isNetWork;
    int                 currentIndex;
    BOOL                reloading;
}

@property (nonatomic, copy) NSString    *tiltleNameString;
@property (nonatomic, copy) NSString    *giftId;
@property (nonatomic, strong) ASIHTTPRequest    *sendRequest;
@property (nonatomic, strong) EGORefreshTableHeaderView *refreshHeaderView;
@property (nonatomic, strong) UITableView       *giftListTV;

- (void)initWithRequestByUrl:(NSString *)urlString;


@end
