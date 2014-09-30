//
//  SearchResultViewController.h
//  FindLife
//
//  Created by qianfeng on 14-9-30.
//  Copyright (c) 2014年 GPH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewController.h"

@interface SearchResultViewController : ViewController

@property(nonatomic,copy)NSString *keywords;

@property (nonatomic,copy) NSDictionary *dic;
@property (nonatomic,copy) NSString *catid;
@property (nonatomic,copy) NSString *areaid;
@property (nonatomic,copy) NSString *sortway;
@property (nonatomic,assign) int page;
@property (nonatomic,copy) NSString *lng;
@property (nonatomic,copy) NSString *lat;



@end
