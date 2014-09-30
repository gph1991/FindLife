//
//  MyAnnotation.h
//  FindLife
//
//  Created by qianfeng on 14-9-24.
//  Copyright (c) 2014年 GPH. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "BMapKit.h"

@interface MyAnnotation : NSObject<BMKAnnotation>

@property (nonatomic, copy) NSString* title;
@property (nonatomic, copy) NSString* subtitle;
@property (nonatomic,assign) CLLocationCoordinate2D coordinate;

@end
