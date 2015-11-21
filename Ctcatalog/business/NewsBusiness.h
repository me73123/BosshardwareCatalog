//
//  NewsBusiness.h
//  Youngcatalog
//
//  Created by honlun on 2014/7/19.
//  Copyright (c) 2014年 honlun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ApiOutNews.h"

@protocol NewsBusiness <NSObject>
/**
 * 取得 movie list
 * @param handler
 */
-(void)getVipNews:(void (^)(ApiOutNews*, NSError*))handler;
@end
