//
//  CentChartTechStochastics.m
//  PushApp
//
//  Created by ma on 14/12/23.
//  Copyright (c) 2014年 Centillion. All rights reserved.
//

#import "CentChartTechStochastics.h"
#import "CentChartProjectorLine.h"
#import "CentChartDataCandle.h"

@interface CentChartTechStochastics()

@property (nonatomic) int index;
@property (nonatomic) int paramPerK;
@property (nonatomic) int paramPerD;
@property (nonatomic) int paramSlowPerD;
@property (retain, nonatomic) NSArray *data1;
@property (retain, nonatomic) NSArray *data2;
@property (retain, nonatomic) NSArray *data3;
@property (retain, nonatomic) CentChartProjectorLine *lineProjector;

@end

@implementation CentChartTechStochastics

- (id)init
{
    self = [super init];
    
    if (self) {
        self.lineProjector = [[CentChartProjectorLine alloc] init];
    }
    
    return self;
}

- (id)initWithIndex:(int)index paramPerK:(int)paramPerK paramPerD:(int)paramPerD paramSlowPerD:(int)paramSlowPerD
{
    self = [self init];
    
    if (self) {
        self.index = index;
        self.paramPerK = paramPerK;
        self.paramPerD = paramPerD;
        self.paramSlowPerD = paramSlowPerD;
        self.data1 = nil;
        self.data2 = nil;
        self.data3 = nil;
    }
    
    return self;
}

- (void) prepareData:(NSArray *)data
{
    @try {
        NSMutableArray *resultPerK = [NSMutableArray arrayWithCapacity:0];
        NSMutableArray *resultPerD = [NSMutableArray arrayWithCapacity:0];
        NSMutableArray *resultSlowPerD = [NSMutableArray arrayWithCapacity:0];
        
        for(int i = 0; i < [data count]; i++){
            
            
            if(i < self.paramPerK - 1){
                [resultPerK addObject:[NSNumber numberWithDouble:NAN]];
            }else{
                double minLow = MAXFLOAT;
                double maxHigh = -MAXFLOAT;
                CentChartDataCandle *lastCandle = [data objectAtIndex:i];
                
                for(int j = i; j > i - self.paramPerK; j--){
                    CentChartDataCandle *candle = [data objectAtIndex:j];
                    
                    if(candle.low < minLow) minLow = candle.low;
                    if(candle.high > maxHigh) maxHigh = candle.high;
                    
                }
                double v = (lastCandle.close - minLow) / (maxHigh - minLow) * 100;
                [resultPerK addObject:[NSNumber numberWithDouble:v]];
            }
            
            [resultPerD addObject:[CentChartTechStochastics perD:data withIndex:i withParamPerD:self.paramPerD withParamPerK:self.paramPerK]];
            
            if(i < self.paramPerD + self.paramPerK + self.paramSlowPerD - 3){
                [resultSlowPerD addObject:[NSNumber numberWithDouble:NAN]];
            }else{
                double sum = 0.0f, num = 0.0f;
                for(int j = i; j > i - self.paramSlowPerD; j--){
                    NSNumber *perD = [CentChartTechStochastics perD:data withIndex:j withParamPerD:self.paramPerD withParamPerK:self.paramPerK];
                    sum += [perD doubleValue];
                    num++;
                }
                if(num != 0.0f) [resultSlowPerD addObject:[NSNumber numberWithDouble:sum / num]];
            }
            
        }
        self.data1 = resultPerK;
        self.data2 = resultPerD;
        self.data3 = resultSlowPerD;
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
}

+(NSNumber *)perD:(NSArray *)data withIndex:(int)index withParamPerD:(int)paramPerD withParamPerK:(int)paramPerK{
    
    
    if(index < paramPerK + paramPerD - 2){
        return [NSNumber numberWithDouble:NAN];
    }else{
        double deno = 0.0f, num = 0.0f;
        for(int j = index; j > index - paramPerD; j--){
            CentChartDataCandle *candle = [data objectAtIndex:j];
            double high = candle.high;
            double low = candle.low;
            
            for(int k = 0; k < paramPerK; k++){
                CentChartDataCandle *currentCandle = [data objectAtIndex:j - k];
                if(currentCandle.high > high){
                    high = currentCandle.high;
                }
                if(currentCandle.low < low){
                    low = currentCandle.low;
                }
            }
            num += candle.close - low;
            deno += high - low;
        }
        if(deno == 0.0f){
            return [NSNumber numberWithDouble:0.0f];
        }else{
            return [NSNumber numberWithDouble:num / deno * 100];
        }
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
            NSNumber *data1 = [self.data1 objectAtIndex:i];
            NSNumber *data2 = [self.data2 objectAtIndex:i];
            NSNumber *data3 = [self.data3 objectAtIndex:i];
            
            if(!isnan(data1.doubleValue) && !isnan(data2.doubleValue) && !isnan(data3.doubleValue)) {
                double MA1 = data1.doubleValue;
                double MA2 = data2.doubleValue;
                double MA3 = data3.doubleValue;
                
                double v2 = MIN(MA1, MIN(MA2, MA3));
                double v1 = MAX(MA1, MAX(MA2, MA3));
                
                if(isnan(*min) || *min > v2) *min = v2;
                if(isnan(*max) || *max < v1) *max = v1;
                
            }
        }
    }
}

- (void) drawWithContext:(CGContextRef)context mapping:(CentChartMapping *)mapping
{
    if(self.data1) {
        NSArray *colors1 = @[mapping.theme.techStochasticColors[0]];
        NSArray *colors2 = @[mapping.theme.techStochasticColors[1]];
        NSArray *colors3 = @[mapping.theme.techStochasticColors[2]];
        [self.lineProjector projectWithContext:context mapping:mapping data:self.data1 colors:colors1];
        [self.lineProjector projectWithContext:context mapping:mapping data:self.data2 colors:colors2];
        [self.lineProjector projectWithContext:context mapping:mapping data:self.data3 colors:colors3];
    }
}

- (NSArray *) getColorLabels:(CentChartTheme *)theme
{
    CentChartColorLabel *label1 = [CentChartColorLabel labelWithColor:theme.techIchimokuColors[self.index] lable:[NSString stringWithFormat:@"%%K(%d)", self.paramPerK]];
    CentChartColorLabel *label2 = [CentChartColorLabel labelWithColor:theme.techIchimokuColors[self.index + 1] lable:[NSString stringWithFormat:@"%%D(%d)", self.paramPerD]];
    CentChartColorLabel *label3 = [CentChartColorLabel labelWithColor:theme.techIchimokuColors[self.index + 4] lable:[NSString stringWithFormat:@"Slow%%D(%d)", self.paramSlowPerD]];
    
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
