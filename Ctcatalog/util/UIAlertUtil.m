//
//  UIAlertUtil.m
//  kokola
//
//  Created by Myles on 2014/3/11.
//  Copyright (c) 2014年 michael. All rights reserved.
//

#import "UIAlertUtil.h"
#import "AppDelegate.h"

static NSMutableArray* alerts = nil;

@interface UIAlertUtil () <UIAlertViewDelegate>  {
    AlertCallback alertCallback;
    NSString* alertText;
    NSString* alertTitle;
}

//@property (strong, nonatomic) NSString* alertText;
//@property (strong, nonatomic) NSString* alertTitle;
//@property (strong, nonatomic) UIAlertView* alertView;
//@property (strong, nonatomic) AlertCallback alertCallback;
@property (strong, nonatomic) UIAlertUtil* strongRef;

@end

@implementation UIAlertUtil

+(void)alertWithTitle:(NSString*)title andText:(NSString*)text andHandler:(AlertCallback) handler {
    UIAlertUtil* util = [[UIAlertUtil alloc] initWithTitle:title andText:text andHandler:handler];
    [util alert];
}

+(void)confirmWithTitle:(NSString*)title andText:(NSString*)text andHandler:(AlertCallback) handler {
    UIAlertUtil* util = [[UIAlertUtil alloc] initWithTitle:title andText:text andHandler:handler];
    [util confirm];
}

+(void)removeAll {
    for(UIAlertUtil *alertUtil in alerts) {
        [alertUtil dismiss];
    }
}

-(UIAlertUtil*)initWithTitle:(NSString*)title andText:(NSString*)text andHandler:(AlertCallback) handler {
    self = [super init];
    if(self != nil) {
        alertTitle = title;
        alertText = text;
        alertCallback = handler;
    }
    return self;
}



-(void)alert {
    self.strongRef = self;
    UIAlertView* v = [[UIAlertView alloc] initWithTitle:alertTitle message:alertText delegate:self cancelButtonTitle:NSLocalizedString(@"configure", nil) otherButtonTitles:nil];
    self.view = v;

    if(alerts == nil) {
        alerts = [NSMutableArray arrayWithCapacity:4];
    }
    [alerts addObject:self];
    [v show];
}

-(void)confirm {
    self.strongRef = self;
    UIAlertView* v = [[UIAlertView alloc] initWithTitle:alertTitle message:alertText delegate:self cancelButtonTitle:NSLocalizedString(@"cancel", nil) otherButtonTitles:NSLocalizedString(@"configure", nil),nil];
    self.view = v;
    
    if(alerts == nil) {
        alerts = [NSMutableArray arrayWithCapacity:4];
    }
    [alerts addObject:self];
    [v show];
}

- (void)dismiss {
    [self.view dismissWithClickedButtonIndex:0 animated:NO];
    self.strongRef = nil;
    [alerts removeObject:self];
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if(alertCallback != nil) {
        alertCallback(buttonIndex);
    }
    [self dismiss];
}


@end
