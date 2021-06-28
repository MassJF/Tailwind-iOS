//
//  CentChartTechnicalMA.m
//  MobileTest_iPhone
//
//  Created by wolf on 13-1-23.
//  Copyright (c) 2013年 wolf. All rights reserved.
//

#import "CentChartTechnicalMA.h"
#import "CentChartProjectorLine.h"
#import "CentChartDataCandle.h"

@interface CentChartTechnicalMA ()

@property (nonatomic) int index;
@property (nonatomic) int param;
@property (retain, nonatomic) NSArray *data;
@property (retain, nonatomic) CentChartProjectorLine *projector;

@end


@implementation CentChartTechnicalMA

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
    self.data = [CentChartTechnicalMA MA:data param:self.param];
}

+(NSArray *)MA:(NSArray *)data param:(int)param{
    NSMutableArray *result = [NSMutableArray arrayWithCapacity:data.count];
    
    for(int i = 0; i < data.count; i++) {
        if(i < param - 1) {
            [result addObject:[NSNumber numberWithDouble:NAN]];
        }
        else {
            double sum = 0;
            
            for(int j = 0; j < param; j++) {
                CentChartDataCandle *candle = [data objectAtIndex:i - j];
                sum += candle.close;
            }
            
            double ma = sum / param;
            
            [result addObject:[NSNumber numberWithDouble:ma]];
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
        NSArray *colors = @[mapping.theme.techMaColors[self.index]];
        [self.projector projectWithContext:context mapping:mapping data:self.data colors:colors];
    }
}

- (NSArray *) getColorLabels:(CentChartTheme *)theme
{
    CentChartColorLabel *label = [CentChartColorLabel labelWithColor:theme.techMaColors[self.index] lable:[NSString stringWithFormat:@"MA(%d)", self.param]];
    
    return @[label];
}

- (NSArray *) getDataLabels:(int)index
{
    if(index >= 0 && index < self.data.count) {
        NSNumber *value = self.data[index];
        
        if(isnan(value.doubleValue)) return nil;
        
        CentChartDataLabel *label1 = [CentChartDataLabel labelWithType:CentChartDataLabelTypeValue name:[NSString stringWithFormat:@"MA(%d)", self.param] value:value];
        
        return @[label1];
    }
    else {
        return nil;
    }
}

@end
