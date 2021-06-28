//
//  CentDataCache.m
//  MobileTest_iPhone
//
//  Created by wolf on 12-9-10.
//  Copyright (c) 2012年 wolf. All rights reserved.
//

#import "CentDataCache.h"

@interface CentDataCacheItem : NSObject

@property (strong, nonatomic) NSDate* timestamp;
@property (strong, nonatomic) NSData* data;

@end

@implementation CentDataCacheItem


@end


@interface CentDataCache ()

@property (strong, nonatomic) NSMutableDictionary* items;
@property (strong, nonatomic) NSNumber* totalSize;

- (void) removeCacheItemWithKey: (NSString* )key;
- (void) addCacheItem: (NSData* )data withKey:(NSString* )key;
- (CentDataCacheItem* ) getCacheItemWithKey: (NSString* )key;

@end


static CentDataCache* sharedInstance = nil;

@implementation CentDataCache

+ (CentDataCache* ) sharedDataCache
{
    if(sharedInstance == nil) {
        sharedInstance = [[self alloc] init];
    }
    
    return sharedInstance;
}

-(id) init
{
    self = [super init];
    
    if(self) {
        self.cacheTimeout = [NSNumber numberWithDouble:60 * 10];
        self.cacheSize = [NSNumber numberWithDouble:(50 * 1024 * 1024)];
        self.items = [NSMutableDictionary dictionary];
        self.totalSize = [NSNumber numberWithDouble:0];
    }
    
    return self;
}


- (NSData* ) getDataWithKey:(NSString* )key
{
    CentDataCacheItem* item = [self getCacheItemWithKey:key];
    
    if(item != nil) {
        return item.data;
    }
    else {
        return nil;
    }
}

- (void) setData: (NSData* )data withKey:(NSString* )key
{
    if(data && key)
        [self addCacheItem:data withKey:key];
}

- (void) removeCacheItemWithKey: (NSString* )key
{
    CentDataCacheItem* item = (CentDataCacheItem* ) [self.items objectForKey:key];
    
    if(item != nil) {
        self.totalSize = [NSNumber numberWithDouble:(self.totalSize.doubleValue - item.data.length)];
        [self.items removeObjectForKey:key];
    }

//    NSLog(@"CentDataCache removeCacheItem: %@ cache size: %@", key, self.totalSize);
}

- (void) addCacheItem: (NSData* )data withKey:(NSString* )key
{
    CentDataCacheItem* item = [self getCacheItemWithKey:key];
    
    if(item != nil) {
        [self removeCacheItemWithKey:key];
    }
    
    item = [[CentDataCacheItem alloc] init];
    
    item.timestamp = [NSDate date];
    item.data = data;
    [self.items setObject:item forKey:key];
    self.totalSize = [NSNumber numberWithDouble:(self.totalSize.doubleValue + item.data.length)];
    
    if(self.totalSize.doubleValue > self.cacheSize.doubleValue) {
        NSArray* keys = [self.items keysSortedByValueUsingComparator: ^(id obj1, id obj2) {
            CentDataCacheItem* item1 = (CentDataCacheItem* ) obj1;
            CentDataCacheItem* item2 = (CentDataCacheItem* ) obj2;
            
            return [item1.timestamp compare: item2.timestamp];
        }];
        
        for (NSString* key in keys) {
            [self removeCacheItemWithKey:key];
            
            if(self.totalSize.doubleValue < self.cacheSize.doubleValue*  0.5) {
                break;
            }
        }
    }

//    NSLog(@"entDataCache addCacheItem: %@ cache size: %@", key, self.totalSize);
}

- (CentDataCacheItem* ) getCacheItemWithKey: (NSString* )key
{
//    NSLog(@"CentDataCache getCacheItemWithKey: %@", key);
    
    CentDataCacheItem* item = (CentDataCacheItem* ) [self.items objectForKey:key];

    if(item != nil) {
        if(item.timestamp.timeIntervalSinceNow < -self.cacheTimeout.doubleValue) {
            [self removeCacheItemWithKey:key];
            item = nil;
        }
    }
    
    return item;
}

@end

