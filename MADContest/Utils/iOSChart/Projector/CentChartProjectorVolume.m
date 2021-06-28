//
//  CentChartProjectorVolume.m
//  MobileTest_iPhone
//
//  Created by wolf on 13-1-22.
//  Copyright (c) 2013年 wolf. All rights reserved.
//

#import "CentChartProjectorVolume.h"
#import "CentChartDataCandle.h"

@implementation CentChartProjectorVolume

- (void) projectWithContext:(CGContextRef)context mapping:(CentChartMapping *)mapping data:(NSArray *)data colors:(NSArray *)colors
{
    int startIndex = (int)floor(mapping.dataRange.x);
    int endIndex = (int)ceil(mapping.dataRange.x + mapping.dataRange.y);
    
    startIndex = MAX(0, startIndex);
    endIndex = MIN((int)data.count - 1, endIndex);
    
    float candleWidth = floor((mapping.getUnitWidth - 1 ) / 2);
    candleWidth = MAX(0, candleWidth);
    
    UIColor *colorUp = [colors objectAtIndex:0];
    UIColor *colorDown = [colors objectAtIndex:0];
    
    CGContextSetAllowsAntialiasing(context, false);
    CGContextSetLineWidth(context, 1);
    
    float drawy0 = roundf([mapping transformValue:mapping.dataMinValue]) + 0.5;

    CentChartDataCandle *frontCandle = nil;
    for(int i = startIndex; i <= endIndex; i++) {
        CentChartDataCandle *candle = [data objectAtIndex:i];
        
        float drawx = roundf([mapping transformIndex:i]) + 0.5;
        float drawyv = roundf([mapping transformValue: candle.volume]) + 0.5;
        
        if(candle.close > candle.open) {
            CGContextSetFillColorWithColor(context, colorUp.CGColor);
            CGContextSetStrokeColorWithColor(context, colorUp.CGColor);
        }
        else {
            CGContextSetFillColorWithColor(context, colorDown.CGColor);
            CGContextSetStrokeColorWithColor(context, colorDown.CGColor);
        }
        
        if(candleWidth > 0) {
            CGRect rect = CGRectMake(drawx - candleWidth, drawyv, candleWidth * 2, drawy0 - drawyv);
                
            CGContextFillRect(context, rect);
        }
        else {
            CGContextMoveToPoint(context, drawx, drawyv);
            CGContextAddLineToPoint(context, drawx, drawy0);
            CGContextStrokePath(context);
        }
        frontCandle = candle;
    }
}

@end
