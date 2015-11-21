//
//  BasicViewController.m
//  Youngcatalog
//
//  Created by honlun on 2014/7/19.
//  Copyright (c) 2014年 honlun. All rights reserved.
//

#import "BasicViewController.h"
#import "AppDelegate.h"

@interface BasicViewController ()

@end

@implementation BasicViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

/**
 *	設定label文字、顏色(black)
 *
 *	@param 	label
 *	@param 	text
 */
-(void) setCommonText:(UILabel*)label text:(NSString*)text
{
    label.text = text;
    label.textColor = [UIColor blackColor];
}

/**
 *	設定button文字、顏色(white)
 *
 *	@param 	button
 *	@param 	text
 */
-(void) setCommonButton:(UIButton*)button text:(NSString*)text{
    [button setTitle:text forState:UIControlStateNormal];  //設定btn文字
    button.titleLabel.textColor = [UIColor whiteColor];
}

//螢幕旋轉
-(NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskAllButUpsideDown;
}

- (BOOL)shouldAutorotate{
    return YES;
}

//螢幕旋轉,重新取螢幕寬高
-(void)awakeFromNib
{
    [super awakeFromNib];
    CGRect screenRect = [[UIScreen mainScreen] applicationFrame];
    self.view.frame = screenRect;
    self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
}

#pragma mark - system
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
