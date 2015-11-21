//
//  AlbumDao.m
//  Youngcatalog
//
//  Created by honlun on 2014/8/9.
//  Copyright (c) 2014年 honlun. All rights reserved.
//

#import "AlbumDao.h"
#import "UdfConstants.h"

@implementation AlbumDao

//建構子
-(id)init{
    self = [super initWithAppDelegate];
    return self;
}

-(void) save:(Album*)saveObj{
    Album* obj = [NSEntityDescription insertNewObjectForEntityForName:@"Album" inManagedObjectContext:self.managedObjectContext];
    obj.albumuuid = saveObj.albumuuid;
    obj.albumTitle = saveObj.albumTitle;
    obj.albumphoto = saveObj.albumphoto;
    obj.albumDetailPath = saveObj.albumDetailPath;
    obj.updateDate = saveObj.updateDate;
    obj.isUse = saveObj.isUse;
    obj.isLoad = saveObj.isLoad;
    obj.isDelete = @0;
    obj.albumPhotoSavePath = saveObj.albumPhotoSavePath;
    obj.detailPhotoSavePath = saveObj.detailPhotoSavePath;
    
    NSError *error;
    if([self.managedObjectContext save:&error]){
        NSLog(@"新增成功");
    }else{
        NSLog(@"新增失敗：%@",[error localizedDescription]);
    }
}

-(void) saveAry:(NSArray<Album>*)saveObjAry{
    for(Album* obj in saveObjAry){
        [self save:obj];
    }
}

-(NSArray<Album>*) getAllAlbum {
    NSFetchRequest *fetchRequest = [self getFetchRequest:@"Album"];  //取得NSFetchRequest
    //設定排序
    NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey:@"updateDate" ascending:NO];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sort, nil];
    [fetchRequest setSortDescriptors:sortDescriptors];
    //查詢
    NSError *error;
    NSArray<Album>* array = (NSArray<Album>*)[self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    if(error!=nil){
        NSLog(@"查詢失敗：%@",[error localizedDescription]);
    }
    return array;
}

-(NSMutableArray<Album>*) getIsuseAlbum {
    NSFetchRequest *fetchRequest = [self getFetchRequest:@"Album"];  //取得NSFetchRequest
    //設定查詢條件
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"isUse=1"];
    [fetchRequest setPredicate:predicate];  //加入條件
    //設定排序
    NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey:@"updateDate" ascending:NO];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sort, nil];
    [fetchRequest setSortDescriptors:sortDescriptors];
    //查詢
    NSError *error;
    NSMutableArray<Album>* array = [(NSArray<Album>*)[self.managedObjectContext executeFetchRequest:fetchRequest error:&error]mutableCopy];
    
    if(error!=nil){
        NSLog(@"查詢失敗：%@",[error localizedDescription]);
    }
    return array;
}

-(NSArray<Album>*) getVipIsuseAlbum {
    NSFetchRequest *fetchRequest = [self getFetchRequest:@"Album"];  //取得NSFetchRequest
    //設定查詢條件
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"isUse=0"];
    [fetchRequest setPredicate:predicate];  //加入條件
    //設定排序
    NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey:@"updateDate" ascending:NO];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sort, nil];
    [fetchRequest setSortDescriptors:sortDescriptors];
    //查詢
    NSError *error;
    NSArray<Album>* array = (NSArray<Album>*)[self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    if(error!=nil){
        NSLog(@"查詢失敗：%@",[error localizedDescription]);
    }
    return array;
}

-(NSMutableArray<Album>*) getFavAlbum {
    NSFetchRequest *fetchRequest = [self getFetchRequest:@"Album"];  //取得NSFetchRequest
    //設定查詢條件
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"(isUse==1 or isUse=nil) and (isDelete==0 or isDelete=nil)"];  //設定查詢條件
    [fetchRequest setPredicate:predicate];  //加入條件
    //設定排序
    NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey:@"updateDate" ascending:NO];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sort, nil];
    [fetchRequest setSortDescriptors:sortDescriptors];
    //查詢
    NSError *error;
    NSMutableArray<Album>* array = [[self.managedObjectContext executeFetchRequest:fetchRequest error:&error] mutableCopy];
    
    if(error!=nil){
        NSLog(@"查詢失敗：%@",[error localizedDescription]);
    }
    return array;
}

-(NSMutableArray<Album>*) getVipAlbum {
    NSFetchRequest *fetchRequest = [self getFetchRequest:@"Album"];  //取得NSFetchRequest
    //設定查詢條件
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"isUse<>0 and isDelete=0"];  //設定查詢條件
    [fetchRequest setPredicate:predicate];  //加入條件
    //設定排序
    NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey:@"updateDate" ascending:NO];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sort, nil];
    [fetchRequest setSortDescriptors:sortDescriptors];
    //查詢
    NSError *error;
    NSMutableArray<Album>* array = [[self.managedObjectContext executeFetchRequest:fetchRequest error:&error]mutableCopy];
    
    if(error!=nil){
        NSLog(@"查詢失敗：%@",[error localizedDescription]);
    }
    return array;
}

-(NSUInteger) getAllAlbumSum {
    NSFetchRequest *fetchRequest = [self getFetchRequest:@"Album"];  //取得NSFetchRequest
    [fetchRequest setIncludesSubentities:NO]; //Omit subentities. Default is YES (i.e. include subentities)
    
    NSError *error;
    NSUInteger count = [self.managedObjectContext countForFetchRequest:fetchRequest error:&error];
    if(count == NSNotFound) {
        NSLog(@"查詢失敗：%@",[error localizedDescription]);
    }
    return count;
}

-(void) updateAlbum:(Album*) album {
    NSFetchRequest *fetchRequest = [self getFetchRequest:@"Album"];  //取得NSFetchRequest
    //設定查詢條件
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"albumuuid=%@", album.albumuuid];  //設定查詢條件
    [fetchRequest setPredicate:predicate];  //加入條件
    //查詢
    NSError *error;
    NSArray<Album>* array = (NSArray<Album>*)[self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    if(error==nil){
        //更新
        Album *obj = [array objectAtIndex:0];
        obj.albumTitle = album.albumTitle;
        obj.albumphoto = album.albumphoto;
        obj.albumDetailPath = album.albumDetailPath;
        obj.updateDate = album.updateDate;
        obj.isUse = album.isUse;
        NSLog(@"albumTitle:%@", obj.albumTitle);
        NSLog(@"isUse:%@", obj.isUse);
        //儲存
        NSError *error;
        if([self.managedObjectContext save:&error]){
            NSLog(@"修改成功");
        }else{
            NSLog(@"修改失敗：%@",[error localizedDescription]);
        }
    }else{
        NSLog(@"查詢失敗：%@",[error localizedDescription]);
    }
}

-(void) updateAlbumPhotoSavePath:(NSString*) albumuuid path:(NSString*) path {
    NSFetchRequest *fetchRequest = [self getFetchRequest:@"Album"];  //取得NSFetchRequest
    //設定查詢條件
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"albumuuid=%@", albumuuid];  //設定查詢條件
    [fetchRequest setPredicate:predicate];  //加入條件
    //查詢
    NSError *error;
    NSArray<Album>* array = (NSArray<Album>*)[self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    if(error==nil){
        //更新
        Album *obj = [array objectAtIndex:0];
        obj.albumPhotoSavePath = path;
        //儲存
        NSError *error;
        if([self.managedObjectContext save:&error]){
            NSLog(@"修改成功");
        }else{
            NSLog(@"修改失敗：%@",[error localizedDescription]);
        }
    }else{
        NSLog(@"查詢失敗：%@",[error localizedDescription]);
    }
}

-(void) updateDetailPhotoSavePath:(NSString*) albumuuid path:(NSString*) path{
    NSFetchRequest *fetchRequest = [self getFetchRequest:@"Album"];  //取得NSFetchRequest
    //設定查詢條件
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"albumuuid=%@", albumuuid];  //設定查詢條件
    [fetchRequest setPredicate:predicate];  //加入條件
    //查詢
    NSError *error;
    NSArray<Album>* array = (NSArray<Album>*)[self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    if(error==nil){
        //更新
        Album *obj = [array objectAtIndex:0];
        obj.detailPhotoSavePath = path;
        //儲存
        NSError *error;
        if([self.managedObjectContext save:&error]){
            NSLog(@"修改成功");
        }else{
            NSLog(@"修改失敗：%@",[error localizedDescription]);
        }
    }else{
        NSLog(@"查詢失敗：%@",[error localizedDescription]);
    }
}

-(void) updateIsLoad:(NSString*) albumuuid isload:(NSNumber*) isload {
    NSFetchRequest *fetchRequest = [self getFetchRequest:@"Album"];  //取得NSFetchRequest
    //設定查詢條件
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"albumuuid=%@", albumuuid];  //設定查詢條件
    [fetchRequest setPredicate:predicate];  //加入條件
    //查詢
    NSError *error;
    NSArray<Album>* array = (NSArray<Album>*)[self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    if(error==nil){
        //更新
        Album *obj = [array objectAtIndex:0];
        obj.isLoad = isload;
        //儲存
        NSError *error;
        if([self.managedObjectContext save:&error]){
            NSLog(@"修改成功");
        }else{
            NSLog(@"修改失敗：%@",[error localizedDescription]);
        }
    }else{
        NSLog(@"查詢失敗：%@",[error localizedDescription]);
    }
}

-(void) updateIsDelete:(NSString*) albumuuid isdelete:(NSNumber*) isdelete {
    NSFetchRequest *fetchRequest = [self getFetchRequest:@"Album"];  //取得NSFetchRequest
    //設定查詢條件
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"albumuuid=%@", albumuuid];  //設定查詢條件
    [fetchRequest setPredicate:predicate];  //加入條件
    //查詢
    NSError *error;
    NSArray<Album>* array = (NSArray<Album>*)[self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    if(error==nil){
        //更新
        Album *obj = [array objectAtIndex:0];
        obj.isDelete = isdelete;
        NSLog(@"isDelete:%@", obj.isDelete);
        //儲存
        NSError *error;
        if([self.managedObjectContext save:&error]){
            NSLog(@"修改成功");
        }else{
            NSLog(@"修改失敗：%@",[error localizedDescription]);
        }
    }else{
        NSLog(@"查詢失敗：%@",[error localizedDescription]);
    }
}

-(void) deleteAlbum:(NSString*) albumuuid {
    NSFetchRequest* fetchRequest = [self getFetchRequest:@"Album"];
    //設定查詢條件
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"albumuuid=%@", albumuuid];  //設定查詢條件
    [fetchRequest setPredicate:predicate];  //加入條件
    //查詢
    NSError *error = nil;
    NSArray<Album>* array = (NSArray<Album>*)[[self managedObjectContext] executeFetchRequest:fetchRequest error:&error];
    if(error==nil){
        NSManagedObject *obj = [array objectAtIndex:0];
        [[self managedObjectContext] deleteObject:obj];
        //這行很重要，要執行這行，才會把變更後的資料寫入
        if([self.managedObjectContext save:&error]){
            NSLog(@"刪除成功");
        }else{
            NSLog(@"刪除失敗：%@",[error localizedDescription]);
        }
    }else{
        NSLog(@"查詢失敗：%@",[error localizedDescription]);
    }
}

-(void) deleteAlbumAry:(NSArray<Album>*) albumAry {
    NSFetchRequest* fetchRequest = [self getFetchRequest:@"Album"];
    NSError *error;
    for (Album* album in albumAry) {
        //設定查詢條件
        NSPredicate * predicate = [NSPredicate predicateWithFormat:@"albumuuid=%@", album.albumuuid];  //設定查詢條件
        [fetchRequest setPredicate:predicate];  //加入條件
        //查詢
        
        NSArray<Album>* array = (NSArray<Album>*)[self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
        if(error==nil){
            //更新
            Album *obj = [array objectAtIndex:0];
            obj.isDelete = @1;
        }else{
            NSLog(@"查詢失敗：%@",[error localizedDescription]);
        }
    }
    
    if(error==nil){
        //儲存
        NSError *err;
        if([self.managedObjectContext save:&err]){
            NSLog(@"修改成功");
        }else{
            NSLog(@"修改失敗：%@",[err localizedDescription]);
        }
    }
}

@end
