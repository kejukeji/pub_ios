//
//  MInvitationModel.h
//  Maomao
//
//  Created by maochengfang on 13-12-23.
//  Copyright (c) 2013年 BangQu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MInvitationModel : NSObject

@property (nonatomic, assign)   NSInteger   invitation_id;
@property (nonatomic, copy)     NSString    *nick_name;
@property (nonatomic, copy)     NSString    *pic_path;
@property (nonatomic, assign)   NSInteger   receiver_id;
@property (nonatomic, assign)   NSInteger   sender_id;
@property (nonatomic, copy)     NSString    *time;

@end
