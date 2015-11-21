//
//  DirectoryBusinessImpl.m
//  Youngcatalog
//
//  Created by honlun on 2014/7/19.
//  Copyright (c) 2014年 honlun. All rights reserved.
//

#import "DirectoryBusinessImpl.h"
#import "FileUtil.h"
#import "ApiInUpdateAlbum.h"
#import "ApiInLogin.h"
#import "AlbumDao.h"
#import "ZipFile.h"
#import "FileInZipInfo.h"
#import "ZipReadStream.h"
#import "ObjectConvertUtil.h"
#import "Album.h"

@implementation DirectoryBusinessImpl{
    id delegate;
}
//********************************************************************************************************
//API

/**
 * 下載所有行動目錄資料
 * @param handler
 */
-(void)getAllDirectoryInfo:(void (^)(ApiOutAlbum*, NSError*))handler{
    
    NSString* path = [NSString stringWithFormat:@"%@%@", ROOT_PATH, @"/catadown2.php"];
    NSString *httpBodyString = @"";
    
    HttpUtil* httpUtil = [[HttpUtil alloc] init];
    [httpUtil sendHttpPostJSON:path httpBodyString:httpBodyString completionHandler:^(NSURLResponse* response, NSData* data, NSError* err){
        
        if ([data length] > 0 && err == nil) {
            NSString* responseStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSError *jsonError;
            ApiOutAlbum* apiOut = [[ApiOutAlbum alloc] initWithString:responseStr usingEncoding:NSUTF8StringEncoding error:&jsonError];
            for(id str in apiOut.albumsList){
                NSLog(@"str:%@", str);
            }
            NSMutableArray* albumList = [ObjectConvertUtil convertTOManagedobjectWithJsonStr:apiOut.albumsList class:Album.class];
            apiOut.albumsList = [albumList copy];
            if(apiOut!=nil){
                if(apiOut.date!=nil){
                    //更新update日期
                    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                    [formatter setDateFormat:UPDATE_DATE_DATEFORMAT];
                    NSString* updateDateStr = [formatter stringFromDate:apiOut.date];
                    NSLog(@"Date = %@", updateDateStr);
                    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
                    [userDefaults setObject:updateDateStr forKey:DIRECTORY_LAST_UPDATE_DATE];
                    [userDefaults synchronize]; //馬上修改standardUserDefaults
                }
            }
            
            handler(apiOut,nil);
        }
        else {
            handler(nil,err);
        }
    }];
    
}

/**
 *	下載行動目錄封面照
 *
 *	@param 	albumuuid
 *	@param 	savePath
 */
-(void)getDirectoryImage:(NSString*) filename albumuuid:(NSString*)albumuuid savePath:(NSString*)savePath completionHandler:(void (^)())handler{
    NSString* apiPath = [NSString stringWithFormat:@"%@%@", ROOT_PATH, @"/chmt-catalog/c/image/"];
    NSString* path = [NSString stringWithFormat:@"%@%@%@",SERVER_URL, apiPath, filename];
    NSString *httpBodyString = @"";
    HttpUtil* httpUtil = [[HttpUtil alloc] init];
    [httpUtil sendHttpPostDownload:path httpBodyString:httpBodyString completionHandler:^(NSURLResponse* response, NSData* data, NSError* error){
        
        if ([data length] > 0 && error == nil) {
            //儲存檔案
            NSLog(@"savePath:%@",savePath);
            
            NSError* err = nil;
            BOOL writeResult = [data writeToFile:savePath options:NSDataWritingAtomic error:&err];
            if(writeResult) {
                //寫入檔案成功
                [self updateAlbumPhotoSavePath:albumuuid path:savePath completionHandler:handler];
            }else {
                NSLog(@"圖片寫入檔案失敗");
            }
        }else {
            NSLog(@"下載行動目錄封面照 error:%@",error);
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"prompt",nil) message:NSLocalizedString(@"networkError",nil)  delegate:nil cancelButtonTitle:NSLocalizedString(@"configure",nil) otherButtonTitles: nil];
            [alert show];
        }
    }];
}

/**
 *	下載行動目錄zip檔
 *  @param filename
 *  @param handler
 */
-(void)downloadDirectory:(NSString*) filename zipSavePath:(NSString*)zipSavePath photoSavePath:(NSString*) photoSavePath completionHandler:(void (^)(NSError*))handler
 {
    
//    AppDelegate* app = (AppDelegate*) [UIApplication sharedApplication].delegate;
    
    NSString* apiPath = [NSString stringWithFormat:@"%@%@", ROOT_PATH, @"/chmt-catalog/c/image/"];
    NSString* path = [NSString stringWithFormat:@"%@%@%@",SERVER_URL, apiPath, filename];
    //NSString *httpBodyString = [apiIn toJSONString];
//    NSString* filename = emogroupid;
    
    NSString *httpBodyString = @"";//[NSString stringWithFormat:@"deviceid=%@&accesstoken=%@&filename=%@&downloadtype=emozip",app.deviceid,app.accesstoken,filename];
    //NSLog(@"getFullOrg request: %@", httpBodyString);
    
    HttpUtil* httpUtil = [[HttpUtil alloc] init];
    
    [httpUtil sendHttpPostDownload:path httpBodyString:httpBodyString completionHandler:^(NSURLResponse* response, NSData* data, NSError* err){
        
        NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*) response;
        NSInteger statusCode = httpResponse.statusCode;
        
        if ([data length] > 0 && err == nil && statusCode != 403) {
            NSFileManager *fileManager = [NSFileManager defaultManager];
            
            NSString* zipPath = [zipSavePath stringByAppendingPathComponent:filename];

            //清除舊的zip
            NSError* cleanZipError = nil;
            BOOL cleanZipResult = [fileManager removeItemAtPath:zipPath error:&cleanZipError];
            if(cleanZipResult == NO) {
                NSLog(@"cleanZip failed, error=%@",cleanZipError);
            }
            
            //儲存下載的zip檔案
            NSError* writeZipError = nil;
            BOOL writeZipResult = [data writeToFile:zipPath options:NSDataWritingAtomic error:&writeZipError];
            NSLog(@"writeZipResult:%i",writeZipResult);
            if(writeZipResult == NO) {
                NSLog(@"writeZip failed, error=%@",writeZipError);
            }

//            NSString* folderPath = [FileUtil getFullFilePath:emogroupid andDirName:@"expression_maps"];
            
            //清除舊的解壓縮目錄
            NSError* cleanFolderError = nil;
            BOOL cleanFolderResult = [fileManager removeItemAtPath:photoSavePath error:&cleanFolderError];
            if(cleanFolderResult == NO) {
                NSLog(@"cleanEmoFolder failed, error=%@",cleanFolderError);
            }
            
            //解壓縮
#warning TODO: 處理ZIP Exception (無法存取檔案)
            ZipFile *unzipFile = [[ZipFile alloc] initWithFileName:zipPath mode:ZipFileModeUnzip];

            NSArray *infos= [unzipFile listFileInZipInfos];
            for (FileInZipInfo *info in infos) {
                // locate the file in the zip
                [unzipFile locateFileInZip:info.name];
                NSLog(@"info.name:%@",info.name);
                // expand the file in memory
                ZipReadStream *read= [unzipFile readCurrentFileInZip];
                NSMutableData *data= [[NSMutableData alloc] initWithLength:info.length];
                NSLog(@"info.length=%lu",(unsigned long)info.length);
                NSInteger bytesRead= [read readDataWithBuffer:data];
                [read finishedReading];
                NSLog(@"bytesRead=%li",(long)bytesRead);
                // construct the folder/file path structure
                NSString *unzipPathFilename = [photoSavePath stringByAppendingPathComponent:[info.name lastPathComponent]];
                NSLog(@"unzipPathFilename=%@",unzipPathFilename);
                NSString *unzipPathFoldername = [[unzipPathFilename stringByDeletingLastPathComponent] copy];
                NSError *errorw;
                
#warning TODO: handle ZipException
                //ZipException在重新安裝App時可能發生, 需考慮重新下載
                
                //檢查檔名，略過系統檔
                NSRange range = [unzipPathFoldername rangeOfString:@"__MACOSX"];
                if (range.location == NSNotFound) {
                    if ([fileManager createDirectoryAtPath:unzipPathFoldername withIntermediateDirectories:YES attributes:nil error:&errorw]) {
                        if (![[unzipPathFilename pathExtension] isEqualToString:@""] && ![[[unzipPathFilename lastPathComponent] substringToIndex:1] isEqualToString:@"." ]) {
                            BOOL unzipImgWriteResult = [data writeToFile:unzipPathFilename atomically:NO];
                            NSLog(@"unzipImgWriteResult=%i",unzipImgWriteResult);
                        }
                    }
                    else {
                        NSLog(@"Directory Fail: %@", errorw);
                    }
                }
            }
            // close the zip file
            [unzipFile close];

//            //2014-6-25 計算下載次數
//            String url2 = "http://www.honlun.com.tw/youngcatalog/downcount.php?fname=" + filename;
//            HttpClient httpclient = new DefaultHttpClient();
//            HttpGet method = new HttpGet(url2);//連線到 url網址
//            HttpResponse response1 = httpclient.execute(method);
//            HttpEntity entity1 = response1.getEntity();
        }
        else {
            NSLog(@"Network error:%@",err);
        }
        NSLog(@"finish download zip:%@",filename);
        if(handler) {
            handler(err);
        }
        
    }];
}

/**
 *	一般使用者更新目錄
 *  @param handler
 */
-(void)getUpdateDirectoryInfo:(void (^)(ApiOutUpdateAlbum*, NSError*))handler
{
    
    NSString* path = [NSString stringWithFormat:@"%@%@", ROOT_PATH, @"/cataupdate2.php"];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:UPDATE_DATE_DATEFORMAT];
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *lastUpdateDate = [userDefaults stringForKey:DIRECTORY_LAST_UPDATE_DATE];
    
    ApiInUpdateAlbum* apiIn = [[ApiInUpdateAlbum alloc]init];
    if(![TextUtils isEmpty:lastUpdateDate]){
        apiIn.date = [formatter dateFromString:lastUpdateDate];
    }else{
        apiIn.date = [[NSDate alloc]init];
    }
    
    NSString *httpBodyString = [apiIn toJSONString];
    
    HttpUtil* httpUtil = [[HttpUtil alloc] init];
    [httpUtil sendHttpPostJSON:path httpBodyString:httpBodyString completionHandler:^(NSURLResponse* response, NSData* data, NSError* err){
        
        if ([data length] > 0 && err == nil) {
            NSString* responseStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSError *jsonError;
            ApiOutUpdateAlbum* apiOut = [[ApiOutUpdateAlbum alloc] initWithString:responseStr usingEncoding:NSUTF8StringEncoding error:&jsonError];
            
            if(apiOut!=nil && apiOut.date!=nil){
                //更新update日期
                NSString* updateDateStr = [formatter stringFromDate:apiOut.date];
                NSLog(@"Date = %@", updateDateStr);
                [userDefaults setObject:updateDateStr forKey:DIRECTORY_LAST_UPDATE_DATE];
                [userDefaults synchronize]; //馬上修改standardUserDefaults
            }
            
            handler(apiOut,nil);
        }
        else {
            handler(nil,err);
        }
    }];
}

/**
 * vip使用者更新目錄
 * @param handler
 */
-(void)getUpdateVipCatalog:(void (^)(ApiOutUpdateAlbum*, NSError*))handler
{
    
    NSString* path = [NSString stringWithFormat:@"%@%@", ROOT_PATH, @"/cataVIPupdate2.php"];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:UPDATE_DATE_DATEFORMAT];
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *lastUpdateDate = [userDefaults stringForKey:VIP_DIRECTORY_LAST_UPDATE_DATE];
    NSString* regid = [userDefaults stringForKey:GCM_REGISTERID];
    NSString* md5 = [userDefaults stringForKey:BUILD_SERIAL];
    
    ApiInUpdateAlbum* apiIn = [[ApiInUpdateAlbum alloc]init];
    if(![TextUtils isEmpty:lastUpdateDate]){
        apiIn.date = [formatter dateFromString:lastUpdateDate];
    }else{
        apiIn.date = [[NSDate alloc]init];
    }
    apiIn.regid = regid;
    apiIn.md5 = md5;
    
    NSString *httpBodyString = [apiIn toJSONString];
    
    HttpUtil* httpUtil = [[HttpUtil alloc] init];
    [httpUtil sendHttpPostJSON:path httpBodyString:httpBodyString completionHandler:^(NSURLResponse* response, NSData* data, NSError* err){
        
        if ([data length] > 0 && err == nil) {
            NSString* responseStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSError *jsonError;
            ApiOutUpdateAlbum* apiOut = [[ApiOutUpdateAlbum alloc] initWithString:responseStr usingEncoding:NSUTF8StringEncoding error:&jsonError];
            
            if(apiOut!=nil && apiOut.date!=nil){
                //更新update日期
                NSString* updateDateStr = [formatter stringFromDate:apiOut.date];
                NSLog(@"Date = %@", updateDateStr);
                [userDefaults setObject:updateDateStr forKey:VIP_DIRECTORY_LAST_UPDATE_DATE];
                [userDefaults synchronize]; //馬上修改standardUserDefaults
            }
            
            handler(apiOut,nil);
        }
        else {
            handler(nil,err);
        }
    }];
}

/**
 *  vip登入
 *	@param 	userid 
 *  @param 	passwd
 *  @param 	handler
 */
-(void)login:(NSString*)userid passwd:(NSString*) passwd completionHandler:(void (^)(ApiOutLogin*, NSError*))handler
{
    
    NSString* path = [NSString stringWithFormat:@"%@%@", ROOT_PATH, @"/catalogLogin2.php"];
    
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    NSString* regid = [userDefaults stringForKey:GCM_REGISTERID];
    NSString* md5 = [userDefaults stringForKey:BUILD_SERIAL];
    
    ApiInLogin* apiIn = [[ApiInLogin alloc]init];
    apiIn.id = userid;
    apiIn.pwd = passwd;
    apiIn.regid = regid;
    apiIn.md5 = md5;
    
    NSString *httpBodyString = [apiIn toJSONString];
    
    HttpUtil* httpUtil = [[HttpUtil alloc] init];
    [httpUtil sendHttpPostJSON:path httpBodyString:httpBodyString completionHandler:^(NSURLResponse* response, NSData* data, NSError* err){
        
        if ([data length] > 0 && err == nil) {
            NSString* responseStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSError *jsonError;
            ApiOutLogin* apiOut = [[ApiOutLogin alloc] initWithString:responseStr usingEncoding:NSUTF8StringEncoding error:&jsonError];
            
            if(apiOut!=nil && apiOut.date!=nil){
                //更新update日期
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                [formatter setDateFormat:UPDATE_DATE_DATEFORMAT];
                NSString* updateDateStr = [formatter stringFromDate:apiOut.date];
                NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
                NSLog(@"Date = %@", updateDateStr);
                [userDefaults setObject:updateDateStr forKey:VIP_DIRECTORY_LAST_UPDATE_DATE];
                [userDefaults synchronize]; //馬上修改standardUserDefaults
            }
            
            handler(apiOut,nil);
        }
        else {
            handler(nil,err);
        }
    }];
}

///**
// *	查詢舊客戶
// *
// *	@param 	userid
// *  @param  handler
// */
//-(void)callservice:(NSString*)userid completionHandler:(void (^)(ApiOutService*, NSError*))handler
//{
//    NSString* path = [NSString stringWithFormat:@"%@%@", ROOT_PATH, @"/cataservice.php"];
//    
//    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
//    NSString* regid = [userDefaults stringForKey:GCM_REGISTERID];
//    
//    ApiInService* apiIn = [[ApiInService alloc]init];
//    apiIn.userid = userid;
//    apiIn.regid = regid;
//    
//    NSString *httpBodyString = [apiIn toJSONString];
//    
//    HttpUtil* httpUtil = [[HttpUtil alloc] init];
//    [httpUtil sendHttpPostJSON:path httpBodyString:httpBodyString completionHandler:^(NSURLResponse* response, NSData* data, NSError* err){
//        
//        if ([data length] > 0 && err == nil) {
//            NSString* responseStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//            NSError *jsonError;
//            ApiOutService* apiOut = [[ApiOutService alloc] initWithString:responseStr usingEncoding:NSUTF8StringEncoding error:&jsonError];
//            handler(apiOut,nil);
//        }
//        else {
//            handler(nil,err);
//        }
//    }];
//}
//
///**
// *	新增叫修
// *  @param 	userid
// *	@param 	passwd
// *  @param  handler
// */
//-(void)callservice1:(NSString*)userid passwd:(NSString*) passwd completionHandler:(void (^)(ApiOutService1*, NSError*))handler
//{
//    NSString* path = [NSString stringWithFormat:@"%@%@", ROOT_PATH, @"/addservice.php"];
//    
//    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
//    NSString* regid = [userDefaults stringForKey:GCM_REGISTERID];
//    
//    ApiInService1* apiIn = [[ApiInService1 alloc]init];
//    apiIn.userid = userid;
//    apiIn.pwd = passwd;
//    
//    NSString *httpBodyString = [apiIn toJSONString];
//    
//    HttpUtil* httpUtil = [[HttpUtil alloc] init];
//    [httpUtil sendHttpPostJSON:path httpBodyString:httpBodyString completionHandler:^(NSURLResponse* response, NSData* data, NSError* err){
//        
//        if ([data length] > 0 && err == nil) {
//            NSString* responseStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//            NSError *jsonError;
//            ApiOutService1* apiOut = [[ApiOutService1 alloc] initWithString:responseStr usingEncoding:NSUTF8StringEncoding error:&jsonError];
//            handler(apiOut,nil);
//        }
//        else {
//            handler(nil,err);
//        }
//    }];
//}

///**
// *	新增客戶註冊
// *  @param 	userid
// *	@param 	passwd
// *  @param  handler
// */
//-(void)callservice2:(NSString*) cname tel:(NSString*) tel caddr:(NSString*) caddr cstatus:(NSString*) cstatus completionHandler:(void (^)(ApiOutService2*, NSError*))handler
//{
//    NSString* path = [NSString stringWithFormat:@"%@%@", ROOT_PATH, @"/addcustomer.php"];
//    
//    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
//    NSString* regid = [userDefaults stringForKey:GCM_REGISTERID];
//    
//    ApiInService2* apiIn = [[ApiInService2 alloc]init];
//    apiIn.cname = cname;
//    apiIn.tel = tel;
//    apiIn.caddr = caddr;
//    apiIn.cstatus = cstatus;
//    
//    NSString *httpBodyString = [apiIn toJSONString];
//    
//    HttpUtil* httpUtil = [[HttpUtil alloc] init];
//    [httpUtil sendHttpPostJSON:path httpBodyString:httpBodyString completionHandler:^(NSURLResponse* response, NSData* data, NSError* err){
//        
//        if ([data length] > 0 && err == nil) {
//            NSString* responseStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//            NSError *jsonError;
//            ApiOutService2* apiOut = [[ApiOutService2 alloc] initWithString:responseStr usingEncoding:NSUTF8StringEncoding error:&jsonError];
//            handler(apiOut,nil);
//        }
//        else {
//            handler(nil,err);
//        }
//    }];
//}

//********************************************************************************************************
//DB

-(void) saveAlbum:(NSArray<Album>*) albumAry {
    AlbumDao* dao = [[AlbumDao alloc] init];
    [dao saveAry:albumAry];
}

-(void) updateOrSaveAlbum:(NSArray<Album>*) albumAry {
    AlbumDao* dao = [[AlbumDao alloc] init];
    NSArray<Album>* dbAlbumAry = [dao getAllAlbum];
    BOOL isNewAlbum;
    for(Album* album in albumAry){
        isNewAlbum = YES;
        for(Album* dbAlbum in dbAlbumAry){
            if([album.albumuuid isEqualToString:dbAlbum.albumuuid]){
                //update
                isNewAlbum = NO;
            }
        }
        if(isNewAlbum){
            //新增
            [dao save:album];
        }else{
#warning TODO check update field
            //修改
            [dao updateAlbum:album];
        }
    }
}

-(void) updateAlbumPhotoSavePath:(NSString*) albumuuid path:(NSString*) path completionHandler:(void (^)())handler{
    AlbumDao* dao = [[AlbumDao alloc] init];
    [dao updateAlbumPhotoSavePath:albumuuid path:path];
    if(handler!=nil){
        handler();
    }
}

-(void) updateDetailPhotoSavePath:(NSString*) albumuuid path:(NSString*) path {
    AlbumDao* dao = [[AlbumDao alloc] init];
    [dao updateDetailPhotoSavePath:albumuuid path:path];
}

-(void) updateIsLoad:(NSString*) albumuuid isload:(NSNumber*) isload {
    AlbumDao* dao = [[AlbumDao alloc] init];
    [dao updateIsLoad:albumuuid isload:isload];
}

-(void) updateIsDelete:(NSString*) albumuuid isdelete:(NSNumber*) isdelete {
    AlbumDao* dao = [[AlbumDao alloc] init];
    [dao updateIsDelete:albumuuid isdelete:isdelete];
}

-(NSArray<Album>*) getAllAlbum {
    AlbumDao* dao = [[AlbumDao alloc] init];
    NSArray<Album>* result = [dao getAllAlbum];
    return result;
}

-(NSMutableArray<Album>*) getIsuseAlbum {
    AlbumDao* dao = [[AlbumDao alloc] init];
    NSMutableArray<Album>* result = [dao getIsuseAlbum];
    return result;
}

-(NSArray<Album>*) getVipIsuseAlbum {
    AlbumDao* dao = [[AlbumDao alloc] init];
    NSArray<Album>* result = [dao getVipIsuseAlbum];
    return result;
}

-(NSMutableArray<Album>*) getFavAlbum {
    AlbumDao* dao = [[AlbumDao alloc] init];
    NSMutableArray<Album>* result = [dao getFavAlbum];
    return result;
}

-(NSMutableArray<Album>*) getVipAlbum {
    AlbumDao* dao = [[AlbumDao alloc] init];
    NSMutableArray<Album>* result = [dao getVipAlbum];
    return result;
}

-(NSUInteger) getAllAlbumSum {
    AlbumDao* dao = [[AlbumDao alloc] init];
    NSUInteger count = [dao getAllAlbumSum];
    return count;
}

-(void) deleteAlbum:(Album*) album {
    if (![TextUtils isEmpty:album.albumPhotoSavePath]) {
        //刪除目錄下所有資料及當前目錄
        NSString* zipFilepath = [[FileUtil getDocumentPath] stringByAppendingPathComponent:album.albumuuid];
        
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSError* err;
        BOOL result = [fileManager removeItemAtPath:zipFilepath error:&err];
        NSLog(@"remove ALL files in emoZip, result=%i, error=%@",result,err);
    }
    
    //刪除DB
    AlbumDao* dao = [[AlbumDao alloc] init];
    [dao deleteAlbum:album.albumuuid];
}
@end
