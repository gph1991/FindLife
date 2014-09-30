//
//  Shadow.m
//  FindLife
//
//  Created by qianfeng on 14-9-23.
//  Copyright (c) 2014年 GPH. All rights reserved.
//

#import "Shadow.h"

@implementation Shadow

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        // Initialization code
        [self makeShadow];
        
    }
    return self;
}
-(void)awakeFromNib
{
    [self makeShadow];
}

-(void)makeShadow
{
//    for (int i = 0; i < 55; i++)
//    {
//        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, i, 310, 1)];
//        label.backgroundColor = [UIColor colorWithRed:(i+10)/255.0 green:(i+20)/255.0 blue:i/255.0 alpha:0.4];
//        [self addSubview:label];
//        [label release];
//    }
    self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"indexCell_shadow.png"]];
 //   self.alpha = 0.5;
    
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
