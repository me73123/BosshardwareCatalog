//
//  MovieBusiness.h
//  Youngcatalog
//
//  Created by honlun on 2014/7/19.
//  Copyright (c) 2014年 honlun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ApiOutMovie.h"

@protocol MovieBusiness <NSObject>
/**
 * 取得 movie list
 * @param handler
 */
-(void)getMovies:(void (^)(ApiOutMovie*, NSError*))handler;
@end
