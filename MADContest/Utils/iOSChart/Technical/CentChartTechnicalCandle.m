//
//  CentChartTechnicalCandle.m
//  MobileTest_iPhone
//
//  Created by wolf on 13-1-15.
//  Copyright (c) 2013年 wolf. All rights reserved.
//

#import "CentChartTechnicalCandle.h"
#import "CentChartProjectorCandle.h"
#import "CentChartDataCandle.h"
#import "CentChartUtil.h"

@interface CentChartTechnicalCandle ()

@property (retain, nonatomic) NSArray *candleData;
@property (retain, nonatomic) CentChartProjectorCandle *candleProjector;

@end


@implementation CentChartTechnicalCandle

- (id)init
{
    self = [super init];
    
    if (self) {
        self.candleData = nil;
        self.candleProjector = [[CentChartProjectorCandle alloc] init];
    }
    
    return self;
}

- (void) prepareData:(NSArray *)data
{
    self.candleData = data;
}

- (void) getDataMin:(double *)min max:(double *)max mapping:(CentChartMapping *)mapping
{
    if(self.candleData && 0 < [self.candleData count]) {
        NSInteger startIndex = floor(mapping.dataRange.x);
        NSInteger endIndex = ceil(mapping.dataRange.x + mapping.dataRange.y);
                        
        startIndex = MAX(0, startIndex);
        endIndex = MIN(self.candleData.count - 1, endIndex);
        
        for(NSInteger i = startIndex; i <= endIndex; i++) {
            CentChartDataCandle *data = (CentChartDataCandle *) [self.candleData objectAtIndex:i];
            
            if(isnan(*min) || *min > data.low) *min = data.low;
            if(isnan(*max) || *max < data.high) *max = data.high;
        }
    }
}

- (void) drawWithContext:(CGContextRef)context mapping:(CentChartMapping *)mapping
{
    if(self.candleData) {
        NSArray *colors = mapping.theme.techCandleColors;
        [self.candleProjector projectWithContext:context mapping:mapping data:self.candleData colors:colors];
    }
}

- (NSArray *) getDataLabels:(int)index
{
    if(index >= 0 && index < self.candleData.count) {
        CentChartDataCandle *candle = self.candleData[index];
        
        CentChartDataLabel *label1 = [CentChartDataLabel labelWithType:CentChartDataLabelTypeDate name:nil value:candle.timestamp];
        CentChartDataLabel *label2 = [CentChartDataLabel labelWithType:CentChartDataLabelTypeValue name:@"开盘" value:[NSNumber numberWithDouble:candle.open]];
        CentChartDataLabel *label3 = [CentChartDataLabel labelWithType:CentChartDataLabelTypeValue name:@"最高" value:[NSNumber numberWithDouble:candle.high]];
        CentChartDataLabel *label4 = [CentChartDataLabel labelWithType:CentChartDataLabelTypeValue name:@"最低" value:[NSNumber numberWithDouble:candle.low]];
        CentChartDataLabel *label5 = [CentChartDataLabel labelWithType:CentChartDataLabelTypeValue name:@"收盘" value:[NSNumber numberWithDouble:candle.close]];
//        [CentChartUtil bigNumberFormat:]
        
        NSString *value = [CentChartUtil bigNumberFormat:candle.volume];
        CentChartDataLabel *label6 = [CentChartDataLabel labelWithType:CentChartDataLabelTypeValue name:@"成交量" value:value];
        
        return @[label1, label2, label3, label4, label5, label6];
    }
    else {
        return nil;
    }
}

@end
