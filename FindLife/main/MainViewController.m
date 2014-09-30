//
//  MainViewController.m
//  FindLife
//
//  Created by qianfeng on 14-9-23.
//  Copyright (c) 2014年 GPH. All rights reserved.
//

#import "MainViewController.h"
#import "MainModel.h"
#import "MainCell.h"
#import "MainHeaderCell.h"
#import "MainHeaderModel.h"
#import "SearchViewController.h"
#import "MainDetailViewController.h"

#define STATE @"STATE"

@interface MainViewController ()
{
    NSDateFormatter *_dateFormatter;
    NSMutableArray *_headerArr;
    NSString *_localUrl;
    NSMutableArray *_dataState;
    int state[10];
    int isCollect[200];
}
@end

@implementation MainViewController

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
    
    _dataState = [[NSMutableArray alloc]init];
    self.title = @"Index";
    [self initTableViewWithFrame:CGRectMake(0, 64, 320, self.view.frame.size.height-49-64) andIsRefresh:YES andIsLoadMore:YES andHasSearchBar:YES];
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.page = 0;
    _dateFormatter = [[NSDateFormatter alloc]init];
    _headerArr = [[NSMutableArray alloc]init];
    [self setUrlWithDate];
    [self startRequest];
    for (int i = 0; i < 200; i++) {
        isCollect[i] = 0;
    }
    
}


-(void)setUrlWithDate
{
    _dateFormatter.dateFormat = @"yyyyMMdd";
    NSDate *date = [NSDate dateWithTimeIntervalSinceNow:-self.page*24*60*60];
    NSString *str = [_dateFormatter stringFromDate:date];
    NSLog(@"%@",[NSString stringWithFormat:@"%@%@",self.url,str]);
    _localUrl =  [NSString stringWithFormat:@"%@%@",self.url,str];

}

-(NSString*)date
{
    NSDate *date = [NSDate dateWithTimeIntervalSinceNow:-self.page*24*60*60];
    _dateFormatter.dateFormat = @"M月dd日";
    NSCalendar *gregorian = [[NSCalendar alloc]initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *weekdayComponents = [gregorian components:NSWeekdayCalendarUnit fromDate:date];
    
    NSString *weekday = nil;
    
    switch (weekdayComponents.weekday)
    {
        case 1:
            weekday = @"一";
            break;
        case 2:
            weekday = @"二";
            break;
        case 3:
            weekday = @"三";
            break;
        case 4:
            weekday = @"四";
            break;
        case 5:
            weekday = @"五";
            break;
        case 6:
            weekday = @"六";
            break;
        case 7:
            weekday = @"日";
            break;
    }
    NSString *dateInfo = [NSString stringWithFormat:@"%@ 星期%@",[_dateFormatter stringFromDate:date],weekday];
    return dateInfo ;
    
}

-(void)startRequest
{
    AFHTTPRequestOperation *request =[[AFHTTPRequestOperation alloc]initWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_localUrl]]];
    
    [request setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
    {
        if (self.isRefresh)
        {
            [_headerArr removeAllObjects];
            [self.dataArr removeAllObjects];
        }

        //标题
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        MainHeaderModel *headerModel = [[MainHeaderModel alloc]init];
        headerModel.title = [dic objectForKey:@"descriptioninfo"];
        headerModel.iconUrl = [dic objectForKey:@"iconurl"];
        headerModel.color = [dic objectForKey:@"color"];
        headerModel.date = [self date];

        [_headerArr addObject:headerModel];
        [headerModel release];
        
        //内容
        NSDictionary *collectDic = [dic objectForKey:@"collectcnt"];
        NSArray *contentArr = [dic objectForKey:@"sectioninfo"];
        NSLog(@"%d,%d",collectDic.count,contentArr.count);
        for (int i = 0;i < contentArr.count;i++)
        {
            NSDictionary *tmpDic = [contentArr objectAtIndex:i];
            MainModel *model = [[MainModel alloc]init];
            model.pic = tmpDic[@"pic"];
            model.sid = [tmpDic[@"sid"] stringValue];
            model.shortname = tmpDic[@"shortname"];
            model.short_addr = tmpDic[@"short_addr"];
            model.collectcnt = [collectDic[model.sid]stringValue];
            
            [self.dataArr addObject:model];
            [model release];
            
            NSMutableDictionary *dic1 = [NSMutableDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:NO],STATE, nil];
            [_dataState addObject:dic1];
        }
        
        [self endPullDownRefresh];
        [self.tableView reloadData];
        NSLog(@"OK");
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
        NSLog(@"ERROR");
    }];
    [request start];
}

#pragma mark -
#pragma mark table的代理方法

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArr.count;
}


-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row%10 == 0)
    {
        MainHeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Header"];
        if (cell == nil)
        {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"MainHeaderCell" owner:self options:nil]lastObject];
        }
        MainHeaderModel *model = _headerArr[indexPath.row/10];

        cell.backView.backgroundColor = [Common colorWithString:model.color];
        cell.titleLabel.text = model.title;
        cell.dateLabel.text = model.date;
        [cell.iconImg setImageWithURL:[NSURL URLWithString:model.iconUrl]];
        return cell;
    }
    
    
    MainCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ID"];
    if (cell == nil)
    {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"MainCell" owner:self options:nil]lastObject];
    }
    //每个段10个row
    
    MainModel *model = self.dataArr[indexPath.row];
    [cell.collectBtn addTarget:self action:@selector(collectBtnDown:) forControlEvents:UIControlEventTouchUpInside];
    if (isCollect[indexPath.row] == 1)
    {
        [cell.collectBtn setImage:[UIImage imageNamed:@"btn_collection_pressed.png"] forState:UIControlStateNormal];
    }
    else
    {
        [cell.collectBtn setImage:[UIImage imageNamed:@"btn_collection_normal.png"] forState:UIControlStateNormal];
    }

    cell.collectBtn.tag = indexPath.row;
    cell.addrLabel.text = model.short_addr;
    cell.titleLabel.text = model.shortname;
    cell.collectNumLabel.text = model.collectcnt;
    //如果已收藏，改变图片
    
    [cell.backImg setImageWithURL:[NSURL URLWithString:model.pic]];
    return cell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //第一个
    if (indexPath.row%10 == 0)
    {
        return 50;
    }
    return 95;
}

//收藏或取消收藏
-(void)collectBtnDown:(UIButton*)btn
{
    MainModel *model = [self.dataArr objectAtIndex:btn.tag];
    int flag = isCollect[btn.tag];
    for (int i = 0; i < 200; i++)
    {
        isCollect[i] = 0;
    }
    
    if (1 == flag)
    {
        model.collectcnt = [NSString stringWithFormat:@"%d",
                            [model.collectcnt intValue]-1];

    }
    else
    {
        model.collectcnt = [NSString stringWithFormat:@"%d",
                            [model.collectcnt intValue]+1];
        isCollect[btn.tag] = 1;
    }
    
    NSIndexPath *index = [NSIndexPath indexPathForRow:btn.tag inSection:0];
    [self.tableView reloadRowsAtIndexPaths:@[index] withRowAnimation:UITableViewRowAnimationFade];
}

-(void)viewWillAppear:(BOOL)animated
{
    [Common HideTabBar:NO andViews:self.tabBarController.view.subviews];
    self.navigationController.navigationBarHidden = NO;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"OK:%d",indexPath.row);
    if (indexPath.row%10 == 0)
    {
        return;
    }
    
    MainModel *model = [self.dataArr objectAtIndex:indexPath.row];
    MainDetailViewController *detail = [[MainDetailViewController alloc]init];
    detail.sid = model.sid;
    detail.addr = model.short_addr;
    detail.title = model.shortname;
    detail.shorName = model.shortname;
    [self.navigationController pushViewController:detail animated:YES];
    [detail release];
    
}

-(void)startToSearch
{
    SearchViewController *search = [[SearchViewController alloc]init];
    [self.navigationController pushViewController:search animated:YES];
    [search release];
}


//加载更多
-(void)loadMore
{
    self.page++;
    [self setUrlWithDate];
    [self startRequest];
}

//下拉刷新
-(void)pullDownRefresh
{
    self.page = 0;
    [self setUrlWithDate];
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
