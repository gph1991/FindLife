//
//  TypeView.m
//  FindLife
//
//  Created by qianfeng on 14-9-25.
//  Copyright (c) 2014年 GPH. All rights reserved.
//

#import "TypeView.h"
#import "UIImageView+WebCache.h"

@implementation TypeView

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
    for (UIView *view in self.subviews)
    {
        [view removeFromSuperview];
    }
    
    NSArray *catchild = self.dic[@"catchild"];
    NSLog(@"%d",catchild.count);
    int i = 0;
    UILabel *label = [[UILabel alloc]
                      initWithFrame:CGRectMake(30, 20, 60, 60)];
    label.text = @"全部";
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.layer.cornerRadius = 30;
    label.layer.masksToBounds = YES;
    [self addSubview:label];
    [label release];
    label.backgroundColor = [Common colorWithString:self.dic[@"color"]];

    UILabel *typeName = [[UILabel alloc]initWithFrame:CGRectMake(30, 82, 60, 10)];
    [self addSubview:typeName];
    [typeName release];
    typeName.text = self.dic[@"catname"];
    typeName.font = [UIFont systemFontOfSize:12];
    typeName.textAlignment = NSTextAlignmentCenter;

    UILabel *typeNum = [[UILabel alloc]initWithFrame:CGRectMake(30, 95, 60, 10)];
    [self addSubview:typeNum];
    [typeNum release];
    typeNum.text = [self.dic[@"catcnt"]stringValue];
    typeNum.font = [UIFont systemFontOfSize:12];
    typeNum.textAlignment = NSTextAlignmentCenter;


    UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btn.frame = CGRectMake(30, 20, 60, 60);
    [btn addTarget:self action:@selector(typeDown:) forControlEvents:UIControlEventTouchUpInside];
    
    btn.tag = [self.dic[@"catid"]intValue];
    [self addSubview:btn];

    self.contentSize = CGSizeMake(320, catchild.count/3*100+100);

    for(i = 1; i <= catchild.count; i++)
    {
        NSDictionary *tmpDic = [catchild objectAtIndex:i-1];
        UIImageView *img1 = [[UIImageView alloc]initWithFrame:CGRectMake(30+i%3*100, i/3*100+20, 60, 60)];
        [img1 setImageWithURL:[NSURL URLWithString:tmpDic[@"iconurl"]] placeholderImage:[UIImage imageNamed:@"infoSecname.png"]];
        
        [self addSubview:img1];
        [img1 release];

        UILabel *typeName1 = [[UILabel alloc]initWithFrame:CGRectMake(25+i%3*100, i/3*100+80, 70, 20)];
        [self addSubview:typeName1];
        [typeName1 release];
        typeName1.text = tmpDic[@"name"];
        typeName1.font = [UIFont systemFontOfSize:13];
        typeName1.textAlignment = NSTextAlignmentCenter;

        UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        btn1.frame = CGRectMake(30+i%3*100, i/3*100+20, 80, 80);
        [btn1 addTarget:self action:@selector(typeDown:) forControlEvents:UIControlEventTouchUpInside];
        btn1.tag = [tmpDic[@"id"]intValue];
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
