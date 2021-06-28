//
//  NSSaftyDictionary.m
//  zgxt
//
//  Created by superMa on 15/11/20.
//  Copyright © 2015年 htqh. All rights reserved.
//

#import "SaftyDictionary.h"

@implementation NSDictionary (SaftyDictionary)

- (id)objectForKeySafty:(id)aKey{
    id object = [self objectForKey:aKey];
    
    if([object isEqual:[NSNull null]]){
        object = nil;
    }
    return object;
}

- (id)valueForKeySafty:(NSString*)key{
    id object = [self valueForKey:key];
    
    if([object isEqual:[NSNull null]]){
        object = nil;
    }
    return object;
}

@end

@implementation NSMutableDictionary (SaftyMutableDictionary)

-(void)setObjectSafty:(id)obj forKey:(id<NSCopying>)key{
    if(obj && key){
        [self setObject:obj forKey:key];
    }
}

@end

@implementation NSArray (SaftyArray)

-(id)objectAtIndexSafty:(NSUInteger)index{
    if(index > -1.0f && index < [self count]){
        return [self objectAtIndex:index];
    }else
        return nil;
}

@end
