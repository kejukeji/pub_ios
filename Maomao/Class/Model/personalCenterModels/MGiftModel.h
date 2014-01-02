//
//  MGiftModel.h
//  Maomao
//  个人中心礼物列表模型
//  Created by maochengfang on 13-12-23.
//  Copyright (c) 2013年 BangQu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MGiftModel : NSObject

@property (nonatomic, assign)   NSInteger   gift_id;
@property (nonatomic, assign)   NSInteger   gift_id_id;
@property (nonatomic, copy)     NSString    *gift_pic_path;
@property (nonatomic, copy)     NSString    *gift_name;
@property (nonatomic, copy)     NSString    *nick_name;
@property (nonatomic, copy)     NSString    *pic_path;
@property (nonatomic, assign)   NSInteger   receiver_id;
@property (nonatomic, assign)   NSInteger   sender_id;
@property (nonatomic, copy)     NSString    *time;
@property (nonatomic, copy)     NSString    *words;

@end
