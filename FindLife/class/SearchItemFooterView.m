//
//  SearchItemFooterView.m
//  FindLife
//
//  Created by qianfeng on 14-9-27.
//  Copyright (c) 2014年 GPH. All rights reserved.
//

#import "SearchItemFooterView.h"

@implementation SearchItemFooterView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        // Initialization code
    }
    return self;
}

-(void)makeViewWithContentNum:(int)cNum andColNum:(int)colNum WithBool:(BOOL)isCollect andCommetn:(NSString*)str
{
    int num[2] = {cNum,colNum};
    
 //   NSArray *btnArr = @[self.commentBtn,self.collectBtn];
    
    UILabel *content = [[UILabel alloc]initWithFrame:CGRectMake(5, 0, 310, 40)];
    content.text = str;
    content.font = [UIFont systemFontOfSize:14];
    content.numberOfLines = 0;
    [self addSubview:content];
    [content release];
    
    UILabel *backLabel = [[UILabel alloc]initWithFrame:CGRectMake(-1, 40, 322, 30)];
    [self addSubview:backLabel];
    [backLabel release];
    backLabel.layer.borderColor = [[UIColor grayColor]CGColor];
    backLabel.layer.borderWidth = 1;
    backLabel.backgroundColor = [UIColor grayColor];
    backLabel.alpha = 0.5;
    
    
    NSArray *picArr = @[@"discoverList_articleCountIcon.png",@"discoverList_collection.png"];
    NSArray *picArr2 = @[@"discoverList_articleCountIcon.png",@"discoverList_collectionClicked.png"];
    NSArray *titleBtn = @[@"攻略",@"收藏"];
    for (int i = 0; i < picArr.count; i++)
    {
        UIImageView *img = [[UIImageView alloc]initWithFrame:CGRectMake(100+i*50, 40, 25, 25)];
        if (isCollect)
        {
            [img setImage:[UIImage imageNamed:picArr2[i]]];
        }
        else
        {
            [img setImage:[UIImage imageNamed:picArr[i]]];
        }
        [self addSubview:img];
        
        

        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        btn.frame = CGRectMake(i*160, 40, 159, 30);
        [btn setTitle:titleBtn[i] forState:UIControlStateNormal];
        [self addSubview:btn];
        
    }
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
