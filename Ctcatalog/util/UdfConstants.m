//
//  UdfConstants.m
//  Youngcatalog
//
//  Created by honlun on 2014/7/19.
//  Copyright (c) 2014年 honlun. All rights reserved.
//

#import "UdfConstants.h"

static NSString *userAgent = nil;

@implementation UdfConstants

NSString *const SERVER_URL = @"www.honlun.com.tw";
NSString *const ROOT_PATH = @"/packcatalog";
NSString *const SENDER_ID = @"3591757920";
NSString *const API_KEY = @"AIzaSyCG_7D7a5zZsngVBOHQqTVVj7--maPMm3c";

NSString *const DIRECTORY_LAST_UPDATE_DATE = @"DIRECTORY_LAST_UPDATE_DATE";
NSString *const VIP_DIRECTORY_LAST_UPDATE_DATE = @"VIP_DIRECTORY_LAST_UPDATE_DATE";
NSString *const UPDATE_DATE_DATEFORMAT = @"yyyy-MM-dd HH:mm:ss";
NSString *const ISLOGIN = @"ISLOGIN";

NSString *const GCM_REGISTERID = @"GCM_REGISTERID";
NSString *const BUILD_SERIAL = @"BUILD_SERIAL";

+(void) setUserAgent{
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectZero];
    userAgent = [webView stringByEvaluatingJavaScriptFromString:@"navigator.userAgent"];
}

+(NSString*) getUserAgent{
    if(userAgent==nil){
        [self setUserAgent];
    }
    return userAgent;
}
@end
