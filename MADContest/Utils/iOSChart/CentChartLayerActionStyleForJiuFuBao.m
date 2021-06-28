//
//  CentChartLayerAction.m
//  MobileTest_iPhone
//
//  Created by wolf on 13-2-2.
//  Copyright (c) 2013年 wolf. All rights reserved.
//

#import "CentChartLayerActionStyleForJiuFuBao.h"
#import "CentChartView.h"
#import "CentChartDataLabel.h"
#import "CentChartUtil.h"
#include "Utils.h"


@implementation CentChartLayerActionStyleForJiuFuBao

- (id)initWithLayer:(id)layer {
    self = [super initWithLayer:layer];
    
    if(self) {
        if([layer isKindOfClass:[CentChartLayerActionStyleForJiuFuBao class]]) {
            CentChartLayerActionStyleForJiuFuBao *other = (CentChartLayerActionStyleForJiuFuBao *)layer;
            
            self.theme = other.theme;
            self.views = other.views;
            self.dataRange = other.dataRange;
            self.actionLocation = other.actionLocation;
        }
    }
    
    return self;
}

- (void)drawInContext:(CGContextRef)context
{
    if(self.dataRange.y == 0 || self.actionLocation.x == 0) return;
    
    // Calculate size
//    CGRect chartRect = CGRectInset(self.bounds, self.theme.chartPadding * 2, self.theme.chartPadding * 2);
    CGRect chartRect = CGRectMake(self.bounds.origin.x + self.theme.chartPaddingLeft,
                                  self.bounds.origin.y + self.theme.chartPaddingTop,
                                  self.bounds.size.width - self.theme.chartPaddingLeft - self.theme.chartPaddingRight,
                                  self.bounds.size.height - self.theme.chartPaddingTop - self.theme.chartPaddingBottom);
    
//    if(self.period == CentChartPeriodCandle1Minute) {
//        chartRect.origin.x += self.theme.axisWidth;
//        chartRect.size.width -= self.theme.axisWidth * 2;
//    }
//    else {
        chartRect.size.width -= self.theme.axisWidth;
//    }

//    if(self.period == CentChartPeriodCandle1Minute) {
//        chartRect.size.height -= self.theme.axisHeight;
//    }
//    else {
        chartRect.size.height -= self.theme.scrollHeight + self.theme.axisHeight;
//    }

    // Prepare mapping
    CentChartMapping *mapping = [CentChartMapping mappingWithIndex:0 dataRange:self.dataRange viewPort:chartRect theme:self.theme period:self.period];
    
    // Calculate min max
    double min = CGFLOAT_MAX;
    double max = CGFLOAT_MIN;
    
    [self.crossDependentTechnical getDataMin:&min max:&max mapping:mapping];
    
    int vaxisCount = [CentChartUtil getAxisCountWithViewIndex:0 withViewHeight:mapping.viewPort.size.height];
    int precision = [CentChartUtil getPrecisionWithViewIndex:0 withPreios:mapping.period];
    
    NSArray *vaxisValues = [CentChartUtil getOptimizedPointsWithMin:min max:max count:vaxisCount precision:precision];
    
    min = [(NSNumber *)vaxisValues[0] doubleValue];
    max = [(NSNumber *)vaxisValues[vaxisCount - 1] doubleValue];
    
    [mapping setDataMin:min max:max];
    
    // Calculate index
//    CGPoint crossLocation = self.actionLocation;
    CGFloat x = self.actionLocation.x;
    CGFloat y = self.actionLocation.y;
    CGPoint crossLocation = CGPointMake(x, y);
    
    //easy to use
//    crossLocation.x -= 30;
//    crossLocation.y -= 50;

    int indexMin = (int)ceilf([mapping untransformIndex:CGRectGetMinX(chartRect) + 1]);
    int indexMax = (int)floorf([mapping untransformIndex:CGRectGetMaxX(chartRect) - 1]);

    if(indexMin < 0) indexMin = 0;
    if(indexMax >= self.dataRange.x + self.dataRange.y) indexMax =  self.dataRange.x + self.dataRange.y - 1;
    
    int selectedIndex = (int)roundf([mapping untransformIndex:crossLocation.x]);
    
    selectedIndex = MAX(MIN(selectedIndex, indexMax), indexMin);
    
//    CentChartDataCandle* candle = [self.data objectAtIndex:selectedIndex];
//    CGFloat crossValue = [self.crossDependentTechnical getCrossPointValue:selectedIndex];
    
    crossLocation.x = roundf([mapping transformIndex:selectedIndex]+ 0.5);
    crossLocation.y = roundf(crossLocation.y) + 0.5;
    
    //get y dependent on current technical
    if(self.crossDependentTechnical){
        CGFloat value = [self.crossDependentTechnical getCrossPointValue:selectedIndex];
        CGFloat y = [mapping transformValue:value];
        crossLocation.y = roundf(y) + 0.5;
    }
    
    CGFloat strokeWidth = 1.0f;
    UIGraphicsPushContext(context);
    CGContextSetAllowsAntialiasing(context, true);
    CGContextSetLineWidth(context, strokeWidth);
//    CGContextSaveGState(context);
    // Draw cross
//    CGContextSetAllowsAntialiasing(context, false);
//    CGContextSetLineWidth(context, 1);
//    CGContextSetStrokeColorWithColor(context, self.theme.crossLineColor.CGColor);

    //Draw H cross
//    CGContextBeginPath(context);
//    CGContextMoveToPoint(context, CGRectGetMinX(mapping.viewPort), crossLocation.y);
//    CGContextAddLineToPoint(context, CGRectGetMaxX(mapping.viewPort), crossLocation.y);
//    CGContextStrokePath(context);
    
    //Draw V cross
//    CGContextBeginPath(context);
//    CGContextMoveToPoint(context, crossLocation.x, CGRectGetMinY(mapping.viewPort));
//    CGContextAddLineToPoint(context, crossLocation.x, CGRectGetMaxY(mapping.viewPort));
//    CGContextStrokePath(context);
    
    // Get labes
    NSMutableArray *allDataLabels = [NSMutableArray arrayWithCapacity:10];
    
    for(CentChartView *view in self.views) {
        for(CentChartTechnical *tech in view.techList) {
            NSArray *dataLabels = [tech getDataLabels:selectedIndex];
            
            if(dataLabels != nil) {
                [allDataLabels addObjectsFromArray:dataLabels];
            }
        }
    }
    
    NSDictionary *attrs = [NSDictionary dictionaryWithObjectsAndKeys:
                           [UIFont systemFontOfSize:12],
                           NSFontAttributeName,
                           [UIColor orangeColor],
                           NSForegroundColorAttributeName,
                           nil];
    
    // Draw labels box
    CGFloat itemHeight = [@"8" sizeWithAttributes:attrs].height + 2.0f;
//    CGFloat boxWidth = 60.0f;
    CGFloat boxHeight = roundf(itemHeight * allDataLabels.count);

    CGPoint rootPoint = CGPointMake(roundf(crossLocation.x), roundf(crossLocation.y));
    
    CGPoint valueRootPoint = CGPointMake(rootPoint.x, rootPoint.y - boxHeight);
    CGPoint dateRootPoint = CGPointMake(rootPoint.x, rootPoint.y + itemHeight + 4.0f);
    
    NSString *hlabelFormat = [CentChartUtil getHLabelFormat:self.period];
    NSDateFormatter *fmtDate = [[NSDateFormatter alloc] init];
    [fmtDate setDateFormat:hlabelFormat];
    
    NSNumberFormatter *fmtNumber = [[NSNumberFormatter alloc] init];
    [fmtNumber setPositiveFormat:@"##########0.00"];

    for(CentChartDataLabel *dataLabel in allDataLabels) {
        CGFloat getMaxWidth = 0.0f;
        
        if(dataLabel.type == CentChartDataLabelTypeDate) {
            NSString *value = [fmtDate stringFromDate:(NSDate*)dataLabel.value];
            [value drawAtPoint:CGPointMake(rootPoint.x, rootPoint.y)
                withAttributes:attrs];
        }
        else {
            
            NSString *date = [NSString stringWithFormat:@"%@ ", dataLabel.name];
            NSString *value = @"";
            
            getMaxWidth = [[NSString stringWithFormat:@"%@%@", date, value] sizeWithAttributes:attrs].width;
            
            if(dataLabel.type == CentChartDataLabelTypeValue) {

                if([dataLabel.value isKindOfClass:[NSNumber class]])
                    value = [fmtNumber stringFromNumber:(NSNumber *)dataLabel.value];
                if([dataLabel.value isKindOfClass:[NSString class]])
                    value = dataLabel.value;
                
            }else if(dataLabel.type == CentChartDataLabelTypeRate){
                
                NSNumberFormatter *fmt = [[NSNumberFormatter alloc] init];
                [fmt setPositiveFormat:@"##########0.00"];
                value = [NSString stringWithFormat:@"%@%%", [fmt stringFromNumber:dataLabel.value]];
                
            }
            
            //fill point
            CGContextSetFillColorWithColor(context, [UIColor redColor].CGColor);
            CGContextAddArc(context, crossLocation.x, crossLocation.y, 3.0f, 0, 2 * M_PI, 1);
            CGContextFillPath(context);
            
            //draw boxes
            
            CGFloat nameWidth = [date sizeWithAttributes:attrs].width;
            
            CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
            CGContextSetStrokeColorWithColor(context, self.theme.crossBorderColor.CGColor);
            
            CGFloat dateBoxWidth = nameWidth + 6.0f;
            CGFloat x = dateRootPoint.x - dateBoxWidth / 2 - strokeWidth;
            
            if(x < 0.0f) x = 0.0f;
            if(x + dateBoxWidth > CGRectGetMaxX(chartRect)) x = CGRectGetMaxX(chartRect) - dateBoxWidth;
            
            CGRect dateBox = CGRectMake(x,
                                        dateRootPoint.y - itemHeight / 2,
                                        dateBoxWidth,
                                        itemHeight);
            
            [Utils addRoundRectWithContext:context rect:dateBox radius:4.0f];
            
            //draw triangle
            CGPoint triangleTopPoint = CGPointMake(rootPoint.x, rootPoint.y + 6.0f);
            CGPoint triangleLeftPoint = CGPointMake(CGRectGetMidX(dateBox) - 10.0f, dateRootPoint.y);
            CGPoint triangleRightPoint = CGPointMake(CGRectGetMidX(dateBox) + 10.0f, dateRootPoint.y);
            
            CGContextBeginPath(context);
            CGContextMoveToPoint(context, triangleTopPoint.x, triangleTopPoint.y);
            CGContextAddLineToPoint(context, triangleLeftPoint.x, triangleLeftPoint.y);
            CGContextAddLineToPoint(context, triangleRightPoint.x, triangleRightPoint.y);
            
            CGContextClosePath(context);
            CGContextFillPath(context);
            
//            CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
            
            //draw values
            NSDictionary *attrs1 = [NSDictionary dictionaryWithObjectsAndKeys:
                                   [UIFont systemFontOfSize:15],
                                   NSFontAttributeName,
                                   [UIColor whiteColor],
                                   NSForegroundColorAttributeName,
                                   nil];
            CGFloat valueWidth = [value sizeWithAttributes:attrs1].width;
            
            [value drawAtPoint:CGPointMake(fmax(0.0f, valueRootPoint.x - valueWidth / 2), valueRootPoint.y - itemHeight / 2 - 4)
                withAttributes:attrs1];
            
            CGContextSetFillColorWithColor(context, [UIColor blackColor].CGColor);
            
            x = dateRootPoint.x - nameWidth / 2;
            
            if(x < 0.0f) x = 0.0f;
            if(x + nameWidth > CGRectGetMaxX(chartRect)) x = CGRectGetMaxX(chartRect) - nameWidth;
            
            [date drawAtPoint:CGPointMake(x,
                                          dateRootPoint.y - [[attrs objectForKey:NSFontAttributeName] pointSize] / 2 - 1)
               withAttributes:attrs];
            
        }
    }
//    CGContextRestoreGState(context);
    UIGraphicsPopContext();
}

@end
