//
//  CentChartProjectorCandle.m
//  MobileTest_iPhone
//
//  Created by wolf on 13-1-15.
//  Copyright (c) 2013年 wolf. All rights reserved.
//

#import "CentChartProjectorCandle.h"
#import "CentChartDataCandle.h"

@implementation CentChartProjectorCandle

- (void) projectWithContext:(CGContextRef)context mapping:(CentChartMapping *)mapping data:(NSArray *)data colors:(NSArray *)colors
{
    NSInteger startIndex = (int)floor(mapping.dataRange.x);
    NSInteger endIndex = (int)ceil(mapping.dataRange.x + mapping.dataRange.y);
    
    startIndex = MAX(0, startIndex);
    endIndex = MIN(data.count - 1, endIndex);
    
    float candleWidth = floor((mapping.getUnitWidth - 1 ) / 2);
    candleWidth = MAX(0, candleWidth);
    
    if(0 == candleWidth || CentChartPeriodCandle1Minute == mapping.period){  //画折线图
        [self drawLineWithContext:context mapping:mapping data:data candleWidth:candleWidth startIndex:startIndex endIndex:endIndex color:colors];
    }else{   //画candle
        [self drawCandleWithContext:context mapping:mapping data:data candleWidth:candleWidth startIndex:startIndex endIndex:endIndex color:colors];
    }
    
}

-(void)drawLineWithContext:(CGContextRef)context mapping:(CentChartMapping *)mapping data:(NSArray *)data candleWidth:(float)candleWidth startIndex:(NSInteger)startIndex endIndex:(NSInteger)endIndex color:(NSArray *)colors
{
    UIColor *color = [colors objectAtIndex:4];
    
    CGContextSetAllowsAntialiasing(context, true);
    CGContextSetLineWidth(context, 1.5);
    CGContextSetStrokeColorWithColor(context, color.CGColor);
    CGContextBeginPath(context);
    
    int pointCount = 0;
    
    for(NSInteger i = startIndex; i <= endIndex; i++) {
        //NSNumber *value = [data objectAtIndex:i];
        CentChartDataCandle *candle = [data objectAtIndex:i];
        NSNumber *value = [NSNumber numberWithDouble:candle.close];
        
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

-(void)drawCandleWithContext:(CGContextRef)context mapping:(CentChartMapping *)mapping data:(NSArray *)data candleWidth:(float)candleWidth startIndex:(NSInteger)startIndex endIndex:(NSInteger)endIndex color:(NSArray *)colors
{
    UIColor *colorUpBoard = [colors objectAtIndex:0];
    UIColor *colorUpFill = [colors objectAtIndex:1];
    UIColor *colorDownBoard = [colors objectAtIndex:2];
    UIColor *colorDownFill = [colors objectAtIndex:3];
    
    CGContextSetAllowsAntialiasing(context, false);
    CGContextSetLineWidth(context, 1);
    
    for(NSInteger i = startIndex; i <= endIndex; i++) {
        CentChartDataCandle *candle = [data objectAtIndex:i];
        
        if(!candle.invalid){
            float drawx = roundf([mapping transformIndex:i]) + 0.5;
            float drawyo = roundf([mapping transformValue: candle.open]) + 0.5;
            float drawyh = roundf([mapping transformValue: candle.high]) + 0.5;
            float drawyl = roundf([mapping transformValue: candle.low]) + 0.5;
            float drawyc = roundf([mapping transformValue: candle.close]) + 0.5;
            
            if(candle.close > candle.open) {
                CGContextSetStrokeColorWithColor(context, colorUpBoard.CGColor);
                CGContextSetFillColorWithColor(context, colorUpFill.CGColor);
                
                CGContextBeginPath(context);
                CGContextMoveToPoint(context, drawx, drawyh);
                CGContextAddLineToPoint(context, drawx, drawyl);
                CGContextStrokePath(context);
                
                CGRect rect = CGRectMake(drawx - candleWidth, drawyc, candleWidth * 2, drawyo - drawyc);
                
                CGContextFillRect(context, rect);
                CGContextStrokeRect(context, rect);
            }
            else {
                CGContextSetStrokeColorWithColor(context, colorDownBoard.CGColor);
                CGContextSetFillColorWithColor(context, colorDownFill.CGColor);
                
                CGContextBeginPath(context);
                CGContextMoveToPoint(context, drawx, drawyl);
                CGContextAddLineToPoint(context, drawx, drawyh);
                CGContextStrokePath(context);
                
                CGRect rect = CGRectMake(drawx - candleWidth, drawyo, candleWidth * 2, drawyc - drawyo);
                
                CGContextFillRect(context, rect);
                CGContextStrokeRect(context, rect);
            }
        }
    }
}

@end
