//
//  FindViewController.m
//  FindLife
//
//  Created by qianfeng on 14-9-23.
//  Copyright (c) 2014年 GPH. All rights reserved.
//

#define URL @"http://api.chengmi.com/v1.9/discover?theme_ids=1,3,4,5,6,7,8,9,10,11,12,13,14,15,16,18,19,20,21,22,24,25,26,27,28"

#import "FindViewController.h"
#import "EGORefreshTableHeaderView.h"
#import "AFNetworking.h"
#import "UIImageView+WebCache.h"
#import "HTTPManager.h"
#import "ThemeViewController.h"
#import "TypeViewController.h"
#import "SearchViewController.h"

#import "FindResultViewController.h"


@interface FindViewController ()<EGORefreshTableHeaderDelegate,UIScrollViewDelegate,UITextFieldDelegate>
{
    UIScrollView *_mainScroll;
    UIScrollView *_typeScroll;
    UIScrollView *_areaScroll;
    EGORefreshTableHeaderView *_refreshView;
    BOOL _isRefresh;
    UIView *_navView;
    UIView *_navigationView;
}
@end

@implementation FindViewController

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
    self.title = @"发现";
    [self makeMainScroll];
    [self startRequest];
    [self makeSearchView];
    _isRefresh = NO;
}

-(void)makeNavView
{

}

-(void)startRequest
{
    [HTTPManager requestWithUrl:URL FinishBlock:^(NSData *data)
    {
        self.dataDic = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        [self makeView];
        [self endPullDown];
    } FailedBlock:^{
        NSLog(@"ERROR");
    }];
}

-(void)makeMainScroll
{
    _mainScroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height)];
    _mainScroll.contentSize = CGSizeMake(320, 860);
    [self.view addSubview:_mainScroll];
    [_mainScroll release];
    _mainScroll.delegate = self;
    _refreshView = [[EGORefreshTableHeaderView alloc]initWithFrame:CGRectMake(0, -self.view.frame.size.height, 320, self.view.frame.size.height)];
    _refreshView.delegate = self;
    [_mainScroll addSubview:_refreshView];
    [_refreshView release];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [Common HideTabBar:NO andViews:self.tabBarController.view.subviews];
}

-(void)makeView
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self makeThemeView];
    });
    dispatch_async(dispatch_get_main_queue(), ^{

        [self makeTypeView];
    });
    dispatch_async(dispatch_get_main_queue(), ^{

        [self makeAreaView];
    });
}

-(void)makeThemeView
{
    NSArray *picArr = self.dataDic[@"themeinfo"];
    int i = 0;
    for (;i < picArr.count;i++)
    {
        NSDictionary *dic = picArr[i];
        //背景
        UIImageView *img = [[UIImageView alloc]initWithFrame:CGRectMake(2+i%2*159, 2+i/2*159, 157, 157)];
        [img setImageWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:dic[@"pic"]]] placeholderImage:[UIImage imageNamed:@"articleList_dogLogo.png"] success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image)
        {
            img.userInteractionEnabled = YES;
            img.image = image;
            [_mainScroll addSubview:img];
            [img release];
            
            //标签
            UILabel *titleLabel = [[UILabel alloc]initWithFrame:
                                   CGRectMake(i%2*159+30, 2+i/2*159+45, 100, 30)];
            titleLabel.text = dic[@"name"];
            //类型为1500，地区为1600
            titleLabel.tag = 1400+[dic[@"id"] integerValue];
            titleLabel.textColor = [UIColor whiteColor];
            titleLabel.font = [UIFont systemFontOfSize:16];
            titleLabel.textAlignment = NSTextAlignmentCenter;
            [_mainScroll addSubview:titleLabel];
            [titleLabel release];
            
            //心型
            
            UIImageView *heartImg = [[UIImageView alloc]initWithFrame:CGRectMake(2+i%2*159+40, 2+i/2*159+70, 80, 20)];
            [heartImg setImage:[UIImage imageNamed:@"articleList_btn_Collect.png"]];
        //    heartImg.alpha = 0.7;
            [_mainScroll addSubview:heartImg];
            //heartImg.backgroundColor = [UIColor redColor];
            [heartImg release];
            
            //数字
            UILabel *numberLabel = [[UILabel alloc]initWithFrame:
                                    CGRectMake(2+i%2*159+60, 2+i/2*159+70, 60, 20)];
            numberLabel.text = [dic[@"collect_cnt"] stringValue];
            numberLabel.font = [UIFont systemFontOfSize:13];
            numberLabel.textColor = [UIColor whiteColor];
            numberLabel.textAlignment = NSTextAlignmentCenter;
            [_mainScroll addSubview:numberLabel];
            [numberLabel release];

            //按钮
            UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            button.frame = CGRectMake(2+i%2*159, 2+i/2*159, 157, 157);
            button.tag = [dic[@"id"] integerValue];
            [button addTarget:self action:@selector(themeDown:) forControlEvents:UIControlEventTouchUpInside];
            [_mainScroll addSubview:button];
            
            
            
        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error)
        {
            NSLog(@"ERROR");
        }];
    }
    
}

-(void)makeTypeView
{
    int height = 4*162+20;
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, height, 100, 20)];
    titleLabel.font = [UIFont systemFontOfSize:12];
    [_mainScroll addSubview:titleLabel];
    
    [titleLabel release];
    titleLabel.text = [NSString stringWithFormat:@"%@个推荐", [self.dataDic[@"allsectioncnt"] stringValue]];
    
    _typeScroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0, height+20, 320, 100)];
    [_mainScroll addSubview:_typeScroll];
    [_typeScroll release];
    
    _typeScroll.backgroundColor = [UIColor cyanColor];
 //   _typeScroll.bounces = NO;
    _typeScroll.showsHorizontalScrollIndicator = NO;
    
    NSArray *typeArr = self.dataDic[@"catinfo"];
    int i ;
    for (i = 0; i < typeArr.count; i++)
    {
        NSDictionary *dic = typeArr[i];
        UIImageView *backImg = [[UIImageView alloc]
                                initWithFrame:CGRectMake(15+i*100, 14, 50, 50)];
        [backImg setImageWithURL:[NSURL URLWithString:dic[@"iconurl"]]];
        [_typeScroll addSubview:backImg];
        [backImg release];
        
        //类型名
        UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(15+i*100, 65, 50, 20)];
        nameLabel.text = dic[@"catname"];
        nameLabel.font = [UIFont systemFontOfSize:14];
        nameLabel.textAlignment = NSTextAlignmentCenter;
        [_typeScroll addSubview:nameLabel];
        [nameLabel release];

        //数目
        UILabel *typeName = [[UILabel alloc]initWithFrame:CGRectMake(15+i*100, 85, 50, 10)];
        typeName.text = [dic[@"catcnt"]stringValue];
        typeName.font = [UIFont systemFontOfSize:12];
        typeName.textAlignment = NSTextAlignmentCenter;
        [_typeScroll addSubview:typeName];
        [typeName release];
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        btn.frame = CGRectMake(15+i*100, 5, 60, 60);
        [btn addTarget:self action:@selector(typeDown:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = 1300 + i;
        [_typeScroll addSubview:btn];
        
    }

    _typeScroll.contentSize = CGSizeMake(100*i, 80);
}


-(void)makeAreaView
{
    int height = 4*162+20+120;
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, height, 100, 20)];
    titleLabel.font = [UIFont systemFontOfSize:12];
    [_mainScroll addSubview:titleLabel];
    [titleLabel release];
    titleLabel.text = [NSString stringWithFormat:@"%@个地区", [self.dataDic[@"areacnt"] stringValue]];
    height += 25;
    
    _areaScroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0, height, 320, 100)];
    [_mainScroll addSubview:_areaScroll];
    [_areaScroll release];
    
    _areaScroll.backgroundColor = [UIColor whiteColor];
    _areaScroll.showsHorizontalScrollIndicator = NO;
    
    NSArray *areaArr = self.dataDic[@"areainfo"];
    int i ;
    for (i = 0; i < areaArr.count; i++)
    {
        NSDictionary *dic = areaArr[i];
        
//        NSMutableString *color = dic[@"color"];
        UIImageView *backImg = [[UIImageView alloc]
                                initWithFrame:CGRectMake(15+i*100, 15, 50, 50)];
        [backImg setImageWithURL:[NSURL URLWithString:dic[@"iconurl"]]];
        [_areaScroll addSubview:backImg];
        [backImg release];
        
        //类型名
        UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(i*100, 65, 85, 20)];
        nameLabel.text = dic[@"areaname"];
        nameLabel.font = [UIFont systemFontOfSize:13];
        nameLabel.textAlignment = NSTextAlignmentCenter;
        [_areaScroll addSubview:nameLabel];
        [nameLabel release];
        
        //数目
        UILabel *typeName = [[UILabel alloc]initWithFrame:CGRectMake(15+i*100, 85, 50, 10)];
        typeName.text = [dic[@"areacnt"]stringValue];
        typeName.font = [UIFont systemFontOfSize:12];
        
        typeName.textAlignment = NSTextAlignmentCenter;
        [_areaScroll addSubview:typeName];
        [typeName release];
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        btn.frame = CGRectMake(15+i*100, 5, 60, 60);
        [btn addTarget:self action:@selector(areaDown:) forControlEvents:UIControlEventTouchUpInside];
        
        btn.tag = [dic[@"areaid"]intValue];
        [_areaScroll addSubview:btn];
    }
    
    _areaScroll.contentSize = CGSizeMake(90*i, 100);
    _mainScroll.contentSize = CGSizeMake(320, height+230);
    
}


-(void)makeSearchView
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
    
    UIImageView *img = [[UIImageView alloc]initWithFrame:CGRectMake(190, -2, 30, 30)];
    [img setImage:[UIImage imageNamed:@"selectView_sort_nearby.png"]];
    [_navigationView addSubview:img];
    [img release];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [btn setTitle:@"附近" forState:UIControlStateNormal];
    btn.frame = CGRectMake(220, -3, 50, 30);
    [btn setTintColor:[UIColor whiteColor]];
    [_navigationView addSubview:btn];
    
    NSLog(@"Search OK in Find");

}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    [textField resignFirstResponder];
    SearchViewController *search = [[SearchViewController alloc]init];
    [self.navigationController pushViewController:search animated:YES];
    [search release];
}


-(void)viewWillDisappear:(BOOL)animated
{
    [Common HideTabBar:YES andViews:self.tabBarController.view.subviews];
    self.navigationController.navigationBarHidden = NO;
}

-(void)setTheUrl
{
    
}


-(void)makeNav
{

}

#pragma mark - scrollView代理
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [_refreshView egoRefreshScrollViewDidScroll:scrollView];
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [_refreshView egoRefreshScrollViewDidEndDragging:_mainScroll];
    
}

#pragma mark - ego代理


-(NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView *)view
{
    return [NSDate date];
}

-(BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView *)view
{
    return _isRefresh;
}

-(void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView *)view
{
    _isRefresh = YES;
    [self pullDownRefresh];
}

-(void)endPullDown
{
    [_refreshView egoRefreshScrollViewDataSourceDidFinishedLoading:_mainScroll];
    _isRefresh = NO;
}

-(void)pullDownRefresh
{
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [self endPullDown];
//    });
    [self startRequest];
}

-(void)themeDown:(UIButton*)btn
{
    UILabel *label = (UILabel*)[_mainScroll viewWithTag:1400+btn.tag];
    ThemeViewController *theme = [[ThemeViewController alloc]init];
    theme.title = label.text;
    theme.selectId = [NSString stringWithFormat:@"%d",btn.tag];
    [self.navigationController pushViewController:theme animated:YES];
    [theme release];
}

-(void)areaDown:(UIButton*)btn
{
    NSLog(@"btn:%d",btn.tag);
    FindResultViewController *search = [[FindResultViewController alloc]init];
    search.dic = self.dataDic;
    search.areaid = [NSString stringWithFormat:@"%d",btn.tag];
    search.catid = @"-1";
    [self.navigationController pushViewController:search animated:YES];
    [search release];
    
}

-(void)typeDown:(UIButton*)btn
{
    NSArray *typeArr = self.dataDic[@"catinfo"];
    NSDictionary *typeDic = typeArr[btn.tag-1300];
    TypeViewController *type = [[TypeViewController alloc]init];
    type.dic = typeDic;
    type.orientDic = self.dataDic;
    [self.navigationController pushViewController:type animated:YES];
    [type release];
    
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
