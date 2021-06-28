//
//  CentRemoteService.h
//  SlideOutNavi
//
//  Created by wolf on 12-9-9.
//  Copyright (c) 2012年 wolf. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface CentRemoteService : NSObject

@property (nonatomic) NSInteger retryMaxTimes;

+(NSString* )createUrlWithBaseUrl:(NSString* )baseUrl
                         WithPath:(NSString* )path
                       withParams:(NSDictionary* )params;

+(void)loadDataWithBaseUrl:(NSString* )baseUrl
                  WithPath:(NSString* )path
                    params:(NSDictionary* )params
                 getOrPost:(NSString *)getOrPost
                    target:(id)target
                    action:(SEL)action
                  maxTimes:(NSInteger)times;

+(void)loadDataFromCacheWithBaseUrl:(NSString* )baseUrl
                           WithPath:(NSString* )path
                             params:(NSDictionary* )params
                          getOrPost:(NSString *)getOrPost
                             target:(id)target
                             action:(SEL)action
                           maxTimes:(NSInteger)times;


@end
