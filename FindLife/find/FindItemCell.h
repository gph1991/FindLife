//
//  FindItemCell.h
//  FindLife
//
//  Created by qianfeng on 14-9-26.
//  Copyright (c) 2014年 GPH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FindItemModel.h"

@interface FindItemCell : UITableViewCell

@property (retain, nonatomic) IBOutlet UILabel *titleLabel;
@property (retain, nonatomic) IBOutlet UILabel *addrLabel;
@property (retain, nonatomic) IBOutlet UIImageView *imgView;
@property (retain, nonatomic) IBOutlet UIButton *moreBtn;

@property (retain, nonatomic) IBOutlet UIButton *commentBtn;

@property (retain, nonatomic) IBOutlet UIButton *collectBtn;
@property (retain, nonatomic) IBOutlet UILabel *commentNumLabel;
@property (retain, nonatomic) IBOutlet UILabel *collectNumLabel;
@property (retain, nonatomic) IBOutlet UIView *backView;
@property (retain, nonatomic) IBOutlet UIButton *showMoreBtn;
@property (retain, nonatomic) IBOutlet UILabel *btnBackLabel;

@property (retain, nonatomic) IBOutlet UILabel *contentLabel;
@property (retain, nonatomic) IBOutlet UIImageView *colImg;

- (IBAction)showOrHide:(UIButton *)sender;

@property (assign,nonatomic) SEL sel;
@property (assign,nonatomic) id delegate;

-(void)config:(FindItemModel*)model andWithFlag:(int)flag;

@end
