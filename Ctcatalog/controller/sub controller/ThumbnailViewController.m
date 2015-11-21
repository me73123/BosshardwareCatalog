//
//  ThumbnailViewController.m
//  Youngcatalog
//
//  Created by honlun on 2014/6/28.
//  Copyright (c) 2014年 honlun. All rights reserved.
//

#import "ThumbnailViewController.h"
#import "ThumbnailCollectionDelegate.h"
#import "FileUtil.h"

@interface ThumbnailViewController (){
    ThumbnailCollectionDelegate* thumbnailCollectionDelegate;
    NSMutableArray* imagePathAry;
    LoadingViewController* loadingCtrl;
}

@property (weak, nonatomic) IBOutlet UILabel *lb_title;
@property (weak, nonatomic) IBOutlet UICollectionView *cv_catalog;
@property (weak, nonatomic) IBOutlet UIButton *btn_refresh;

//action
- (IBAction)clickRefresh:(UIButton *)sender;

@end

@implementation ThumbnailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    [self loadString];
    //用全域變數,不然螢幕旋轉會有問題
    loadingCtrl = [LoadingViewController createLoadingViewController:NSLocalizedString(@"loading",nil)];
    
    imagePathAry = [[NSMutableArray alloc]init];
    // 顯示目錄縮圖
    thumbnailCollectionDelegate = [[ThumbnailCollectionDelegate alloc] initWithController:self collectionView:self.cv_catalog mlist:imagePathAry loadingCtrl:loadingCtrl];
    self.cv_catalog.delegate = thumbnailCollectionDelegate;
    self.cv_catalog.dataSource = thumbnailCollectionDelegate;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    // 取目錄內容
    [self getAllDirectoryInfo];
}

#pragma mark - ui
-(void)loadString{
    [self setCommonText:self.lb_title text:NSLocalizedString(@"albumarea", nil)];
    [self setCommonButton:self.btn_refresh text:NSLocalizedString(@"update", nil)];
}

#pragma mark - action
- (IBAction)clickRefresh:(UIButton *)sender {
    // update
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    BOOL isLogin = [userDefaults boolForKey:ISLOGIN];
    // 已登入
    if (isLogin) {
        [self updateVipCatalog];
    } else {
        
        NSString *lastUpdateDate = [userDefaults stringForKey:DIRECTORY_LAST_UPDATE_DATE];
        if([TextUtils isEmpty:lastUpdateDate]){
            //取得所有目錄時,下載失敗
            [self getAllCatalogInfo];
        }else{
            [self updateDirectoryInfo];
        }
    }
}

#pragma mark - api
-(void)getAllDirectoryInfo{
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    BOOL isLogin = [userDefaults boolForKey:ISLOGIN];
    id<DirectoryBusiness> directoryBiz = [BusinessGetter getDirectoryBusiness];
    // 已登入
    if (isLogin) {
        imagePathAry = [directoryBiz getVipAlbum];
        
        // 取得目錄
        if (imagePathAry==nil || imagePathAry.count<1) {
            NSLog(@"需要下載vip目錄");
        }
		//未登入
    }else{
        NSUInteger albumCount = -1;
        imagePathAry = [directoryBiz getFavAlbum];
        if (imagePathAry==nil || imagePathAry.count<1) {
            albumCount = [directoryBiz getAllAlbumSum];
        }
        
        // 取得目錄
        if (albumCount==0) {
            [self getAllCatalogInfo];
        }
    }
    if(imagePathAry==nil){
        NSLog(@"imagePathAry is nil");
        imagePathAry = [[NSMutableArray alloc]init];
    }
//    NSLog(@"[FileUtil getDocumentPath]:%@", [FileUtil getDocumentPath]);
    [thumbnailCollectionDelegate reloadDataWithCollectionView:self.cv_catalog mlist:imagePathAry];
}

-(void)getAllCatalogInfo{
    NSLog(@"getAllCatalogInfo");
    //顯示loading
    if(loadingCtrl != nil){
        [loadingCtrl close];
    }
    [loadingCtrl showLoadingView:self];
    id<DirectoryBusiness> directoryBiz = [BusinessGetter getDirectoryBusiness];
    [directoryBiz getAllDirectoryInfo:^(ApiOutAlbum *apiOut, NSError *error) {
        if(error==nil){
            if(apiOut!=nil && [apiOut.resultcode isEqualToString:@"200"]){
                if(apiOut.albumsList!=nil){
                    [directoryBiz updateOrSaveAlbum:apiOut.albumsList];
                    
                    NSArray<Album>* albumAry = apiOut.albumsList;
                    for (Album* album in albumAry) {
                        if (album.isUse.intValue == 1) {
                            NSString* dir = [album.albumuuid stringByAppendingPathComponent:@"title_page"];
                            [FileUtil createFolderUnderDocuments:dir];
                            NSString* filepath = [dir stringByAppendingPathComponent:album.albumphoto];
                            NSString* savePath = [[FileUtil getDocumentPath] stringByAppendingPathComponent:filepath];
                            //下載目錄封面
                            [directoryBiz getDirectoryImage:album.albumphoto albumuuid:album.albumuuid savePath:savePath completionHandler:^{
                                //下載成功才會直行,不用判斷下載結果
                                album.albumPhotoSavePath = savePath;
                                [imagePathAry addObject:album];
                                [thumbnailCollectionDelegate reloadDataWithCollectionView:self.cv_catalog mlist:imagePathAry];
                            }];
                        }
                    }
                    [loadingCtrl close];
                }else{
                    NSLog(@"getAllCatalogInfo movieList is null");
                    [loadingCtrl close];
                    [[[[iToast makeText:NSLocalizedString(@"toast_download_album_fail",nil)] setGravity:iToastGravityBottom] setDuration:iToastDurationNormal] show];
                }
            }else{
                NSLog(@"getAllCatalogInfo apiOut is null or resultcode not 200");
                [loadingCtrl close];
                [[[[iToast makeText:NSLocalizedString(@"toast_download_album_fail",nil)] setGravity:iToastGravityBottom] setDuration:iToastDurationNormal] show];
            }
        }else{
            NSLog(@"getAllCatalogInfo error:%@", error.localizedDescription);
            [loadingCtrl close];
            [[[[iToast makeText:NSLocalizedString(@"toast_download_album_fail",nil)] setGravity:iToastGravityBottom] setDuration:iToastDurationNormal] show];
        }
    }];
}

-(void)updateDirectoryInfo{
    NSLog(@"updateDirectoryInfo");
    //顯示loading
    if(loadingCtrl != nil){
        [loadingCtrl close];
    }
    [loadingCtrl showLoadingView:self];
    id<DirectoryBusiness> directoryBiz = [BusinessGetter getDirectoryBusiness];
    [directoryBiz getUpdateDirectoryInfo:^(ApiOutUpdateAlbum *apiOut, NSError *error) {
        if(error==nil){
            if(apiOut!=nil && [apiOut.resultcode isEqualToString:@"200"]){
                if(apiOut.albumsList!=nil){
                    [directoryBiz updateOrSaveAlbum:apiOut.albumsList];
                    
                    NSArray<Album>* albumAry = apiOut.albumsList;
                    for (Album* album in albumAry) {
                        if (album.isUse.intValue == 1) {
                            NSString* dir = [album.albumuuid stringByAppendingPathComponent:@"title_page"];
                            [FileUtil createFolderUnderDocuments:dir];
                            NSString* filepath = [dir stringByAppendingPathComponent:album.albumphoto];
                            NSString* savePath = [[FileUtil getDocumentPath] stringByAppendingPathComponent:filepath];
                            //下載目錄封面
                            [directoryBiz getDirectoryImage:album.albumphoto albumuuid:album.albumuuid savePath:savePath completionHandler:^{
                                //下載成功才會直行,不用判斷下載結果
                                album.albumPhotoSavePath = savePath;
                                [imagePathAry addObject:album];
                                [thumbnailCollectionDelegate reloadDataWithCollectionView:self.cv_catalog mlist:imagePathAry];
                            }];
                        }
                    }
                    [loadingCtrl close];
                }else{
                    NSLog(@"沒有新目錄需要更新");
                    [loadingCtrl close];
                }
            }else{
                NSLog(@"updateDirectoryInfo apiOut is null or resultcode not 200");
                [loadingCtrl close];
                [[[[iToast makeText:NSLocalizedString(@"toast_update_album_fail",nil)] setGravity:iToastGravityBottom] setDuration:iToastDurationNormal] show];
            }
        }else{
            NSLog(@"updateDirectoryInfo error:%@", error.localizedDescription);
            [loadingCtrl close];
            [[[[iToast makeText:NSLocalizedString(@"toast_update_album_fail",nil)] setGravity:iToastGravityBottom] setDuration:iToastDurationNormal] show];
        }
    }];
}

-(void)updateVipCatalog{
    NSLog(@"updateVipCatalog");
    //顯示loading
    if(loadingCtrl != nil){
        [loadingCtrl close];
    }
    [loadingCtrl showLoadingView:self];
    id<DirectoryBusiness> directoryBiz = [BusinessGetter getDirectoryBusiness];
    [directoryBiz getUpdateVipCatalog:^(ApiOutUpdateAlbum *apiOut, NSError *error) {
        if(error==nil){
            if(apiOut!=nil && [apiOut.resultcode isEqualToString:@"200"]){
                if(apiOut.albumsList!=nil){
                    [directoryBiz updateOrSaveAlbum:apiOut.albumsList];
                    
                    NSArray<Album>* albumAry = apiOut.albumsList;
                    for (Album* album in albumAry) {
                        if (album.isUse.intValue == 2) {
                            NSString* dir = [album.albumuuid stringByAppendingPathComponent:@"title_page"];
                            [FileUtil createFolderUnderDocuments:dir];
                            NSString* filepath = [dir stringByAppendingPathComponent:album.albumphoto];
                            NSString* savePath = [[FileUtil getDocumentPath] stringByAppendingPathComponent:filepath];
                            //下載目錄封面
                            [directoryBiz getDirectoryImage:album.albumphoto albumuuid:album.albumuuid savePath:savePath completionHandler:^{
                                //下載成功才會直行,不用判斷下載結果
                                album.albumPhotoSavePath = savePath;
                                [imagePathAry addObject:album];
                                [thumbnailCollectionDelegate reloadDataWithCollectionView:self.cv_catalog mlist:imagePathAry];
                            }];
                        }
                    }
                    [loadingCtrl close];
                }else{
                    NSLog(@"沒有目錄需要更新");
                    [loadingCtrl close];
                }
            }else{
                NSLog(@"updateVipCatalog apiOut is null or resultcode not 200");
                [loadingCtrl close];
                [[[[iToast makeText:NSLocalizedString(@"toast_update_album_fail",nil)] setGravity:iToastGravityBottom] setDuration:iToastDurationNormal] show];
            }
        }else{
            NSLog(@"updateVipCatalog error:%@", error.localizedDescription);
            [loadingCtrl close];
            [[[[iToast makeText:NSLocalizedString(@"toast_update_album_fail",nil)] setGravity:iToastGravityBottom] setDuration:iToastDurationNormal] show];
        }
    }];
}

-(void)downloadDirectory:(Album*)vo saveZipFilePath:(NSString*)saveZipFilePath photoSavePath:(NSString*)photoSavePath{
    //顯示loading
    if(loadingCtrl != nil){
        [loadingCtrl close];
    }
    [loadingCtrl showLoadingView:self];
    id<DirectoryBusiness> directoryBiz = [BusinessGetter getDirectoryBusiness];
    [directoryBiz downloadDirectory:vo.albumDetailPath zipSavePath:saveZipFilePath photoSavePath:photoSavePath completionHandler:^(NSError *error) {
        [loadingCtrl close];
        if(error==nil){
            // 儲存到DB
            [directoryBiz updateIsLoad:vo.albumuuid isload:@1];
            [directoryBiz updateDetailPhotoSavePath:vo.albumuuid path:photoSavePath];
            
            vo.isLoad = @1;
            vo.detailPhotoSavePath = photoSavePath;
            // 更新畫面
            [self.cv_catalog reloadData];
        }else{
            NSLog(@"downloadDirectory error:%@", error.localizedDescription);
            [[[[iToast makeText:NSLocalizedString(@"toast_download_album_fail",nil)] setGravity:iToastGravityBottom] setDuration:iToastDurationNormal] show];
        }
    }];
}

#pragma mark - system
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
@end
