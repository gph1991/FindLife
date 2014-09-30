//
//  TypeView.h
//  FindLife
//
//  Created by qianfeng on 14-9-25.
//  Copyright (c) 2014年 GPH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TypeView : UIScrollView

@property(nonatomic,copy)NSDictionary *dic;

@property (nonatomic, assign) id delegate;
@property (nonatomic, assign) SEL sel;
@property (nonatomic, copy) NSArray *keysArr;



-(void)makeView;
@end
