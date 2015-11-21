//
//  BusinessGetter.h
//  Youngcatalog
//
//  Created by honlun on 2014/7/19.
//  Copyright (c) 2014年 honlun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DirectoryBusinessImpl.h"
#import "MovieBusinessImpl.h"
#import "NewsBusinessImpl.h"

@interface BusinessGetter : NSObject
+(id <DirectoryBusiness>) getDirectoryBusiness;
+(id <MovieBusiness>) getMovieBusiness;
+(id <NewsBusiness>) getNewsBusiness;
@end
