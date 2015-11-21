//
//  FileUtil.h
//  kokola
//
//  Created by Myles on 13/10/15.
//  Copyright (c) 2013年 michael. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FileUtil : NSObject

+(BOOL)createFolderUnderDocuments:(NSString*) folderpath;
+(NSString*)getDocumentPath;
//+(BOOL)saveMiniImageFile:(NSData*)data withFilename:(NSString*) filename andWithuuid:(NSString*) withuuid;
+(BOOL)saveOriginImageFile:(NSData*)data withFilename:(NSString*) filename andWithuuid:(NSString*) withuuid;
+(NSString*) getFullFilePath:(NSString*) filename andDirName:(NSString*) dirname;
+(BOOL)renameRecorderOldFilePath:(NSString*) oldFilePath withNewFilePath:(NSString*)newFilePath;
@end
