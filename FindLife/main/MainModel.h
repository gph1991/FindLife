//
//  MainModel.h
//  FindLife
//
//  Created by qianfeng on 14-9-23.
//  Copyright (c) 2014年 GPH. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MainModel : NSObject

//在收到数据时转为NSString,不是太合适

@property(nonatomic,copy)NSString *short_addr;
@property(nonatomic,copy)NSString *shortname;
@property(nonatomic,copy)NSString *pic;
@property(nonatomic,copy)NSString *sid;
@property(nonatomic,copy)NSString *collectcnt;
@property(nonatomic,copy)NSString *distance;

@end
