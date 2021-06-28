//
//  CentChartContext.h
//  MobileTest_iPhone
//
//  Created by wolf on 13-1-15.
//  Copyright (c) 2013年 wolf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CentChartTheme.h"
#import "CentChartData.h"

@interface CentChartMapping : NSObject

@property (assign, nonatomic) int index;
@property (assign, nonatomic) CGRect viewPort;
@property (assign, nonatomic) CGPoint dataRange;
@property (retain, nonatomic) CentChartTheme *theme;
@property (assign, nonatomic) double dataMinValue;
@property (assign, nonatomic) double dataMaxValue;
@property (retain, nonatomic) NSArray *hLableIndexes;
@property (nonatomic) CentChartPeriod period;

+ (CentChartMapping *) mappingWithIndex:(int)index dataRange:(CGPoint)dataRange viewPort:(CGRect)viewPort theme:(CentChartTheme *)theme period:(CentChartPeriod)period;

- (void) setDataMin:(double)min max:(double)max;
- (float) transformIndex:(double)index;
- (double) untransformIndex:(float)x;
- (float) transformValue:(double)value;
- (float) getUnitWidth;

@end
