//
//  TypeViewController.m
//  FindLife
//
//  Created by qianfeng on 14-9-25.
//  Copyright (c) 2014年 GPH. All rights reserved.
//

#import "UIImageView+WebCache.h"
#import "TypeViewController.h"

#import "FindResultViewController.h"

#import "TypeView.h"

@interface TypeViewController ()

{
    UIScrollView *_mainScroll;
}

@end

@implementation TypeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self makeView];

}

-(void)viewWillAppear:(BOOL)animated
{
    [Common HideTabBar:YES andViews:self.tabBarController.view.subviews];
    self.navigationController.navigationBarHidden = NO;
}
-(void)makeView
{
    TypeView *typeView = [[TypeView alloc]initWithFrame:CGRectMake(0, 0, 320, FRAME_HEIGHT)];
    typeView.delegate = self;
    typeView.dic = self.dic;
    typeView.sel = @selector(typeDown:);
    [self.view addSubview:typeView];
    [typeView release];
    [typeView makeView];
}

-(void)typeDown:(NSNumber*)num
{
    FindResultViewController *result = [[FindResultViewController alloc]init];
    result.dic = self.orientDic;
    
    result.catid = [NSString stringWithFormat:@"%d",[num intValue]];
    NSLog(@"catid:%@",result.catid);
    result.areaid = @"-1";
    [self.navigationController pushViewController:result animated:YES];
    [result release];
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
