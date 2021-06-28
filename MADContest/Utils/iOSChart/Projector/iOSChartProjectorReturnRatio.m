//
//  iOSChartProjectorReturnRatio.m
//  zgxt
//
//  Created by superMa on 16/1/3.
//  Copyright © 2016年 htqh. All rights reserved.
//

#import "iOSChartProjectorReturnRatio.h"
#import "CentChartDataCandle.h"

@implementation iOSChartProjectorReturnRatio

- (void) projectWithContext:(CGContextRef)context mapping:(CentChartMapping *)mapping data:(NSArray *)data colors:(NSArray *)colors
{
    int startIndex = (int)floor(mapping.dataRange.x);
    int endIndex = (int)ceil(mapping.dataRange.x + mapping.dataRange.y);
    
    startIndex = MAX(0, startIndex);
    endIndex = MIN((int)data.count - 1, endIndex);
    
    float candleWidth = floor((mapping.getUnitWidth - 1 ) / 2);
    candleWidth = MAX(0, candleWidth);
    
    UIColor *colorUp = [colors objectAtIndex:0];
    UIColor *colorDown = [colors objectAtIndex:1];
    
    CGContextSetAllowsAntialiasing(context, false);
    CGContextSetLineWidth(context, 1);
    
    float drawy0 = roundf([mapping transformValue:0]) + 0.5;
    
    CentChartDataCandle *frontCandle = nil;
    for(int i = startIndex; i <= endIndex; i++) {
        CentChartDataCandle *candle = [data objectAtIndex:i];
        
        float drawx = roundf([mapping transformIndex:i]) + 0.5;
        float drawyv = roundf([mapping transformValue: candle.volume]) + 0.5;
        
        CGFloat height = drawy0 - drawyv;
        
        if(candle.volume < 0) {
            if(height == 0){
                height = 1;
            }
            CGContextSetFillColorWithColor(context, colorDown.CGColor);
            CGContextSetStrokeColorWithColor(context, colorDown.CGColor);
        }
        else {
            if(height == 0){
                height = -1;
            }
            CGContextSetFillColorWithColor(context, colorUp.CGColor);
            CGContextSetStrokeColorWithColor(context, colorUp.CGColor);
        }
        
        if(candleWidth > 0) {
            
            CGRect rect = CGRectMake(drawx - candleWidth, drawyv, candleWidth * 2, height);
            
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
