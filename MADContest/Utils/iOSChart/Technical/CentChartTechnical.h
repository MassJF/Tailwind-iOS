//
//  CentChartTechnical.h
//  MobileTest_iPhone
//
//  Created by wolf on 13-1-15.
//  Copyright (c) 2013年 wolf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CentChartTheme.h"
#import "CentChartMapping.h"
#import "CentChartColorLabel.h"
#import "CentChartDataLabel.h"

@class CentChartTheme;

@interface CentChartTechnical : NSObject

- (void) prepareData:(NSArray *)data;
- (void) getDataMin:(double *)min max:(double *)max mapping:(CentChartMapping *)mapping;
- (void) drawWithContext:(CGContextRef)context mapping:(CentChartMapping *)mapping;
- (NSArray *) getColorLabels:(CentChartTheme *)theme;
- (NSArray *) getDataLabels:(int)index;
-(double)getCrossPointValue:(NSInteger)index;

@end
