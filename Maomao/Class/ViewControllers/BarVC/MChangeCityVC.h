//
//  MChangeCityVC.h
//  Maomao
//
//  Created by maochengfang on 14-1-7.
//  Copyright (c) 2014年 BangQu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MChangeCityCell.h"
#import "ASIHTTPRequest.h"
#import "GPPrompting.h"
#import "EGORefreshTableHeaderView.h"
#import <MapKit/MapKit.h>

@interface MChangeCityVC : UIViewController <ASIHTTPRequestDelegate, EGORefreshTableHeaderDelegate,CLLocationManagerDelegate>
{
    
    IBOutlet MChangeCityCell *cityCell;
    GPPrompting             *prompting;
    BOOL                   reloading;
    NSMutableArray          *citySource;
    
    
}

@property (weak, nonatomic) IBOutlet UITextField *cityNameTF;
@property (weak, nonatomic) IBOutlet UILabel *currentCityName;
@property (nonatomic, strong) ASIHTTPRequest    *sendRequest;
@property (nonatomic, strong) EGORefreshTableHeaderView *
    refreshHeaderView;
@property (nonatomic, strong) UITableView   *cityTV;
@property (nonatomic, strong) NSString      *lastUrlString;

- (IBAction)searchCityBtn:(UIButton *)sender;
- (void)initWithRequestUrl:(NSString *)urlString;

@end
