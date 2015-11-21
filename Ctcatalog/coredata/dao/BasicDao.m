//
//  BasicDao.m
//  Youngcatalog
//
//  Created by honlun on 2014/8/9.
//  Copyright (c) 2014年 honlun. All rights reserved.
//

#import "BasicDao.h"

@implementation BasicDao
-(id) initWithAppDelegate{
    self = [super init];
    self.appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    self.managedObjectContext = [self.appDelegate managedObjectContext];
    return self;
}

#pragma mark - 取得NSFetchRequest
- (NSFetchRequest *)getFetchRequest:(NSString*)tableName {
    NSEntityDescription *entity = [NSEntityDescription entityForName:tableName inManagedObjectContext:self.managedObjectContext];  //取出Entity
    NSFetchRequest *frq = [[NSFetchRequest alloc] init];
    [frq setEntity:entity];  //將Entity存入NSFetchRequest
    [frq setReturnsObjectsAsFaults:NO];
    return frq;
}
@end
