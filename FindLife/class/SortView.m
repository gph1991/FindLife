//
//  SortView.m
//  FindLife
//
//  Created by qianfeng on 14-9-26.
//  Copyright (c) 2014年 GPH. All rights reserved.
//

#import "SortView.h"

@implementation SortView

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
    NSArray *arr = @[@"最新",@"最近",@"最热"];
    NSArray *picArr = @[@"discoverNav_new.png",@"discoverNav_nearby.png",@"discoverNav_hot.png"];
    for (int i = 0; i < arr.count; i++)
    {
        UIImageView *img= [[UIImageView alloc]initWithFrame:
                           CGRectMake(30+i*100, 130, 50, 50)];
        img.image = [UIImage imageNamed:picArr[i]];
        [self addSubview:img];
        [img release];

        UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        btn.frame = img.frame;
        [btn addTarget:self action:@selector(btnDown:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
        btn.tag = i;
        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(30+i*100,180, 50, 20)];
        label.text = arr[i];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:13];
        [self addSubview:label];
        [label release];
    }
    self.contentSize = CGSizeMake(320, 320);

}

-(void)btnDown:(UIButton*)btn
{
    [self.delegate performSelector:self.sel withObject:btn];
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
