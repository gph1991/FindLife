//
//  MainHeaderCell.h
//  FindLife
//
//  Created by qianfeng on 14-9-23.
//  Copyright (c) 2014年 GPH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainHeaderCell : UITableViewCell

@property (retain, nonatomic) IBOutlet UIImageView *iconImg;
@property (retain, nonatomic) IBOutlet UILabel *titleLabel;
@property (retain, nonatomic) IBOutlet UILabel *dateLabel;
@property (retain, nonatomic) IBOutlet UIView *backView;

@end
