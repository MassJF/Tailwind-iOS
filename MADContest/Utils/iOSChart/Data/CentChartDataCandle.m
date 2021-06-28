//
//  CentChartDataCandle.m
//  MobileTest_iPhone
//
//  Created by wolf on 13-1-15.
//  Copyright (c) 2013年 wolf. All rights reserved.
//

#import "CentChartDataCandle.h"

@implementation CentChartDataCandle

-(id)init{
    self = [super init];
    if(self){
        self.signalType = nil;
        self.balance = NAN;
        self.totleBalance = NAN;
        self.invalid = NO;
    }
    return self;
}

@end
