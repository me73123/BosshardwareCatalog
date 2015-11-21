//
//  NewsListDelegate.h
//  Youngcatalog
//
//  Created by honlun on 2014/8/16.
//  Copyright (c) 2014年 honlun. All rights reserved.
//

#import "BasicListDelegate.h"

@interface NewsListDelegate : BasicListDelegate
-(id) initWithController:(UIViewController*)myContext TableView:(UITableView *)myTableView list:(NSArray*)mylist;
@end
