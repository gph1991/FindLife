//
//  PKDownload.m
//  POST
//
//  Created by qianfeng on 13-7-15.
//  Copyright (c) 2013年 PK. All rights reserved.
//

#import "PKDownload.h"
#import "ASIFormDataRequest.h"

@implementation NSData(stringValue)

- (NSString *)stringValue{
    return [[[NSString alloc] initWithData:self encoding:NSUTF8StringEncoding] autorelease];
}

@end

@implementation NSString(jsonxml)

- (NSString *)PKJsonElement:(NSString *)ele{
    NSString* pattern = [NSString stringWithFormat:@"\"%@\":\"(.*?)\"",ele];
    NSRegularExpression* regular = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:nil];
    __block NSString* finValue = nil;
    [regular enumerateMatchesInString:self options:NSMatchingReportCompletion range:NSMakeRange(0, self.length) usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
        NSString* value = [self substringWithRange:[result rangeAtIndex:1]];
        if (value.length > 0) {
            finValue = value;
            return ;
        }
    }];
    return finValue;
}

- (NSString *)PKXmlElement:(NSString *)ele{
    NSString* pattern = [NSString stringWithFormat:@"<%@>(.*?)</%@>",ele,ele];
    NSRegularExpression* regular = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:nil];
    __block NSString* finValue = nil;
    [regular enumerateMatchesInString:self options:NSMatchingReportCompletion range:NSMakeRange(0, self.length) usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
        NSString* value = [self substringWithRange:[result rangeAtIndex:1]];
        if (value.length > 0) {
            finValue = value;
            return ;
        }
        return ;
    }];
    return finValue;
}

@end

@implementation PKDownload
@synthesize tag = _tag;
@synthesize url = _url;
@synthesize delegate = _delegate;
@synthesize cache = _cache;
@synthesize contentType = _contentType;

- (id)initWithURL:(NSString *)url Delegate:(id<PKDownloadDelegate>)delegate{
    if (self = [super init]) {
        self.url = url;
        self.delegate = delegate;
        
        self.contentType = @"Application/x-www-from-data";
        
        NSFileManager* fm = [NSFileManager defaultManager];
        //if (![fm fileExistsAtPath:CachePath isDirectory:YES]) {
            [fm createDirectoryAtPath:CachePath withIntermediateDirectories:YES attributes:nil error:nil];
        //}
    }
    return self;
}


- (BOOL)readCache{
    NSString* file = [NSString stringWithFormat:@"%@/%@",CachePath,[self.url MD5Hash]];
    NSFileManager* fm = [NSFileManager defaultManager];
    if ([fm fileExistsAtPath:file]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [_delegate PKDownloadFinish:self Data:[NSData dataWithContentsOfFile:file]];
        });
        return YES;
    }
    //[_delegate PKDownloadFailed:nil];
    return NO;
}

- (void)startGet{
    if (self.cache && [self readCache]) {
        return;
    }
    _request = [[ASIHTTPRequest alloc] initWithURL:[NSURL URLWithString:self.url]];
    _request.delegate = self;
    [_request startAsynchronous];
}

- (void)startPostWithDictionary:(NSDictionary *)parameterDic{
    if (self.cache && [self readCache]) {
        return;
    }
    _request = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:self.url]];
    ASIFormDataRequest* request = (ASIFormDataRequest*)_request;
    request.delegate = self;
    for (NSString* key in parameterDic.allKeys) {
        id value = [parameterDic objectForKey:key];
        if ([value isKindOfClass:[NSData class]]) {
            UIImage* image = [UIImage imageWithData:value];
            NSData* data = UIImagePNGRepresentation(image);
            [request setData:data withFileName:@"tmp.png" andContentType:@"image/png" forKey:key];
        } else {
            [request setPostValue:value forKey:key];
        }
    }
    [request startAsynchronous];
}

- (void)startPostWithJsonOrXmlString:(NSString *)jsonOrXml{
    if (self.cache && [self readCache]) {
        return;
    }
    NSData* data = [jsonOrXml dataUsingEncoding:NSUTF8StringEncoding];
    _request = [[ASIHTTPRequest alloc] initWithURL:[NSURL URLWithString:self.url]];
    _request.requestMethod = @"POST";
    [_request addRequestHeader:@"Content-Type" value:self.contentType];
    [_request addRequestHeader:@"Content-Length" value:[NSString stringWithFormat:@"%d",data.length]];
    [_request setPostBody:[NSMutableData dataWithData:data]];
    _request.delegate = self;
    [_request startAsynchronous];
}

- (void)requestFinished:(ASIHTTPRequest *)request{
    if (self.cache && ![self readCache]) {
        NSString* file = [NSString stringWithFormat:@"%@/%@",CachePath,[self.url MD5Hash]];
        [request.responseData writeToFile:file atomically:YES];
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [_delegate PKDownloadFinish:self Data:request.responseData];
    });
}

- (void)requestFailed:(ASIHTTPRequest *)request{
    dispatch_async(dispatch_get_main_queue(), ^{
        [_delegate PKDownloadFailed:self];
    });
    
}

- (void)clearDelegatesAndCancel{
    if (_request) {
        [_request clearDelegatesAndCancel];
    }
}

- (void)clearCache{
    NSFileManager* fm = [NSFileManager defaultManager];
    [fm removeItemAtPath:CachePath error:nil];
}

- (void)dealloc{
    if (_request) {
        [_request clearDelegatesAndCancel];
        [_request release];
    }
    [_contentType release];
    [_url release];
    [super dealloc];
}

@end
