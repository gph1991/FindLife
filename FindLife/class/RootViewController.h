//
//  RootViewController.h
//  FindLife
//
//  Created by qianfeng on 14-9-23.
//  Copyright (c) 2014年 GPH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewController.h"
//比父类多了下拉刷新
@interface RootViewController : ViewController

@property(nonatomic,assign)int page;
@property(nonatomic,assign)BOOL isRefresh;
@property(nonatomic,retain)UIView *navigationView;


//初始化table并是否使用上拉加载,下拉刷新,搜索
-(void)initTableViewWithFrame:(CGRect)rect andIsRefresh:(BOOL)hasRefresh andIsLoadMore:(BOOL)isHaveLoad andHasSearchBar:(BOOL)search;

-(void)loadMore;
-(void)pullDownRefresh;
-(void)endPullDownRefresh;

-(void)startToSearch;
@end
