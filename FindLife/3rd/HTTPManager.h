//
//  HTTPManager.h
//  aixianmian
//
//  Created by qianfeng on 14-9-1.
//  Copyright (c) 2014年 GPH. All rights reserved.
//
#import "HTTPRequest.h"
#import <Foundation/Foundation.h>

@interface HTTPManager : NSObject

+ (void) requestWithUrl:(NSString*)url FinishBlock:(FinishBlock)finishBlock FailedBlock:(FailedBlock)failedBlock;

@end
