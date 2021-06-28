//
//  CentchartProjectorSignal.m
//  PushApp
//
//  Created by ma on 14/12/24.
//  Copyright (c) 2014年 Centillion. All rights reserved.
//

#import "CentchartProjectorSignal.h"
#import "CentChartDataCandle.h"

static int SignalWidth;
static int SignalHeight;

@implementation CentchartProjectorSignal

- (void) projectWithContext:(CGContextRef)context mapping:(CentChartMapping *)mapping data:(NSArray *)data colors:(NSArray *)colors{
    
    SignalWidth = 8;
    SignalHeight = 14;
    
    int startIndex = (int)floor(mapping.dataRange.x);
    int endIndex = (int)ceil(mapping.dataRange.x + mapping.dataRange.y);
    
    startIndex = MAX(0, startIndex);
    endIndex = MIN((int)data.count - 1, endIndex);
    
    float candleWidth = floor((mapping.getUnitWidth - 1 ) / 2);
    candleWidth = MAX(0, candleWidth);
    
    UIColor *sellBorderColor = [colors objectAtIndex:0];
    UIColor *sellFillColor = [colors objectAtIndex:1];
    UIColor *buyBorderColor = [colors objectAtIndex:2];
    UIColor *buyFillColor = [colors objectAtIndex:3];
    
    for(int i = startIndex; i < endIndex; i++){
        CentChartDataCandle *candle = [data objectAtIndex:i];
        float drawx = roundf([mapping transformIndex:i]) + 0.5;
        
        if([candle.signalType isEqualToString:@"sell"]){
            float drawyh = roundf([mapping transformValue: candle.high]) + 0.5 - 20;
            [self drawSellSignal:context point:CGPointMake(drawx, drawyh) borderColor:sellBorderColor fillColor:sellFillColor];
        }
        
        if([candle.signalType isEqualToString:@"buy"]){
            float drawyl = roundf([mapping transformValue: candle.low]) + 0.5 + 20;
            [self drawBuySignal:context point:CGPointMake(drawx, drawyl) borderColor:buyBorderColor fillColor:buyFillColor];
        }
    }
}

-(void)drawSellSignal:(CGContextRef)context point:(CGPoint)point borderColor:(UIColor *)borderColor fillColor:(UIColor *)fillColor{
    
    CGContextSetStrokeColorWithColor(context, borderColor.CGColor);
    CGContextSetFillColorWithColor(context, fillColor.CGColor);
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, point.x, point.y);
    CGPathAddLineToPoint(path, NULL, point.x + SignalWidth / 2, point.y - SignalHeight / 2);
    CGPathAddLineToPoint(path, NULL, point.x + SignalWidth / 2 - 2, point.y - SignalHeight / 2);
    CGPathAddLineToPoint(path, NULL, point.x + SignalWidth / 2 - 2, point.y - SignalHeight);
    CGPathAddLineToPoint(path, NULL, point.x - SignalWidth / 2 + 2, point.y - SignalHeight);
    CGPathAddLineToPoint(path, NULL, point.x - SignalWidth / 2 + 2, point.y - SignalHeight / 2);
    CGPathAddLineToPoint(path, NULL, point.x - SignalWidth / 2, point.y - SignalHeight / 2);
    CGPathCloseSubpath(path);
    CGContextAddPath(context, path);
    CGContextFillPath(context);
//    CGContextAddPath(context, path);
//    CGContextStrokePath(context);
    CGPathRelease(path);
}

-(void)drawBuySignal:(CGContextRef)context point:(CGPoint)point borderColor:(UIColor *)borderColor fillColor:(UIColor *)fillColor{
    
    CGContextSetStrokeColorWithColor(context, borderColor.CGColor);
    CGContextSetFillColorWithColor(context, fillColor.CGColor);
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, point.x, point.y);
    CGPathAddLineToPoint(path, NULL, point.x + SignalWidth / 2, point.y + SignalHeight / 2);
    CGPathAddLineToPoint(path, NULL, point.x + SignalWidth / 2 - 2, point.y + SignalHeight / 2);
    CGPathAddLineToPoint(path, NULL, point.x + SignalWidth / 2 - 2, point.y + SignalHeight);
    CGPathAddLineToPoint(path, NULL, point.x - SignalWidth / 2 + 2, point.y + SignalHeight);
    CGPathAddLineToPoint(path, NULL, point.x - SignalWidth / 2 + 2, point.y + SignalHeight / 2);
    CGPathAddLineToPoint(path, NULL, point.x - SignalWidth / 2, point.y + SignalHeight / 2);
    CGPathCloseSubpath(path);
    CGContextAddPath(context, path);
    CGContextFillPath(context);
//    CGContextAddPath(context, path);
//    CGContextStrokePath(context);
    CGPathRelease(path);
    
}

@end
