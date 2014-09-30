//
//  RootViewController.m
//  FindLife
//
//  Created by qianfeng on 14-9-23.
//  Copyright (c) 2014年 GPH. All rights reserved.
//

#import "RootViewController.h"
#import "EGORefreshTableHeaderView.h"


@interface RootViewController ()<EGORefreshTableHeaderDelegate,UITextFieldDelegate>
{
    EGORefreshTableHeaderView *_refreshView;
    UIButton *_loadMore;
}
@end

@implementation RootViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.dataArr = [NSMutableArray arrayWithCapacity:0];

}

-(void)initTableViewWithFrame:(CGRect)rect andIsRefresh:(BOOL)hasRefresh andIsLoadMore:(BOOL)isHaveLoad andHasSearchBar:(BOOL)search
{
    [self initTableViewWithFrame:rect];
    
    if (hasRefresh)
    {
        _refreshView  = [[EGORefreshTableHeaderView alloc]initWithFrame:
                         CGRectMake(0, -100, 320, 100)];
        _refreshView.delegate = self;
        [self.tableView addSubview:_refreshView];
        [_refreshView release];
    }

    if (isHaveLoad)
    {
        _loadMore = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        _loadMore.frame = CGRectMake(0, 10, 320, 30);
        [_loadMore setTitle:@"加载更多" forState:UIControlStateNormal];
        [_loadMore addTarget:self action:@selector(loadMore) forControlEvents:UIControlEventTouchUpInside];
        self.tableView.tableFooterView = _loadMore;
    }
    if (search)
    {
        [self makeNavigationView];
    }
    
}

-(void)makeNavigationView
{
    _navigationView = [[UIView alloc]initWithFrame:CGRectMake(50, 0, 250, 30)];
    self.navigationItem.titleView = _navigationView;
    [_navigationView release];
    
    UIImageView *searchImg = [[UIImageView alloc]initWithFrame:CGRectMake(10, 5, 15, 15)];
    [searchImg setImage:[UIImage imageNamed:@"search_button.png"]];
    [_navigationView addSubview:searchImg];
    [searchImg release];
    
    UITextField *text = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, 180, 25)];
    text.borderStyle = UITextBorderStyleRoundedRect;
    text.delegate = self;
    text.font = [UIFont systemFontOfSize:14];
    text.placeholder = @"搜索城觅推荐";
    

    text.backgroundColor = COLOR(53, 170, 160, 1);
    [_navigationView addSubview:text];
    [text release];
    
    NSLog(@"Search OK");
    
    UIImageView *img = [[UIImageView alloc]initWithFrame:CGRectMake(190, -2, 30, 30)];
    [img setImage:[UIImage imageNamed:@"selectView_sort_nearby.png"]];
    [_navigationView addSubview:img];
    [img release];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [btn setTitle:@"附近" forState:UIControlStateNormal];
    btn.frame = CGRectMake(220, -3, 50, 30);
    [btn setTintColor:[UIColor whiteColor]];
    [_navigationView addSubview:btn];

}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    //进行跳转
    [textField resignFirstResponder];
    [self startToSearch];
}


-(void)loadMore
{
    
}

//留着重写
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [_refreshView egoRefreshScrollViewDidScroll:scrollView];
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [_refreshView egoRefreshScrollViewDidEndDragging:self.tableView];

}

#pragma mark -
#pragma mark refreshView的代理方法
-(NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView *)view
{
    return [NSDate date];
}

-(void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView *)view
{
    _isRefresh = YES;
    [self pullDownRefresh];
}


//留着被继承后重写,在此更新数据
-(void)pullDownRefresh
{
    
}

-(void)endPullDownRefresh
{
    [_refreshView egoRefreshScrollViewDataSourceDidFinishedLoading:self.tableView];
    _isRefresh = NO;
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
