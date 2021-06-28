//
//  CentChartProjectorHistogram.m
//  PushApp
//
//  Created by ma on 14/12/22.
//  Copyright (c) 2014年 Centillion. All rights reserved.
//

#import "CentChartProjectorHistogram.h"

@implementation CentChartProjectorHistogram

- (void) projectWithContext:(CGContextRef)context mapping:(CentChartMapping *)mapping data:(NSArray *)data colors:(NSArray *)colors
{
    NSInteger startIndex = (int)floor(mapping.dataRange.x);
    NSInteger endIndex = (int)ceil(mapping.dataRange.x + mapping.dataRange.y);
    
    startIndex = MAX(0, startIndex);
    endIndex = MIN(data.count - 1, endIndex);
    
    float candleWidth = floor((mapping.getUnitWidth - 1 ) / 2);
    candleWidth = MAX(0, candleWidth);
    
//    UIColor *colorUp = [colors objectAtIndex:0];
    UIColor *colorDown = [colors objectAtIndex:0];
    
    CGContextSetAllowsAntialiasing(context, false);
    CGContextSetLineWidth(context, 1);
    
    float drawy0 = roundf([mapping transformValue:0]) + 0.5;
    
//    CentChartDataCandle *frontCandle = nil;
    NSNumber *frontClose = nil;
    for(NSInteger i = startIndex; i <= endIndex; i++) {
        NSNumber *close = [data objectAtIndex:i];
        
        float drawx = roundf([mapping transformIndex:i]) + 0.5;
        float drawyv = roundf([mapping transformValue: [close doubleValue]]) + 0.5;
        
        CGContextSetFillColorWithColor(context, colorDown.CGColor);
        CGContextSetStrokeColorWithColor(context, colorDown.CGColor);
        
        if(candleWidth > 0) {
            CGRect rect = CGRectMake(drawx - candleWidth, drawyv, candleWidth * 2, drawy0 - drawyv);
            
            CGContextFillRect(context, rect);
        }
        else {
            CGContextMoveToPoint(context, drawx, drawyv);
            CGContextAddLineToPoint(context, drawx, drawy0);
            CGContextStrokePath(context);
        }
        frontClose = close;
    }
}

@end
