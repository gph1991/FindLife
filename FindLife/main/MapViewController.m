//
//  MapViewController.m
//  FindLife
//
//  Created by qianfeng on 14-9-24.
//  Copyright (c) 2014年 GPH. All rights reserved.
//

#import "MapViewController.h"
#import "BMapKit.h"
#import "MyAnnotation.h"


@interface MapViewController ()<BMKMapViewDelegate>
{
    BMKMapView *_mapView;
    CLLocationCoordinate2D _mystartPt;
}
@end

@implementation MapViewController

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
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBarHidden = NO;
    
    [self makeView];
}

-(void)makeView
{
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 320, 40)];
    label.text = self.addr;
    label.font = [UIFont systemFontOfSize:13];
    [self.view addSubview:label];
    [label release];
    [self makeMap];

    //微调
    UIStepper *step = [[UIStepper alloc]initWithFrame:CGRectMake(220, self.view.frame.size.height-100-49, 40, 40)];
    [self.view addSubview:step];
    [step release];
    [step addTarget:self action:@selector(change:) forControlEvents:UIControlEventValueChanged];
    step.value = 0.01;
    step.minimumValue = 0.001;
    step.maximumValue = 0.1;
    step.stepValue = 0.005;
}

-(void)change:(UIStepper*)step
{
    BMKCoordinateSpan span = BMKCoordinateSpanMake(step.value, step.value);
    BMKCoordinateRegion region = BMKCoordinateRegionMake(_mystartPt, span);
    [_mapView setRegion:region animated:YES];
}


-(void)makeMap
{
    _mystartPt = CLLocationCoordinate2DMake(self.latitude, self.longitude);
    NSLog(@"%f,%f",self.latitude,self.longitude);
    BMKCoordinateSpan span = BMKCoordinateSpanMake(0.01, 0.01);
    BMKCoordinateRegion region = BMKCoordinateRegionMake(_mystartPt, span);
    
    //C OC C++
    _mapView = [[BMKMapView alloc] initWithFrame:CGRectMake(0, 40, 320, self.view.frame.size.height-40)];
    _mapView.delegate = self;
    [_mapView setRegion:region animated:YES];
    [self.view addSubview:_mapView];
    [_mapView release];
    
    //大头针
    MyAnnotation* anno = [[MyAnnotation alloc] init];
    anno.coordinate = _mystartPt;
    [_mapView addAnnotation:anno];
    [anno release];

}
-(void)viewWillAppear:(BOOL)animated
{
    [Common HideTabBar:YES andViews:self.tabBarController.view.subviews];
    self.navigationController.navigationBarHidden = YES;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
