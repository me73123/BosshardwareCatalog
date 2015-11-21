//
//  BasicDao.h
//  Youngcatalog
//
//  Created by honlun on 2014/8/9.
//  Copyright (c) 2014年 honlun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppDelegate.h"

@interface BasicDao : NSObject
@property (strong,nonatomic) AppDelegate *appDelegate;
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
-(id) initWithAppDelegate;
- (NSFetchRequest *)getFetchRequest:(NSString*)tableName;
@end
