//
//  FindItemCell.m
//  FindLife
//
//  Created by qianfeng on 14-9-26.
//  Copyright (c) 2014年 GPH. All rights reserved.
//

#import "FindItemCell.h"
#import "UIImageView+WebCache.h"

@implementation FindItemCell

- (void)awakeFromNib
{
    // Initialization code
    _btnBackLabel.layer.borderColor = [[UIColor lightGrayColor]CGColor];
    _btnBackLabel.layer.borderWidth = 1;
    _imgView.layer.cornerRadius = 10;
    _imgView.layer.masksToBounds = YES;
    _btnBackLabel.alpha = 0.5;
    [_showMoreBtn setImage:[UIImage imageNamed:@"index_arrow_up.png"] forState:UIControlStateSelected];

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
    [_imgView release];
    [_moreBtn release];
    [_commentBtn release];
    [_collectBtn release];
    [_commentNumLabel release];
    [_collectNumLabel release];
    [_backView release];
    [_showMoreBtn release];
    [_contentLabel release];
    [_btnBackLabel release];
    [_colImg release];
    [super dealloc];
}

- (IBAction)showOrHide:(UIButton *)sender
{

    [self.delegate performSelector:self.sel withObject:sender];
}


-(void)config:(FindItemModel*)model andWithFlag:(int)flag
{
    self.titleLabel.text = model.secname;
    self.addrLabel.text = model.secaddr;
    [self.imgView setImageWithURL:[NSURL URLWithString:model.secpic]];
    self.contentLabel.text = model.secabstract;
    
    self.commentNumLabel.text = [model.artriclecnt stringValue];
    self.collectNumLabel.text = [model.collectcnt stringValue];
    if (model.iscollect)
    {
        self.colImg.image = [UIImage imageNamed:@"discoverList_collectionClicked.png"];
    }
    else
    {
            self.colImg.image = [UIImage imageNamed:@"discoverList_collection.png"];
    }
    
    if (flag)
    {
        self.showMoreBtn.selected = YES;
        self.backView.hidden = NO;
        [UIView animateWithDuration:0.4f animations:^{
            self.frame = CGRectMake(0, 0, 320, 130);
        }];
    }
    else
    {
        self.showMoreBtn.selected = NO;
        self.backView.hidden = YES;
    }

}

@end
