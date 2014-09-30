//
//  FindItemFooterCell.h
//  FindLife
//
//  Created by qianfeng on 14-9-28.
//  Copyright (c) 2014年 GPH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FindItemFooterCell : UITableViewCell


@property (retain, nonatomic) IBOutlet UIButton *commentBtn;
@property (retain, nonatomic) IBOutlet UIButton *collectBtn;
@property (retain, nonatomic) IBOutlet UILabel *commentNumLabel;

@property (retain, nonatomic) IBOutlet UILabel *collectNumLabel;

@property (retain, nonatomic) IBOutlet UILabel *btnBackLabel;

@end
