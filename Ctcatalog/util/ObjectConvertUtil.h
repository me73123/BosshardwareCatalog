//
//  ObjectConvertUtil.h
//  Youngcatalog
//
//  Created by honlun on 2014/8/23.
//  Copyright (c) 2014年 honlun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ObjectConvertUtil : NSObject
+(NSMutableArray*)convertTOManagedobjectWithJsonStr:(NSString*)jsonStr class:(Class)managedClass;
@end
