//
//  CommentViewController.h
//  FindLife
//
//  Created by qianfeng on 14-9-25.
//  Copyright (c) 2014年 GPH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommentViewController : UIViewController

@property(nonatomic,copy)NSString *articleId;
@property(nonatomic,copy)NSString *title;
@property(nonatomic,copy)NSString *addr;
@property(nonatomic,copy)NSArray *likelist;

@end
