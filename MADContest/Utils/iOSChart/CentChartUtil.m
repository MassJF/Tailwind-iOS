//
//  CentChartUtil.m
//  MobileTest_iPhone
//
//  Created by wolf on 13-1-15.
//  Copyright (c) 2013年 wolf. All rights reserved.
//

#import "CentChartUtil.h"

@implementation CentChartUtil

+ (int)getPrecisionWithViewIndex:(int)viewIndex withPreios:(CentChartPeriod)period{
    int precision = viewIndex > 0 ? 2 : 4;
    
    if(viewIndex == 0) {
        // IF /JPY
//        NSUInteger index = [self.pair length] - [@"JPY" length];
//        if([[self.pair substringFromIndex:index] isEqualToString:@"JPY"]){
//            precision = 3;
//        }
//        else {
//            precision = 5;
//        }
        if(period == CentChartStyleJingZhiZouShi){
            precision = 4;
        }else if (period == CentChartStyleYueJiDuShouYiLv){
            precision = 2;
        }
    }
    else {
        precision = 2;
    }
    return precision;
}

+ (int)getAxisCountWithViewIndex:(int)viewIndex withViewHeight:(CGFloat)height{
    
    int topViewVaxisCount = height / 35;
    
    if(topViewVaxisCount % 2 == 0){
        topViewVaxisCount++;
    }
    
    int vaxisCount = viewIndex > 0 ? 3 : topViewVaxisCount;
//    int vaxisCount = self.index > 0 ? 3 : 5;
    return vaxisCount;
}

+ (NSString *) getHLabelFormat:(CentChartPeriod)period
{
    NSString *fmt = @"yyyy/MM/dd HH:mm:ss";
    
    switch(period) {
        case CentChartPeriodTick:
            fmt = @"HH:mm:ss";
            break;
        case CentChartPeriodCandle1Minute:
        case CentChartPeriodCandle5Minute:
        case CentChartPeriodCandle10Minute:
        case CentChartPeriodCandle15Minute:
        case CentChartPeriodCandle30Minute:
        case CentChartPeriodCandle1Hour:
        case CentChartPeriodCandle2Hour:
        case CentChartPeriodCandle4Hour:
            fmt = @"MM/dd";
            break;
        case CentChartPeriodCandle1Day:
            fmt = @"yyyy/MM/dd";
            break;
        case CentChartPeriodCandle1Week:
            fmt = @"yyyy/MM/dd";
            break;
        case CentChartPeriodCandle1Month:
            fmt = @"yyyy/MM/dd";
            break;
        case CentChartStyleJingZhiZouShi:
            fmt = @"yyyy/MM/dd";
            break;
        case CentChartStyleYueJiDuShouYiLv:
            fmt = @"yyyy/MM";
            break;
        default:
            break;
    }
    
    return fmt;
}

+ (NSArray *) getOptimizedPointsWithMin:(double)min max:(double)max count:(int)count precision:(int)precision
{
    double result[count];
    
    double span = (max-min) / (count - 1);
    span = [CentChartUtil getOptimizedValue:span precision:precision];
    
    while(true)
    {
//        NSLog(@"-------------");
        result[0] = floor(min / span) * span;
        
        for(int i = 1; i < count; i++)
        {
            result[i] = result[i - 1] + span;
        }
        
        if(result[count - 1] > max)
        {
            break;
        }
        else
        {
            span = [CentChartUtil getOptimizedValue:span precision:precision];
        }
    }
    
    if(result[0] > 0 && count > 2 && result[count - 3] > max)
    {
        for(int i = 0; i < count; i++)
        {
            result[i] -= span;
        }
    }
    
    NSMutableArray *resultArray = [NSMutableArray arrayWithCapacity:count];
    
    for(int i = 0; i < count; i++) {
        [resultArray addObject:[NSNumber numberWithDouble:result[i]]];
    }
    
    return resultArray;
}

+ (NSString *)bigNumberFormat:(double)value
{
    NSString *label = nil;
    
    long long nValue = value;
    
    if(nValue > 1000000000 ) {
        if(nValue % 1000000000 == 0) {
            label = [NSString stringWithFormat:@"%lld亿手", (nValue / 100000000)];
        }
        else {
            label = [NSString stringWithFormat:@"%.1f亿手", (nValue / 100000000.0)];
        }
    }
//    else if(nValue > 10000000 ) {
//        if(nValue % 10000000 == 0) {
//            label = [NSString stringWithFormat:@"%lld百万手", (nValue / 1000000)];
//        }
//        else {
//            label = [NSString stringWithFormat:@"%.1f百万手", (nValue / 1000000.0)];
//        }
//    }
    else if(nValue > 10000 ) {
        if(nValue % 10000 == 0) {
            label = [NSString stringWithFormat:@"%lld万手", (nValue / 10000)];
        }
        else {
            label = [NSString stringWithFormat:@"%.1f万手", (nValue / 10000.0)];
        }
    }
    else {
        label = [NSString stringWithFormat:@"%lld手", nValue];
    }
    
    return label;
}

+ (double) getOptimizedValue:(double)value precision:(int)precision
{
    double value1 = value;
    double result = 0;
    double result1 = 0;
    
    int values[] = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 15, 20, 25, 30, 35, 40, 45, 50, 60, 70, 80, 90, 100, 110};
    int valueCount = sizeof(values) / sizeof(values[0]);
    
    value *= pow(10, precision);
    
    double scale = 1;
    
    while(value >= 100)
    {
        value /= 10;
        scale *= 10;
    }
    
    for(int i = 0; i < valueCount - 1; i++)
    {
        if (values[i] > value) {
            result = values[i];
            result1 = values[i + 1];
            break;
        }
    }
    
    result *= scale;
    
    result /= pow(10, precision);
    
    if(result <= value1) {
        result = result1 * scale;
        
        result /= pow(10, precision);
    }
    
    return result;
}

@end
