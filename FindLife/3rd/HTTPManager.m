//
//  HTTPManager.m
//  aixianmian
//
//  Created by GPH on 14-9-1.
//  Copyright (c) 2014年 GPH. All rights reserved.
//

#import "HTTPManager.h"

@implementation HTTPManager
+ (void)requestWithUrl:(NSString *)url FinishBlock:(FinishBlock)finishBlock FailedBlock:(FailedBlock)failedBlock
{
    HTTPRequest *request = [[HTTPRequest alloc]init];
    request.url = url;
    request.finishBlock = finishBlock;
    request.failedBlock = failedBlock;
    [request startRequest];
}

@end
