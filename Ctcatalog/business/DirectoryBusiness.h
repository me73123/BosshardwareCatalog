//
//  DirectoryBusiness.h
//  Youngcatalog
//
//  Created by honlun on 2014/7/19.
//  Copyright (c) 2014年 honlun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ApiOutAlbum.h"
#import "ApiOutUpdateAlbum.h"
#import "ApiOutLogin.h"

@protocol DirectoryBusiness <NSObject>
//********************************************************************************************************
//API

/**
 * 下載所有行動目錄資料
 * @param handler
 */
-(void)getAllDirectoryInfo:(void (^)(ApiOutAlbum*, NSError*))handler;
/**
 *	下載行動目錄封面照
 *
 *	@param 	albumuuid
 *	@param 	savePath
 */
-(void)getDirectoryImage:(NSString*) filename albumuuid:(NSString*)albumuuid savePath:(NSString*)savePath completionHandler:(void (^)())handler;
/**
 *	下載行動目錄zip檔
 *  @param filename
 *  @param handler
 */
-(void)downloadDirectory:(NSString*) filename zipSavePath:(NSString*)zipSavePath photoSavePath:(NSString*) photoSavePath completionHandler:(void (^)(NSError*))handler;
/**
 *	一般使用者更新目錄
 *  @param handler
 */
-(void)getUpdateDirectoryInfo:(void (^)(ApiOutUpdateAlbum*, NSError*))handler;
/**
 * vip使用者更新目錄
 * @param handler
 */
-(void)getUpdateVipCatalog:(void (^)(ApiOutUpdateAlbum*, NSError*))handler;
/**
 *  vip登入
 *	@param 	userid
 *  @param 	passwd
 *  @param 	handler
 */
-(void)login:(NSString*)userid passwd:(NSString*) passwd completionHandler:(void (^)(ApiOutLogin*, NSError*))handler;
///**
// *	查詢舊客戶
// *
// *	@param 	userid
// *  @param  handler
// */
//-(void)callservice:(NSString*)userid completionHandler:(void (^)(ApiOutService*, NSError*))handler;//
///**
// *	新增叫修
// *  @param 	userid
// *	@param 	passwd
// *  @param  handler
// */
//-(void)callservice1:(NSString*)userid passwd:(NSString*) passwd completionHandler:(void (^)(ApiOutService1*, NSError*))handler;
///**
// *	新增客戶註冊
// *  @param 	userid
// *	@param 	passwd
// *  @param  handler
// */
//-(void)callservice2:(NSString*) cname tel:(NSString*) tel caddr:(NSString*) caddr cstatus:(NSString*) cstatus completionHandler:(void (^)(ApiOutService2*, NSError*))handler;
//********************************************************************************************************
//DB
-(void) saveAlbum:(NSArray<Album>*) albumAry;


-(void) updateOrSaveAlbum:(NSArray<Album>*) albumAry;
-(void) updateAlbumPhotoSavePath:(NSString*) albumuuid path:(NSString*) path completionHandler:(void (^)())handler;
-(void) updateDetailPhotoSavePath:(NSString*) albumuuid path:(NSString*) path;
-(void) updateIsLoad:(NSString*) albumuuid isload:(NSNumber*) isload;
-(void) updateIsDelete:(NSString*) albumuuid isdelete:(NSNumber*) isdelete;


-(NSArray<Album>*) getAllAlbum;
-(NSMutableArray<Album>*) getIsuseAlbum;
-(NSArray<Album>*) getVipIsuseAlbum;
-(NSMutableArray<Album>*) getFavAlbum;
-(NSMutableArray<Album>*) getVipAlbum;
-(NSUInteger) getAllAlbumSum;


-(void) deleteAlbum:(Album*) album;
@end
