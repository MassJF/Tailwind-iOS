//
//  CentChartProjectorBalance.m
//  PushApp
//
//  Created by ma on 14/12/25.
//  Copyright (c) 2014年 Centillion. All rights reserved.
//

#import "CentChartProjectorBalance.h"
#import "CentChartDataCandle.h"

@implementation CentChartProjectorBalance

- (void) projectWithContext:(CGContextRef)context mapping:(CentChartMapping *)mapping data:(NSArray *)data colors:(NSArray *)colors{
    
    int startIndex = (int)floor(mapping.dataRange.x);
    int endIndex = (int)ceil(mapping.dataRange.x + mapping.dataRange.y);
    
    startIndex = MAX(0, startIndex);
    endIndex = MIN((int)data.count - 1, endIndex);
    
    float candleWidth = floor((mapping.getUnitWidth - 1 ) / 2);
    candleWidth = MAX(0, candleWidth);
    
    double viewStartX = mapping.viewPort.origin.x + 3;
    double viewEndX = mapping.viewPort.origin.x + mapping.viewPort.size.width - 3;
    
    UIColor *sellBorderColor = [colors objectAtIndex:0];
    UIColor *sellFillColor = [colors objectAtIndex:1];
    UIColor *buyBorderColor = [colors objectAtIndex:2];
    UIColor *buyFillColor = [colors objectAtIndex:3];
    
    double y0 = [mapping transformValue:0.0f];
    double frontBalance = [[data objectAtIndex:startIndex] doubleValue];

    if(isnan(frontBalance)){
        frontBalance = 0.0f;
        for(int j = startIndex - 1; j >= 0; j--){
            double balance = [[data objectAtIndex:j] doubleValue];
            if(!isnan(balance)){
                frontBalance = balance;
                break;
            }
        }
    }
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, viewStartX, y0);
    CGPathAddLineToPoint(path, NULL, viewStartX, [mapping transformValue:frontBalance]);
    
    for(int i = startIndex + 1; i <= endIndex; i++){
        double balance = [[data objectAtIndex:i] doubleValue];
        double x = [mapping transformIndex:i];
        double y = [mapping transformValue:balance];
        double frontY = [mapping transformValue:frontBalance];
        
        if(frontBalance >= 0.0f){
            CGContextSetFillColorWithColor(context, sellFillColor.CGColor);
            CGContextSetStrokeColorWithColor(context, sellBorderColor.CGColor);
        }else{
            CGContextSetFillColorWithColor(context, buyFillColor.CGColor);
            CGContextSetStrokeColorWithColor(context, buyBorderColor.CGColor);
        }
        
        if(balance * frontBalance > 0.0f){
            
            if(balance != frontBalance){
                CGPathAddLineToPoint(path, NULL, MIN(x, viewEndX), frontY);
            }
            CGPathAddLineToPoint(path, NULL, MIN(x, viewEndX), y);
            
            if(i == endIndex){
                CGPathAddLineToPoint(path, NULL, MIN(x, viewEndX), y0);
                CGContextAddPath(context, path);
                CGContextStrokePath(context);
                CGContextAddPath(context, path);
                CGContextFillPath(context);
                CGPathRelease(path);
            }
        }else{
            CGPathAddLineToPoint(path, NULL, MIN(x, viewEndX), frontY);
            CGPathAddLineToPoint(path, NULL, MIN(x, viewEndX), y0);
            CGContextAddPath(context, path);
            CGContextStrokePath(context);
            CGContextAddPath(context, path);
            CGContextFillPath(context);
            CGPathRelease(path);
            
            path = CGPathCreateMutable();
            CGPathMoveToPoint(path, NULL, MIN(x, viewEndX), y0);
            CGPathAddLineToPoint(path, NULL, MIN(x, viewEndX), y);
        }
        frontBalance = balance;
    }
    
}
@end
