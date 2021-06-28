//
//  CentChartLayerAction.m
//  MobileTest_iPhone
//
//  Created by wolf on 13-2-2.
//  Copyright (c) 2013年 wolf. All rights reserved.
//

#import "CentChartLayerAction.h"
#import "CentChartView.h"
#import "CentChartDataLabel.h"
#import "CentChartUtil.h"


@implementation CentChartLayerAction

- (id)initWithLayer:(id)layer {
    self = [super initWithLayer:layer];
    
    if(self) {
        if([layer isKindOfClass:[CentChartLayerAction class]]) {
            CentChartLayerAction *other = (CentChartLayerAction *)layer;
            
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
    CGRect chartRect = CGRectInset(self.bounds, self.theme.chartPadding * 2, self.theme.chartPadding * 2);
    
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
    
//    // Calculate min max
//    double min = NAN;
//    double max = NAN;
//    
//    [self.crossDependentTechnical getDataMin:&min max:&max mapping:mapping];
//    
//    [mapping setDataMin:min max:max];
 
    // Calculate index
    CGPoint crossLocation = self.actionLocation;
    crossLocation.x -= 30;
    crossLocation.y -= 50;

    int indexMin = (int)ceilf([mapping untransformIndex:CGRectGetMinX(chartRect) + 1]);
    int indexMax = (int)floorf([mapping untransformIndex:CGRectGetMaxX(chartRect) - 1]);

    if(indexMin < 0) indexMin = 0;
    if(indexMax >= self.dataRange.x + self.dataRange.y) indexMax =  self.dataRange.x + self.dataRange.y - 1;
    
    int selectedIndex = (int)roundf([mapping untransformIndex:crossLocation.x]);
    
    selectedIndex = MAX(MIN(selectedIndex, indexMax), indexMin);
    
//    CentChartDataCandle* candle = [self.data objectAtIndex:selectedIndex];
//    CGFloat crossValue = [self.crossDependentTechnical getCrossPointValue:selectedIndex];
    
    crossLocation.x = roundf([mapping transformIndex:selectedIndex]) + 0.5;
    crossLocation.y = roundf(crossLocation.y) + 0.5;
//    crossLocation.y = roundf([mapping transformValue:crossValue]) + 0.5;
    
    // Draw cross
    CGContextSetAllowsAntialiasing(context, false);
    CGContextSetLineWidth(context, 1);
    CGContextSetStrokeColorWithColor(context, self.theme.crossLineColor.CGColor);

//    CGContextBeginPath(context);
//    CGContextMoveToPoint(context, CGRectGetMinX(mapping.viewPort), crossLocation.y);
//    CGContextAddLineToPoint(context, CGRectGetMaxX(mapping.viewPort), crossLocation.y);
//    CGContextStrokePath(context);
    
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, crossLocation.x, CGRectGetMinY(mapping.viewPort));
    CGContextAddLineToPoint(context, crossLocation.x, CGRectGetMaxY(mapping.viewPort));
    CGContextStrokePath(context);
    
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
                           mapping.theme.crossLabelFont,
                           NSFontAttributeName,
                           [UIColor orangeColor],
                           NSForegroundColorAttributeName,
                           nil];
    
    // Draw labels box
    UIGraphicsPushContext(context);

//    CGFloat itemHeight = [@"8" sizeWithFont:mapping.theme.crossLabelFont].height;
    CGFloat itemHeight = [@"8" sizeWithAttributes:attrs].height;
    CGFloat boxWidth = 130;
    CGFloat boxHeight = itemHeight * allDataLabels.count + 4;

    CGFloat boxTop = roundf(CGRectGetMinY(chartRect)) + 2.5;
//    CGFloat boxLeft = roundf(CGRectGetMinX(chartRect)) + 2.5;
    CGFloat boxLeft = roundf(crossLocation.x - boxWidth) - 3.5;
//    if(crossLocation.x < CGRectGetMidX(chartRect)) boxLeft = roundf(CGRectGetMaxX(chartRect) - boxWidth) - 1.5;
    if(crossLocation.x < CGRectGetMidX(chartRect)) boxLeft = roundf(crossLocation.x) + 3.5;
    
    CGRect rectBox = CGRectMake(boxLeft, boxTop, boxWidth, boxHeight);
    
    

    // Draw labels
    CGContextSetAllowsAntialiasing(context, true);
    CGContextSetFillColorWithColor(context, self.theme.crossLabelColor.CGColor);

    CGFloat itemTop = boxTop + 2;
    CGFloat itemLeft = boxLeft + 2;

    NSString *hlabelFormat = [CentChartUtil getHLabelFormat:self.period];
    NSDateFormatter *fmtDate = [[NSDateFormatter alloc] init];
    [fmtDate setDateFormat:hlabelFormat];
    
    NSNumberFormatter *fmtNumber = [[NSNumberFormatter alloc] init];
    [fmtNumber setPositiveFormat:@"##########0.0000"];

    CGContextSaveGState(context);
//    CGContextClipToRect(context, rectBox);
    
    for(CentChartDataLabel *dataLabel in allDataLabels) {
        CGFloat getMaxWidth = 0;
        
        if(dataLabel.type == CentChartDataLabelTypeDate) {
            NSString *value = [fmtDate stringFromDate:(NSDate*)dataLabel.value];
//            [value drawAtPoint:CGPointMake(itemLeft, itemTop) withFont:self.theme.crossLabelFont];
            [value drawAtPoint:CGPointMake(itemLeft, itemTop) withAttributes:attrs];
        }
        else if(dataLabel.type == CentChartDataLabelTypeValue) {
            NSString *name = [NSString stringWithFormat:@"%@ ", dataLabel.name];
            
            NSString *value = @"";
            if([dataLabel.value isKindOfClass:[NSNumber class]])
                value = [fmtNumber stringFromNumber:(NSNumber *)dataLabel.value];
            if([dataLabel.value isKindOfClass:[NSString class]])
                value = dataLabel.value;

//            CGFloat nameWidth = [name sizeWithFont:self.theme.crossLabelFont].width + 2;
            CGFloat nameWidth = [name sizeWithAttributes:attrs].width + 2;
            
//            getMaxWidth = [[NSString stringWithFormat:@"%@%@", name, value] sizeWithFont:self.theme.crossLabelFont].width;
            getMaxWidth = [[NSString stringWithFormat:@"%@%@", name, value] sizeWithAttributes:attrs].width;
            
            if(getMaxWidth > boxWidth){
                rectBox.origin.x = roundf(crossLocation.x - getMaxWidth) - 2.5 - 4;
                if(crossLocation.x < CGRectGetMidX(chartRect)) rectBox.origin.x = roundf(crossLocation.x) + 2.5;
                rectBox.size.width = getMaxWidth + 4;
            }
//            [name drawAtPoint:CGPointMake(rectBox.origin.x + 2.5, itemTop) withFont:self.theme.crossLabelFont];
            [name drawAtPoint:CGPointMake(rectBox.origin.x + 2.5, itemTop) withAttributes:attrs];
//            [value drawAtPoint:CGPointMake(rectBox.origin.x + nameWidth, itemTop) withFont:self.theme.crossLabelFont];
            [value drawAtPoint:CGPointMake(rectBox.origin.x + nameWidth, itemTop) withAttributes:attrs];
            
        }
        else if(dataLabel.type == CentChartDataLabelTypeRate){
            NSString *name = [NSString stringWithFormat:@"%@ ", dataLabel.name];
//            CGFloat nameWidth = [name sizeWithFont:self.theme.crossLabelFont].width + 2;
            CGFloat nameWidth = [name sizeWithAttributes:attrs].width + 2;
            
            
            NSString *value = @"";
            NSNumberFormatter *fmt = [[NSNumberFormatter alloc] init];
            [fmt setPositiveFormat:@"##########0.00"];
            value = [NSString stringWithFormat:@"%@%%", [fmt stringFromNumber:dataLabel.value]];
            
//            getMaxWidth = [[NSString stringWithFormat:@"%@%@", name, value] sizeWithFont:self.theme.crossLabelFont].width;
            getMaxWidth = [[NSString stringWithFormat:@"%@%@", name, value] sizeWithAttributes:attrs].width;
            
//            if(getMaxWidth > boxWidth){
                rectBox.origin.x = roundf(crossLocation.x - getMaxWidth) - 2.5 - 4;
                if(crossLocation.x < CGRectGetMidX(chartRect)) rectBox.origin.x = roundf(crossLocation.x) + 2.5;
                rectBox.size.width = getMaxWidth + 4;
//            }
            
//            [name drawAtPoint:CGPointMake(rectBox.origin.x + 2.5, itemTop) withFont:self.theme.crossLabelFont];
//            [value drawAtPoint:CGPointMake(rectBox.origin.x + nameWidth, itemTop) withFont:self.theme.crossLabelFont];
            [name drawAtPoint:CGPointMake(rectBox.origin.x + 2.5, itemTop) withAttributes:attrs];
            [value drawAtPoint:CGPointMake(rectBox.origin.x + nameWidth, itemTop) withAttributes:attrs];
        }
        
        
        itemTop += itemHeight;
    }
    CGContextSetFillColorWithColor(context, self.theme.crossBackgroundColor.CGColor);
    CGContextSetStrokeColorWithColor(context, self.theme.crossBorderColor.CGColor);
    CGContextFillRect(context, rectBox);
    CGContextStrokeRect(context, rectBox);
    
    CGContextRestoreGState(context);
    UIGraphicsPopContext();
}

@end
