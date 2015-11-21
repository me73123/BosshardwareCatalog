//
//  UdfConstants.h
//  Youngcatalog
//
//  Created by honlun on 2014/7/19.
//  Copyright (c) 2014年 honlun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UdfConstants : NSObject

extern NSString *const SERVER_URL;
extern NSString *const ROOT_PATH;
extern NSString *const SENDER_ID;
extern NSString *const API_KEY;

extern NSString *const DIRECTORY_LAST_UPDATE_DATE;
extern NSString *const VIP_DIRECTORY_LAST_UPDATE_DATE;
extern NSString *const UPDATE_DATE_DATEFORMAT;
extern NSString *const ISLOGIN;

extern NSString *const GCM_REGISTERID;
extern NSString *const BUILD_SERIAL;

+(NSString*) getUserAgent;
@end
