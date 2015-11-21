//
//  BusinessGetter.m
//  Youngcatalog
//
//  Created by honlun on 2014/7/19.
//  Copyright (c) 2014年 honlun. All rights reserved.
//

#import "BusinessGetter.h"

@implementation BusinessGetter
+(id <DirectoryBusiness>) getDirectoryBusiness{
    return [[DirectoryBusinessImpl alloc] init];
}

+(id <MovieBusiness>) getMovieBusiness{
    return [[MovieBusinessImpl alloc] init];
}

+(id <NewsBusiness>) getNewsBusiness{
    return [[NewsBusinessImpl alloc] init];
}

@end
