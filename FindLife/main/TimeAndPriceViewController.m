//
//  TimeAndPriceViewController.m
//  FindLife
//
//  Created by qianfeng on 14-9-24.
//  Copyright (c) 2014年 GPH. All rights reserved.
//

#import "TimeAndPriceViewController.h"
#import "MapViewController.h"
@interface TimeAndPriceViewController ()
{
    IBOutlet UILabel *_typeLabel;
    IBOutlet UILabel *_shortDescripeLabel;
    IBOutlet UILabel *_addrLabel;
    IBOutlet UILabel *_timeLabel;
    IBOutlet UILabel *_priceLabel;
    IBOutlet UILabel *_contectLabel;
}


- (IBAction)MapDown:(id)sender;

@end

@implementation TimeAndPriceViewController

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
    self.navigationController.navigationBarHidden = NO;
    [self makeView];
    self.navigationItem.title = @"详情";
}


-(void)makeView
{
    _typeLabel.text = self.dic[@"sec_typename"];
    _shortDescripeLabel.text = self.dic[@"abstract_content"];
    _addrLabel.text = self.dic[@"address"];
    NSArray *sec_attr = self.dic[@"sec_attr"];
    if (sec_attr.count >= 5)
    {
        _timeLabel.text = [sec_attr[2] objectForKey:@"content"];
        _priceLabel.text = [sec_attr[3] objectForKey:@"content"];
        _contectLabel.text = [sec_attr[4] objectForKey:@"content"];
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)MapDown:(id)sender
{
    NSLog(@"OK");
    MapViewController *mapView = [[MapViewController alloc]init];
    [self.navigationController pushViewController:mapView animated:YES];
    [mapView release];
}

-(void)dealloc
{
    [self.sid release];
    [self.dic release];
    [super dealloc];
}

@end
