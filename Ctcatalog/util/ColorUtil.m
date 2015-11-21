//
//  ColorUtil.m
//  kokomeeting
//
//  Created by james on 13/9/18.
//  Copyright (c) 2013年 ruby. All rights reserved.
//

#import "ColorUtil.h"

@implementation ColorUtil
+ (UIColor *)colorWithR:(CGFloat)red G:(CGFloat)green B:(CGFloat)blue A:(CGFloat)alpha {
    return [UIColor colorWithRed:(red/255.0) green:(green/255.0) blue:(blue/255.0) alpha:alpha];
}

+(UIColor*) background {
    return [UIColor colorWithRed:(201/255.0) green:(202/255.0) blue:(202/255.0) alpha:1];
}
@end
