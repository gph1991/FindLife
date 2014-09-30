//
//  SearchViewController.m
//  FindLife
//
//  Created by qianfeng on 14-9-25.
//  Copyright (c) 2014年 GPH. All rights reserved.
//

#import "FindResultViewController.h"
#import "BMapKit.h"
#import "MainDetailViewController.h"
#import "AllTypeView.h"
#import "AreaView.h"
#import "TypeView.h"
#import "SortView.h"
#import "MyAnnotation.h"
#import "SearchItem.h"
#import "FindItemModel.h"
#import "FindItemCell.h"
#import "MyAnnotation.h"


#define URL @"http://api.chengmi.com/v1.9/findsection?catid=%@&areaid=%@&curlng=%@&curlat=%@&curpage=%d&perpage=20&loginuserid=%@&sortway=%@&showname=area&iscollect=-1&location=1&childcatid=-1"

@interface FindResultViewController ()<BMKMapViewDelegate>
{
    BMKMapView *_mapView;
    CLLocationCoordinate2D _mystartPt;
    UIView *_view;
    
    NSString *_userid;
    int state[100];
    NSMutableArray *_mapinfo;
    
    AllTypeView *_allTypeView;
    TypeView *_typeView;
    SortView *_sortView;
    AreaView *_areaView;
}
@end

@implementation FindResultViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
        _userid = @"88100";
        self.lat = @"40.0359055152648";
        self.lng = @"116.3640101435277";
        self.sortway = @"time";
        self.view.backgroundColor = [UIColor whiteColor];
        _mapinfo = [[NSMutableArray alloc]init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationController.navigationBarHidden = YES;
    for (int i = 0; i < 100; i++)
    {
        state[i] = 0;
    }
    self.page = 1;
    [self initTableViewWithFrame:CGRectMake(0, 190, 320, FRAME_HEIGHT-50) andIsRefresh:YES andIsLoadMore:NO andHasSearchBar:NO];
    [self makeMapView];
    [self addObserver:self forKeyPath:@"url" options:NSKeyValueObservingOptionNew context:nil];

}

-(void)setTheUrl
{
    [self setValue:[NSString stringWithFormat:URL,self.catid,self.areaid,self.lng,self.lat,self.page,_userid,self.sortway] forKey:@"url"];
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    NSLog(@"new url:%@",change[@"new"]);
    [self startRequest];
}

-(void)makeBtnView
{
    NSArray *titleArr = @[@"返回",@"分类",@"地区",@"排序",@"刷新"];
    int height = 0;
    if (IOS7)
    {
        height = 20;
    }
    for (int i = 0; i < 5; i++)
    {
        UIButton  *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        btn.frame = CGRectMake(i*64, height, 64, 30);
        [btn setTintColor:[UIColor whiteColor]];
        [btn setTitle:titleArr[i] forState:UIControlStateNormal];
        btn.backgroundColor = COLOR(74, 180, 160, 1);

        btn.tag = 3000+i;
        [btn addTarget:self action:@selector(selectDown:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];

        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(i*64-1, height+5, 1, 20)];
        label.backgroundColor = COLOR(212, 212, 212, 1);
        [self.view addSubview:label];
        [label release];
        
        if ( i > 0 && i < 4 )
        {
            UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(i*64+2, height+28, 60, 1)];
            line.backgroundColor = [UIColor whiteColor];
            line.tag = 2000+i;
            line.hidden = YES;
            if (i == 1 && ![self.catid isEqualToString:@"-1"])
            {
                line.hidden = NO;
            }
            if (i == 2 && ![self.areaid isEqualToString:@"-1"])
            {
                line.hidden = NO;
            }
            [self.view addSubview:line];
            [line release];
        }
    }
}


#pragma mark - 请求
-(void)startRequest
{
    [HTTPManager requestWithUrl:self.url FinishBlock:^(NSData *data)
    {
        [self.dataArr removeAllObjects];
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        NSDictionary *mapinfo = dic[@"mapinfo"];
        self.lng = mapinfo[@"lng"];
        self.lat = mapinfo[@"lat"];
        NSArray *locationArr = [mapinfo allKeys];
        NSArray *sectionlist = dic[@"sectionlist"];
        
        for (int i = 0; i < sectionlist.count; i++)
        {
            FindItemModel *model = [[FindItemModel alloc]init];
            NSDictionary *tepDic = sectionlist[i];
            model.secid = tepDic[@"secid"];
            model.collectcnt = tepDic[@"collectcnt"];
            model.artriclecnt = tepDic[@"artriclecnt"];
            model.iscollect = [tepDic[@"iscollect"]boolValue];
            
            model.secabstract = tepDic[@"secabstract"];
            model.secaddr = tepDic[@"secaddr"];
            model.secname = tepDic[@"secname"];
            model.secpic = tepDic[@"secpic"];
            
            for (NSString *str in locationArr )
            {
                if ([str isEqualToString:@"lng"] || [str isEqualToString:@"lat"] )
                {
                    continue;
                }
 
                NSDictionary *locDic = mapinfo[str];
                NSDictionary *lastDic = [locDic[@"seccontent"] objectAtIndex:0];
                
                if ([lastDic[@"secid"] isEqualToNumber:model.secid])
                {
                    model.lng = locDic[@"lng"];
                    model.lat = locDic[@"lat"];
                    break;
                }
            }
            
            [self.dataArr addObject:model];
            [model release];
        }

        dispatch_async(dispatch_get_main_queue(), ^{
            [self loadAnnimation];
        });
        [self.tableView reloadData];

    }
    FailedBlock:^{
        NSLog(@"FindResult ERROR");
    }];
}

-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = YES;
    [Common HideTabBar:YES andViews:self.tabBarController.view.subviews];
    
    [self makeBtnView];
    [self setTheUrl];

}

#pragma mark - 地图
-(void)makeMapView
{
    _mapView = [[BMKMapView alloc]initWithFrame:CGRectMake(0, 50, 320, 130)];
    
    _mystartPt = CLLocationCoordinate2DMake([self.lat floatValue], [self.lng floatValue]);
    BMKCoordinateSpan span = BMKCoordinateSpanMake(0.02, 0.02);
    BMKCoordinateRegion region = BMKCoordinateRegionMake(_mystartPt, span);
    
    //C OC C++
    _mapView.delegate = self;
    [_mapView setRegion:region animated:YES];
    [self.view addSubview:_mapView];
    [_mapView release];
    
    for (int i = 0;i<self.dataArr.count;i++)
    {
        //大头针
        FindItemModel *model = self.dataArr[i];
        MyAnnotation* anno = [[MyAnnotation alloc] init];
        CLLocationCoordinate2D nodePt = CLLocationCoordinate2DMake([model.lat floatValue], [model.lng floatValue]);
        anno.title = [NSString stringWithFormat:@"%d",i];
        anno.coordinate = nodePt;
        [_mapView addAnnotation:anno];
        [anno release];
    }
    
//    UITapGestureRecognizer *mapTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(mapDown)];
//    [_mapView addGestureRecognizer:mapTap];
//    [mapTap release];

}

-(void)loadAnnimation
{
    _mystartPt = CLLocationCoordinate2DMake([self.lat floatValue], [self.lng floatValue]);
    BMKCoordinateSpan span = BMKCoordinateSpanMake(0.02, 0.02);
    BMKCoordinateRegion region = BMKCoordinateRegionMake(_mystartPt, span);
    [_mapView setRegion:region animated:YES];

    for (int i = 0;i<self.dataArr.count;i++)
    {
        //大头针
        FindItemModel *model = self.dataArr[i];
        MyAnnotation* anno = [[MyAnnotation alloc] init];
        CLLocationCoordinate2D nodePt = CLLocationCoordinate2DMake([model.lat floatValue], [model.lng floatValue]);
        anno.title = model.secname;
        anno.subtitle = model.secaddr;
        anno.coordinate = nodePt;
        [_mapView addAnnotation:anno];
        [anno release];
    }
}

-(void)mapDown
{
    NSLog(@"朕知道了");
}

#pragma mark - 选择回调
-(void)selectDown:(UIButton*)btn
{
    switch (btn.tag-3000)
    {
        case 0:
        {
            [self.navigationController popViewControllerAnimated:YES];
            break;
        }
        case 1:
        {
            [self closeView];
            [self showSelectView];
            [self showFirstTypeView];

            break;
        }
        case 2:
        {
            [self closeView];
            [self showSelectView];
            [self showFirstAreaView];
            break;
        }
        case 3:
        {
            [self closeView];
            [self showSelectView];
            [self showSortView];
            break;
        }
        case 4:
        {
            [self setTheUrl];
            break;
        }
    }
}


-(void)showSelectView
{
    NSLog(@"%@",NSStringFromSelector(_cmd));

    if (!_view)
    {
        _view  = [[UIView alloc]initWithFrame:CGRectMake(-1, self.view.frame.size.height-40, 322, 40)];
        [self.view addSubview:_view];
        _view.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _view.layer.borderWidth = 1;
        _view.backgroundColor = [UIColor whiteColor];
        [_view release];
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setImage:[UIImage imageNamed:@"selectView_cancel.png"] forState:UIControlStateNormal];
        btn.tag = 2300;
        btn.frame = CGRectMake(150, 10, 20, 20);
        [btn addTarget:self action:@selector(closeAllExtraView) forControlEvents:UIControlEventTouchUpInside];
        [_view addSubview:btn];
    }
    else
    {
        _view.hidden = NO;
    }
}

//总的分类
-(void)showFirstTypeView
{
    if (_allTypeView != nil)
    {
        [UIView animateWithDuration:0.6f animations:^{
            _allTypeView.frame = CGRectMake(0, 50, 320, FRAME_HEIGHT-50-40);
        }];
        return;
    }

    _allTypeView = [[AllTypeView alloc]initWithFrame:CGRectMake(0, 50, 320, 1)];
    _allTypeView.dataArr = self.dic[@"catinfo"];
    [_allTypeView makeView];
    _allTypeView.delegate = self;
    _allTypeView.sel = @selector(firstTypeDown:);
    [self.view addSubview:_allTypeView];
    _allTypeView.tag =112;
    [UIView animateWithDuration:0.6f animations:^{
        _allTypeView.frame = CGRectMake(0, 50, 320, FRAME_HEIGHT-50-40);
    } completion:^(BOOL finished)
     {
         [self.view addSubview:_allTypeView];
         [_allTypeView release];
     }];
}
//下一级分类
-(void)firstTypeDown:(NSNumber*)num
{
    if ([num intValue] - 5000 == 0)
    {
        NSLog(@"推荐");
        //推荐
        [self closeAllExtraView];
        return;
    }
    NSArray *arr = self.dic[@"catinfo"];
    NSDictionary *dic = arr[[num intValue]-1000];
    
    if (_typeView != nil)
    {
        _typeView.dic = dic;
        [_typeView makeView];
        [UIView animateWithDuration:0.6f animations:^{
            _typeView.frame = CGRectMake(0, 50, 320, FRAME_HEIGHT-50-40);
        }];
        return;
    }
    
    _typeView = [[TypeView alloc]initWithFrame:CGRectMake(0, 50, 320, 1)];
    _typeView.dic = dic;
    [_typeView makeView];
    _typeView.delegate = self;
    _typeView.sel = @selector(secondTypeDown:);
    _typeView.tag = 113;
    
    [UIView animateWithDuration:0.6f animations:^{
        _typeView.frame = CGRectMake(0, 50, 320, FRAME_HEIGHT-50-40);
    } completion:^(BOOL finished)
     {
         [self.view addSubview:_typeView];
        [_typeView release];
     }];
}

//最终分类选择以后
-(void)secondTypeDown:(NSNumber*)num
{
    UILabel *line  = (UILabel*)[self.view viewWithTag:2001];
    line.hidden = NO;
    self.catid = [num stringValue];
    [self closeAllExtraView];
    [self setTheUrl];
}

//选择地区
-(void)showFirstAreaView
{

    if (_areaView != nil)
    {
        [UIView animateWithDuration:0.6f animations:^{
            _areaView.frame = CGRectMake(0, 50, 320, FRAME_HEIGHT-50-40);
        }];
        return;
    }
    
    _areaView = [[AreaView alloc]initWithFrame:CGRectMake(0, 50, 320, 1)];
    _areaView.delegate = self;
    _areaView.sel = @selector(selectFirstArea:);
    _areaView.dataArr = self.dic[@"areainfo"];
    [_areaView makeView];
    _areaView.tag = 114;
    [UIView animateWithDuration:0.6f animations:^{
        _areaView.frame = CGRectMake(0, 50, 320, FRAME_HEIGHT-50-40);
    } completion:^(BOOL finished)
     {
         [self.view addSubview:_areaView];
         [_areaView release];
     }];
}

//选择以后
-(void)selectFirstArea:(NSNumber*)num
{

    UILabel *line  = (UILabel*)[self.view viewWithTag:2002];
    line.hidden = NO;
    
    self.areaid = [num stringValue];
    [self closeAllExtraView];
    [self setTheUrl];

}

-(void)showSortView
{
    NSLog(@"%@",NSStringFromSelector(_cmd));
    if (_sortView != nil)
    {
        [UIView animateWithDuration:0.6f animations:^{
            _sortView.frame = CGRectMake(0, 50, 320, FRAME_HEIGHT-50-40);
        }];
        return;
    }
    
    _sortView = [[SortView alloc]initWithFrame:
                          CGRectMake(0, 50, 320, 1)];
    _sortView.delegate = self;
    _sortView.sel = @selector(sortDown:);
    [_sortView makeView];
    _sortView.tag = 115;
    [UIView animateWithDuration:0.6f animations:^{
        _sortView.frame = CGRectMake(0, 50, 320, FRAME_HEIGHT-50-40);
    } completion:^(BOOL finished)
     {
         [self.view addSubview:_sortView];
         [_sortView release];
     }];
}

-(void)sortDown:(UIButton*)btn;
{
    UILabel *line  = (UILabel*)[self.view viewWithTag:2003];
    line.hidden = NO;
    NSArray *arr = @[@"time",@"distance",@"colcnt"];
    self.sortway = arr[btn.tag];
    [self setTheUrl];
    [self closeAllExtraView];
    
}
#pragma mark - 关闭视图
-(void)closeView
{
    for (int i = 112; i < 116; i++)
    {
        UIView *view = [(UIView*)self.view viewWithTag:i];
        if (view != nil)
        {
            [UIView animateWithDuration:0.5f animations:^{
                view.frame = CGRectMake(0, 50, 320, 1);
            }];
        }
    }

    NSLog(@"catid;%@,areaid:%@",self.catid,self.areaid);
}

-(void)closeAllExtraView
{
    UIButton *btn = (UIButton*)[_view viewWithTag:2300];
    
    [UIView animateWithDuration:0.6f animations:^{
        btn.transform  = CGAffineTransformRotate(btn.transform, M_PI/2);
        _view.alpha = 0.3;
    } completion:^(BOOL finished)
     {
         [_view setHidden:YES];
         _view.alpha = 1;
         btn.transform = CGAffineTransformIdentity;
     }];
    [self closeView];
    NSLog(@"lng:%@,lat:%@",self.lng,self.lat);
}

#pragma mark - tableView代理

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (state[indexPath.row])
    {
        return 130;
    }
    return 60;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArr.count;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    FindItemModel *model = self.dataArr[indexPath.row];
    MainDetailViewController *detail = [[MainDetailViewController alloc]init];
    detail.sid = [model.secid stringValue];
    detail.addr = model.secaddr;
    detail.title = model.secname;
    detail.shorName = model.secname;
    [self.navigationController pushViewController:detail animated:YES];
    [detail release];
}


-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FindItemCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FindItem"];
    
    if (cell == nil)
    {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"FindItemCell" owner:self options:nil]lastObject];
    }
    
    FindItemModel *model = [self.dataArr objectAtIndex:indexPath.row];
    
    [cell config:model andWithFlag:state[indexPath.row]];
    cell.collectBtn.tag = indexPath.row+500;
    [cell.collectBtn addTarget:self action:@selector(collectBtnDown:) forControlEvents:UIControlEventTouchUpInside];
    cell.showMoreBtn.tag = indexPath.row;
    cell.commentBtn.tag = indexPath.row+200;
    [cell.commentBtn addTarget:self action:@selector(commentBtnDown:)
              forControlEvents:UIControlEventTouchUpInside];
    cell.sel = @selector(test:);
    cell.delegate = self;
    return cell;
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//跳转到详情
-(void)commentBtnDown:(UIButton*)btn
{
    FindItemModel *model = self.dataArr[btn.tag-200];
    MainDetailViewController *detail = [[MainDetailViewController alloc]init];
    detail.sid = [model.secid stringValue];
    detail.addr = model.secaddr;
    detail.title = model.secname;
    detail.shorName = model.secname;
    [self.navigationController pushViewController:detail animated:YES];
    [detail release];
 
}

-(void)collectBtnDown:(UIButton*)btn
{
    FindItemModel *model = self.dataArr[btn.tag-500];
    NSLog(@"%@",model.collectcnt);
    //改变本地数据源
    
    if (model.iscollect)
    {
        model.collectcnt = [NSNumber numberWithInt
                            :[model.collectcnt intValue]-1];
        model.iscollect = NO;
    }
    else
    {
        model.collectcnt = [NSNumber numberWithInt:
                            [model.collectcnt intValue]+1];
        model.iscollect = YES;
    }
    [self.tableView reloadData];

    //向服务器更新数据
    
    
    
    
    
}

-(void)test:(UIButton*)btn
{
    int now = state[btn.tag];
    for (int i = 0; i < 20; i++)
    {
        state[i] = 0;
    }
    
    if (now == 0)
    {
        state[btn.tag] = 1;
    }
    
    [self.tableView reloadData];
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
