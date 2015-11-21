//
//  HttpPostException.m
//  kokomeeting
//
//  Created by james on 13/8/26.
//  Copyright (c) 2013年 ruby. All rights reserved.
//

#import "HttpPostException.h"

@implementation HttpPostException

-(HttpPostException*) initWithMsg:(NSString*)msg{
    self = [super init];
    self.message = msg;
    return self;
}

@end
