//
//  ThumbnailCollectionDelegate.h
//  Youngcatalog
//
//  Created by honlun on 2014/8/16.
//  Copyright (c) 2014年 honlun. All rights reserved.
//

#import "BasicCollectionDelegate.h"

@class LoadingViewController;
@interface ThumbnailCollectionDelegate : BasicCollectionDelegate
-(id) initWithController:(UIViewController*)myContext collectionView:(UICollectionView *)myCollectionView mlist:(NSMutableArray*)mylist loadingCtrl:(LoadingViewController*)myLoadingCtrl;
@end
