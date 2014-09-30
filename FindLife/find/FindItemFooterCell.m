//
//  FindItemFooterCell.m
//  FindLife
//
//  Created by qianfeng on 14-9-28.
//  Copyright (c) 2014年 GPH. All rights reserved.
//

#import "FindItemFooterCell.h"

@implementation FindItemFooterCell

- (void)awakeFromNib
{
    // Initialization code
    _btnBackLabel.layer.borderColor = [[UIColor grayColor]CGColor];
    _btnBackLabel.layer.borderWidth = 1;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)dealloc {
    [_commentBtn release];
    [_collectBtn release];
    [_collectNumLabel release];
    [_commentNumLabel release];
    [_btnBackLabel release];
    [super dealloc];
}
@end
