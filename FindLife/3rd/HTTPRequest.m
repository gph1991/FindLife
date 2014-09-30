//
//  HTTPRequest.m
//  aixianmian
//
//  Created by GPH on 14-9-1.
//  Copyright (c) 2014年 GPH. All rights reserved.
//

#import "HTTPRequest.h"

@implementation HTTPRequest

-(void)startRequest
{
    _mData = [[NSMutableData alloc]init];
    NSURLRequest *request = [[NSURLRequest alloc]
                    initWithURL:[NSURL URLWithString:self.url]];
    NSURLConnection *connection = [NSURLConnection connectionWithRequest:request delegate:self];
    
    [connection start];

}

#pragma mark -
#pragma mark 代理方法
-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"%@",error);
    self.failedBlock();
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [_mData appendData:data];
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    self.finishBlock(_mData);
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    
    // 注意这里将NSURLResponse对象转换成NSHTTPURLResponse对象才能去
  //  NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse*)response;
  //  NSLog(@"allHeaderFields: %@",httpResponse);
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}
- (void)dealloc
{
    [_mData retain];
    [super dealloc];
}
@end
