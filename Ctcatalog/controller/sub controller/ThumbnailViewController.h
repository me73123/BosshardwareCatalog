//
//  ThumbnailViewController.h
//  Youngcatalog
//
//  Created by honlun on 2014/6/28.
//  Copyright (c) 2014年 honlun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BasicViewController.h"

@interface ThumbnailViewController : BasicViewController
-(void)downloadDirectory:(Album*)vo saveZipFilePath:(NSString*)saveZipFilePath photoSavePath:(NSString*)photoSavePath;
@end
