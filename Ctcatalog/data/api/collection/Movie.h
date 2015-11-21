//
//  Movie.h
//  Youngcatalog
//
//  Created by honlun on 2014/6/28.
//  Copyright (c) 2014年 honlun. All rights reserved.
//

#import "JSONModel.h"

@protocol Movie
@end

@interface Movie : JSONModel
@property(retain, nonatomic, strong) NSString *movieuuid;
@property(retain, nonatomic, strong) NSString *title;
@property(retain, nonatomic, strong) NSDate *updateDate;
@property(retain, nonatomic, strong) NSString *videoid;
@end
