//
//  ExitAppViewController.h
//  Youngcatalog
//
//  Created by honlun on 2014/8/2.
//  Copyright (c) 2014年 honlun. All rights reserved.
//

#import "BasicViewController.h"
#import "MainViewController.h"

typedef void (^ConfigureCallback)();

@interface AlertViewController : BasicViewController
@property (nonatomic, strong) MainViewController* mainCtrl;
@property (weak, nonatomic) IBOutlet UILabel *lb_title;
@property (weak, nonatomic) IBOutlet UILabel *lb_msg;
@property (weak, nonatomic) IBOutlet UIButton *btn_configure;
@property (nonatomic,strong) ConfigureCallback configureCallback;
@property BOOL hiddenCancel;
@end
