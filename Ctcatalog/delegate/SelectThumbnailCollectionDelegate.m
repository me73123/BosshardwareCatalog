//
//  SelectThumbnailCollectionDelegate.m
//  Youngcatalog
//
//  Created by honlun on 2014/8/16.
//  Copyright (c) 2014年 honlun. All rights reserved.
//

#import "SelectThumbnailCollectionDelegate.h"
#import "Album.h"

@implementation SelectThumbnailCollectionDelegate{
    NSMutableArray* deleteList;
}
-(id) initWithController:(UIViewController*)myContext collectionView:(UICollectionView *)myCollectionView mlist:(NSMutableArray*)mylist delList:(NSMutableArray*)delList{
    self = [super initWithController:myContext collectionView:myCollectionView mlist:mylist];
    if(!self) return self;
    deleteList = delList;
    return self;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SelectCatalogCell" forIndexPath:indexPath];
    
    Album* vo = [self.mlist objectAtIndex:indexPath.row];
    
    UIImageView* imgv_catalog = (UIImageView*) [cell viewWithTag:101];
    UIImageView* imgv_vip_catalog = (UIImageView*) [cell viewWithTag:105];
    UIButton* btn_select = (UIButton*) [cell viewWithTag:102];
    UILabel* lb_title = (UILabel*) [cell viewWithTag:103];
    UILabel* lb_delete = (UILabel*) [cell viewWithTag:104];
    
    //封面圖片
    if(![TextUtils isEmpty:vo.albumPhotoSavePath]){
        imgv_catalog.image = [[UIImage alloc] initWithContentsOfFile:vo.albumPhotoSavePath];
    }else{
        //封面下載失敗或尚未下載
        imgv_catalog.image = [UIImage imageNamed:@"download_failed.png"];
    }
    
    //vip catalog
    if(vo.isUse!=nil && vo.isUse.intValue==2){
        imgv_vip_catalog.hidden = NO;
    }else{
        imgv_vip_catalog.hidden = YES;
    }
    
    //選取圖示
    lb_delete.text = NSLocalizedString(@"isdelete", nil);
    if(vo.isDelete.intValue == 1){  //選取
        [btn_select setImage:[UIImage imageNamed:@"select.png"] forState:UIControlStateNormal];
        lb_delete.hidden = NO;
    }else{
        [btn_select setImage:[UIImage imageNamed:@"select1.png"] forState:UIControlStateNormal];
        lb_delete.hidden = YES;
    }
    
    //文字
    lb_title.text = vo.albumTitle;
    
    //註冊event
    [btn_select addTarget:self action:@selector(clickSelect:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}

-(void)clickSelect:(UIButton*)sender{
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.m_collectionView];
    NSIndexPath *indexPath = [self.m_collectionView indexPathForItemAtPoint:buttonPosition];
    NSLog(@"clickSelect position:%ld", (long)indexPath.row);
    
    Album* vo = [self.mlist objectAtIndex:indexPath.row];
    UICollectionViewCell *cell = (UICollectionViewCell*) sender.superview;
    UILabel* lb_delete = (UILabel*) [cell viewWithTag:104];
    UIImage* image;
    if(vo.isDelete.intValue == 0){
        //選取
        [self setAlbumIsdelete:vo position:indexPath.row isdelete:YES];
        image = [UIImage imageNamed:@"select.png"];
        lb_delete.hidden = NO;
    }else{
        //取消選取
        [self setAlbumIsdelete:vo position:indexPath.row isdelete:NO];
        image = [UIImage imageNamed:@"select1.png"];
        lb_delete.hidden = YES;
    }
    [sender setImage:image forState:UIControlStateNormal];
    [self.m_collectionView reloadData];
}

-(void)setAlbumIsdelete:(Album*) album position:(NSInteger)position isdelete:(BOOL)isdelete{
    @synchronized (self) {
        Album* vo = [self.mlist objectAtIndex:position];
        //隱藏目錄
        id<DirectoryBusiness> directoryBiz = [BusinessGetter getDirectoryBusiness];
        if (isdelete) {
            //把目前物件status改變
            vo.isDelete = @1;
            [deleteList replaceObjectAtIndex:position withObject:@1];
            //更新ＤＢ
            [directoryBiz updateIsDelete:vo.albumuuid isdelete:@1];
        } else {
            //把目前物件status改變
            vo.isDelete = @0;
            [deleteList replaceObjectAtIndex:position withObject:@0];
            //更新ＤＢ
            [directoryBiz updateIsDelete:vo.albumuuid isdelete:@0];
        }
    }
}

-(NSMutableArray*) getDeleteAry{
    return deleteList;
}

-(void) reloadDataWithCollectionView:(UICollectionView *)collectionView mlist:(NSMutableArray*)changeList delAlbumAry:(NSMutableArray*)delAlbumAry{
    self.mlist = changeList;
    deleteList = delAlbumAry;
    [collectionView reloadData];
}

@end
