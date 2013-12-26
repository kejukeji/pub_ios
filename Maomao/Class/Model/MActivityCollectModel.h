//
//  MActivityCollectModel.h
//  Maomao
//  活动收藏模型
//  Created by maochengfang on 13-12-26.
//  Copyright (c) 2013年 BangQu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MActivityCollectModel : NSObject

@property (nonatomic, copy)     NSString    *activity_info;
@property (nonatomic, copy)     NSString    *base_path;
@property (nonatomic, copy)     NSString    *collect_time;
@property (nonatomic, copy)     NSString    *end_date;
@property (nonatomic, assign)   BOOL        hot;
@property (nonatomic, copy)     NSString    *activity_collect_id;
@property (nonatomic, assign)   BOOL        is_collect;
@property (nonatomic, copy)     NSString    *join_people_number;
@property (nonatomic, copy)     NSString    *pic_name;
@property (nonatomic, copy)     NSString    *pic_path;
@property (nonatomic, copy)     NSString    *pub_id;
@property (nonatomic, copy)     NSString    *pub_name;
@property (nonatomic, copy)     NSString    *rel_path;
@property (nonatomic, copy)     NSString    *start_date;
@property (nonatomic, copy)     NSString    *title;

@end
