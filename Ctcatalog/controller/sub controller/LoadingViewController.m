//
//  LoadingViewController.m
//  kokola
//
//  Created by Myles on 13/12/27.
//  Copyright (c) 2013年 michael. All rights reserved.
//

#import "LoadingViewController.h"
#import "AppDelegate.h"

@interface LoadingViewController ()
@end

@implementation LoadingViewController {
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.lb_msg.lineBreakMode = NSLineBreakByWordWrapping;
    self.lb_msg.numberOfLines = 0;
    
    if(self.msg==nil){
        self.msg = NSLocalizedString(@"loading",nil);
    }
    self.lb_msg.text = self.msg;
}

+(LoadingViewController*) createLoadingViewController {
    AppDelegate* app = (AppDelegate*) [UIApplication sharedApplication].delegate;
    return (LoadingViewController*) [[app storyboardWithName:@"OtherFunctional"] instantiateViewControllerWithIdentifier:@"LoadingViewController"];
}

+(LoadingViewController*) createLoadingViewController:(NSString*) msg {
    AppDelegate* app = (AppDelegate*) [UIApplication sharedApplication].delegate;
    LoadingViewController* loadingCtrl = (LoadingViewController*) [[app storyboardWithName:@"OtherFunctional"] instantiateViewControllerWithIdentifier:@"LoadingViewController"];
    loadingCtrl.msg = msg;
    return loadingCtrl;
}

-(void) showLoadingView:(UIViewController*) ctrl {
    [ctrl addChildViewController:self];
    [ctrl.view addSubview:self.view];
    [self didMoveToParentViewController:ctrl];
}

-(void)kokoAlert:(NSNotification*) aNSNotification {
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)close {
    [self willMoveToParentViewController:nil];
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
}

-(void)prepareChatView:(NSNotification*) aNSNotification {
    
}
@end
