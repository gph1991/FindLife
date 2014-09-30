//
//  MainDetailViewController.m
//  FindLife
//
//  Created by qianfeng on 14-9-23.
//  Copyright (c) 2014年 GPH. All rights reserved.
//

#define URL @"http://api.chengmi.com/sectionv17?sectionid=%@&showusercnt=6"

#import "MainDetailViewController.h"
#import "HTTPManager.h"
#import "UIImageView+WebCache.h"
#import "MapViewController.h"
#import "MyAnnotation.h"
#import "TimeAndPriceViewController.h"
#import "AllCollectViewController.h"
#import "CollectUserDetailController.h"
#import "CommentViewController.h"
#import "Common.h"

@interface MainDetailViewController ()<UIScrollViewDelegate>
{
    UIScrollView *_scorllView;
    NSDictionary *_artinfo;
    NSDictionary *_orientDic;

    BMKMapView *_mapView;
    CLLocationCoordinate2D _mystartPt;

}
@end

@implementation MainDetailViewController

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
    self.navigationController.navigationBarHidden = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = self.title;
    [self makeView];
    [self startRequest];
    NSLog(@"%@",self.sid);

}

-(void)viewWillAppear:(BOOL)animated
{
    [Common HideTabBar:YES andViews:self.tabBarController.view.subviews];
    self.navigationController.navigationBarHidden = YES;
    self.navigationItem.title = self.title;
}

-(void)makeView
{
    _scorllView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height)];
    
    //40留给下面按钮
    _scorllView.contentSize = CGSizeMake(320, 800);
    _scorllView.delegate = self;
    [self.view addSubview:_scorllView];
    [_scorllView release];
    _scorllView.userInteractionEnabled = YES;
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(10, 20, 45, 35);
    [backBtn setImage:[UIImage imageNamed:@"return_button.png"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backDown) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];
    
}

-(void)backDown
{
    [self.navigationController popViewControllerAnimated:YES];
}

//地图
-(void)startMap
{
    NSArray *sec_attr = _secinfo[@"sec_attr"];
    NSDictionary *content = [sec_attr[0] objectForKey:@"content"];

    self.detailAddr = content[@"address"];
    NSArray *lnglat = [content[@"lnglat"] componentsSeparatedByString:@","];

    self.longitude = [lnglat[0] floatValue];
    self.latitude = [lnglat[1] floatValue];
    _mystartPt = CLLocationCoordinate2DMake(self.latitude, self.longitude);
    BMKCoordinateSpan span = BMKCoordinateSpanMake(0.01, 0.01);
    BMKCoordinateRegion region = BMKCoordinateRegionMake(_mystartPt, span);
    
    //C OC C++
    _mapView = [[BMKMapView alloc] initWithFrame:CGRectMake(0, 200, 320, 100)];
    _mapView.delegate = self;
    [_mapView setRegion:region animated:YES];
    [_scorllView addSubview:_mapView];
    [_mapView release];
    
    
    //大头针
    MyAnnotation* anno = [[MyAnnotation alloc] init];
    anno.title = self.navigationItem.title;
    anno.coordinate = _mystartPt;
    [_mapView addAnnotation:anno];
    [anno release];

    UITapGestureRecognizer *mapTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(mapDown)];
    [_mapView addGestureRecognizer:mapTap];
    [mapTap release];
    
}

//进入详细的地图
-(void)mapDown
{
    NSLog(@"OK");
    MapViewController *map = [[MapViewController alloc]init];
    map.longitude = self.longitude;
    map.latitude = self.latitude;
    map.addr = self.detailAddr;
    [self.navigationController pushViewController:map animated:YES];
    [map release];
}

-(void)startRequest
{
    NSString *strUrl = [NSString stringWithFormat:URL,self.sid];
   [HTTPManager requestWithUrl:strUrl FinishBlock:^(NSData *data)
    {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        _orientDic = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        self.collectlist  = [NSMutableArray arrayWithArray:dic[@"collectlist"]];
        self.secinfo  = [NSDictionary dictionaryWithDictionary:dic[@"secinfo"]];
        NSArray *artinfoTmp = [NSMutableArray arrayWithArray:dic[@"artinfo"]];
        _artinfo = artinfoTmp[0];
        
        UIImageView *topImg = [[UIImageView alloc]
                               initWithFrame:CGRectMake(0, 0, 320, 200)];
        [_scorllView addSubview:topImg];
        [topImg release];
        [topImg setImageWithURL:[NSURL URLWithString:_secinfo[@"app_toppic"]]];
        
        
        //阴影
        UIImageView *shadownImg = [[UIImageView alloc]
                                   initWithFrame:CGRectMake(0, 140, 320, 60)];
        shadownImg.image = [UIImage imageNamed:@"indexCell_shadow.png"];
        [_scorllView addSubview:shadownImg];
        [shadownImg release];
        
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 150, 280, 30)];
        titleLabel.text = self.secinfo[@"abstract_content"];
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.numberOfLines = 0;
        [_scorllView addSubview:titleLabel];
        [titleLabel release];
        
        UIImageView *addrLogo = [[UIImageView alloc]
                                 initWithFrame:CGRectMake(10, 185, 10, 10)];
        [addrLogo setImage:[UIImage imageNamed:@"index_address_icon.png"]];
        [_scorllView addSubview:addrLogo];
        [addrLogo release];
        
        UILabel *otherInfo = [[UILabel alloc]initWithFrame:CGRectMake(30, 180, 270, 20)];
        otherInfo.text = _secinfo[@"address"];
        otherInfo.textColor = [UIColor whiteColor];
        otherInfo.numberOfLines = 0;
        otherInfo.font = [UIFont systemFontOfSize:12];
        [_scorllView addSubview:otherInfo];
        [otherInfo release];
        
        
        //地图
        dispatch_async(dispatch_get_main_queue(), ^{
            [self startMap];
        });

        //联系按钮
        UIImageView *infoImg = [[UIImageView alloc]initWithFrame:CGRectMake(15, 313, 15, 15)];
        [_scorllView addSubview:infoImg];
        [infoImg release];
        [infoImg setImage:[UIImage imageNamed:@"icon_email.png"]];
        
        UIImageView *rightImg1 = [[UIImageView alloc]initWithFrame:CGRectMake(320-30, 315, 12, 13)];
        [_scorllView addSubview:rightImg1];
        [rightImg1 release];
        [rightImg1 setImage:[UIImage imageNamed:@"pub_right_arrow.png"]];
        
        UIButton *otherBtn  =[UIButton buttonWithType:UIButtonTypeRoundedRect];
        otherBtn.frame  = CGRectMake(0, 300, 320, 40);
        [_scorllView addSubview:otherBtn];
        [otherBtn addTarget:self action:@selector(otherDown) forControlEvents:UIControlEventTouchUpInside];
        [otherBtn setTitle:@"时间、价格、联系" forState:UIControlStateNormal];
        otherBtn.tintColor = COLOR(53, 198, 179, 1);
        
        UILabel *gongluoLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 350, 320, 20)];
        
        gongluoLabel.text = @"   攻略";
        gongluoLabel.backgroundColor = [UIColor lightGrayColor];
        gongluoLabel.font = [UIFont systemFontOfSize:12];
        gongluoLabel.numberOfLines = 0;
        [_scorllView addSubview:gongluoLabel];
        [gongluoLabel release];
        
        //点评者头像
        UIImageView *headIcon = [[UIImageView alloc]initWithFrame:CGRectMake(20, 380, 40, 40)];
        headIcon.layer.masksToBounds = YES;
        headIcon.layer.cornerRadius = 10;
        [_scorllView addSubview:headIcon];
        [headIcon release];
        [headIcon setImageWithURL:[NSURL URLWithString:_artinfo[@"authoravatar"]]];
        
        UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(65, 400, 280, 20)];
        nameLabel.textColor = COLOR(53, 198, 179, 1);
        nameLabel.text = _artinfo[@"authorname"];
        nameLabel.numberOfLines = 0;
        nameLabel.font = [UIFont systemFontOfSize:14];
        [_scorllView addSubview:nameLabel];
        [nameLabel release];
        NSArray *picArr = _artinfo[@"pics"];
        int i = 0;
        for (;i < picArr.count; i++)
        {
            UIImageView *img = [[UIImageView alloc]initWithFrame:
                                CGRectMake(200+i%2*55, 380+i/2*60, 50, 55)];
            [_scorllView addSubview:img];
            [img release];
            [img setImageWithURL:[NSURL URLWithString:picArr[i]]];
        }
        
        
        NSString *content = _artinfo[@"firstpar"];
//        CGRect rect = [content boundingRectWithSize:CGSizeMake(160, MAXFLOAT) options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]} context:nil];
        
        UILabel *contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 420, 150, 110)];
        contentLabel.numberOfLines = 0;
        contentLabel.text = content;
        contentLabel.font = [UIFont systemFontOfSize:12];
        [_scorllView addSubview:contentLabel];
        [contentLabel release];
        UIButton *contentBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        contentBtn.frame = CGRectMake(20, 425, 150, 110);
        contentBtn.tag = [_artinfo[@"artid"]intValue];
        [contentBtn addTarget:self action:@selector(contentBtnDown:) forControlEvents:UIControlEventTouchUpInside];
        [_scorllView addSubview:contentBtn];
        
        //阅读者
        
        UIImageView *visteImg = [[UIImageView alloc]initWithFrame:
                            CGRectMake(10, 535, 18, 18)];
        [_scorllView addSubview:visteImg];
        [visteImg release];
        [visteImg setImage:[UIImage imageNamed:@"articleList_readIcon.png"]];
        
        UILabel *readNumLabel = [[UILabel alloc]initWithFrame:CGRectMake(40, 535, 80, 20)];
        readNumLabel.text = [NSString stringWithFormat:@"%@ 阅读", [_artinfo[@"viewcount"] stringValue]];
        readNumLabel.font = [UIFont systemFontOfSize:11];
        [_scorllView addSubview:readNumLabel];
        [readNumLabel release];
        
        //收藏
        UILabel *collectLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 560, 320, 20)];
        collectLabel.text = @"   收藏者";
        collectLabel.backgroundColor = [UIColor lightGrayColor];
        collectLabel.font = [UIFont systemFontOfSize:12];
        [_scorllView addSubview:collectLabel];
        [collectLabel release];

        int height = 590;
        //6名收藏者
        for (i = 0; i < _collectlist.count; i++)
        {
            NSDictionary *userDic  = _collectlist[i];
            
            //收藏者头像
            UIImageView *userImg = [[UIImageView alloc]
                                    initWithFrame:
                                    CGRectMake(10+i%2*150, 590+i/2*40, 35, 35)];
            userImg.layer.masksToBounds = YES;
            userImg.layer.cornerRadius = 10;
            [_scorllView addSubview:userImg];
            [userImg release];
            [userImg setImageWithURL:[NSURL URLWithString:userDic[@"uavatar"]]];
            
            //收藏者名字
            
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            btn.frame = CGRectMake(50+i%2*150, 590+i/2*40, 100, 20);
            btn.tintColor = COLOR(53, 198, 179, 1);
            btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            btn.titleLabel.font = [UIFont systemFontOfSize:12];
            [btn setTitle:userDic[@"uname"] forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(showCollectUser:) forControlEvents:UIControlEventTouchUpInside];
            [_scorllView addSubview:btn];
            btn.tag = [userDic[@"userid"] intValue];
            
            //收藏时间
            
            UILabel *collectTime  = [[UILabel alloc]initWithFrame:CGRectMake(50+i%2*150, 590+i/2*40+18, 100, 20)];
            NSNumber *interval = userDic[@"timeat"];
            collectTime.font = [UIFont systemFontOfSize:11];
            collectTime.text = [NSString stringWithFormat:@"%@前收藏",[Common getTimeWithSecond:interval]];
            [_scorllView addSubview:collectTime];
            [collectTime release];
        }
        
        height = height+i/2*40+5;
        
       //横线
        UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(0, height, 320, 1)];
        line.backgroundColor = [UIColor lightGrayColor];
        [_scorllView addSubview:line];
        [line release];
        
         //所有收藏者
        UIImageView *infoImg2 = [[UIImageView alloc]initWithFrame:CGRectMake(15, height+12, 15, 15)];
        [_scorllView addSubview:infoImg2];
        [infoImg2 release];
        [infoImg2 setImage:[UIImage imageNamed:@"heartImage.png"]];
        
        UIImageView *rightImg2 = [[UIImageView alloc]initWithFrame:CGRectMake(320-30, height+12, 12, 13)];
        [_scorllView addSubview:rightImg2];
        [rightImg2 release];
        [rightImg2 setImage:[UIImage imageNamed:@"pub_right_arrow.png"]];
        
        
        UIButton *collectBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [collectBtn setTitle:[NSString stringWithFormat:@"%@位收藏者",[_orientDic[@"collectcnt"]stringValue]] forState:UIControlStateNormal];
        [collectBtn addTarget:self action:@selector(showAllCollectUser) forControlEvents:UIControlEventTouchUpInside];
        collectBtn.frame = CGRectMake(0, height, 320, 40);
        [_scorllView addSubview:collectBtn];
        
        collectBtn.tintColor = COLOR(53, 198, 179, 1);
        _scorllView.contentSize = CGSizeMake(320, height+80);

    } FailedBlock:^{
        NSLog(@"ERROR");
    }];

}

//进入评论详情
-(void)contentBtnDown:(UIButton*)btn
{

    CommentViewController *comment = [[CommentViewController alloc]init];
    comment.articleId = [NSString stringWithFormat:@"%d",btn.tag];
    comment.title = self.title;
    comment.addr = self.addr;
    [self.navigationController pushViewController:comment animated:YES];
    [comment release];
    /*

     */
}
-(void)showAllCollectUser
{
    AllCollectViewController *allUser = [[AllCollectViewController alloc]init];
    allUser.sectionid =  self.sid;
    [self.navigationController pushViewController:allUser animated:YES];
    [allUser release];
}

-(void)showCollectUser:(UIButton*)btn
{
    CollectUserDetailController *userDetail = [[CollectUserDetailController alloc]init];
    int i = 0;
    for (; i < self.collectlist.count; i++)
    {
        NSDictionary *dic = [self.collectlist objectAtIndex:i];
        if ([dic[@"userid"]intValue] == btn.tag)
        {
            userDetail.dic = dic;
            break;
        }
    }
    [self.navigationController pushViewController:userDetail animated:YES];
    [userDetail release];
}

-(void)otherDown
{
    TimeAndPriceViewController *time =[[TimeAndPriceViewController alloc]init];
    
    time.sid = self.sid;
    time.dic = self.secinfo;
    [self.navigationController pushViewController:time animated:YES];
    [time release];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



-(void)dealloc
{
    [self.sid release];
    [self.secinfo release];
    [self.addr release];
    [self.collectlist release];
    [super dealloc];
    
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
