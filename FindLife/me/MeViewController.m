//
//  MeViewController.m
//  FindLife
//
//  Created by qianfeng on 14-9-23.
//  Copyright (c) 2014年 GPH. All rights reserved.
//

#import "MeViewController.h"

#import "TypeView.h"
#import "SearchItem.h"
#import "FindResultViewController.h"


@interface MeViewController ()
{
    UIScrollView *_mainScroll;
    SearchItem *_searchItem;
}
@end

@implementation MeViewController

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
    // Do any additional setup after loading the view.
    self.title = @"Me";
    [self makeView];
  
}



-(void)makeView
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeContactAdd];
    [btn addTarget:self action:@selector(typeDown:) forControlEvents:UIControlEventTouchUpInside];
    
    btn.frame = CGRectMake(0, 70, 320, 60);
    [self.view addSubview:btn];
}


-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = YES;
    self.navigationItem.title = self.title;
}

-(void)typeDown:(UIButton*)btn
{
    FindResultViewController *result = [[FindResultViewController alloc]init];
    [self.navigationController pushViewController:result animated:YES];
    [result release];
  [self setFullScreen:YES];
    
}

- (void)setFullScreen:(BOOL)fullScreen
{
    // 状态条
   [UIApplication sharedApplication].statusBarHidden = fullScreen;
    // 导航条
    [self.navigationController setNavigationBarHidden:fullScreen];
     // tabBar的隐藏通过在初始化方法中设置hidesBottomBarWhenPushed属性来实现
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
