//
//  ThemeViewController.m
//  FindLife
//
//  Created by qianfeng on 14-9-25.
//  Copyright (c) 2014年 GPH. All rights reserved.
//


#import "ThemeViewController.h"
#import "MainModel.h"
#import "MainCell.h"
#import "MainDetailViewController.h"



#import "SearchItemFooterView.h"

//http://api.chengmi.com/v1.9/theme_section_list?theme_id=27&curlng=116.3634362428665&curlat=40.0360007176735&uid=-1&curpage=1
#define URL @"http://api.chengmi.com/v1.9/theme_section_list?theme_id=%@&curlng=%@&curlat=%@&uid=-1&curpage=%d"


@interface ThemeViewController ()
{
    int _page;
    int _number;
    BOOL _hasMap;
    NSMutableArray *_distanceArr;
    
    int state[100];
}

@end

@implementation ThemeViewController

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
    self.title = self.title;
    self.navigationController.navigationBarHidden = NO;
    
    [self initTableViewWithFrame:CGRectMake(0, 0, 320, FRAME_HEIGHT)];
    NSLog(@"height:%f",FRAME_HEIGHT);
    self.tableView.backgroundColor = [UIColor whiteColor];
    _page = 1;
    _number = 0;
    self.lng = @"116.3634362428665";
    self.lat = @"40.0360007176735";
    _hasMap = NO;
    [self setTheUrl];
    [self startRequest];
    
    for (int i = 0; i < 100; i++)
    {
        state[i] = 0;
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = NO;
    [Common HideTabBar:NO andViews:self.tabBarController.view.subviews];
}

-(void)setTheUrl
{
    self.url = [NSString stringWithFormat:URL,self.selectId,self.lng,self.lat,_page];
    NSLog(@"%@",self.url);
}

-(void)startRequest
{
    [HTTPManager requestWithUrl:self.url FinishBlock:^(NSData *data)
    {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        NSDictionary *sectioninfo = dic[@"sectioninfo"];
        _hasMap = [sectioninfo[@"hasmap"]intValue];
        NSDictionary *collectcnt = sectioninfo[@"collectcnt"];
        NSArray *sectionArr = sectioninfo[@"sectioninfo"];
        _number = sectionArr.count;
        for (NSDictionary *tepDic in sectionArr)
        {
            MainModel *model = [[MainModel alloc]init];
            model.pic = tepDic[@"pic"];
            model.short_addr = tepDic[@"short_addr"];
            model.shortname = tepDic[@"shortname"];
            model.sid = [tepDic[@"sid"]stringValue];
            model.distance = [tepDic[@"distance"] stringValue];
            NSLog(@"%@",model.distance);
            //收藏数
            model.collectcnt = [collectcnt[model.sid] stringValue];
            
            [self.dataArr addObject:model];
            [model release];
        }
    
        [self.tableView reloadData];
    } FailedBlock:^{
        NSLog(@"Theme ERROE");
    }];
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 95;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArr.count;
}


-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    MainCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ID"];
    if (cell == nil)
    {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"MainCell" owner:self options:nil]lastObject];
    }

    MainModel *model = self.dataArr[indexPath.row];
    cell.titleLabel.text = model.short_addr;
    NSString *distance = [NSString stringWithFormat:@"%d千米",[model.distance intValue]/1000];
    cell.addrLabel.text = [NSString stringWithFormat:@"%@·%@",model.shortname,distance];
    cell.collectNumLabel.text = model.collectcnt;
    
    //如果已收藏，改变图片,未完成
    [cell.backImg setImageWithURL:[NSURL URLWithString:model.pic]];
    
    return cell;

}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (scrollView.frame.size.height+scrollView.contentOffset.y > scrollView.contentSize.height+50)
    {
        [self loadMore];
    }
}


-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    NSLog(@"OK:%d",indexPath.row);
    MainModel *model = self.dataArr[indexPath.row];
    MainDetailViewController *detail = [[MainDetailViewController alloc]init];
    detail.sid = model.sid;
    detail.title = model.short_addr;
    [self.navigationController pushViewController:detail animated:YES];
    [detail release];
}


-(void)loadMore
{
    if (_page == 2)
    {
        return;
    }
    _page = 2;
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
