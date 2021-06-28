//
//  CentChartUtil.h
//  MobileTest_iPhone
//
//  Created by wolf on 13-1-15.
//  Copyright (c) 2013年 wolf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CentChart.h"

@interface CentChartUtil : NSObject

+ (NSString *) getHLabelFormat:(CentChartPeriod)period;
+ (NSArray *) getOptimizedPointsWithMin:(double)min max:(double)max count:(int)count precision:(int)precision;
+ (NSString *) bigNumberFormat:(double)value;
+ (int)getPrecisionWithViewIndex:(int)viewIndex withPreios:(CentChartPeriod)period;
+ (int)getAxisCountWithViewIndex:(int)viewIndex withViewHeight:(CGFloat)height;

@end
