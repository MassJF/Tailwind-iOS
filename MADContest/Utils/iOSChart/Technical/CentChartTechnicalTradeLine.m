//
//  CentChartTechnicalTradeLine.m
//  zgxt
//
//  Created by superMa on 15/12/5.
//  Copyright © 2015年 htqh. All rights reserved.
//

#import "CentChartTechnicalTradeLine.h"
#import "CentChartProjectorLine.h"
#import "CentChartDataCandle.h"
#import "CentChartUtil.h"

@interface CentChartTechnicalTradeLine ()

@property (retain, nonatomic) NSArray *data;
@property (retain, nonatomic) NSArray* candleData;
@property (retain, nonatomic) CentChartProjectorLine *lineProjector;

@end

@implementation CentChartTechnicalTradeLine

- (id)init
{
    self = [super init];
    
    if (self) {
        self.data = nil;
        self.lineProjector = [[CentChartProjectorLine alloc] init];
    }
    
    return self;
}

- (void) prepareData:(NSArray *)data
{
    NSMutableArray* temp = [NSMutableArray arrayWithCapacity:0];
    for(CentChartDataCandle* candle in data){
        [temp addObject:[NSNumber numberWithDouble:candle.volume]];
    }
    self.candleData = data;
    self.data = temp;
}

- (void) getDataMin:(double *)min max:(double *)max mapping:(CentChartMapping *)mapping
{
    if(self.data && 0 < [self.data count]) {
        NSInteger startIndex = floor(mapping.dataRange.x);
        NSInteger endIndex = ceil(mapping.dataRange.x + mapping.dataRange.y);
        
        startIndex = MAX(0, startIndex);
        endIndex = MIN(self.data.count - 1, endIndex);
        
        for(NSInteger i = startIndex; i <= endIndex; i++) {
            NSNumber* data = [self.data objectAtIndex:i];
            
            if(isnan(*min) || *min > [data doubleValue]) *min = [data doubleValue];
            if(isnan(*max) || *max < [data doubleValue]) *max = [data doubleValue];
        }
    }
}

- (void) drawWithContext:(CGContextRef)context mapping:(CentChartMapping *)mapping
{
    if(self.data) {
        NSArray *colors = mapping.theme.techMaColors;
        [self.lineProjector projectWithContext:context mapping:mapping data:self.data colors:colors];
    }
}

- (NSArray *) getDataLabels:(int)index
{
    if(index >= 0 && index < self.data.count) {
        CentChartDataCandle* candle = [self.candleData objectAtIndex:index];
        NSDate* timestamp = candle.timestamp;
        NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy/MM/dd"];
        NSString* timestampStr = [dateFormatter stringFromDate:timestamp];
        
        NSNumber* jingzhi = [self.data objectAtIndex:index];
        
        CentChartDataLabel *label = [CentChartDataLabel labelWithType:CentChartDataLabelTypeValue name:timestampStr value:jingzhi];
        
        return @[label];
    }
    else {
        return nil;
    }
}

-(double)getCrossPointValue:(NSInteger)index{
    
    if(index >= 0 && index < self.data.count) {
        NSNumber* jingzhi = [self.data objectAtIndex:index];
        return [jingzhi doubleValue];
    }
    else {
        return 0;
    }
}

@end
