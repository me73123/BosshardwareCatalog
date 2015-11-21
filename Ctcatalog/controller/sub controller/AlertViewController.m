//
//  ExitAppViewController.m
//  Youngcatalog
//
//  Created by honlun on 2014/8/2.
//  Copyright (c) 2014年 honlun. All rights reserved.
//

#import "AlertViewController.h"

@interface AlertViewController (){
    CGFloat width_cancel;
}
@property (weak, nonatomic) IBOutlet UIView *view_bg;
@property (weak, nonatomic) IBOutlet UIButton *btn_cancel;

//action
- (IBAction)clickCancel:(UIButton *)sender;
- (IBAction)clickConfigure:(UIButton *)sender;

//constraint
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraint_width_cancel;
@end

@implementation AlertViewController

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
    [self loadString];
    width_cancel = self.constraint_width_cancel.constant;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if(self.hiddenCancel){
        self.constraint_width_cancel.constant = 0;
    }
}

#pragma mark - ui
-(void)loadString{
    [self setCommonButton:self.btn_cancel text:NSLocalizedString(@"cancel", nil)];
    [self setCommonButton:self.btn_configure text:NSLocalizedString(@"configure", nil)];
}

#pragma mark - action
- (IBAction)clickCancel:(UIButton *)sender {
    [self willMoveToParentViewController:nil];
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
}

- (IBAction)clickConfigure:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:^{}];
    if(self.configureCallback!=nil){
        self.configureCallback();
    }
}
#pragma mark - api


#pragma mark - system
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
@end
