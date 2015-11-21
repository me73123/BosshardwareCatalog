//
//  News.h
//  Youngcatalog
//
//  Created by honlun on 2014/6/28.
//  Copyright (c) 2014年 honlun. All rights reserved.
//

#import "JSONModel.h"

@protocol News
@end

@interface News : JSONModel
@property(retain, nonatomic, strong) NSString *title;
@property(retain, nonatomic, strong) NSDate *updateDate;
@property(retain, nonatomic, strong) NSString *link;
@end
