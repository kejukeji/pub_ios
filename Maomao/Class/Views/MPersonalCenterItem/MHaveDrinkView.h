//
//  MHaveDrinkView.h
//  Maomao
//
//  Created by maochengfang on 13-12-10.
//  Copyright (c) 2013年 BangQu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GPPrompting.h"
#import "ASIHTTPRequest.h"

@interface MHaveDrinkView : UIViewController <ASIHTTPRequestDelegate>
{
    GPPrompting *prompting;
    BOOL        isNetWork;
    
}

@property (nonatomic, assign)   NSInteger   receiver_id;
@property (nonatomic, copy)     ASIHTTPRequest  *sendRequest;

- (IBAction)sendInviteBtn:(UIButton *)sender;
- (void)initWithRequestByUrl:(NSString *)urlString;
@end
