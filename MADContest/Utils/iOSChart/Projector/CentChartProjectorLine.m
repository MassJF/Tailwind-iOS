//
//  CentChartProjectorLine.m
//  MobileTest_iPhone
//
//  Created by wolf on 13-1-23.
//  Copyright (c) 2013年 wolf. All rights reserved.
//

#import "CentChartProjectorLine.h"

@implementation CentChartProjectorLine

- (void) projectWithContext:(CGContextRef)context mapping:(CentChartMapping *)mapping data:(NSArray *)data colors:(NSArray *)colors
{
    NSInteger startIndex = (int)floor(mapping.dataRange.x);
    NSInteger endIndex = (int)ceil(mapping.dataRange.x + mapping.dataRange.y);
    
    startIndex = MAX(0, startIndex);
    endIndex = MIN(data.count - 1, endIndex);
    
    float candleWidth = floor((mapping.getUnitWidth - 1 ) / 2);
    candleWidth = MAX(1, candleWidth);
    
    UIColor *color = [colors objectAtIndex:0];
    
    CGContextSetAllowsAntialiasing(context, true);
    CGContextSetLineWidth(context, 1);
    CGContextSetStrokeColorWithColor(context, color.CGColor);
    CGContextBeginPath(context);
    
    int pointCount = 0;
    
    for(NSInteger i = startIndex; i <= endIndex; i++) {
        NSNumber *value = [data objectAtIndex:i];
        
        if(isnan(value.doubleValue)) continue;
        
        float drawx = roundf([mapping transformIndex:i] + 0.5);
        float drawy = roundf([mapping transformValue:value.doubleValue]) + 0.5;
        
        if(pointCount == 0) {
            CGContextMoveToPoint(context, drawx, drawy);
        }
        else {
            CGContextAddLineToPoint(context, drawx, drawy);
        }
        
        pointCount++;
    }
    
    CGContextStrokePath(context);
}

@end
