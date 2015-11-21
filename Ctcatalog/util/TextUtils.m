//
//  TextUtils.m
//  kokomeeting
//
//  Created by maxkit on 2014/6/3.
//  Copyright (c) 2014年 ruby. All rights reserved.
//

#import "TextUtils.h"

@implementation TextUtils

+(BOOL) isEmpty:(NSString*) str{
    if(str!=nil && str.length>0 && ![str isEqualToString:@""]){
        return NO;
    }
    return YES;
}
@end
