//
//  SearchViewController.h
//  FindLife
//
//  Created by qianfeng on 14-9-25.
//  Copyright (c) 2014年 GPH. All rights reserved.
//catid=16&areaid=11&sortway=distance

#import <UIKit/UIKit.h>
#import "RootViewController.h"

@interface FindResultViewController : RootViewController

@property (nonatomic,copy) NSDictionary *dic;
@property (nonatomic,copy) NSString *catid;
@property (nonatomic,copy) NSString *areaid;
@property (nonatomic,copy) NSString *sortway;

@property (nonatomic,copy) NSString *lng;
@property (nonatomic,copy) NSString *lat;

@end
