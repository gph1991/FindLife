//
//  Common.m
//  FindLife
//
//  Created by qianfeng on 14-9-25.
//  Copyright (c) 2014年 GPH. All rights reserved.
//

#import "Common.h"

@implementation Common



+(UIColor*)colorWithString:(NSString*)color
{
    NSLog(@"%@",color);
    
    int num[3] = {0};
    
    for (int j = 0; j < 3; j++)
    {
        //  NSASCIIStringEncoding
        const char *newcolor = [color cStringUsingEncoding:NSASCIIStringEncoding];
        printf("%s",newcolor);
        char one = *(newcolor+j*2);
        NSLog(@"%c",one);
        
        if (one >= 'a' )
        {
            num[j] += (one -'a')*16;
        }
        else
        {
            num[j]  += (one - '0')*16;
        }
        NSLog(@"%c",one);
        one = *(newcolor+j*2+1);
        
        if (one >= 'a' )
        {
            num[j]  += (one -'a');
        }
        else
        {
            num[j]  += (one - '0');
        }
        
        NSLog(@"%c",one);
        NSLog(@"%d",num[0]);
    }
    
    
    return COLOR(num[0], num[1], num[2], 1);
}

+(NSString*)getTimeWithSecond:(NSNumber*)interval
{
    
    
    NSTimeInterval time =[[NSDate date] timeIntervalSince1970];

    
    int second = time - [interval floatValue];
    if (second < 0)
    {
        second = - second;
    }
    NSString *strCollectTime = nil;
    
    //判断收藏时间
    if (second < 60)
    {
        strCollectTime = @"秒";
    }
    else if(second/60 < 60)
    {
        strCollectTime = @"分钟";
        second /= 60;
    }
    else if((second/3600) < 24)
    {
        strCollectTime = @"小时";
        second /= 3600;
    }
    else if((second/(3600*24)) < 30)
    {
        strCollectTime = @"天";
        second = second/(3600*24);
        
    }
    else if((second/(3600*24)/30) < 12)
    {
        strCollectTime = @"月";
        second = second/(3600*24)/30;
        
    }
    else
    {
        second = second/(3600*24)/30/12;
        strCollectTime = @"年";
        second %= 60;
    }
    
    return [NSString stringWithFormat:@"%@%d",strCollectTime,second];
    
}


+(float)getHeightWidth:(int)width andFontSize:(int)size andString:(NSString *)str
{
    CGRect  rect = [str boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:size]} context:nil];
    return rect.size.height;
}

+(float)getWidthWithHeight:(int)height andFontSize:(int)size andString:(NSString *)str
{
    CGRect  rect = [str boundingRectWithSize:CGSizeMake(MAXFLOAT, height) options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:size]} context:nil];
    return rect.size.width;
}
+(void)HideTabBar:(BOOL)flag andViews:(NSArray*)viewArr
{
    for (UIView *view in viewArr)
    {
        if (view.frame.size.height == 49 && view.frame.size.width == 320)
        {
            view.hidden = flag;
        }
    }
}



@end
