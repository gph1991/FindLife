//
//  MapViewController.h
//  FindLife
//
//  Created by qianfeng on 14-9-24.
//  Copyright (c) 2014年 GPH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MapViewController : UIViewController
@property(nonatomic,copy)NSString *addr;
@property(nonatomic,assign)float longitude;
@property(nonatomic,assign)float latitude;
@end
