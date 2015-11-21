//
//  ApiOutLogin.h
//  Youngcatalog
//
//  Created by honlun on 2014/6/28.
//  Copyright (c) 2014年 honlun. All rights reserved.
//

#import "JSONModel.h"

@interface ApiOutLogin : JSONModel
@property(retain, nonatomic, strong) NSString *resultcode;
@property(retain, nonatomic, strong) NSString *resultdesc;
@property(retain, nonatomic, strong) NSDate *date;
@end
