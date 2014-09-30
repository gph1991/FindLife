//
//  CollectUserDetailController.m
//  FindLife
//
//  Created by qianfeng on 14-9-24.
//  Copyright (c) 2014年 GPH. All rights reserved.
//
#import "UIImageView+WebCache.h"
#import "CollectUserDetailController.h"

@interface CollectUserDetailController ()
{
    IBOutlet UIImageView *_userIconImg;
    IBOutlet UILabel *_userNameLabel;
    IBOutlet UILabel *_userAddLabel;
}
- (IBAction)showUserCollect:(id)sender;
- (IBAction)backDown:(id)sender;

@end

@implementation CollectUserDetailController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationController.navigationBarHidden = YES;
    _userIconImg.layer.masksToBounds = YES;
    _userIconImg.layer.cornerRadius = 10;
    [self makeView];
    
}

-(void)makeView
{
    [_userIconImg setImageWithURL:[NSURL URLWithString:self.dic[@"uavatar"]]];
    _userNameLabel.text = self.dic[@"uname"];
    _userAddLabel.text = [NSString stringWithFormat:@"%@ %@",self.dic[@"provincename"],self.dic[@"cityname"]];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)showUserCollect:(id)sender
{
    NSLog(@"OK");
}

- (IBAction)backDown:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)dealloc
{
    [self.dic release];
    [super dealloc];
}
@end
