//
//  CentChartView.h
//  MobileTest_iPhone
//
//  Created by wolf on 13-1-15.
//  Copyright (c) 2013年 wolf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CentChartMapping.h"
#import "CentChartTheme.h"

@interface CentChartView : NSObject

@property (nonatomic) int index;
@property (nonatomic) BOOL drawAxisBoard;
@property (retain, nonatomic) NSArray *techList;
@property (assign, nonatomic) CentChartPeriod period;

- (void) prepareData:(NSArray *)data;
- (void) drawWithContext:(CGContextRef)context mapping:(CentChartMapping *)mapping;

@end
