//
//  ApiOutMovie.h
//  Youngcatalog
//
//  Created by honlun on 2014/6/28.
//  Copyright (c) 2014年 honlun. All rights reserved.
//

#import "JSONModel.h"
#import "Movie.h"

@interface ApiOutMovie : JSONModel
@property(retain, nonatomic, strong) NSString *resultcode;
@property(retain, nonatomic, strong) NSString *resultdesc;
@property(retain, nonatomic, strong) NSArray<Movie> *movieList;
@property(retain, nonatomic, strong) NSDate *date;
@end
