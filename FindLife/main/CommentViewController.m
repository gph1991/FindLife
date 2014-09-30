 //
//  CommentViewController.m
//  FindLife
//
//  Created by qianfeng on 14-9-25.
//  Copyright (c) 2014年 GPH. All rights reserved.
//

#define URL @"http://api.chengmi.com/articleinfov17?articleid=%@&showusercnt=6"

#import "HTTPManager.h"
#import "CommentViewController.h"
#import "UIImageView+WebCache.h"
#import "CollectUserDetailController.h"


@interface CommentViewController ()<UIScrollViewDelegate>
{
    NSString *_strUrl;
    UIScrollView *_mainScroll;
    NSDictionary *_dic;
    int _height;
}
@end

@implementation CommentViewController

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
    self.view.backgroundColor = [UIColor whiteColor];
    [self makeScrollView];
    [self setTheUrl];
    [self startRequest];
}

-(void)makeScrollView
{
    _mainScroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 20, 320, self.view.frame.size.height)];
    _mainScroll.contentSize = CGSizeMake(320,600);
    [self.view addSubview:_mainScroll];
    _mainScroll.userInteractionEnabled = YES;
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(10, 20, 45, 35);
    [backBtn setImage:[UIImage imageNamed:@"return_button.png"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backDown) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(30, 30, 260, 20)];
    titleLabel.text = self.title;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [_mainScroll addSubview:titleLabel];
    [titleLabel release];
    _height = 65;

    float y = [Common getWidthWithHeight:20 andFontSize:12 andString:self.addr];
    
    UIImageView *addrImg = [[UIImageView alloc]initWithFrame:CGRectMake(140-y/2, _height+3, 13, 15)];
    addrImg.image = [UIImage imageNamed:@"index_address_icon.png"];
    [_mainScroll addSubview:addrImg];
    [addrImg release];
    
    UILabel *addrLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, _height, 300, 20)];
    addrLabel.text = self.addr;
    addrLabel.textAlignment = NSTextAlignmentCenter;
    addrLabel.font = [UIFont systemFontOfSize:12];
    [_mainScroll addSubview:addrLabel];
    [addrLabel release];
  
}

-(void)backDown
{
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)startRequest
{
    
    [HTTPManager requestWithUrl:_strUrl FinishBlock:^(NSData *data)
     {
         _dic = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
         [self loadPicAndText];
         
     } FailedBlock:^{
         NSLog(@"ERROR");
     }];
}


//加载视图
-(void)loadPicAndText
{
    NSDictionary *authorinfo = _dic[@"authorinfo"];
    NSDictionary *artinfo = _dic[@"artinfo"];
    NSString *newcontent = artinfo[@"newcontent"];
    
    UIImageView *userImg = [[UIImageView alloc]initWithFrame:CGRectMake(135, _height+30, 50, 50)];
    [userImg setImageWithURL:[NSURL URLWithString:authorinfo[@"uavatar"]]];
    userImg.layer.masksToBounds = YES;
    userImg.layer.cornerRadius = 15;
    [_mainScroll addSubview:userImg];
    [userImg release];
    
    UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, _height+80, 300, 20)];
    nameLabel.text = authorinfo[@"uname"];
    nameLabel.font = [UIFont systemFontOfSize:12];
    nameLabel.textAlignment = NSTextAlignmentCenter;
    [_mainScroll addSubview:nameLabel];
    [nameLabel release];
    _height += 130;
    
    //描述
    int i = 0;
    
    NSData *data = [newcontent dataUsingEncoding:NSUTF8StringEncoding];
    NSArray *artile = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    
    for (; i < artile.count; i++)
    {
        NSDictionary *dic = artile[i];
        NSString *type = [[dic allKeys]objectAtIndex:0];
        if ([type isEqualToString:@"ch"])
        {
            NSString *ch = dic[@"ch"];
            CGRect  rect = [ch boundingRectWithSize:CGSizeMake(300, MAXFLOAT) options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]} context:nil];

            UILabel *content = [[UILabel alloc]initWithFrame:
                                CGRectMake(10, _height, 300, rect.size.height)];
            content.text = ch;
            content.numberOfLines = 0;
            content.font = [UIFont systemFontOfSize:13];
            [_mainScroll addSubview:content];
            [content release];
            _height = _height + rect.size.height + 10;
        }
        else
        {
            NSString *picUrl = dic[@"pic"];
            UIImageView *img = [[UIImageView alloc]initWithFrame:CGRectMake(10, _height, 300, 200)];
           [img setImageWithURL:[NSURL URLWithString:picUrl] placeholderImage:[UIImage imageNamed:@"discoverList_default.png"]];
            [_mainScroll addSubview:img];
            [img release];
            _height += 210;
        }
    }
    
    UILabel *timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, _height, 320, 30)];
    timeLabel.text = @"   点赞者";
    timeLabel.font = [UIFont systemFontOfSize:13];
    timeLabel.backgroundColor = [UIColor lightGrayColor];
    [_mainScroll addSubview:timeLabel];
    [timeLabel release];
    
    _height += 35;
     self.likelist = _dic[@"likelist"];
    
    for (int i = 0; i < self.likelist.count; i++)
    {
        
        NSDictionary *userDic  = self.likelist[i];
        
        //收藏者头像
        UIImageView *userImg = [[UIImageView alloc]
                                initWithFrame:
                                CGRectMake(10+i%2*150, _height+i/2*40, 35, 35)];
        userImg.layer.masksToBounds = YES;
        userImg.layer.cornerRadius = 10;
        [_mainScroll addSubview:userImg];
        [userImg release];
        [userImg setImageWithURL:[NSURL URLWithString:userDic[@"uavatar"]]];
        
        //收藏者名字
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        btn.frame = CGRectMake(50+i%2*150, _height+i/2*40, 100, 20);
        btn.tintColor = COLOR(53, 198, 179, 1);
        btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        btn.titleLabel.font = [UIFont systemFontOfSize:12];
        [btn setTitle:userDic[@"uname"] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(showCollectUser:) forControlEvents:UIControlEventTouchUpInside];
        [_mainScroll addSubview:btn];
        btn.tag = 1200+i;
        
        //收藏时间
        
        UILabel *collectTime  = [[UILabel alloc]initWithFrame:CGRectMake(50+i%2*150, _height+i/2*40+18, 100, 20)];
        NSNumber *interval = userDic[@"timeat"];
        collectTime.font = [UIFont systemFontOfSize:11];
        collectTime.text = [NSString stringWithFormat:@"%@前收藏",[Common getTimeWithSecond:interval]];
        [_mainScroll addSubview:collectTime];
        [collectTime release];
        
    }

    _height = _height + self.likelist.count/2*50;
    
    //横线
    UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(0, _height, 320, 1)];
    line.backgroundColor = [UIColor lightGrayColor];
    [_mainScroll addSubview:line];
    [line release];
    
    _mainScroll.contentSize = CGSizeMake(320, _height+40);
    
}

-(void)setTheUrl
{
    _strUrl = [NSString stringWithFormat:URL,self.articleId];
}


-(void)showCollectUser:(UIButton*)btn
{
    NSDictionary *dic = [self.likelist objectAtIndex:btn.tag-1200];
    CollectUserDetailController *userDetail = [[CollectUserDetailController alloc]init];
    userDetail.dic = dic;
    [self.navigationController pushViewController:userDetail animated:YES];
    [userDetail release];
}

-(void)dealloc
{
    self.title = nil;
    self.articleId = nil;
    self.likelist = nil;
    [super dealloc];
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
