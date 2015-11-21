//
//  NewsBusinessImpl.m
//  Youngcatalog
//
//  Created by honlun on 2014/7/19.
//  Copyright (c) 2014年 honlun. All rights reserved.
//

#import "NewsBusinessImpl.h"

@implementation NewsBusinessImpl

//********************************************************************************************************
//API

/**
 * 取得 movie list
 * @param handler
 */
-(void)getVipNews:(void (^)(ApiOutNews*, NSError*))handler{
    
    NSString* path = [NSString stringWithFormat:@"%@%@", ROOT_PATH, @"/getVIPnews2.php"];
    NSString *httpBodyString = @"";
    
    HttpUtil* httpUtil = [[HttpUtil alloc] init];
    [httpUtil sendHttpPostJSON:path httpBodyString:httpBodyString completionHandler:^(NSURLResponse* response, NSData* data, NSError* err){
        
        if ([data length] > 0 && err == nil) {
            NSString* responseStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSError *jsonError;
            ApiOutNews* apiOut = [[ApiOutNews alloc] initWithString:responseStr usingEncoding:NSUTF8StringEncoding error:&jsonError];
            
            handler(apiOut,nil);
        }
        else {
            handler(nil,err);
        }
    }];
    
}
@end
