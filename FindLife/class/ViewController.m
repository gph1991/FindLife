//
//  ViewController.m
//  FindLife
//
//  Created by qianfeng on 14-9-25.
//  Copyright (c) 2014年 GPH. All rights reserved.
//

#define IOS7 [[[UIDevice currentDevice]systemVersion]floatValue] >= 7.0

#import "ViewController.h"

@interface ViewController ()<UISearchBarDelegate>
{


}
@end

@implementation ViewController

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
    self.dataArr = [NSMutableArray arrayWithCapacity:0];

}

-(void)initTableViewWithFrame:(CGRect)rect
{
    self.tableView = [[UITableView alloc]initWithFrame:rect style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    [self.tableView release];
}

-(void)loadMore
{
    
}

#pragma mark -
#pragma mark table的代理方法

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

//+(void)HideTabBar:(BOOL)flag andViews:(NSArray*)viewArr;
//{
//    NSLog(@"%@",viewArr);
//    
//    UIView *view = viewArr[2];
//    view.hidden = flag;
//    
//    UIView *view1 = viewArr[1];
//    view1.hidden = flag;
//    
//}

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
