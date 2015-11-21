//
//  FileUtil.m
//  kokola
//
//  Created by Myles on 13/10/15.
//  Copyright (c) 2013年 michael. All rights reserved.
//

#import "FileUtil.h"

@implementation FileUtil

+(BOOL)createFolderUnderDocuments:(NSString*) foldername {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0]; // Get documents folder
    NSString *dataPath = [documentsDirectory stringByAppendingPathComponent:foldername];
    
    
    BOOL result = YES;
    if (![[NSFileManager defaultManager] fileExistsAtPath:dataPath]) {
        NSLog(@"createDocumentsFolder:%@",dataPath);
        NSError* error = nil;
        result = [[NSFileManager defaultManager] createDirectoryAtPath:dataPath withIntermediateDirectories:YES attributes:nil error:&error]; //Create folder
        if(!result) {
            NSLog(@"createDocumentsFolder error:%@",error);
        }
    }
    return result;
}

+(NSString*)getDocumentPath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0]; // Get documents folder
    return documentsDirectory;
}

//+(BOOL)saveMiniImageFile:(NSData*)data withFilename:(NSString*) filename andWithuuid:(NSString*) withuuid{
////    NSString* minifilename = chatmsg.ckey;
////    NSString* withuuid = @"";
////    if ([chatmsg.msgtype isEqualToString:@"0"]) {
////        //單人訊息，withuuid為對方id (此處只有接收訊息後會執行，因此fromid都是對方id)
////        withuuid = chatmsg.fromid;
////    } else {
////        //多人訊息，withuuid為groupid(多人訊息的toid都是groupid)
////        withuuid = chatmsg.toid;
////    }
//    NSString* miniDir = [withuuid stringByAppendingPathComponent:@"mini"];
//    [FileUtil createFolderUnderDocuments:miniDir];
//    
//    NSString* filepath = [miniDir stringByAppendingPathComponent:
//                          [NSString stringWithFormat:@"%@",filename]];
//    //NSLog(@"filepath:%@",filepath);
//    
//    NSString* documentDir = [FileUtil getDocumentPath];
//    NSString* filefullpath = [documentDir stringByAppendingPathComponent:filepath];
//    
//    NSLog(@"filefullpath:%@",filefullpath);
//    
//    NSError* err = nil;
//
//    BOOL writeResult = [data writeToFile:filefullpath options:NSDataWritingAtomic error:&err];
//    if(!writeResult) {
//        NSLog(@"write [%@] error:%@",filefullpath, err);
//    }
//    return writeResult;
//}

+(BOOL)saveOriginImageFile:(NSData*)data withFilename:(NSString*) filename andWithuuid:(NSString*) withuuid {
    NSString* originDir = [withuuid stringByAppendingPathComponent:@"origin"];
    [FileUtil createFolderUnderDocuments:originDir];
    
    NSString* filepath = [originDir stringByAppendingPathComponent:
                          [NSString stringWithFormat:@"%@",filename]];
    //NSLog(@"filepath:%@",filepath);
    
    NSString* documentDir = [FileUtil getDocumentPath];
    NSString* filefullpath = [documentDir stringByAppendingPathComponent:filepath];
    
    NSLog(@"filefullpath:%@",filefullpath);
    
    NSError* err = nil;
    
    BOOL writeResult = [data writeToFile:filefullpath options:NSDataWritingAtomic error:&err];
    if(!writeResult) {
        NSLog(@"write [%@] error:%@",filefullpath, err);
    }
    return writeResult;
}

+(void)EmptySandbox
{
    NSFileManager *fileMgr = [[NSFileManager alloc] init];
    NSError *error = nil;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSArray *files = [fileMgr contentsOfDirectoryAtPath:documentsDirectory error:nil];
    
    while (files.count > 0) {
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSArray *directoryContents = [fileMgr contentsOfDirectoryAtPath:documentsDirectory error:&error];
        if (error == nil) {
            for (NSString *path in directoryContents) {
                NSString *fullPath = [documentsDirectory stringByAppendingPathComponent:path];
                BOOL removeSuccess = [fileMgr removeItemAtPath:fullPath error:&error];
                files = [fileMgr contentsOfDirectoryAtPath:documentsDirectory error:nil];
                if (!removeSuccess) {
                    // Error
                }
            }
        } else {
            // Error
        }
    }
}

+(NSString*) getFullFilePath:(NSString*) filename andDirName:(NSString*) dirname{
    NSString* dir = dirname;
    [FileUtil createFolderUnderDocuments:dir];
    NSString* filepath = [dir stringByAppendingPathComponent:
                          [NSString stringWithFormat:@"%@",filename]];
    NSString* documentDir = [FileUtil getDocumentPath];
    NSString* filefullpath = [documentDir stringByAppendingPathComponent:filepath];
    //NSLog(@"filefullpath:%@",filefullpath);
    return filefullpath;
}

+(BOOL)renameRecorderOldFilePath:(NSString*) oldFilePath withNewFilePath:(NSString*)newFilePath{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError* renameFileError = nil;
    BOOL removeFileResult = NO;
    
    if ([fileManager fileExistsAtPath:oldFilePath])
    {
        if (![fileManager fileExistsAtPath:newFilePath])
        {
            removeFileResult = [fileManager moveItemAtPath:oldFilePath toPath:newFilePath error:&renameFileError];
            if(removeFileResult == NO) {
//                KoKoLaLog(KOKOLALOG_FILE_ERROR, @"renameFileError oldFilePath=%@, newFilePath=%@, error=%@",oldFilePath,newFilePath, renameFileError);
                NSLog(@"renameFileError oldFilePath=%@, newFilePath=%@, error=%@",oldFilePath,newFilePath, renameFileError);
            }
        }else{
            //新檔案已經存在
            NSLog(@"new file is exists newFilePath=%@", newFilePath);
        }
    }else{
        //舊檔案不存在
        NSLog(@"file not exists oldFilePath=%@", oldFilePath);
    }
    return removeFileResult;
}
@end
