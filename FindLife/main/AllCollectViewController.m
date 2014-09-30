    //
//  AllCollectViewController.m
//  FindLife
//
//  Created by qianfeng on 14-9-24.
//  Copyright (c) 2014年 GPH. All rights reserved.
//
#define URL @"http://api.chengmi.com/sectioncollectlistv17?sectionid=%@&curpage=%d&perpage=20"

#import "AllCollectViewController.h"
#import "CollectUserCell.h"
#import "CollectUserDetailController.h"


@interface AllCollectViewController ()

@end

@implementation AllCollectViewController

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
    [self initTableViewWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height) andIsRefresh:YES andIsLoadMore:YES andHasSearchBar:NO];
    self.navigationController.navigationBarHidden = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    self.page = 1;
    [self setTheUrl];
    [self startRequest];
    NSLog(@"收藏:%@",self.url);
}

-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = NO;
}

-(void)setTheUrl
{
    self.url = [NSString stringWithFormat:URL,self.sectionid,self.page];
}
-(void)startRequest
{
    [HTTPManager requestWithUrl:self.url FinishBlock:^(NSData *data)
    {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        self.navigationItem.title = [NSString stringWithFormat:@"收藏者(%@)",[dic[@"allcnt"]stringValue]];

        NSArray *arr = dic[@"collectlist"];
        if (self.isRefresh)
        {
            [self.dataArr removeAllObjects];
        }
        //解析
        for (NSDictionary *tmpDic in arr)
        {
            [self.dataArr addObject:tmpDic];
        }
        
        [self.tableView reloadData];
        [self endPullDownRefresh];
        
    } FailedBlock:^{
        NSLog(@"ERROR");
    }];
    
}

#pragma mark table的代理事件

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    CollectUserCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ID"];
    if (cell == nil)
    {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"CollectUserCell" owner:self options:nil]lastObject];
        
    }
    
    NSDictionary *dic = [self.dataArr objectAtIndex:indexPath.row];
    cell.userNameLabel.text = dic[@"uname"];
    [cell.userIconImg setImageWithURL:[NSURL URLWithString:dic[@"uavatar"]]];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dic = [self.dataArr objectAtIndex:indexPath.row];
    CollectUserDetailController *userDetail = [[CollectUserDetailController alloc]init];
    userDetail.dic = dic;
    [self.navigationController pushViewController:userDetail animated:YES];
    [userDetail release];

}


-(void)pullDownRefresh
{
    self.page = 1;
    [self setTheUrl];
    [self startRequest];
}

-(void)loadMore
{
    self.page++;
    [self setTheUrl];
    [self startRequest];
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
