//
//  CentChartLayerLoading.m
//  MobileTest_iPhone
//
//  Created by wolf on 13-2-21.
//  Copyright (c) 2013年 wolf. All rights reserved.
//

#import "CentChartLayerLoading.h"

@implementation CentChartLayerLoading

- (id)initWithLayer:(id)layer {
    self = [super initWithLayer:layer];
    
    if(self) {
        if([layer isKindOfClass:[CentChartLayerLoading class]]) {
            CentChartLayerLoading *other = (CentChartLayerLoading *)layer;
            
            self.theme = other.theme;
            self.views = other.views;
            self.loadingLocation = other.loadingLocation;
            self.loadingRotation = other.loadingRotation;
        }
    }
    
    return self;
}

- (void)drawInContext:(CGContextRef)context
{
    if(self.loadingLocation.x == 0 && self.loadingLocation.y == 0) return;

    // Calc size
//    CGRect chartRect = CGRectInset(self.bounds, self.theme.chartPadding * 2, self.theme.chartPadding * 2);
    CGRect chartRect = CGRectMake(self.bounds.origin.x + self.theme.chartPaddingLeft,
                                  self.bounds.origin.y + self.theme.chartPaddingTop,
                                  self.bounds.size.width - self.theme.chartPaddingLeft - self.theme.chartPaddingRight,
                                  self.bounds.size.height - self.theme.chartPaddingTop - self.theme.chartPaddingBottom);
    
    chartRect.size.width -= self.theme.axisWidth;
    chartRect.size.height -= self.theme.scrollHeight + self.theme.axisHeight;
//    chartRect.size.height = chartRect.size.height * ((NSNumber *)self.theme.viewHeights[0]).floatValue;

    // Draw
    CGContextSetAllowsAntialiasing(context, true);
    CGContextSetFillColorWithColor(context, self.theme.loadingFillColor.CGColor);
    
    CGFloat lineAngle = 0;
    CGFloat rotateAngle = 0;
    CGFloat radius = self.theme.loadingRadius - 2 + 4 * self.loadingLocation.y;
    CGFloat radiusLine = radius * 0.6;
    
    if(self.loadingLocation.y == 0) {
        rotateAngle = M_PI * 2 * ABS(self.loadingLocation.x) / self.theme.loadingWidth;
        lineAngle = rotateAngle * 0.8;
    }
    else if(self.loadingLocation.y == 1) {
        rotateAngle = M_PI * 2 * self.loadingRotation;
        lineAngle = M_PI * 2 * 0.8;
    }
    else {
        rotateAngle = 0;
        lineAngle = M_PI * 2 * 0.8;
    }
    
    CGPoint center;
    
    if(self.loadingLocation.x > 0) {
        center = CGPointMake(CGRectGetMaxX(chartRect) + 0.5 - self.loadingLocation.x + self.theme.loadingWidth / 2, CGRectGetMidY(chartRect));
    }
    else {
        center = CGPointMake(CGRectGetMinX(chartRect) + 0.5 - self.loadingLocation.x - self.theme.loadingWidth / 2, CGRectGetMidY(chartRect));
    }
    
    CGContextSaveGState(context);
    CGContextClipToRect(context, chartRect);
    
    CGContextFillEllipseInRect(context, CGRectMake(center.x - radius, center.y - radius, radius * 2, radius * 2));
    
    CGContextTranslateCTM(context, center.x, center.y);
    CGContextRotateCTM(context, rotateAngle);
    
    if(self.loadingLocation.y == 1) {
        CGContextSetStrokeColorWithColor(context, self.theme.loadingActiveLineColor.CGColor);
        CGContextSetFillColorWithColor(context, self.theme.loadingActiveLineColor.CGColor);
    }
    else {
        CGContextSetStrokeColorWithColor(context, self.theme.loadingLineColor.CGColor);
        CGContextSetFillColorWithColor(context, self.theme.loadingLineColor.CGColor);
    }
    
    CGContextSetLineWidth(context, 2);
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, 0, -radiusLine);
    CGContextAddArc(context, 0, 0, radiusLine, -M_PI_2, -M_PI_2 - lineAngle, 1);
    CGContextStrokePath(context);
    
    CGContextSetLineWidth(context, 2);
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, 0, -radiusLine - 2.5);
    CGContextAddLineToPoint(context, 0, -radiusLine + 3);
    CGContextAddLineToPoint(context, 5, -radiusLine);
    CGContextClosePath(context);
    CGContextFillPath(context);

    CGContextRestoreGState(context);
}

+ (BOOL)needsDisplayForKey:(NSString *)key
{
    if([key isEqualToString:@"loadingLocation"] || [key isEqualToString:@"loadingRotation"]) {
        return YES;
    }
    else {
        return [super needsDisplayForKey:key];
    }
}

@end
