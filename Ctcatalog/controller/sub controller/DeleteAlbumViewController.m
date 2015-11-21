//
//  DeleteAlbumViewController.m
//  Youngcatalog
//
//  Created by honlun on 2014/7/19.
//  Copyright (c) 2014年 honlun. All rights reserved.
//

#import "DeleteAlbumViewController.h"
#import "SelectThumbnailCollectionDelegate.h"
#import "UIAlertUtil.h"

@interface DeleteAlbumViewController (){
    SelectThumbnailCollectionDelegate* selectThumbnailCollectionDelegate;
    NSMutableArray* imagePathAry;
    NSMutableArray* delAlbumAry;
}

@property (weak, nonatomic) IBOutlet UILabel *lb_title;
@property (weak, nonatomic) IBOutlet UIButton *btn_delete;
@property (weak, nonatomic) IBOutlet UICollectionView *cv_catalog;

//action
- (IBAction)clickDelete:(UIButton*)sender;
@end

@implementation DeleteAlbumViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

-(void)viewDidLoad{
    [super viewDidLoad];
    [self loadString];
    imagePathAry = [[NSMutableArray alloc]init];
    delAlbumAry = [[NSMutableArray alloc]init];
    // 顯示目錄縮圖
    selectThumbnailCollectionDelegate = [[SelectThumbnailCollectionDelegate alloc] initWithController:self collectionView:self.cv_catalog mlist:imagePathAry delList:delAlbumAry];
    self.cv_catalog.delegate = selectThumbnailCollectionDelegate;
    self.cv_catalog.dataSource = selectThumbnailCollectionDelegate;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self getAllDirectoryInfo];
}

#pragma mark - ui
-(void)loadString{
    [self setCommonText:self.lb_title text:NSLocalizedString(@"delAlbum", nil)];
}

#pragma mark - action
- (IBAction)clickDelete:(UIButton*)sender {
   [UIAlertUtil confirmWithTitle:NSLocalizedString(@"prompt", nil) andText:NSLocalizedString(@"alert_del", nil) andHandler:^(int buttonIndex) {
       if(buttonIndex==1){
           //刪除目錄
           NSMutableArray* deleteAlbumAry = [selectThumbnailCollectionDelegate getDeleteAry];
           for(int i=0; i<deleteAlbumAry.count; i++){
               NSLog(@"%d=%@", i, deleteAlbumAry[i]);
               if(((NSNumber*)[deleteAlbumAry objectAtIndex:i]).intValue==1){
                   Album* album = (Album*) [imagePathAry objectAtIndex:i];
                   id<DirectoryBusiness> directoryBiz = [BusinessGetter getDirectoryBusiness];
                   [directoryBiz deleteAlbum:album];
               }
           }
           //重取目錄列表
           [self getAllDirectoryInfo];
       }
   }];
}

#pragma mark - api
/**
 * 取得所有型錄想關資訊
 */
-(void)getAllDirectoryInfo{
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    BOOL isLogin = [userDefaults boolForKey:ISLOGIN];
    id<DirectoryBusiness> directoryBiz = [BusinessGetter getDirectoryBusiness];
    // 已登入
    if (isLogin) {
        imagePathAry = [directoryBiz getVipAlbum];
    //未登入
    }else{
        imagePathAry = [directoryBiz getIsuseAlbum];
    }
    if (imagePathAry==nil) {
        imagePathAry = [[NSMutableArray alloc]init];
    }
    delAlbumAry = [[NSMutableArray alloc]init];
    for(Album* vo in imagePathAry){
        NSLog(@"uuid:%@", vo.albumuuid);
        if(vo.isDelete.intValue==1){
            [delAlbumAry addObject:@1];
        }else{
            [delAlbumAry addObject:@0];
        }
    }
    [selectThumbnailCollectionDelegate reloadDataWithCollectionView:self.cv_catalog mlist:imagePathAry delAlbumAry:delAlbumAry];
}

#pragma mark - system
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
