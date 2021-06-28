//
//  CentRemoteModel.m
//  MobileTest_iPhone
//
//  Created by wolf on 12-9-11.
//  Copyright (c) 2012年 wolf. All rights reserved.
//

#import "CentRemoteModel.h"

@interface CentRemoteModel()

@property (strong, nonatomic) id target;
@property (nonatomic) SEL action;

@end


@implementation CentRemoteModel

-(id)initWithTarget:(id)target action:(SEL)action
{
    self = [super init];
    
    if(self) {
        self.target = target;
        self.action = action;
        self.withCache = NO;
    }
    
    return self;
}

-(void)dealloc
{
//    NSLog(@"CentRemoteModel dealloc");
    
    self.target = nil;
    self.action = NULL;
    
}

-(void)sendData:(id)data withExtra:(id)extra
{
    // Call target action with data
    if(self.target != nil && self.action != nil && [self.target respondsToSelector:self.action]) {
//        [self.target performSelector:self.action withObject:data withObject:extra];
        [self.target performSelectorOnMainThread:self.action withObject:data waitUntilDone:NO];
    }
}

@end
