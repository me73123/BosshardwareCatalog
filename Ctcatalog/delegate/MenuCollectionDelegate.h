//
//  MenuCollectionDelegate.h
//  Youngcatalog
//
//  Created by honlun on 2014/6/28.
//  Copyright (c) 2014年 honlun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BasicCollectionDelegate.h"

@interface MenuCollectionDelegate : BasicCollectionDelegate 
-(id) initWithController:(UIViewController*)myContext collectionView:(UICollectionView *)myCollectionView list:(NSMutableArray*)mylist strList:(NSMutableArray*)strList;
@end
