//
//  HttpUtil.m
//  kokomeeting
//
//  Created by james on 13/8/12.
//  Copyright (c) 2013年 ruby. All rights reserved.
//

#import "HttpUtil.h"
#import "AppDelegate.h"
#import "UdfConstants.h"

static int maxTimeOut = 10;  //等待連線逾時時間

//static NSString* httpJSessionid = nil;

@implementation HttpUtil {
    NSURLResponse* httpResponse;
    NSMutableData *httpResponseData;
    NSError* httpError;
    id delegate;
    void (^httpResponseHandler)(NSURLResponse*, NSData*, NSError*);
    void (^progressHandler)(double);
    BOOL isJson;
    long contentSize;
    
    NSString* pathLog;
    NSString* httpBodyLog;
    NSString* receivedJsessionIDLog;
}

#pragma mark - instanse functions

-(void)setProgressHandler:(void (^)(double))handler {
    progressHandler = handler;
}

-(void)sendHttpPostJSON:(NSString*)path httpBodyString:(NSString *)httpBodyString completionHandler:(void (^)(NSURLResponse*, NSData*, NSError*))handler {
    
    NSLog(@"HttpPostJSON,path=%@\nhttpBodyString=%@",path,httpBodyString);
    pathLog = path;
    httpBodyLog = httpBodyString;
    
    isJson = YES;
    
    httpResponseHandler = handler;
    
    NSString* httppath = [NSString stringWithFormat:@"http://%@%@",SERVER_URL, path];
    NSURL *requestUrl = [NSURL URLWithString:httppath];
        
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:requestUrl];
    [request setValue:@10 forKey:@"timeoutInterval"];
    
    //設定header
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:[UdfConstants getUserAgent] forHTTPHeaderField:@"User-Agent"];
    
    [request setHTTPMethod:@"POST"];
    
    [request setHTTPBody:[httpBodyString dataUsingEncoding:NSUTF8StringEncoding]];

    NSURLConnection* conn = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:NO];
    [conn scheduleInRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
    [conn start];
}

-(void)sendHttpPostDownload:(NSString*)path httpBodyString:(NSString *)httpBodyString completionHandler:(void (^)(NSURLResponse*, NSData*, NSError*))handler {

    NSLog(@"HttpPostJSON,path=%@\nhttpBodyString=%@",path,httpBodyString);
    pathLog = path;
    httpBodyLog = httpBodyString;
    isJson = NO;
    
    httpResponseHandler = handler;

    NSString* httppath = [NSString stringWithFormat:@"http://%@", path];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    NSURL *connection = [[NSURL alloc] initWithString:httppath];

    [request setURL:connection];
    [request setValue:[NSNumber numberWithInt:maxTimeOut] forKey:@"timeoutInterval"];

    //設定header
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setValue:[UdfConstants getUserAgent] forHTTPHeaderField:@"User-Agent"];

    //設定連線方式
    [request setHTTPMethod:@"POST"];

    //將編碼改為UTF8
    NSData* postdata = [httpBodyString dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:postdata];

    [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[postdata length]]
            forHTTPHeaderField:@"Content-Length"];

    NSURLConnection* conn = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:NO];
    [conn scheduleInRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
    [conn start];
}


-(void)sendHTTPPostUpload:(NSString*)path stringParams:(NSDictionary *)params thumbnailImage:(UIImage*) thumbnailImage originImage:(UIImage*) originImage completionHandler:(void (^)(NSURLResponse*, NSData*, NSError*))handler {
    
    NSLog(@"HttpPostJSON,path=%@\nparams=%@--",path,params);
    pathLog = path;
    httpBodyLog = [NSString stringWithFormat:@"%@",params];
    isJson = NO;
    
    httpResponseHandler = handler;
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
    [request setHTTPShouldHandleCookies:NO];
    
    NSString* httppath = [NSString stringWithFormat:@"http://%@%@",SERVER_URL, path];
    NSURL *connection = [[NSURL alloc] initWithString:httppath];
    [request setURL:connection];
    [request setValue:[NSNumber numberWithInt:maxTimeOut] forKey:@"timeoutInterval"];
    
    //設定header
    // set Content-Type in HTTP header
    
    NSString* boundary = @"d29a0c638b540b23e9a29a3a9aebc900aeeb6a82";
    
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
    [request setValue:contentType forHTTPHeaderField: @"Content-Type"];
    [request setValue:[UdfConstants getUserAgent] forHTTPHeaderField:@"User-Agent"];
    
    //設定連線方式
    [request setHTTPMethod:@"POST"];
    
    // post body
    NSMutableData *postdata = [NSMutableData data];
    
    // add params (all params are strings)
    for (NSString *param in params) {
        [postdata appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [postdata appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", param] dataUsingEncoding:NSUTF8StringEncoding]];
        [postdata appendData:[[NSString stringWithFormat:@"%@\r\n", [params objectForKey:param]] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    NSData* imageData;
    
    // add image data (當snapchat時不需上傳縮圖，thumbnailImage會是nil, 跳過不處理)
    if(thumbnailImage != nil) {
        imageData = UIImageJPEGRepresentation(thumbnailImage, 1.0);
        if (imageData) {
            [postdata appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [postdata appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"thumbnaiiImage.jpg\"\r\n", @"uploadedfile1"] dataUsingEncoding:NSUTF8StringEncoding]];
            [postdata appendData:[@"Content-Type: image/jpeg\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
            [postdata appendData:imageData];
            [postdata appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        }
    }
    
    // add image data
    imageData = UIImageJPEGRepresentation(originImage, 0.8);  //壓縮 80%
    NSLog(@"imageData size:%lu", (unsigned long)imageData.length);
    if (imageData) {
        [postdata appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [postdata appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"originimage.jpg\"\r\n", @"uploadedfile2"] dataUsingEncoding:NSUTF8StringEncoding]];
        [postdata appendData:[@"Content-Type: image/jpeg\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [postdata appendData:imageData];
        [postdata appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    
    [postdata appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    [request setHTTPBody:postdata];
    
    [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[postdata length]]
   forHTTPHeaderField:@"Content-Length"];
  
    NSURLConnection* conn = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:NO];
    [conn scheduleInRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
    [conn start];
    
}

-(void)sendHTTPPostUpload:(NSString*)path stringParams:(NSDictionary *)params recorder:(NSString*) recorderFilePath completionHandler:(void (^)(NSURLResponse*, NSData*, NSError*))handler {
    
    NSLog(@"HttpPostJSON,path=%@\nparams=%@---",path,params);
    pathLog = path;
    httpBodyLog = [NSString stringWithFormat:@"%@",params];
    isJson = NO;
    
    httpResponseHandler = handler;
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
    [request setHTTPShouldHandleCookies:NO];
    
    NSString* httppath = [NSString stringWithFormat:@"http://%@%@",SERVER_URL, path];
    NSURL *connection = [[NSURL alloc] initWithString:httppath];
    [request setURL:connection];
    [request setValue:[NSNumber numberWithInt:maxTimeOut] forKey:@"timeoutInterval"];
    
    //設定header
    // set Content-Type in HTTP header
    NSString* boundary = @"d29a0c638b540b23e9a29a3a9aebc900aeeb6a82";
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
    [request setValue:contentType forHTTPHeaderField: @"Content-Type"];
    [request setValue:[UdfConstants getUserAgent] forHTTPHeaderField:@"User-Agent"];
    
    //設定連線方式
    [request setHTTPMethod:@"POST"];
    
    // post body
    NSMutableData *postdata = [NSMutableData data];
    
    // add params (all params are strings)
    for (NSString *param in params) {
        [postdata appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [postdata appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", param] dataUsingEncoding:NSUTF8StringEncoding]];
        [postdata appendData:[[NSString stringWithFormat:@"%@\r\n", [params objectForKey:param]] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    NSData* recorderData;
    
    // add recorder
    if(recorderFilePath != nil) {
        recorderData = [[NSData alloc] initWithContentsOfFile:recorderFilePath];
        if (recorderData) {
            [postdata appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [postdata appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"recorder.m4a\"\r\n", @"uploadedfile2"] dataUsingEncoding:NSUTF8StringEncoding]];
            [postdata appendData:[@"Content-Type: audio/m4a\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
            [postdata appendData:recorderData];
            [postdata appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        }
    }
    
    [postdata appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    [request setHTTPBody:postdata];
    
    [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[postdata length]]
   forHTTPHeaderField:@"Content-Length"];
    
    NSURLConnection* conn = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:NO];
    [conn scheduleInRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
    [conn start];
}

-(void)sendHttpGet:(NSString*)path completionHandler:(void (^)(NSURLResponse*, NSData*, NSError*))handler {
    
}

#pragma mark - delegates

// 開始接收資料，會呼叫此方法

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    //response
    
    
    NSHTTPURLResponse* httpRes = (NSHTTPURLResponse*) response;
    receivedJsessionIDLog = nil;
    if([httpRes respondsToSelector:@selector(allHeaderFields)]) {
        NSDictionary * dic = [httpRes allHeaderFields];
        //NSLog(@"dic=%@",dic);
        receivedJsessionIDLog = [dic objectForKey:@"Set-Cookie"];
        //NSLog(@"jsessionid=%@", jsessionid);
    }
    NSLog(@"didReceiveResponse,path=%@\nreceivedJSessionid=%@",pathLog,receivedJsessionIDLog);
    
    
    httpResponseData = [[NSMutableData alloc] init];
    [httpResponseData setLength:0];
    
    httpResponse = response;
    contentSize = [httpResponse expectedContentLength];
}

// 接收新的資料時，會呼叫此方法

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    //NSLog(@"didReceiveData:%d",[data length]);
    [httpResponseData appendData:data];
    if(progressHandler != nil) {
        progressHandler(httpResponseData.length);
    }
}

// 下載完畢時，會呼叫此方法

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSLog(@"connectionDidFinishLoading,path=%@\nreceivedJSessionid=%@",pathLog,receivedJsessionIDLog);
    
    // 轉譯編碼文字
    
    if(isJson == YES) {
        NSString *responseString = [[NSString alloc] initWithData:httpResponseData encoding:NSUTF8StringEncoding];
        NSLog(@"connectionDidFinishLoading,responseString=%@",responseString);
        NSError* e;
        NSDictionary* dict = [NSJSONSerialization JSONObjectWithData:[responseString dataUsingEncoding:NSUTF8StringEncoding ] options:NSJSONReadingMutableContainers error:&e];//[message toDictionary];
        if(e == nil) {
            NSString* resultcode = [dict objectForKey:@"resultcode"];
            NSLog(@"connectionDidFinishLoading,resultcode=%@",resultcode);
        }
        else {
            NSLog(@"connectionDidFinishLoading, json error:%@",e);
        }
    }
    if(httpResponseHandler != nil) {
        httpResponseHandler(httpResponse, httpResponseData, nil);
    }
}

// 連線錯誤時，會呼叫此方法

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSLog(@"didFailWithError,path=%@\nhttpBodyString=%@\nreceivedJSessionid=%@",pathLog,httpBodyLog,receivedJsessionIDLog);
    if(httpResponseHandler != nil) {
        httpResponseHandler(httpResponse, nil, error);
    }
}

//http://stackoverflow.com/questions/933331/how-to-use-nsurlconnection-to-connect-with-ssl-for-an-untrusted-cert

- (BOOL)connection:(NSURLConnection *)connection canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace {
    return [protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust];
}

- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
    if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust])
        //        if ([trustedHosts containsObject:challenge.protectionSpace.host])
        [challenge.sender useCredential:[NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust] forAuthenticationChallenge:challenge];
    
    [challenge.sender continueWithoutCredentialForAuthenticationChallenge:challenge];
}

@end
