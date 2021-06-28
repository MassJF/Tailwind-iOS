//
//  CentDataCache.h
//  MobileTest_iPhone
//
//  Created by wolf on 12-9-10.
//  Copyright (c) 2012年 wolf. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CentDataCache : NSObject

+ (CentDataCache* ) sharedDataCache;

@property (strong, nonatomic) NSNumber* cacheSize;
@property (strong, nonatomic) NSNumber* cacheTimeout;

- (NSData* ) getDataWithKey:(NSString* )key;
- (void) setData: (NSData* )data withKey:(NSString* )key;

@end
