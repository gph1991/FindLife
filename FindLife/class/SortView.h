//
//  SortView.h
//  FindLife
//
//  Created by qianfeng on 14-9-26.
//  Copyright (c) 2014年 GPH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SortView : UIScrollView

@property (nonatomic, assign) id delegate;
@property (nonatomic, assign) SEL sel;

-(void)makeView;
@end
