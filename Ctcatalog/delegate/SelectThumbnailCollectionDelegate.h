//
//  SelectThumbnailCollectionDelegate.h
//  Youngcatalog
//
//  Created by honlun on 2014/8/16.
//  Copyright (c) 2014年 honlun. All rights reserved.
//

#import "BasicCollectionDelegate.h"

@interface SelectThumbnailCollectionDelegate : BasicCollectionDelegate
-(id) initWithController:(UIViewController*)myContext collectionView:(UICollectionView *)myCollectionView mlist:(NSMutableArray*)mylist delList:(NSMutableArray*)delList;
-(NSMutableArray*) getDeleteAry;
-(void) reloadDataWithCollectionView:(UICollectionView *)collectionView mlist:(NSMutableArray*)changeList delAlbumAry:(NSMutableArray*)delAlbumAry;
@end
