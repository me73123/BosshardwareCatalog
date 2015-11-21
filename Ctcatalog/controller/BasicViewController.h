//
//  BasicViewController.h
//  Youngcatalog
//
//  Created by honlun on 2014/7/19.
//  Copyright (c) 2014年 honlun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "iToast.h"
#import "BusinessGetter.h"
#import "LoadingViewController.h"

@interface BasicViewController : UIViewController
/**
 *	設定label文字、顏色(black)
 *
 *	@param 	label
 *	@param 	text
 */
-(void) setCommonText:(UILabel*)label text:(NSString*)text;

/**
 *	設定button文字、顏色(white)
 *
 *	@param 	button
 *	@param 	text
 */
-(void) setCommonButton:(UIButton*)button text:(NSString*)text;
@end
