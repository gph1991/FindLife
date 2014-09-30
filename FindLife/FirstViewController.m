    //
//  FirstViewController.m
//  FindLife
//
//  Created by qianfeng on 14-9-23.
//  Copyright (c) 2014年 GPH. All rights reserved.
//



#import "FirstViewController.h"
#import "MainViewController.h"
#import "MeViewController.h"
#import "FindViewController.h"

#define IOS7 [[[UIDevice currentDevice]systemVersion]floatValue] >= 7.0


@interface FirstViewController ()
{
    UIView *_view;
}
@end

@implementation FirstViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *str = [defaults objectForKey:@"first"];
    if (!str)
    {
        _view = [[UIView alloc]initWithFrame:self.view.frame];
        [self.view addSubview:_view];
        [_view release];
        
        UIImageView *img = [[UIImageView alloc]initWithFrame:_view.frame];
        img.image = [UIImage imageNamed:@"guide_4.png"];
        [_view addSubview:img];
        [img release];
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
        btn.frame = CGRectMake(80, self.view.frame.size.height-120, 160, 60);
        [btn setTitle:@"开始" forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(startDown) forControlEvents:UIControlEventTouchUpInside];
        [_view addSubview:btn];
    }
    else
    {
        [self makeMainView];
    }
}


-(void)startDown
{
    [_view removeFromSuperview];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:@"1" forKey:@"first"];
    [defaults synchronize];
    
    [self makeMainView];

}

-(void)makeMainView
{
    if(IOS7)
    {
        UIView *topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320,20)];
        topView.backgroundColor = COLOR(53, 198, 179, 1);
        [self.view addSubview:topView];
        [topView release];
    }
    [self createViewController];
    [self createTabBar];
}
-(void)createViewController
{

    MainViewController *main = [[MainViewController alloc]init];
    main.url = @"http://api.chengmi.com/index?passdate=";
    UINavigationController *navMain = [[UINavigationController alloc]
                                       initWithRootViewController:main];
    [main release];
    FindViewController *find = [[FindViewController alloc]init];
 //   find.url = @"http://api.chengmi.com/v1.9/discover?theme_ids=1,3,4,5,6,7,8,9,10,11,12,13,14,15,16,18,19,20,21,22,24,25,26,27,28";
    UINavigationController *navFind = [[UINavigationController alloc]
                                       initWithRootViewController:find];
    [find release];
    MeViewController *me = [[MeViewController alloc]init];
    UINavigationController *navMe = [[UINavigationController alloc]initWithRootViewController:me];
    [me release];
    NSMutableArray *arr =  [NSMutableArray arrayWithObjects:navMain,navFind,navMe,nil];
    [navMain release];
    [navFind release];
    [navMe release];
    self.viewControllers = arr;

}

-(void)createTabBar
{

    NSArray *titlePicCover = @[@"tabBar_index2New.png",@"tabBar_discover2New.png",@"tabBar_mine2New.png"];
    NSArray *titlePicUnconver =  @[@"tabBar_indexNew.png",@"tabBar_discoverNew.png",@"tabBar_mineNew.png"];
    
    UIView *TabBarview = [[UIView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height-49, 320, 49)];
    [self.view addSubview:TabBarview];
    [TabBarview release];
    
    for(int i = 0;i < titlePicCover.count;i++)
    {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(i*106.5,0,106.5, 49);
        
        [btn setImage:[UIImage imageNamed:titlePicCover[i]] forState:UIControlStateSelected];//选中的图片
        
        [btn setImage:[UIImage imageNamed:titlePicUnconver[i]] forState:UIControlStateNormal];//非选中图片
        btn.tag = 1000+i;
        [btn addTarget:self action:@selector(btnDown:) forControlEvents:UIControlEventTouchUpInside];
        
        [TabBarview addSubview:btn];
        
        //确定默认选中的按钮
        if(i == 0)
        {
            btn.selected = YES;
        }
    }
}

-(void)btnDown:(UIButton*)btn
{
    for(int i = 0;i < 3;i++)
    {
        UIButton *tempBtn = (UIButton *)[self.view viewWithTag:1000+i];
        if(tempBtn == btn)
        {
            tempBtn.selected = YES;
        }
        else
        {
            tempBtn.selected = NO;
        }

    }
    //把这个按钮对应的VC显示出来
    self.selectedIndex = btn.tag - 1000;
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
