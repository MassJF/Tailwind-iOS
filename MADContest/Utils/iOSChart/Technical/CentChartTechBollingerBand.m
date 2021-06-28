//
//  CentChartTechBollingerBand.m
//  PushApp
//
//  Created by ma on 14/12/19.
//  Copyright (c) 2014年 Centillion. All rights reserved.
//

#import "CentChartTechBollingerBand.h"
#import "CentChartProjectorLine.h"
#import "CentChartDataCandle.h"

@interface CentChartTechBollingerBand()

@property (nonatomic) int index;
@property (nonatomic) int param;
@property (retain, nonatomic) NSArray *dataP2;
@property (retain, nonatomic) NSArray *dataP1;
@property (retain, nonatomic) NSArray *data;
@property (retain, nonatomic) NSArray *dataN1;
@property (retain, nonatomic) NSArray *dataN2;
@property (retain, nonatomic) CentChartProjectorLine *projector;

@end

@implementation CentChartTechBollingerBand

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
    NSMutableArray *resultP2 = [NSMutableArray arrayWithCapacity:data.count];
    NSMutableArray *resultP1 = [NSMutableArray arrayWithCapacity:data.count];
    NSMutableArray *result = [NSMutableArray arrayWithCapacity:data.count];
    NSMutableArray *resultN1 = [NSMutableArray arrayWithCapacity:data.count];
    NSMutableArray *resultN2 = [NSMutableArray arrayWithCapacity:data.count];
    
    int param = self.param;
    
    for(int i = 0; i < data.count; i++) {
        if(i < param - 1) {
            [resultP2 addObject:[NSNumber numberWithDouble:NAN]];
            [resultP1 addObject:[NSNumber numberWithDouble:NAN]];
            [result addObject:[NSNumber numberWithDouble:NAN]];
            [resultN1 addObject:[NSNumber numberWithDouble:NAN]];
            [resultN2 addObject:[NSNumber numberWithDouble:NAN]];
        } else {
            double sum = 0;
            
            for(int j = 0; j < param; j++) {
                CentChartDataCandle *candle = [data objectAtIndex:i - j];
                sum += candle.close;
            }
            double ma = sum / param;
            
            sum = 0;
            for(int k = 0; k < param; k++){
                CentChartDataCandle *candle = [data objectAtIndex:i - k];
                sum += pow(candle.close - ma, 2.0f);
            }
            double delta = sqrt(sum / param);
            
            [resultP2 addObject:[NSNumber numberWithDouble:ma + delta * 2]];
            [resultP1 addObject:[NSNumber numberWithDouble:ma + delta * 1]];
            [result addObject:[NSNumber numberWithDouble:ma]];
            [resultN1 addObject:[NSNumber numberWithDouble:ma - delta * 1]];
            [resultN2 addObject:[NSNumber numberWithDouble:ma - delta * 2]];
        }
    }
    self.dataP2 = resultP2;
    self.dataP1 = resultP1;
    self.data = result;
    self.dataN1 = resultN1;
    self.dataN2 = resultN2;
}

- (void) getDataMin:(double *)min max:(double *)max mapping:(CentChartMapping *)mapping
{
    if(self.data && 0 < [self.data count]) {
        NSInteger startIndex = (int)floor(mapping.dataRange.x);
        NSInteger endIndex = (int)ceil(mapping.dataRange.x + mapping.dataRange.y);
        
        startIndex = MAX(0, startIndex);
        endIndex = MIN(self.data.count - 1, endIndex);
        
        for(NSInteger i = startIndex; i <= endIndex; i++) {
            NSNumber *data1 = [self.dataP2 objectAtIndex:i];
            NSNumber *data2 = [self.dataN2 objectAtIndex:i];
            
            if(!isnan(data1.doubleValue) && !isnan(data2.doubleValue)) {
                double v1 = data1.doubleValue;
                double v2 = data2.doubleValue;
                
                if(isnan(*min) || *min > v2) *min = v2;
                if(isnan(*max) || *max < v1) *max = v1;
            }
        }
    }
}

- (void) drawWithContext:(CGContextRef)context mapping:(CentChartMapping *)mapping
{
    if(self.data) {
        NSArray *color1 = @[mapping.theme.techBollingerBandColors[0]];
        NSArray *color2 = @[mapping.theme.techBollingerBandColors[1]];
        NSArray *color3 = @[mapping.theme.techBollingerBandColors[2]];
        NSArray *color4 = @[mapping.theme.techBollingerBandColors[3]];
        NSArray *color5 = @[mapping.theme.techBollingerBandColors[4]];
        [self.projector projectWithContext:context mapping:mapping data:self.dataP2 colors:color3];
        [self.projector projectWithContext:context mapping:mapping data:self.dataP1 colors:color2];
        [self.projector projectWithContext:context mapping:mapping data:self.data colors:color1];
        [self.projector projectWithContext:context mapping:mapping data:self.dataN1 colors:color4];
        [self.projector projectWithContext:context mapping:mapping data:self.dataN2 colors:color5];
    }
}

- (NSArray *) getColorLabels:(CentChartTheme *)theme
{
    CentChartColorLabel *label = [CentChartColorLabel labelWithColor:theme.techBollingerBandColors[self.index] lable:@"ボリンジャーバンド"];
    
    return @[label];
}

- (NSArray *) getDataLabels:(int)index
{
    if(index >= 0 && index < self.data.count) {
        NSNumber *value = self.data[index];
        
        if(isnan(value.doubleValue)) return nil;
        
        CentChartDataLabel *label1 = [CentChartDataLabel labelWithType:CentChartDataLabelTypeValue name:@"ボリンジャーバンド" value:value];
        
        return @[label1];
    }
    else {
        return nil;
    }
}

@end
