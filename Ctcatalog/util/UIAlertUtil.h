//
//  UIAlertUtil.h
//  kokola
//
//  Created by Myles on 2014/3/11.
//  Copyright (c) 2014年 michael. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^AlertCallback)(int buttonIndex);

@interface UIAlertUtil : NSObject

+(void)alertWithTitle:(NSString*)title andText:(NSString*)text andHandler:(AlertCallback) handler;
+(void)confirmWithTitle:(NSString*)title andText:(NSString*)text andHandler:(AlertCallback) handler;
+(void)removeAll;
-(UIAlertUtil*)initWithTitle:(NSString*)title andText:(NSString*)text andHandler:(AlertCallback) handler;
-(void)alert;
-(void)confirm;

@property (strong,nonatomic) UIAlertView* view;

@end
