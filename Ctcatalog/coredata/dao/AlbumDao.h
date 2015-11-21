//
//  AlbumDao.h
//  Youngcatalog
//
//  Created by honlun on 2014/8/9.
//  Copyright (c) 2014年 honlun. All rights reserved.
//

#import "BasicDao.h"
#import "Album.h"

@interface AlbumDao : BasicDao
-(void) save:(Album*)saveObj;
-(void) saveAry:(NSArray<Album>*)saveObjAry;
-(NSArray<Album>*) getAllAlbum;
-(NSMutableArray<Album>*) getIsuseAlbum;
-(NSArray<Album>*) getVipIsuseAlbum;
-(NSMutableArray<Album>*) getFavAlbum;
-(NSMutableArray<Album>*) getVipAlbum;
-(NSUInteger) getAllAlbumSum;
-(void) updateAlbum:(Album*) album;
-(void) updateAlbumPhotoSavePath:(NSString*) albumuuid path:(NSString*) path;
-(void) updateDetailPhotoSavePath:(NSString*) albumuuid path:(NSString*) path;
-(void) updateIsLoad:(NSString*) albumuuid isload:(NSNumber*) isload;
-(void) updateIsDelete:(NSString*) albumuuid isdelete:(NSNumber*) isdelete;
-(void) deleteAlbum:(NSString*) albumuuid;
-(void) deleteAlbumAry:(NSArray<Album>*) albumAry;
@end
