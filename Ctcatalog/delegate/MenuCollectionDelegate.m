//
//  MenuCollectionDelegate.m
//  Youngcatalog
//
//  Created by honlun on 2014/6/28.
//  Copyright (c) 2014年 honlun. All rights reserved.
//

#import "MenuCollectionDelegate.h"
#import "MainViewController.h"

@implementation MenuCollectionDelegate{
    NSMutableArray* menuStrAry;
}
-(id) initWithController:(UIViewController*)myContext collectionView:(UICollectionView *)myCollectionView list:(NSMutableArray*)mylist strList:(NSMutableArray*)strList{
    self = [super initWithController:myContext collectionView:myCollectionView mlist:mylist];
    if(!self) return self;
    menuStrAry = strList;
    return self;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MenuCell" forIndexPath:indexPath];
    
    UIImageView* imgv_item = (UIImageView*) [cell viewWithTag:101];
    UILabel* lb_itemStr = (UILabel*) [cell viewWithTag:102];
    
    imgv_item.image = [self.mlist objectAtIndex:indexPath.row];
    lb_itemStr.text = [menuStrAry objectAtIndex:indexPath.row];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"MenuCell: %li,%li",(long)[indexPath section],(long)[indexPath row]);
    switch (indexPath.row) {
            //更新目錄
        case UPDATE_CELL:
        {
            [((MainViewController*)self.context) changeViewCtrl:UPDATE_CELL];
        }
            break;
            //刪除目錄
        case DELETE_CELL:
        {
            [((MainViewController*)self.context) changeViewCtrl:DELETE_CELL];
        }
            break;
            //影片
        case MOVIE_CELL:
        {
            [((MainViewController*)self.context) changeViewCtrl:MOVIE_CELL];
        }
            break;
            //vip
        case VIP_CELL:
        {
            [((MainViewController*)self.context) changeViewCtrl:VIP_CELL];
        }
            break;
//            //離開程式
//        case EXIT_CELL:
//        {
//            [((MainViewController*)self.context) changeViewCtrl:EXIT_CELL];
//        }
//            break;
        default:
            break;
    }
}

@end
