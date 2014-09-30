//
//  MainCell.h
//  FindLife
//
//  Created by qianfeng on 14-9-23.
//  Copyright (c) 2014年 GPH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Shadow.h"
@interface MainCell : UITableViewCell

@property (retain, nonatomic) IBOutlet UILabel *titleLabel;
@property (retain, nonatomic) IBOutlet UILabel *addrLabel;
@property (retain, nonatomic) IBOutlet UILabel *collectNumLabel;
@property (retain, nonatomic) IBOutlet UIImageView *backImg;

@property (retain, nonatomic) IBOutlet UIButton *collectBtn;

@end
