//
//  BasicListDelegate.m
//  kokomeeting
//
//  Created by james on 13/9/5.
//  Copyright (c) 2013年 ruby. All rights reserved.
//

#import "BasicListDelegate.h"

@implementation BasicListDelegate

@synthesize context;
@synthesize list;
@synthesize m_tableView;

-(id) initWithController:(UIViewController*)myContext TableView:(UITableView *)myTableView list:(NSArray*)mylist{
    self = [super init];
    if(!self) return self;
    self.context = myContext;
    self.m_tableView = myTableView;
    self.list = mylist;
    return self;
}

-(id) initWithController:(UIViewController*)myContext TableView:(UITableView *)myTableView mlist:(NSMutableArray*)mylist{
    self = [super init];
    if(!self) return self;
    self.context = myContext;
    self.m_tableView = myTableView;
    self.mlist = mylist;
    return self;
}

//設定顯示群組數
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

//設定cell數量
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.list count];
}

/**
 *	重載資料
 *
 *	@param 	tableView 更新資料的tableView
 *	@param 	changeList 要更新的數據(NSMutableArray)
 */
-(void) reloadDataWithTableView:(UITableView *)tableView list:(NSArray*)changeList{
    self.list = changeList;
    [tableView reloadData];
}

/**
 *	重載資料
 *
 *	@param 	tableView 更新資料的tableView
 *	@param 	changeList 要更新的數據(NSMutableArray)
 */
-(void) reloadDataWithTableView:(UITableView *)tableView mlist:(NSMutableArray*)changeList{
    self.mlist = changeList;
    [tableView reloadData];
}

//回傳cell height
-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return tableView.rowHeight;
}

//去除warning用
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    return cell;
}


@end
