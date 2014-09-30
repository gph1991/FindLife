//
//  CollectUserCell.m
//  FindLife
//
//  Created by qianfeng on 14-9-24.
//  Copyright (c) 2014年 GPH. All rights reserved.
//

#import "CollectUserCell.h"

@implementation CollectUserCell

- (void)awakeFromNib
{
    // Initialization code
    _userIconImg.layer.masksToBounds = YES;
    _userIconImg.layer.cornerRadius = 10;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc
{
    [_userIconImg release];
    [_userNameLabel release];
    [super dealloc];
}
@end
