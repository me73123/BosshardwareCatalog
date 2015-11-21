//
//  MainViewController.h
//  Youngcatalog
//
//  Created by honlun on 2014/7/19.
//  Copyright (c) 2014年 honlun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BasicViewController.h"

static const NSInteger UPDATE_CELL = 0;
static const NSInteger DELETE_CELL = 1;
static const NSInteger MOVIE_CELL = 2;
static const NSInteger VIP_CELL = 3;

@interface MainViewController : BasicViewController
-(void)changeViewCtrl:(int) index;
@end
