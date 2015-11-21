//
//  Album.h
//  Youngcatalog
//
//  Created by honlun on 2014/6/28.
//  Copyright (c) 2014年 honlun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "JSONModel.h"

@protocol Album
@end

@interface Album : NSManagedObject

@property (nonatomic, retain) NSString * albumuuid;
@property (nonatomic, retain) NSString * albumTitle;
@property (nonatomic, retain) NSString * albumphoto;
@property (nonatomic, retain) NSString * albumDetailPath;
@property (nonatomic, retain) NSDate * updateDate;
/**
 *	0:下架 1:上架 2:VIP
 */
@property (nonatomic, retain) NSNumber * isUse;
@property (nonatomic, retain) NSNumber * isLoad;
@property (nonatomic, retain) NSNumber * isDelete;
@property (nonatomic, retain) NSString * albumPhotoSavePath;
@property (nonatomic, retain) NSString * detailPhotoSavePath;

@end
