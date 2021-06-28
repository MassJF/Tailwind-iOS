//
//  CentChartTechnicalRSI.m
//  PushApp
//
//  Created by ma on 14/12/18.
//  Copyright (c) 2014年 Centillion. All rights reserved.
//

#import "CentChartTechnicalRSI.h"
#import "CentChartProjectorLine.h"
#import "CentChartDataCandle.h"

@interface CentChartTechnicalRSI()

@property (nonatomic) int index;
@property (nonatomic) int param;
@property (retain, nonatomic) NSArray *data;
@property (retain, nonatomic) CentChartProjectorLine *projector;

@end

@implementation CentChartTechnicalRSI

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
    NSMutableArray *result = [NSMutableArray arrayWithCapacity:data.count];
    int param = self.param;
    
    for(int i = 0; i < [data count]; i++){
        double gain = 0;
        double loss = 0;

        if(i < param) {
            [result addObject:[NSNumber numberWithDouble:NAN]];
        }else{
            for(int j = i; j > i - param; j--){
                CentChartDataCandle *candle0 = [data objectAtIndex:j - 1];
                CentChartDataCandle *candle1 = [data objectAtIndex:j];
                double close0 = candle0.close;
                double close1 = candle1.close;
                
                if(close1 > close0){
                    gain += close1 - close0;
                }else{
                    loss += close0 - close1;
                }
            }
            
            if(gain + loss > 0){
                double rsi = gain / (gain + loss) * 100;
                [result addObject:[NSNumber numberWithDouble:rsi]];
            }else if(gain + loss == 0){
                [result addObject:[NSNumber numberWithDouble:NAN]];
            }
        }
    }
    self.data = result;
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
        NSArray *colors = @[mapping.theme.techRsiColors[self.index]];
        [self.projector projectWithContext:context mapping:mapping data:self.data colors:colors];
    }
}

- (NSArray *) getColorLabels:(CentChartTheme *)theme
{
    CentChartColorLabel *label = [CentChartColorLabel labelWithColor:theme.techRsiColors[self.index] lable:[NSString stringWithFormat:@"RSI(%d)", self.param]];
    
    return @[label];
}

- (NSArray *) getDataLabels:(int)index
{
    if(index >= 0 && index < self.data.count) {
        NSNumber *value = self.data[index];
        
        if(isnan(value.doubleValue)) return nil;
        
        CentChartDataLabel *label1 = [CentChartDataLabel labelWithType:CentChartDataLabelTypeValue name:[NSString stringWithFormat:@"RSI(%d)", self.param] value:value];
        
        return @[label1];
    }
    else {
        return nil;
    }
}


@end
