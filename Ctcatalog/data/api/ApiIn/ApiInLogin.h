//
//  ApiInLogin.h
//  Youngcatalog
//
//  Created by honlun on 2014/6/28.
//  Copyright (c) 2014年 honlun. All rights reserved.
//

#import "JSONModel.h"

@interface ApiInLogin : JSONModel
@property(retain, nonatomic, strong) NSString *regid;
@property(retain, nonatomic, strong) NSString *md5;
@property(retain, nonatomic, strong) NSString *id;
@property(retain, nonatomic, strong) NSString *pwd;
@end
