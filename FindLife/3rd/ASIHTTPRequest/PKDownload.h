//
//  PKDownload.h
//  POST
//
//  Created by qianfeng on 13-7-15.
//  Copyright (c) 2013年 PK. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIHTTPRequest.h"
#import "NSString+Hashing.h"

#define CachePath [[NSHomeDirectory() stringByAppendingPathComponent:@"tmp"] stringByAppendingPathComponent:@"PKCache"]

@class PKDownload;

@protocol PKDownloadDelegate <NSObject>

- (void)PKDownloadFinish:(PKDownload*)download Data:(NSData*)data;
- (void)PKDownloadFailed:(PKDownload*)download;

@end

@interface NSData(stringValue)

- (NSString*)stringValue;

@end

@interface NSString(jsonxml)

- (NSString*)PKJsonElement:(NSString*)ele;
- (NSString*)PKXmlElement:(NSString*)ele;

@end

@interface PKDownload : NSObject<ASIHTTPRequestDelegate>{
    ASIHTTPRequest* _request;
}

@property (nonatomic, assign) int tag;
@property (nonatomic, assign) id<PKDownloadDelegate> delegate;
@property (nonatomic, assign) BOOL cache;
@property (nonatomic, copy) NSString* url;
@property (nonatomic, copy) NSString* contentType;

- (id)initWithURL:(NSString*)url Delegate:(id<PKDownloadDelegate>)delegate;
- (void)startGet;
- (void)startPostWithJsonOrXmlString:(NSString*)jsonOrXml;
- (void)startPostWithDictionary:(NSDictionary*)parameterDic;
- (void)clearDelegatesAndCancel;
- (void)clearCache; 

@end
