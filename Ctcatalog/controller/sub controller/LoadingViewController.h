//
//  LoadingViewController.h
//  kokola
//
//  Created by Myles on 13/12/27.
//  Copyright (c) 2013年 michael. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BasicViewController.h"

@interface LoadingViewController : UIViewController

+(LoadingViewController*) createLoadingViewController;
+(LoadingViewController*) createLoadingViewController:(NSString*) msg;
-(void) showLoadingView:(UIViewController*) ctrl;
-(void)close;

@property (nonatomic, strong) IBOutlet UILabel *lb_msg;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadingIndicator;
@property (strong, nonatomic) NSString* msg;

-(void)prepareChatView:(NSNotification*) aNSNotification;

@end
