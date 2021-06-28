//
//  NSSaftyDictionary.h
//  zgxt
//
//  Created by superMa on 15/11/20.
//  Copyright © 2015年 htqh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (SaftyDictionary)

- (id)objectForKeySafty:(id)aKey;
- (id)valueForKeySafty:(NSString* )key;

@end

@interface NSMutableDictionary (SaftyMutableDictionary)

-(void)setObjectSafty:(id)obj forKey:(id<NSCopying>)key;

@end

@interface NSArray (SaftyArray)

-(id)objectAtIndexSafty:(NSUInteger)index;

@end
