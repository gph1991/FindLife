//
//  HTTPRequest.h
//  aixianmian
//
//  Created by GPH on 14-9-1.
//  Copyright (c) 2014年 GPH. All rights reserved.
//

#import <Foundation/Foundation.h>

//c 格式 typedef void(^)(NSData*) FinishBlock;

typedef void(^FinishBlock)(NSData*);
typedef void(^FailedBlock)();

@interface HTTPRequest : NSObject<NSURLConnectionDataDelegate>
{
    NSMutableData *_mData;
}
@property (nonatomic,copy) NSString *url;
@property (nonatomic,copy) FinishBlock finishBlock;
@property (nonatomic,copy) FailedBlock failedBlock;

//开始请求
-(void)startRequest;
@end
