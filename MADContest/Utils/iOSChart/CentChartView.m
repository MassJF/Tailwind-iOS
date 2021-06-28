//
//  CentChartView.m
//  MobileTest_iPhone
//
//  Created by wolf on 13-1-15.
//  Copyright (c) 2013年 wolf. All rights reserved.
//

#import "CentChartView.h"
#import "CentChartTechnical.h"
#import "CentChartUtil.h"


@interface CentChartView ()

@end


@implementation CentChartView


- (id)init
{
    self = [super init];
    
    if (self) {
        self.techList = nil;
    }
    
    return self;
}

- (void) prepareData:(NSArray *)data
{
    for(CentChartTechnical *tech in self.techList) {
        [tech prepareData:data];
    }
}

- (void) drawWithContext:(CGContextRef)context mapping:(CentChartMapping *)mapping;
{
    if(self.techList) {
        // Calculate min max
        double min = NAN;
        double max = NAN;
        
        for(CentChartTechnical *tech in self.techList) {
            [tech getDataMin:&min max:&max mapping:mapping];
        }
        
        if(isnan(min) || isnan(max)) {
            min = 0;
            max = 0;
        }
        
        /*int topViewVaxisCount = mapping.viewPort.size.height / 35;
        if(topViewVaxisCount % 2 == 0){
            topViewVaxisCount++;
        }
        int vaxisCount = self.index > 0 ? 3 : topViewVaxisCount;
//        int vaxisCount = self.index > 0 ? 3 : 5;
        int precision = self.index > 0 ? 2 : 4;
        
        if(self.index == 0) {
//            // IF /JPY
//            NSUInteger index = [self.pair length] - [@"JPY" length];
//            if([[self.pair substringFromIndex:index] isEqualToString:@"JPY"]){
//                precision = 3;
//            }
//            else {
//                precision = 5;
//            }
            if(self.period == CentChartStyleJingZhiZouShi){
                precision = 4;
            }else if (self.period == CentChartStyleYueJiDuShouYiLv){
                precision = 2;
            }
        }
        else {
            precision = 2;
        }*/
        
        int vaxisCount = [CentChartUtil getAxisCountWithViewIndex:self.index withViewHeight:mapping.viewPort.size.height];
        int precision = [CentChartUtil getPrecisionWithViewIndex:self.index withPreios:self.period];
        
//        if(mapping.period == CentChartPeriodCandle1Minute && self.index == 0) {
//            double maxChange = 0.02;
//            
//            if(fabs(max - mapping.yesterdayEndPrice) > maxChange) maxChange = fabs(max - mapping.yesterdayEndPrice);
//            if(fabs(min - mapping.yesterdayEndPrice) > maxChange) maxChange = fabs(min - mapping.yesterdayEndPrice);
//            
//            min = mapping.yesterdayEndPrice - maxChange;
//            max = mapping.yesterdayEndPrice + maxChange;
//        }
//        else {
            NSArray *vaxisValues = [CentChartUtil getOptimizedPointsWithMin:min max:max count:vaxisCount precision:precision];
            
            min = [(NSNumber *)vaxisValues[0] doubleValue];
            max = [(NSNumber *)vaxisValues[vaxisCount - 1] doubleValue];
//        }

        [mapping setDataMin:min max:max];
        
        // Draw axis board
        UIGraphicsPushContext(context);
        
        CGContextSetAllowsAntialiasing(context, false);
        CGContextSetLineWidth(context, 1.0f);
        CGContextSetFillColorWithColor(context, mapping.theme.axisFillColor.CGColor);
        CGContextFillRect(context, mapping.viewPort);

        // Draw axises
        
        // Draw V axis
        if(self.drawAxisBoard){
        CGContextSetFillColorWithColor(context, mapping.theme.axisLabelColor.CGColor);
        CGContextSetTextDrawingMode(context, kCGTextFill);

        NSNumberFormatter *fmt = [[NSNumberFormatter alloc] init];
        
        if(self.index == 0) {
            if(precision > 3) {
                [fmt setPositiveFormat:@"##########0.0000"];
            }
            else {
                [fmt setPositiveFormat:@"##########0.00"];
            }
        }
        else [fmt setPositiveFormat:@"##########0.00"];
            
        CGFloat drawxMin = roundf(CGRectGetMinX(mapping.viewPort)) + 0.5;
        CGFloat drawxMax = roundf(CGRectGetMaxX(mapping.viewPort)) + 0.5;
        
        CGFloat vaxisHeight = [@"10" sizeWithAttributes: @{NSFontAttributeName: [UIFont systemFontOfSize:10.0f]}].height;
        
        for(int i = 0; i < vaxisCount; i++) {
            CGFloat value = min + (max - min) * i / (vaxisCount - 1);
            CGFloat drawy = roundf([mapping transformValue:value]) + 0.5;
            CGFloat drawx = roundf(CGRectGetMaxX(mapping.viewPort)) + 2.5;
            
            CGContextSetStrokeColorWithColor(context, mapping.theme.axisLineColor.CGColor);
            CGContextBeginPath(context);
            CGContextMoveToPoint(context, drawxMin, drawy);
            CGContextAddLineToPoint(context, drawxMax, drawy);
            CGContextStrokePath(context);
            
            NSString *label = nil;
            
            if(value == floorf(value)) {
                
                long long nValue = value;
                
                if(nValue > 100000000) {
                    if(nValue % 100000000 == 0) {
                        label = [NSString stringWithFormat:@"%lld亿", (nValue / 100000000)];
                    }
                    else {
                        label = [NSString stringWithFormat:@"%.1f亿", (nValue / 100000000.0)];
                    }
                }
//                else if(nValue > 1000000 /*&& nValue % 100000000 == 0*/) {
//                    if(nValue % 1000000 == 0) {
//                        label = [NSString stringWithFormat:@"%lld百万", (nValue / 1000000)];
//                    }
//                    else {
//                        label = [NSString stringWithFormat:@"%.1f百万", (nValue / 1000000.0)];
//                    }
//                }
                else if(nValue > 10000) {
                    if(nValue % 10000 == 0) {
                        label = [NSString stringWithFormat:@"%lld万", (nValue / 10000)];
                    }
                    else {
                        label = [NSString stringWithFormat:@"%.1f万", (nValue / 10000.0)];
                    }
                }
                else {
//                    label = [NSString stringWithFormat:@"%lld", nValue];
                    label = [fmt stringFromNumber:[NSNumber numberWithFloat:value]];
                }
            }
            else {
                label = [fmt stringFromNumber:[NSNumber numberWithFloat:value]];
            }
            
            if(self.period == CentChartStyleYueJiDuShouYiLv){
                label = [NSString stringWithFormat:@"%@%%", label];
            }
            //const char *cLabel = [label cStringUsingEncoding:NSMacOSRomanStringEncoding];
            
            drawy -= vaxisHeight / 2;
            
            CGContextSetAllowsAntialiasing(context, true);
            //CGContextShowTextAtPoint(context, drawx, drawy, cLabel, strlen(cLabel));
            [label drawAtPoint:CGPointMake(drawx, drawy) withFont:mapping.theme.axisLabelFont];
            
            /*if(mapping.period == CentChartPeriodCandle1Minute) {
                if(self.index == 0) {
                    label = [fmt stringFromNumber:[NSNumber numberWithFloat:((value - mapping.yesterdayEndPrice) * 100/ mapping.yesterdayEndPrice)]];
                    label = [NSString stringWithFormat:@"%@%%", label];
                    
                    drawx = roundf(CGRectGetMinX(mapping.viewPort)) - 4.5;
                    drawx -= [label sizeWithFont:mapping.theme.axisLabelFont].width;
                    
                    [label drawAtPoint:CGPointMake(drawx, drawy) withFont:mapping.theme.axisLabelFont];
                }
                else {
                    drawx = roundf(CGRectGetMinX(mapping.viewPort)) - 4.5;
                    drawx -= [label sizeWithFont:mapping.theme.axisLabelFont].width;
                    
                    [label drawAtPoint:CGPointMake(drawx, drawy) withFont:mapping.theme.axisLabelFont];
                }
            }*/
            
            CGContextSetAllowsAntialiasing(context, false);
        }
        
        
        //draw period
        /*CGContextSetAllowsAntialiasing(context, true);
        CGContextSetFillColorWithColor(context, [UIColor colorWithRed:(70)/255.0 green:(119)/255.0 blue:(192)/255.0 alpha:0.8].CGColor);
        
        CGFloat x = roundf(CGRectGetMaxX(mapping.viewPort)) + 0.5;
        CGFloat periodLabelLenth = [@"字字" sizeWithFont:mapping.theme.axisLabelFont].width;
        x -= periodLabelLenth;
        CGFloat padding = 2.0;
        
        NSString *period = nil;
        switch (mapping.period) {
            case CentChartPeriodCandle1Minute:
                period = @"分时";
                break;
            case CentChartPeriodCandle1Day:
                period = @"日线";
                break;
            case CentChartPeriodCandle1Week:
                period = @"周线";
                break;
            case CentChartPeriodCandle1Month:
                period = @"月线";
                break;
            default:
                break;
        }
        [period drawAtPoint:CGPointMake(x - padding, 2 + padding) withFont:mapping.theme.axisLabelFont];
        CGContextSetAllowsAntialiasing(context, false);*/
        //
        
        
            // Draw H axis
            CGFloat drawyMin = roundf(CGRectGetMinY(mapping.viewPort)) + 0.5;
            CGFloat drawyMax = roundf(CGRectGetMaxY(mapping.viewPort)) + 0.5;

//        for(NSNumber *index in mapping.hLableIndexes) {
//            
//            CGFloat drawx = roundf([mapping transformIndex:index.floatValue]) + 0.5;
//            
//            if(drawx > CGRectGetMinX(mapping.viewPort) && drawx < CGRectGetMaxX(mapping.viewPort)) {
//                CGContextSetStrokeColorWithColor(context, mapping.theme.axisLineColor.CGColor);
//                CGContextBeginPath(context);
//                CGContextMoveToPoint(context, drawx, drawyMin);
//                CGContextAddLineToPoint(context, drawx, drawyMax);
//                CGContextStrokePath(context);
//            }
//        }
        
            // Draw axis board
            CGRect rectBoard = CGRectMake(drawxMin,
                                          drawyMin,
                                          drawxMax - drawxMin - mapping.theme.axisBoardWidth,
                                          drawyMax - drawyMin - mapping.theme.axisBoardWidth);
        
            CGContextSetStrokeColorWithColor(context, mapping.theme.axisBorderColor.CGColor);
            CGContextStrokeRect(context, rectBoard);
        }
        // Draw technicals
        CGRect drawRect = CGRectInset(mapping.viewPort, 2, 2);
        
        CGContextSaveGState(context);
        CGContextClipToRect(context, drawRect);
        
        for(CentChartTechnical *tech in self.techList) {
            [tech drawWithContext:context mapping:mapping];
        }
        
        // Draw color labels
        CGContextSetAllowsAntialiasing(context, true);
        
        CGFloat drawxLabelInit = roundf(CGRectGetMinX(drawRect)) + 1;
        CGFloat drawxLabel = drawxLabelInit;
        CGFloat drawyLabel = roundf(CGRectGetMinY(drawRect));
        CGFloat drawHeightLabel = [@"10" sizeWithAttributes: @{NSFontAttributeName: [UIFont systemFontOfSize:10.0f]}].height;
        CGFloat drawVGapLabel = 2;
        CGFloat drawHGapLabel = 5;
        //CGFloat drawIconSizeLabel = drawHeightLabel - 8;
        //CGFloat drawIconGapLabel = 2;
        CGFloat drawIconSizeLabel = 0;
        CGFloat drawIconGapLabel = 0;
        
        CGContextSetAlpha(context, 0.7);
        
        for(CentChartTechnical *tech in self.techList) {
            NSArray *colorLabels = [tech getColorLabels:mapping.theme];
            
            if(colorLabels) {
                for(CentChartColorLabel *colorLabel in colorLabels) {
                    CGFloat labelWidth = drawIconSizeLabel + drawIconGapLabel + [colorLabel.label sizeWithAttributes: @{NSFontAttributeName: [UIFont systemFontOfSize:10.0f]}].height;
                    
                    if(drawxLabel + labelWidth > CGRectGetMaxX(drawRect)) {
                        drawxLabel = drawxLabelInit;
                        drawyLabel += drawHeightLabel + drawVGapLabel;
                    }
                    
                    // Draw icon
                    CGContextSetFillColorWithColor(context, colorLabel.color.CGColor);
                    //CGContextFillRect(context, CGRectMake(drawxLabel + 0.5, drawyLabel + 3.5, drawIconSizeLabel, drawIconSizeLabel));

                    // Draw label
                    [colorLabel.label drawAtPoint:CGPointMake(drawxLabel + drawIconSizeLabel + drawIconGapLabel, drawyLabel) withFont:mapping.theme.colorLabelFont];
                    
                    // Move draw point
                    drawxLabel += roundf(labelWidth + drawHGapLabel);
                }
            }
        }
        
        
        
        CGContextSetAlpha(context, 1.0);

        CGContextRestoreGState(context);

        UIGraphicsPopContext();
    }
}

@end
