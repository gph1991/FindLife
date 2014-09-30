//
//  ViewController.h
//  FindLife
//
//  Created by qianfeng on 14-9-25.
//  Copyright (c) 2014年 GPH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGORefreshTableHeaderView.h"
#import "AFNetworking.h"
#import "UIImageView+WebCache.h"
#import "HTTPManager.h"

//基类，只有tableView
@interface ViewController : UIViewController <UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,retain)UITableView *tableView;
@property(nonatomic,retain)NSMutableArray *dataArr;
@property(nonatomic,copy)NSString *url;

//初始化table
-(void)initTableViewWithFrame:(CGRect)rect;
//隐藏或显示tabBar
//+(void)HideTabBar:(BOOL)flag andViews:(NSArray*)viewArr;
@end
