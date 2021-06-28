//
//  CentChartTechMACD.m
//  PushApp
//
//  Created by ma on 14/12/22.
//  Copyright (c) 2014年 Centillion. All rights reserved.
//

#import "CentChartTechMACD.h"
#import "CentChartProjectorLine.h"
#import "CentChartProjectorHistogram.h"
#import "CentChartDataCandle.h"
#import "CentChartTechnicalEMA.h"
#import "CentChartTechnicalMA.h"

@interface CentChartTechMACD()

@property (nonatomic) int index;
@property (nonatomic) int param12;
@property (nonatomic) int param26;
@property (nonatomic) int param9;
@property (retain, nonatomic) NSArray *data1;
@property (retain, nonatomic) NSArray *data2;
@property (retain, nonatomic) NSArray *data3;
@property (retain, nonatomic) CentChartProjectorLine *lineProjector;
@property (retain, nonatomic) CentChartProjectorHistogram *volumnProjector;

@end

@implementation CentChartTechMACD

- (id)init
{
    self = [super init];
    
    if (self) {
        self.lineProjector = [[CentChartProjectorLine alloc] init];
        self.volumnProjector = [[CentChartProjectorHistogram alloc] init];
    }
    
    return self;
}

- (id)initWithIndex:(int)index param12:(int)param12 param26:(int)param26 param9:(int)param9
{
    self = [self init];
    
    if (self) {
        self.index = index;
        self.param12 = param12;
        self.param26 = param26;
        self.param9 = param9;
        self.data1 = nil;
        self.data2 = nil;
        self.data3 = nil;
    }
    
    return self;
}

- (void) prepareData:(NSArray *)data
{
    @try {
        NSArray *dataEMA12 = [CentChartTechnicalEMA EMA:data withParam:self.param12];
        NSArray *dataEMA26 = [CentChartTechnicalEMA EMA:data withParam:self.param26];
        
        NSMutableArray *EMADEF = [NSMutableArray arrayWithCapacity:0];
        NSMutableArray *EMADEFCandle = [NSMutableArray arrayWithCapacity:0];
        
        for(int i = 0; i < dataEMA12.count; i++){
            NSNumber *MA12 = [dataEMA12 objectAtIndex:i];
            NSNumber *MA26 = [dataEMA26 objectAtIndex:i];
            double def = [MA12 doubleValue] - [MA26 doubleValue];
            [EMADEF addObject:[NSNumber numberWithDouble:def]];
            
            CentChartDataCandle *candle = [[CentChartDataCandle alloc] init];
            candle.close = def;
            [EMADEFCandle addObject:candle];
        }
        self.data1 = EMADEF;
        self.data2 = [CentChartTechnicalMA MA:EMADEFCandle param:self.param9];
        
        NSMutableArray *signal = [NSMutableArray arrayWithCapacity:0];
        
        for(int i = 0; i < EMADEF.count; i++){
            NSNumber *def = [EMADEF objectAtIndex:i];
            NSNumber *macd = [self.data2 objectAtIndex:i];
            NSNumber *s = [NSNumber numberWithDouble:[def doubleValue] - [macd doubleValue]];
            [signal addObject:s];
        }
        self.data3 = signal;
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
}

- (void) getDataMin:(double *)min max:(double *)max mapping:(CentChartMapping *)mapping
{
    if(self.data1 && 0 < [self.data1 count]) {
        int startIndex = (int)floor(mapping.dataRange.x);
        int endIndex = (int)ceil(mapping.dataRange.x + mapping.dataRange.y);
        
        startIndex = MAX(0, startIndex);
        endIndex = MIN((int)self.data1.count - 1, endIndex);
        
        for(int i = startIndex; i <= endIndex; i++) {
            NSNumber *dataMA12 = [self.data1 objectAtIndex:i];
            NSNumber *dataMA26 = [self.data2 objectAtIndex:i];
            NSNumber *dataMACD = [self.data3 objectAtIndex:i];
            
            if(!isnan(dataMA12.doubleValue) && !isnan(dataMA26.doubleValue) && !isnan(dataMACD.doubleValue)) {
                double MA12 = dataMA12.doubleValue;
                double MA26 = dataMA26.doubleValue;
//                double MACD = dataMACD.doubleValue;
                
                double v2 = MIN(MA12, MA26);
                double v1 = MAX(MA12, MA26);
                
                if(isnan(*min) || *min > v2) *min = v2;
                if(isnan(*max) || *max < v1) *max = v1;
                
                double abValue = MAX(fabs(*min), fabs(*max));
                *min = -abValue;
                *max = abValue;
                
            }
        }
    }
}

- (void) drawWithContext:(CGContextRef)context mapping:(CentChartMapping *)mapping
{
    if(self.data1) {
        NSArray *colors1 = @[mapping.theme.techMACDColors[0]];
        NSArray *colors2 = @[mapping.theme.techMACDColors[1]];
        NSArray *colors3 = @[mapping.theme.techMACDColors[2]];
        [self.lineProjector projectWithContext:context mapping:mapping data:self.data1 colors:colors1];
        [self.lineProjector projectWithContext:context mapping:mapping data:self.data2 colors:colors2];
        [self.volumnProjector projectWithContext:context mapping:mapping data:self.data3 colors:colors3];
    }
}

- (NSArray *) getColorLabels:(CentChartTheme *)theme
{
    CentChartColorLabel *label1 = [CentChartColorLabel labelWithColor:theme.techMACDColors[self.index] lable:[NSString stringWithFormat:@"MACD(%d,%d)", self.param12, self.param26]];
    CentChartColorLabel *label2 = [CentChartColorLabel labelWithColor:theme.techMACDColors[self.index + 1] lable:[NSString stringWithFormat:@"シグナル(%d)", self.param9]];
    CentChartColorLabel *label3 = [CentChartColorLabel labelWithColor:theme.techMACDColors[self.index + 2] lable:[NSString stringWithFormat:@"ビストグラム"]];
    
    return @[label1, label2, label3];
}

- (NSArray *) getDataLabels:(int)index
{
    if(index >= 0 && index < self.data1.count) {
        NSNumber *value = self.data1[index];
        
        if(isnan(value.doubleValue)) return nil;
        
        CentChartDataLabel *label1 = [CentChartDataLabel labelWithType:CentChartDataLabelTypeValue name:@"MACD" value:value];
        
        return @[label1];
    }
    else {
        return nil;
    }
}

@end
