//
//  HTTPModelUseCompletionBlok.m
//  zgxt
//
//  Created by superMa on 16/1/31.
//  Copyright © 2016年 htqh. All rights reserved.
//

#import "HTTPModelUseCompletionBlok.h"
#import "CentRemoteService.h"

@interface HTTPModelUseCompletionBlok ()

@property (copy, nonatomic) void (^completionBlock)(id data, NSError *error);

@end

@implementation HTTPModelUseCompletionBlok

+(void)HTTPModelWithBaseUrl:(NSString* )baseUrl
                   WithPath:(NSString* )getPath
                      param:(NSDictionary* )getParam
                  withCache:(BOOL)withCache
                   maxTimes:(NSInteger)times
             completionBlock:(void (^)(id responseData, NSError *error))completionBlock{
    
    HTTPModelUseCompletionBlok* model = [[HTTPModelUseCompletionBlok alloc] init];
    model.completionBlock = completionBlock;
    
    if(withCache){
        [CentRemoteService loadDataFromCacheWithBaseUrl:(NSString* )baseUrl
                                               WithPath:getPath
                                                 params:getParam
                                              getOrPost:@"POST"
                                                 target:model
                                                 action:@selector(requestResponse:)
                                               maxTimes:times];
    }else{
        [CentRemoteService loadDataWithBaseUrl:(NSString* )baseUrl
                                      WithPath:getPath
                                        params:getParam
                                     getOrPost:@"POST"
                                        target:model
                                        action:@selector(requestResponse:)
                                      maxTimes:times];
    }
}

+(void)HTTPModelWithBaseUrl:(NSString* )baseUrl
                   WithPath:(NSString* )getPath
                      param:(id)getParam
                  getOrPost:(NSString *)getOrPost
                  withCache:(BOOL)withCache
                   maxTimes:(NSInteger)times
             completionBlock:(void (^)(id responseData, NSError *error))completionBlock{
    
    HTTPModelUseCompletionBlok* model = [[HTTPModelUseCompletionBlok alloc] init];
    model.completionBlock = completionBlock;
    
    if(withCache){
        [CentRemoteService loadDataFromCacheWithBaseUrl:baseUrl
                                               WithPath:getPath
                                                 params:getParam
                                              getOrPost:getOrPost
                                                 target:model
                                                 action:@selector(requestResponse:)
                                               maxTimes:times];
    }else{
        [CentRemoteService loadDataWithBaseUrl:baseUrl
                                      WithPath:getPath
                                        params:getParam
                                     getOrPost:getOrPost
                                        target:model
                                        action:@selector(requestResponse:)
                                      maxTimes:times];
    }
}

- (void)requestResponse:(id)data
{
    if(self.completionBlock){
        if([data isKindOfClass:[NSError class]]){
            self.completionBlock(nil, data);
        }else{
            self.completionBlock(data, nil);
        }
        
    }
}

@end
