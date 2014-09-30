//
//  SearchItemFooterView.h
//  FindLife
//
//  Created by qianfeng on 14-9-27.
//  Copyright (c) 2014年 GPH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchItemFooterView : UIView

-(void)makeViewWithContentNum:(int)cNum andColNum:(int)colNum WithBool:(BOOL)isCollect andCommetn:(NSString*)str;

@property(nonatomic,retain)UIButton *commentBtn;
@property(nonatomic,retain)UIButton *collectBtn;

@end
