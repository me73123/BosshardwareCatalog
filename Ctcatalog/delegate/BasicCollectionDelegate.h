//
//  BasicCollectionDelegate.h
//  Youngcatalog
//
//  Created by honlun on 2014/6/28.
//  Copyright (c) 2014年 honlun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UdfConstants.h"
#import "TextUtils.h"
#import "BusinessGetter.h"

@interface BasicCollectionDelegate : NSObject <UICollectionViewDataSource, UICollectionViewDelegate>

@property(retain, nonatomic, strong) UIViewController* context;
@property(retain, nonatomic, strong) NSArray *list;
@property(retain, nonatomic, strong) NSMutableArray *mlist;
@property(retain, nonatomic, strong) UICollectionView *m_collectionView;

-(id) initWithController:(UIViewController*)context collectionView:(UICollectionView *)collectionView list:(NSArray*)mylist;
-(id) initWithController:(UIViewController*)myContext collectionView:(UICollectionView *)myCollectionView mlist:(NSMutableArray*)mylist;
/**
 *	重載資料
 *
 *	@param 	collectionView 更新資料的collectionView
 *	@param 	changeList 要更新的數據(NSMutableArray)
 */
-(void) reloadDataWithCollectionView:(UICollectionView *)collectionView list:(NSArray*)list;
/**
 *	重載資料
 *
 *	@param 	collectionView 更新資料的collectionView
 *	@param 	changeList 要更新的數據(NSMutableArray)
 */
-(void) reloadDataWithCollectionView:(UICollectionView *)collectionView mlist:(NSMutableArray*)changeList;
@end
