//
//  CentChartPoint.m
//  JiuFuBao
//
//  Created by superMa on 2017/3/8.
//  Copyright © 2017年 taurus. All rights reserved.
//

#import "CentChartProjectorPoint.h"

@implementation CentChartProjectorPoint

- (void) projectWithContext:(CGContextRef)context mapping:(CentChartMapping *)mapping data:(NSArray *)data colors:(NSArray *)colors radius:(CGFloat)radius{
    
    NSInteger startIndex = (int)floor(mapping.dataRange.x);
    NSInteger endIndex = (int)ceil(mapping.dataRange.x + mapping.dataRange.y);
    
    startIndex = MAX(0, startIndex);
    endIndex = MIN(data.count - 1, endIndex);
    
    float candleWidth = floor((mapping.getUnitWidth - 1 ) / 2);
    candleWidth = MAX(1, candleWidth);
    
    UIColor *lineStrockColor = [colors objectAtIndex:0];
    UIColor *pointFillColor = [colors objectAtIndex:1];
    
    CGFloat lineWidth = 2.0f;
    CGContextSetAllowsAntialiasing(context, true);
    CGContextSetLineWidth(context, lineWidth);
    CGContextSetStrokeColorWithColor(context, lineStrockColor.CGColor);
    CGContextSetFillColorWithColor(context, pointFillColor.CGColor);
    CGContextBeginPath(context);
    
    for(NSInteger i = startIndex; i <= endIndex; i++) {
        NSNumber *value = [data objectAtIndex:i];
        
        if(isnan(value.doubleValue)) continue;
        
        float drawx = roundf([mapping transformIndex:i] + 0.5);
        float drawy = roundf([mapping transformValue:value.doubleValue]) + 0.5;
        
        CGContextAddArc(context, drawx, drawy, radius, 0, 2 * M_PI, 1);
        CGContextStrokePath(context);
        
        CGContextAddArc(context, drawx, drawy, radius, 0, 2 * M_PI, 1);
        CGContextFillPath(context);
        
    }
}

@end
