//
//  CentRemoteModel.h
//  MobileTest_iPhone
//
//  Created by wolf on 12-9-11.
//  Copyright (c) 2012年 wolf. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CentRemoteModel : NSObject

@property (nonatomic) BOOL withCache;

-(id)initWithTarget:(id)target action:(SEL)action;
-(void)sendData:(id)data withExtra:(id)extra;

@end
