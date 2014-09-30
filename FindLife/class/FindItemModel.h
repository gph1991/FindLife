//
//  FindItemModel.h
//  FindLife
//
//  Created by qianfeng on 14-9-29.
//  Copyright (c) 2014年 GPH. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FindItemModel : NSObject


@property(nonatomic,copy) NSString *secabstract;
@property(nonatomic,copy) NSString *secaddr;
@property(nonatomic,copy) NSString *secname;
@property(nonatomic,copy) NSString *secpic;

@property(nonatomic,copy) NSNumber *secid;
@property(nonatomic,copy) NSNumber *artriclecnt;
@property(nonatomic,copy) NSNumber *collectcnt;
@property(nonatomic,copy) NSString *lng;
@property(nonatomic,copy) NSString *lat;

@property(nonatomic,assign) BOOL iscollect;

@end
