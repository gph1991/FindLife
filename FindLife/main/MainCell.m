//
//  MainCell.m
//  FindLife
//
//  Created by qianfeng on 14-9-23.
//  Copyright (c) 2014年 GPH. All rights reserved.
//

#import "MainCell.h"

@implementation MainCell

- (void)awakeFromNib
{

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc
{
    [_titleLabel release];
    [_addrLabel release];
    [_collectNumLabel release];
    [_backImg release];
    [_collectBtn release];
    [super dealloc];
}

@end
