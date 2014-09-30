//
//  MainHeaderCell.m
//  FindLife
//
//  Created by qianfeng on 14-9-23.
//  Copyright (c) 2014年 GPH. All rights reserved.
//

#import "MainHeaderCell.h"

@implementation MainHeaderCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc
{
    [_iconImg release];
    [_titleLabel release];
    [_dateLabel release];
    [_backView release];
    [super dealloc];
}
@end
