//
//  MainDetailViewController.h
//  FindLife
//
//  Created by qianfeng on 14-9-23.
//  Copyright (c) 2014年 GPH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BMapKit.h"

@interface MainDetailViewController : UIViewController <BMKMapViewDelegate>

@property(nonatomic,copy)NSString *sid;
@property(nonatomic,copy)NSString *title;
@property(nonatomic,copy)NSString *addr;
@property(nonatomic,copy)NSString *detailAddr;
@property(nonatomic,copy)NSString *shorName;

@property(nonatomic,copy)NSDictionary *secinfo;
@property(nonatomic,copy)NSMutableArray *collectlist;

@property(nonatomic,assign)float longitude;
@property(nonatomic,assign)float latitude;


@end
