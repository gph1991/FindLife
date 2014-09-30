//
//  Common.h
//  FindLife
//
//  Created by qianfeng on 14-9-25.
//  Copyright (c) 2014年 GPH. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Common : NSObject

//颜色处理
+(UIColor*)colorWithString:(NSString*)color;

//时间处理
+(NSString*)getTimeWithSecond:(NSNumber*)interval;

+(float)getHeightWidth:(int)width andFontSize:(int)size andString:(NSString*)str;

+(float)getWidthWithHeight:(int)height andFontSize:(int)size andString:(NSString *)str;
//隐藏或显示tabBar
+(void)HideTabBar:(BOOL)flag andViews:(NSArray*)viewArr;

@end
