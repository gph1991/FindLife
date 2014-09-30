//
//  AppDelegate.h
//  FindLife
//
//  Created by qianfeng on 14-9-23.
//  Copyright (c) 2014年 GPH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BMapKit.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate,BMKGeneralDelegate>
{
    BMKMapManager *_manager;
}
@property (strong, nonatomic) UIWindow *window;

@end
