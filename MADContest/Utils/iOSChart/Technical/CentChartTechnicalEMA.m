//
//  CentChartTechnicalEMA.m
//  PushApp
//
//  Created by ma on 14/12/19.
//  Copyright (c) 2014年 Centillion. All rights reserved.
//

#import "CentChartTechnicalEMA.h"
#import "CentChartProjectorLine.h"
#import "CentChartDataCandle.h"

@interface CentChartTechnicalEMA()

@property (nonatomic) int index;
@property (nonatomic) int param;
@property (retain, nonatomic) NSArray *data;
@property (retain, nonatomic) CentChartProjectorLine *projector;

@end

@implementation CentChartTechnicalEMA

- (id)init
{
    self = [super init];
    
    if (self) {
        self.projector = [[CentChartProjectorLine alloc] init];
    }
    
    return self;
}

- (id)initWithIndex:(int)index param:(int)param
{
    self = [self init];
    
    if (self) {
        self.index = index;
        self.param = param;
        self.data = nil;
    }
    
    return self;
}

- (void) prepareData:(NSArray *)data
{
    self.data = [CentChartTechnicalEMA EMA:data withParam:self.param];
}

+(NSArray *)EMA:(NSArray *)data withParam:(int)param{
    NSMutableArray *result = [NSMutableArray arrayWithCapacity:data.count];
    
    for(int i = 0; i < [data count]; i++){
        double temp = 0;
        
        if(i < param - 1) {
            [result addObject:[NSNumber numberWithDouble:NAN]];
        }else if(i == (param - 1)){
            for(int j = i; j > i - param; j--){
                id obj = [data objectAtIndex:j];
                
                if([obj isKindOfClass:[CentChartDataCandle class]]){
                    CentChartDataCandle *candle = obj;
                    candle = [data objectAtIndex:j];
                    temp += candle.close;
                }
            }
            temp /= param;
            [result addObject:[NSNumber numberWithDouble:temp]];
        }else if(i > param - 1){
            NSNumber *n1 = [result objectAtIndex:i - 1];
            double n2 = 0.0f;
            
            id obj = [data objectAtIndex:i];
            
            if([obj isKindOfClass:[CentChartDataCandle class]]){
                CentChartDataCandle *candle = obj;
                n2 = [candle close];
            }
            
            temp = [n1 doubleValue] + (n2 - [n1 doubleValue]) * 2 / (1 + param);
            [result addObject:[NSNumber numberWithDouble:temp]];
        }
    }
    return result;
}

- (void) getDataMin:(double *)min max:(double *)max mapping:(CentChartMapping *)mapping
{
    if(self.data && 0 < [self.data count]) {
        NSInteger startIndex = (int)floor(mapping.dataRange.x);
        NSInteger endIndex = (int)ceil(mapping.dataRange.x + mapping.dataRange.y);
        
        startIndex = MAX(0, startIndex);
        endIndex = MIN(self.data.count - 1, endIndex);
        
        for(NSInteger i = startIndex; i <= endIndex; i++) {
            NSNumber *data = [self.data objectAtIndex:i];
            
            if(!isnan(data.doubleValue)) {
                double v = data.doubleValue;
                
                if(isnan(*min) || *min > v) *min = v;
                if(isnan(*max) || *max < v) *max = v;
            }
        }
    }
}

- (void) drawWithContext:(CGContextRef)context mapping:(CentChartMapping *)mapping
{
    if(self.data) {
        NSArray *colors = @[mapping.theme.techEMAColors[self.index]];
        [self.projector projectWithContext:context mapping:mapping data:self.data colors:colors];
    }
}

- (NSArray *) getColorLabels:(CentChartTheme *)theme
{
    CentChartColorLabel *label = [CentChartColorLabel labelWithColor:theme.techEMAColors[self.index] lable:[NSString stringWithFormat:@"EMA(%d)", self.param]];
    
    return @[label];
}

- (NSArray *) getDataLabels:(int)index
{
    if(index >= 0 && index < self.data.count) {
        NSNumber *value = self.data[index];
        
        if(isnan(value.doubleValue)) return nil;
        
        CentChartDataLabel *label1 = [CentChartDataLabel labelWithType:CentChartDataLabelTypeValue name:[NSString stringWithFormat:@"EMA(%d)", self.param] value:value];
        
        return @[label1];
    }
    else {
        return nil;
    }
}


@end
