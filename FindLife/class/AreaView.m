//
//  AreaView.m
//  FindLife
//
//  Created by qianfeng on 14-9-25.
//  Copyright (c) 2014年 GPH. All rights reserved.
//

#import "AreaView.h"
#import "UIImageView+WebCache.h"

@implementation AreaView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

-(void)makeView
{

    self.contentSize = CGSizeMake(320, self.dataArr.count/3*100+150);

    for(int i = 0; i < self.dataArr.count; i++)
    {
        NSDictionary *tmpDic = [self.dataArr objectAtIndex:i];
        UIImageView *img1 = [[UIImageView alloc]initWithFrame:CGRectMake(30+i%3*100, i/3*100+20, 60, 60)];
        [img1 setImageWithURL:[NSURL URLWithString:tmpDic[@"iconurl"]] placeholderImage:[UIImage imageNamed:@"infoSecname.png"]];
        [self addSubview:img1];
        [img1 release];
        
        UILabel *typeName1 = [[UILabel alloc]initWithFrame:CGRectMake(25+i%3*100, i/3*100+80, 70, 20)];
        [self addSubview:typeName1];
        [typeName1 release];
        typeName1.text = tmpDic[@"areaname"];
        typeName1.font = [UIFont systemFontOfSize:13];
        typeName1.textAlignment = NSTextAlignmentCenter;
        
        UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        btn1.frame = CGRectMake(30+i%3*100, i/3*100+20, 80, 80);
        [btn1 addTarget:self action:@selector(typeDown:) forControlEvents:UIControlEventTouchUpInside];
        btn1.tag = [tmpDic[@"areaid"]intValue];
        [self addSubview:btn1];
    }
}

-(void)typeDown:(UIButton*)btn
{
    [self.delegate performSelector:self.sel withObject:[NSNumber numberWithInt:btn.tag]];
}



@end
