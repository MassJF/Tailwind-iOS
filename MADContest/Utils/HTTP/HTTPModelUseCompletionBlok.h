//
//  HTTPModelUseCompletionBlok.h
//  zgxt
//
//  Created by superMa on 16/1/31.
//  Copyright © 2016年 htqh. All rights reserved.
//

#import "CentRemoteModel.h"


@interface HTTPModelUseCompletionBlok : CentRemoteModel

//+(void)HTTPModelWithPath:(NSString* )getPath
//                   param:(NSDictionary* )getParam
//               withCache:(BOOL)withCache
//                maxTimes:(NSInteger)times
//          completionBlock:(void (^)(id responseData))completionBlock;

+(void)HTTPModelWithBaseUrl:(NSString* )baseUrl
                   WithPath:(NSString* )getPath
                      param:(id)getParam
                  getOrPost:(NSString *)getOrPost
                  withCache:(BOOL)withCache
                   maxTimes:(NSInteger)times
             completionBlock:(void (^)(id responseData, NSError *error))completionBlock;

+(void)HTTPModelWithBaseUrl:(NSString* )baseUrl
                   WithPath:(NSString* )getPath
                      param:(id)getParam
                  withCache:(BOOL)withCache
                   maxTimes:(NSInteger)times
             completionBlock:(void (^)(id responseData, NSError *error))completionBlock;


@end
