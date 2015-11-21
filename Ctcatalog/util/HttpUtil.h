//
//  HttpUtil.h
//  kokomeeting
//
//  Created by james on 13/8/12.
//  Copyright (c) 2013年 ruby. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HttpPostException.h"

@interface HttpUtil : NSObject

//+(NSString *)setHttpPost:(NSString*)path httpBodyString:(NSString *)httpBodyString;

//+(void)setAsyncHttpPostJSON:(NSString*)path httpBodyString:(NSString *)httpBodyString completionHandler:(void (^)(NSURLResponse*, NSData*, NSError*))handler;

-(void)setProgressHandler:(void (^)(double))handler;

-(void)sendHttpPostJSON:(NSString*)path httpBodyString:(NSString *)httpBodyString completionHandler:(void (^)(NSURLResponse*, NSData*, NSError*))handler;

-(void)sendHttpPostDownload:(NSString*)path httpBodyString:(NSString *)httpBodyString completionHandler:(void (^)(NSURLResponse*, NSData*, NSError*))handler;
//+(void)setAsyncHttpPostNonJson:(NSString*)path httpBodyString:(NSString *)httpBodyString completionHandler:(void (^)(NSURLResponse*, NSData*, NSError*))handler;

-(void)sendHTTPPostUpload:(NSString*)path stringParams:(NSDictionary *)params thumbnailImage:(UIImage*) thumbnailImage originImage:(UIImage*) originImage completionHandler:(void (^)(NSURLResponse*, NSData*, NSError*))handler;

-(void)sendHTTPPostUpload:(NSString*)path stringParams:(NSDictionary *)params recorder:(NSString*) recorderFilePath completionHandler:(void (^)(NSURLResponse*, NSData*, NSError*))handler;

-(void)sendHttpGet:(NSString*)path completionHandler:(void (^)(NSURLResponse*, NSData*, NSError*))handler;


@end
