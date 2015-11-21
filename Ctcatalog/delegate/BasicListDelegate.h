//
//  BasicListDelegate.h
//  kokomeeting
//
//  Created by james on 13/9/5.
//  Copyright (c) 2013年 ruby. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UdfConstants.h"
#import "TextUtils.h"

@interface BasicListDelegate : NSObject  <UITableViewDelegate, UITableViewDataSource>

@property(retain, nonatomic, strong) UIViewController* context;
@property(retain, nonatomic, strong) NSMutableArray *mlist;
@property(retain, nonatomic, strong) NSArray *list;
@property(retain, nonatomic, strong) UITableView *m_tableView;

-(id) initWithController:(UIViewController*)context TableView:(UITableView *)tableView list:(NSArray*)mylist;
-(id) initWithController:(UIViewController*)context TableView:(UITableView *)tableView mlist:(NSMutableArray*)mylist;

/**
 *	重載資料
 *
 *	@param 	tableView 更新資料的tableView
 *	@param 	changeList 要更新的數據(NSArray)
 */
-(void) reloadDataWithTableView:(UITableView *)tableView list:(NSArray*)list;
/**
 *	重載資料
 *
 *	@param 	tableView 更新資料的tableView
 *	@param 	changeList 要更新的數據(NSMutableArray)
 */
-(void) reloadDataWithTableView:(UITableView *)tableView mlist:(NSMutableArray*)changeList;

@end
