//
//  AllTypeVIew.m
//  FindLife
//
//  Created by qianfeng on 14-9-25.
//  Copyright (c) 2014年 GPH. All rights reserved.
//

#import "AllTypeView.h"
#import "UIImageView+WebCache.h"


@implementation AllTypeView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

-(void)makeView
{
    self.contentSize = CGSizeMake(320, self.dataArr.count/3*100+50);
    int height = 100;
    
    int i = 0;

    UILabel *backView = [[UILabel alloc]initWithFrame:CGRectMake(30+i%3*100, i/3*100+20+height, 60, 60)];
    backView.backgroundColor = [UIColor cyanColor];
    backView.layer.cornerRadius = 30;
    backView.layer.masksToBounds = YES;
    [self addSubview:backView];
    [backView release];
    
    UIImageView *img = [[UIImageView alloc]initWithFrame:CGRectMake(46+i%3*100, i/3*100+38+height, 25, 25)];
    img.image = [UIImage imageNamed:@"oa_section_icon.png"];
    [self addSubview:img];
    [img release];
    
    UILabel *typeNum = [[UILabel alloc]initWithFrame:CGRectMake(30+i%3*100, i/3*100+20+height+60, 60, 20)];
    [self addSubview:typeNum];
    [typeNum release];
    typeNum.text = @"所有推荐";
    typeNum.font = [UIFont systemFontOfSize:13];
    typeNum.textAlignment = NSTextAlignmentCenter;
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btn.frame = CGRectMake(30+i%3*100, i/3*100+20+height, 60, 60);
    [btn addTarget:self action:@selector(typeDown:) forControlEvents:UIControlEventTouchUpInside];
    btn.tag = 5000;
    [self addSubview:btn];
    
    for(i = 1; i <= self.dataArr.count; i++)
    {
        NSDictionary *tmpDic = [self.dataArr objectAtIndex:i-1];
        
        UIImageView *img1 = [[UIImageView alloc]initWithFrame:CGRectMake(30+i%3*100, i/3*100+20+height, 60, 60)];
        [img1 setImageWithURL:[NSURL URLWithString:tmpDic[@"iconurl"]] placeholderImage:[UIImage imageNamed:@"infoSecname.png"]];
        [self addSubview:img1];
        [img1 release];
        
        UILabel *typeName1 = [[UILabel alloc]initWithFrame:CGRectMake(25+i%3*100, i/3*100+80+height, 70, 20)];
        [self addSubview:typeName1];
        [typeName1 release];
        typeName1.text = tmpDic[@"catname"];
        typeName1.font = [UIFont systemFontOfSize:13];
        typeName1.textAlignment = NSTextAlignmentCenter;
        
        UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        btn1.frame = CGRectMake(30+i%3*100, i/3*100+20+height, 80, 80);
        [btn1 addTarget:self action:@selector(typeDown:) forControlEvents:UIControlEventTouchUpInside];
        btn1.tag = i + 999;
        [self addSubview:btn1];
        
    }
}

-(void)typeDown:(UIButton*)btn
{
    [self.delegate performSelector:self.sel withObject:[NSNumber numberWithInt:btn.tag]];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
