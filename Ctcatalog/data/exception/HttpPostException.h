//
//  HttpPostException.h
//  kokomeeting
//
//  Created by james on 13/8/26.
//  Copyright (c) 2013年 ruby. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HttpPostException : NSException
@property(retain, nonatomic, strong) NSString *message;
-(HttpPostException*) initWithMsg:(NSString*)msg;
@end
