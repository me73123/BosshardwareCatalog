//
//  BasicCollectionDelegate.m
//  Youngcatalog
//
//  Created by honlun on 2014/6/28.
//  Copyright (c) 2014年 honlun. All rights reserved.
//

#import "BasicCollectionDelegate.h"

@implementation BasicCollectionDelegate
-(id) initWithController:(UIViewController*)myContext collectionView:(UICollectionView *)myCollectionView list:(NSArray*)mylist{
    self = [super init];
    if(!self) return self;
    self.context = myContext;
    self.m_collectionView = myCollectionView;
    self.list = mylist;
    return self;
}

-(id) initWithController:(UIViewController*)myContext collectionView:(UICollectionView *)myCollectionView mlist:(NSMutableArray*)mylist{
    self = [super init];
    if(!self) return self;
    self.context = myContext;
    self.m_collectionView = myCollectionView;
    self.mlist = mylist;
    return self;
}

//一個Sections有幾個cell
- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section{
    if(self.list==nil){
        return [self.mlist count];
    }else{
        return [self.list count];
    }
}

//有幾個Sections(群組)
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell;
    return cell;
}

-(void) reloadDataWithCollectionView:(UICollectionView *)collectionView list:(NSArray*)changeList{
    self.list = changeList;
    [collectionView reloadData];
}

-(void) reloadDataWithCollectionView:(UICollectionView *)collectionView mlist:(NSMutableArray*)changeList{
    self.mlist = changeList;
    [collectionView reloadData];
}
@end
