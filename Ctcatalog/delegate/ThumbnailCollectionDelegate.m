//
//  ThumbnailCollectionDelegate.m
//  Youngcatalog
//
//  Created by honlun on 2014/8/16.
//  Copyright (c) 2014年 honlun. All rights reserved.
//

#import "ThumbnailCollectionDelegate.h"
#import "Album.h"
#import "FileUtil.h"
#import "iToast.h"
#import "ThumbnailViewController.h"
#import "ReviewCatalogViewController.h"

@implementation ThumbnailCollectionDelegate{
    BOOL isLogin;
    LoadingViewController* loadingCtrl;
}

-(id) initWithController:(UIViewController*)myContext collectionView:(UICollectionView *)myCollectionView mlist:(NSMutableArray*)mylist loadingCtrl:(LoadingViewController*)myLoadingCtrl{
    self = [super initWithController:myContext collectionView:myCollectionView mlist:mylist];
    if(!self) return self;
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    isLogin = [userDefaults boolForKey:ISLOGIN];
    loadingCtrl = myLoadingCtrl;
    return self;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CatalogCell" forIndexPath:indexPath];

    Album* vo = [self.mlist objectAtIndex:indexPath.row];
    
    UIImageView* imgv_catalog = (UIImageView*) [cell viewWithTag:101];
    UIImageView* imgv_vip_catalog = (UIImageView*) [cell viewWithTag:105];
    UIButton* btn_download = (UIButton*) [cell viewWithTag:102];
    UIButton* btn_review = (UIButton*) [cell viewWithTag:103];
    UILabel* lb_title = (UILabel*) [cell viewWithTag:104];
    
    //封面圖片
    if(![TextUtils isEmpty:vo.albumPhotoSavePath]){
        NSLog(@"vo.albumPhotoSavePath:%@", vo.albumPhotoSavePath);
        UIImage* image = [[UIImage alloc] initWithContentsOfFile:vo.albumPhotoSavePath];
        imgv_catalog.image = image;
    }else{
        //封面下載失敗或尚未下載
        NSLog(@"封面下載失敗");
        [self getCatalogImage:vo];
    }
    
    //vip catalog
    if(vo.isUse!=nil && vo.isUse.intValue==2){
        imgv_vip_catalog.hidden = NO;
    }else{
        imgv_vip_catalog.hidden = YES;
    }
    
    //按鈕
    [btn_download setTitle:NSLocalizedString(@"download", nil) forState:UIControlStateNormal];
    [btn_review setTitle:NSLocalizedString(@"review", nil) forState:UIControlStateNormal];
    NSLog(@"isLoad:%@", vo.isLoad);
    if(vo.isLoad.intValue == 0){  //如果手機內沒有圖檔(尚未下載)
        btn_download.hidden = NO;
        btn_review.hidden = YES;
    }else{
        btn_download.hidden = YES;
        btn_review.hidden = NO;
    }
    
    //文字
    lb_title.text = vo.albumTitle;
    
    //註冊event
    [btn_download addTarget:self action:@selector(clickDownloadAlbum:) forControlEvents:UIControlEventTouchUpInside];
    [btn_review addTarget:self action:@selector(clickReviewAlbum:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"CatalogCell: %li,%li",(long)[indexPath section],(long)[indexPath row]);
    Album* vo = [self.mlist objectAtIndex:indexPath.row];
    if(vo.isLoad.intValue == 1){  //已經下載
        [self showCatalogDetail:vo];
    }else{
        [[[[iToast makeText:NSLocalizedString(@"toast_download_album_first",nil)] setGravity:iToastGravityBottom] setDuration:iToastDurationNormal] show];
    }
}

#pragma mark - action
-(void)clickDownloadAlbum:(UIButton*)sender{
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.m_collectionView];
    NSIndexPath *indexPath = [self.m_collectionView indexPathForItemAtPoint:buttonPosition];
    NSLog(@"clickDownloadAlbum position:%ld", (long)indexPath.row);
    Album* vo = [self.mlist objectAtIndex:indexPath.row];
    
    NSString* zipDir = [vo.albumuuid stringByAppendingPathComponent:@"detail_zip"];
    [FileUtil createFolderUnderDocuments:zipDir];
    NSString* saveZipFilePath = [[FileUtil getDocumentPath] stringByAppendingPathComponent:zipDir];
    
    NSString* pageDir = [vo.albumuuid stringByAppendingPathComponent:@"content_page"];
    [FileUtil createFolderUnderDocuments:pageDir];
    NSString* photoSavePath = [[FileUtil getDocumentPath] stringByAppendingPathComponent:pageDir];
    
    
    [((ThumbnailViewController*)self.context) downloadDirectory:vo saveZipFilePath:saveZipFilePath photoSavePath:photoSavePath];
    
//    //顯示loading
//    if(loadingCtrl != nil){
//        [loadingCtrl close];
//    }
//    [loadingCtrl showLoadingView:((ThumbnailViewController*)self.context)];
//    
//    id<DirectoryBusiness> directoryBiz = [BusinessGetter getDirectoryBusiness];
//    [directoryBiz downloadDirectory:vo.albumDetailPath zipSavePath:saveZipFilePath photoSavePath:photoSavePath completionHandler:^(NSError *error) {
//        [loadingCtrl close];
//        if(error==nil){
//            // 儲存到DB
//            [directoryBiz updateIsLoad:vo.albumuuid isload:@1];
//            [directoryBiz updateDetailPhotoSavePath:vo.albumuuid path:photoSavePath];
//            
//            vo.isLoad = @1;
//            vo.detailPhotoSavePath = photoSavePath;
//            // 更新畫面
//            [self.m_collectionView reloadData];
//        }else{
//            NSLog(@"downloadDirectory error:%@", error.localizedDescription);
//            [[[[iToast makeText:NSLocalizedString(@"toast_download_album_fail",nil)] setGravity:iToastGravityBottom] setDuration:iToastDurationNormal] show];
//        }
//    }];
}

-(void)clickReviewAlbum:(UIButton*)sender{
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.m_collectionView];
    NSIndexPath *indexPath = [self.m_collectionView indexPathForItemAtPoint:buttonPosition];
    NSLog(@"clickReviewAlbum position:%ld", (long)indexPath.row);
    Album* vo = [self.mlist objectAtIndex:indexPath.row];
    [self showCatalogDetail:vo];
}

/**
 *	顯示catalog內容
 *
 *	@param 	Album
 */
- (void)showCatalogDetail:(Album *)vo
 {
    AppDelegate* appDelegate = (AppDelegate*) [UIApplication sharedApplication].delegate;
    ReviewCatalogViewController *reviewCatalogCtrl = (ReviewCatalogViewController*) [[appDelegate storyboardWithName:@"Catalog"] instantiateViewControllerWithIdentifier:@"ReviewCatalogViewController"];
    reviewCatalogCtrl.albumuuid = vo.albumuuid;
    reviewCatalogCtrl.albumTitle = vo.albumTitle;
    NSLog(@"vo.albumuuid:%@", vo.albumuuid);
    [((ThumbnailViewController*)self.context) presentViewController:reviewCatalogCtrl animated:YES completion:^{}];
}

-(void)getCatalogImage:(Album*)vo {
    NSString* dir = [vo.albumuuid stringByAppendingPathComponent:@"title_page"];
    NSString* filepath = [dir stringByAppendingPathComponent:vo.albumphoto];
    NSString* savePath = [[FileUtil getDocumentPath] stringByAppendingPathComponent:filepath];
    
    //下載目錄封面
    id<DirectoryBusiness> directoryBiz = [BusinessGetter getDirectoryBusiness];
    [directoryBiz getDirectoryImage:vo.albumphoto albumuuid:vo.albumuuid savePath:savePath completionHandler:^{
        //下載成功才會直行,不用判斷下載結果
        vo.albumPhotoSavePath = savePath;
        [self.m_collectionView reloadData];
    }];
}
@end
