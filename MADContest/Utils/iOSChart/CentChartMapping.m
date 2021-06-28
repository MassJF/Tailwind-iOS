//
//  CentChartContext.m
//  MobileTest_iPhone
//
//  Created by wolf on 13-1-15.
//  Copyright (c) 2013年 wolf. All rights reserved.
//

#import "CentChartMapping.h"
#import "CentChart.h"

#define HAXIS_PADDING 2
#define VAXIS_PADDING 5

@interface CentChartMapping ()



@end

@implementation CentChartMapping

+ (CentChartMapping *) mappingWithIndex:(int)index dataRange:(CGPoint)dataRange viewPort:(CGRect)viewPort theme:(CentChartTheme *)theme period:(CentChartPeriod)period;
{
    CentChartMapping *mapping = [[CentChartMapping alloc] init];
    
    if(mapping) {
        mapping.index = index;
        mapping.dataRange = dataRange;
        mapping.viewPort = viewPort;
        mapping.theme = theme;
        mapping.period = period;
    }
    
    return mapping;
}

- (void) setDataMin:(double)min max:(double)max
{
    self.dataMinValue = min;
    self.dataMaxValue = max;
}

- (float) transformIndex:(double)index
{
    float result = 0.0f;
    
    float unitWidth = [self getUnitWidth];
    result = self.viewPort.origin.x + self.theme.axisHPadding  + unitWidth * (index - self.dataRange.x /*+ 0.5f*/) + 1;
    
    return result;
}

- (double) untransformIndex:(float)x
{
    float unitWidth = [self getUnitWidth];
    x += unitWidth / 2;
    double result = (x - self.viewPort.origin.x - self.theme.axisHPadding - 1) / unitWidth + self.dataRange.x - 0.5;
    
    return result;
}

- (float) transformValue:(double)value
{
    NSNumber *padding = (NSNumber *)self.theme.axisVPaddings[self.index];
    
    float height = self.viewPort.size.height - padding.floatValue * 2;
    float result = self.viewPort.origin.y + padding.floatValue + height * (self.dataMaxValue - value) / (self.dataMaxValue - self.dataMinValue);
    
    return result;
}

- (float) getUnitWidth
{
    float width = self.viewPort.size.width - self.theme.axisHPadding  * 2 - 2;
//    if(CentChartPeriodCandle1Minute == self.period)
//        return width / 242;
//    else
        return width / self.dataRange.y;
    
}

@end
