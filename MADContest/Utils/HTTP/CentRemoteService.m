//
//  CentRemoteService.m
//  SlideOutNavi
//
//  Created by wolf on 12-9-9.
//  Copyright (c) 2012年 wolf. All rights reserved.
//

#define RETRY_COUNT 4
#define RETRY_TIME_INTERVAL 8

#import "CentRemoteService.h"
#import "CentDataCache.h"
#import "NSString+SBJSON.h"
#import "AFNetworkConfig.h"

@interface CentRemoteService ()

@property (strong, nonatomic) NSString* baseUrl;
@property (strong, nonatomic) NSString* path;
@property (strong, nonatomic) NSDictionary* params;
@property (strong, nonatomic) id target;
@property (nonatomic) SEL action;
@property (strong, nonatomic) NSMutableData* receivedData;
@property (nonatomic) NSUInteger retryCount;
@property (nonatomic) BOOL useCache;
@property (strong, nonatomic) NSString* cacheKey;
@property (strong, nonatomic) NSString *getOrPost;

@end

@implementation CentRemoteService

+ (id) serviceWithBaseUrl:(NSString* )baseUrl
                 WithPath:(NSString* )path
                   params:(id)params
                getOrPost:(NSString *)getOrPost
                   target:(id)target
                   action:(SEL)action
                 useCache:(BOOL)useCache
                 maxTimes:(NSInteger)times
{
    CentRemoteService* service = [[CentRemoteService alloc] init];

    if(service) {
        service.baseUrl = baseUrl;
        service.path = path;
        service.params = params;
        service.target = target;
        service.action = action;
        service.receivedData = [NSMutableData data];
        service.retryCount = 0;
        service.getOrPost = getOrPost;
        
        service.retryMaxTimes = times;
//        if(service.retryMaxTimes < 1) service.retryMaxTimes = 1;
        
        service.useCache = useCache;
    }
        
    return service;
}

+ (void) loadDataWithBaseUrl:(NSString* )baseUrl
                    WithPath:(NSString* )path
                      params:(id)params
                   getOrPost:(NSString *)getOrPost
                      target:(id)target
                      action:(SEL)action
                    maxTimes:(NSInteger)times
{
    CentRemoteService* service = [CentRemoteService serviceWithBaseUrl:(NSString* )baseUrl
                                                              WithPath:path
                                                                params:params
                                                             getOrPost:getOrPost
                                                                target:target
                                                                action:action
                                                              useCache:NO
                                                              maxTimes:times];

//    [service loadDataGET];
    [service loadDataPOST];
}

+ (void) loadDataFromCacheWithBaseUrl:(NSString* )baseUrl
                             WithPath:(NSString* )path
                               params:(id)params
                            getOrPost:(NSString *)getOrPost
                               target:(id)target
                               action:(SEL)action
                             maxTimes:(NSInteger)times
{
    CentRemoteService* service = [CentRemoteService serviceWithBaseUrl:(NSString* )baseUrl
                                                              WithPath:path
                                                                params:params
                                                             getOrPost:getOrPost
                                                                target:target
                                                                action:action
                                                              useCache:YES
                                                              maxTimes:times];
    
//    [service loadDataGET];
    [service loadDataPOST];
}

+(NSString* )createParamsPOST:(NSDictionary* )params{
    // Format url
    @try {
        NSMutableString* url = [NSMutableString stringWithString:@""];
        
        if(params != nil && [params count] > 0) {
            
            [params enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL* stop) {
                if([url length] != 0) {
                    [url appendString:@"&"];
                }
                NSString* param = @"";
                
                if([obj isKindOfClass:[NSString class]]){
                    param = [NSString stringWithFormat:@"%@=%@", [CentRemoteService encodeURL:key], [self encodeURL:obj]];
                }
                [url appendString:param];
            }];
        }
        return url;
        
    }
    @catch (NSException* exception) {
        NSLog(@"%@:%@", exception.name, exception.reason);
    }
}

+(NSString* )createUrlWithBaseUrl:(NSString* )baseUrl
                         WithPath:(NSString* )path
                       withParams:(NSDictionary* )params{
    // Format url
    @try {
        if(!baseUrl){
            NSLog(@"baseUrl is nil.");
            return @"baseUrl=nil";
        }
        NSMutableString* url = [NSMutableString stringWithString:baseUrl];
        
        if(path)
            [url appendString:path];
        
        if(params != nil && [params count] > 0 && [params isKindOfClass:[NSDictionary class]]) {
            [url appendString:@"?"];
            
            [params enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL* stop) {
                if([url characterAtIndex:([url length] - 1)] != '?') {
                    [url appendString:@"&"];
                }
                if([obj isKindOfClass:[NSString class]]){
                    NSString* param = [NSString stringWithFormat:@"%@=%@", [CentRemoteService encodeURL:key], [self encodeURL:obj]];
                    [url appendString:param];
                }
            }];
        }
        return url;

    }
    @catch (NSException* exception) {
        NSLog(@"%@:%@", exception.name, exception.reason);
    }
}

- (void)loadDataPOST
{
    @try {
        // Format url
        NSString* redirectUrl = [CentRemoteService createUrlWithBaseUrl:self.baseUrl WithPath:self.path withParams:self.params];
        
        self.cacheKey = redirectUrl;
        
        if(self.useCache == TRUE) {
            CentDataCache* cache = [CentDataCache sharedDataCache];
            NSData* data = [cache getDataWithKey:redirectUrl];
            
            if(data != nil) {
                
                // Parse data received
                NSString* strData = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                
                if(strData){
                    id jsonData = [strData JSONValue];
                
                    if([jsonData isKindOfClass:[NSDictionary class]]) {
                        // Inform the user
                        [self sendReceivedData:jsonData];
                        return;
                    }
                }else{
                    [self sendReceivedData:data];
                    return;
                }
                
            }
        }
        
        // Prepare request
        NSString* action = [NSString stringWithFormat:@"%@%@", self.baseUrl, self.path];
        
        AFNetworkConfig *config = [AFNetworkConfig shareAFNetWorkConfig];
        
        if(!config.AFManager || !config.requestSerializer || !config.responseSerializer){
            NSLog(@"CentRemoteService Error: Please setup AFNetworkConfig objec first.");
            [self sendReceivedData:nil];
            return;
        }
        if(![config.AFManager isKindOfClass:[AFHTTPSessionManager class]] &&
           ![config.AFManager isKindOfClass:[AFURLSessionManager class]]){
            NSLog(@"CentRemoteService Error: AFManager object is not a kind of AFHTTPSessionManager or AFURLSessionManager.");
            [self sendReceivedData:nil];
            return;
        }
        
        /*
         AFURLSessionManager:
         更加底层的请求，支持start/cancel/pause/resume操作，可以获取对应的NSURLRequest和NSURLResponse数据。
         支持 NSInputStream/NSOutputStream，提供了uploadPress和downloadProgress以方便其他使用
         
         AFHTTPSessionManager:
         在AFURLSessionManager的基础上封装了HTTP/HTTPS协议，适合简单的HTTP/HTTPS请求
         */
        AFHTTPSessionManager *manager = config.AFManager;
        
        /*request序列器
         AFHTTPRequestSerializer
         AFJSONRequestSerializer
         AFPropertyListRequestSerializer
         */
        manager.requestSerializer = config.requestSerializer;
        [manager.requestSerializer setTimeoutInterval:RETRY_TIME_INTERVAL];
        
        /*response序列解析器
         AFHTTPResponseSerializer
         AFJSONResponseSerializer
         AFImageResponseSerializer
         AFXMLParserResponseSerializer
         AFCompoundResponseSerializer
         */
        manager.responseSerializer = config.responseSerializer;
        
        //备忘
        //通常POST请求方式：
        //[manager POST: parameters: progress: success: failure:]
        //multiPart Post请求方式：
        //[manager POST: parameters: constructingBodyWithBlock: progress: success: failure:]
        
        if([self.getOrPost isEqualToString:@"GET"]){
            [manager GET:action parameters:self.params progress:^(NSProgress * _Nonnull downloadProgress) {
                
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                NSLog(@"Request URL:\n%@\n%@", task.currentRequest.URL, self.params);
                NSString* strData = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
                
                CentDataCache* cache = [CentDataCache sharedDataCache];
                [cache setData:responseObject withKey:self.cacheKey];
                
                if(strData){
                    id jsonData = [strData JSONValue];
                    
                    if(jsonData) {
                        // Inform the user
                        [self sendReceivedData:jsonData];
                    }
                    /*else {
                        [self retryPost:error];
                    }*/
                }else{
                    [self sendReceivedData:responseObject];
                }
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                NSLog(@"CentRemoteService Connection failed! Error - %@ %@", [error localizedDescription], [[error userInfo] objectForKey:NSURLErrorFailingURLStringErrorKey]);
                [self retryPost:error];
            }];
        }else{
            [manager POST:action parameters:self.params progress:^(NSProgress * _Nonnull uploadProgress) {
                
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                NSLog(@"Request URL:\n%@\n%@", task.currentRequest.URL, self.params);
                NSString* strData = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
                
                CentDataCache* cache = [CentDataCache sharedDataCache];
                [cache setData:responseObject withKey:self.cacheKey];
                
                if(strData){
                    id jsonData = [strData JSONValue];
                    
                    if(jsonData) {
                        // Inform the user
                        [self sendReceivedData:jsonData];
                    }
                    /*else {
                        [self retryPost:error];
                    }*/
                }else{
                    [self sendReceivedData:responseObject];
                }
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                NSLog(@"CentRemoteService Connection failed! Error - %@ %@", [error localizedDescription], [[error userInfo] objectForKey:NSURLErrorFailingURLStringErrorKey]);
                [self retryPost:error];
            }];
        }
        
    }
    @catch (NSException* exception) {
        NSLog(@"%@, %@", exception.name, exception.reason);
    }
    @finally {
        
    }
}

- (void)retryPost:(NSError *)error
{
    self.retryCount++;
    
    if(self.retryCount <= self.retryMaxTimes || self.retryMaxTimes < 1) {
        NSLog(@"CentRemoteService retry %@", self.path);
//        [self loadDataPOST];
        [self performSelector:@selector(loadDataPOST) withObject:nil afterDelay:RETRY_TIME_INTERVAL / 2];
    }
    else {
//        NSLog(@"CentRemoteService retry stop %@", self.path);
        [self sendReceivedData:error];
    }
}

+ (NSString* )encodeURL:(NSString* )string
{
    CFStringRef urlString = CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)string, nil, (CFStringRef)@"!*'\"();:@&=+$/?%#[]% ", kCFStringEncodingUTF8);
    return (__bridge NSString* )urlString;
}

- (void)loadDataGET
{
    @try {
        // Format url
        NSString* redirectUrl = [CentRemoteService createUrlWithBaseUrl:self.baseUrl WithPath:self.path withParams:self.params];
        
        NSLog(@"CentRemoteService GET request url: %@", redirectUrl);
        
        self.cacheKey = redirectUrl;
        
        if(self.useCache == TRUE) {
            CentDataCache* cache = [CentDataCache sharedDataCache];
            NSData* data = [cache getDataWithKey:redirectUrl];
            
            if(data != nil) {
                
                // Parse data received
                NSString* strData = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                
                if(strData){
                    id data = [strData JSONValue];
                    
                    if([data isKindOfClass:[NSDictionary class]]) {
                        // Inform the user
                        [self sendReceivedData:data];
                        return;
                    }
                }else{
                    [self sendReceivedData:data];
                    return;
                }
                
            }
        }
        
        // Prepare request
        NSURLRequest* request = [NSURLRequest requestWithURL:[NSURL URLWithString:redirectUrl] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:RETRY_TIME_INTERVAL];
//        [request setHTTPMethod:@"POST"];
        
        NSURLConnection* conn = nil;
        
        if(request) {
            conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
        }
        
        if(!conn) {
            [self sendReceivedData:nil];
        }
    }
    @catch (NSException* exception) {
        NSLog(@"%@, %@", exception.name, exception.reason);
    }
    @finally {
        
    }
    
}

- (void) retry
{
    self.retryCount++;

    if(self.retryCount <= self.retryMaxTimes || self.retryMaxTimes < 1) {
        NSLog(@"CentRemoteService retry %@", self.path);
        
        // Start retry timer
        [NSTimer scheduledTimerWithTimeInterval:RETRY_TIME_INTERVAL target:self selector:@selector(loadDataGET) userInfo:nil repeats:NO];
    }
    else {
//        NSLog(@"CentRemoteService retry stop %@", self.path);
        [self sendReceivedData:nil];
    }
}

- (void) sendReceivedData:(id)data
{
    // Call target action with data
    if(self.target != nil && self.action != nil && [self.target respondsToSelector:self.action]) {
//        [self.target performSelector:self.action withObject:data];
        [self.target performSelectorOnMainThread:self.action withObject:data waitUntilDone:NO];
    }
}

- (void)connection:(NSURLConnection* )connection didReceiveResponse:(NSURLResponse* )response
{
    // This method is called when the server has determined that it
    // has enough information to create the NSURLResponse.
    
    // It can be called multiple times, for example in the case of a
    // redirect, so each time we reset the data.
    if([(NSHTTPURLResponse* )response statusCode] == 200) {
        [self.receivedData setLength:0];
    }
    else {
        NSLog(@"CentRemoteService Connection failed! Status code - %ld", (long)[(NSHTTPURLResponse* )response statusCode]);

        // Cancel
        [connection cancel];
        

        // Retry
        [self retry];
    }
}

- (void)connection:(NSURLConnection* )connection didReceiveData:(NSData* )data
{
    // Append the new data to receivedData.
    [self.receivedData appendData:data];
}

- (void)connection:(NSURLConnection* )connection didFailWithError:(NSError* )error
{
    // Release the connection, and the data object
    
    // Retry
    [self retry];
    
    // Inform the user
    NSLog(@"CentRemoteService Connection failed! Error - %@ %@", [error localizedDescription], [[error userInfo] objectForKey:NSURLErrorFailingURLStringErrorKey]);
}

- (void)connectionDidFinishLoading:(NSURLConnection* )connection
{
    // Inform the user
//    NSLog(@"CentRemoteService Succeeded! Received %lu bytes of data - %@",(unsigned long)[self.receivedData length], self.receivedData);

    // Parse data received
    
    NSString* strData = [[NSString alloc] initWithData:self.receivedData encoding:NSUTF8StringEncoding];
    
    if(strData){
        id jsonData = [strData JSONValue];
        
        if([jsonData isKindOfClass:[NSDictionary class]]) {
            CentDataCache* cache = [CentDataCache sharedDataCache];
            
            [cache setData:self.receivedData withKey:self.cacheKey];
            
            // Inform the user
            [self sendReceivedData:jsonData];
        }
        else {
            [self retry];
        }
    }else{
        NSData* data = [[NSData alloc] initWithData:self.receivedData];
        [self sendReceivedData:data];
    }
    // Release the connection
}

- (void) dealloc
{
    self.baseUrl = nil;
    self.path = nil;
    self.params = nil;
    self.target = nil;
    self.action = NULL;
    self.receivedData = nil;
    self.cacheKey = nil;
}

@end
