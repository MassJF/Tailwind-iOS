//
//  iOSChartReturnRatioTechnical.m
//  zgxt
//
//  Created by superMa on 16/1/3.
//  Copyright © 2016年 htqh. All rights reserved.
//

#import "iOSChartReturnRatioTechnical.h"
#import "CentChartDataCandle.h"
#import "iOSChartProjectorReturnRatio.h"

#define RGB(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]

@interface iOSChartReturnRatioTechnical ()

@property (retain, nonatomic) NSArray *candleData;
@property (retain, nonatomic) iOSChartProjectorReturnRatio *returnRatioProjector;

@end

@implementation iOSChartReturnRatioTechnical

- (id)init
{
    self = [super init];
    
    if (self) {
        self.candleData = nil;
        self.returnRatioProjector = [[iOSChartProjectorReturnRatio alloc] init];
    }
    
    return self;
}

- (void) prepareData:(NSArray *)data
{
    self.candleData = data;
}

- (void) getDataMin:(double *)min max:(double *)max mapping:(CentChartMapping *)mapping
{
    if(self.candleData) {
        NSInteger startIndex = (int)floor(mapping.dataRange.x);
        NSInteger endIndex = (int)ceil(mapping.dataRange.x + mapping.dataRange.y);
        
        startIndex = MAX(0, startIndex);
        endIndex = MIN(self.candleData.count - 1, endIndex);
        
        for(NSInteger i = startIndex; i <= endIndex; i++) {
            CentChartDataCandle *data = [self.candleData objectAtIndex:i];
            
            if(isnan(*min) || *min > data.volume) *min = data.volume;
            if(isnan(*max) || *max < data.volume) *max = data.volume;
        }
    }
}

- (void) drawWithContext:(CGContextRef)context mapping:(CentChartMapping *)mapping
{
    if(self.candleData) {
        NSArray *colors = @[RGB(0xEB, 0x75, 0x02), RGB(0x77, 0x9D, 0xCB)];
        [self.returnRatioProjector projectWithContext:context mapping:mapping data:self.candleData colors:colors];
    }
}

- (NSArray *) getColorLabels:(CentChartTheme *)theme
{
    //    CentChartColorLabel *label1 = [CentChartColorLabel labelWithColor:theme.techVolumeColors[0] lable:@""];
    //    CentChartColorLabel *label2 = [CentChartColorLabel labelWithColor:theme.techVolumeColors[1] lable:@"VOLUME"];
    
    return /*@[label1, label2]*/nil;
}

- (NSArray *) getDataLabels:(int)index
{
    if(index >= 0 && index < [self.candleData count]) {
        CentChartDataCandle* candle = [self.candleData objectAtIndex:index];
        NSDate* timestamp = candle.timestamp;
        NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy/MM"];
        NSString* timestampStr = [dateFormatter stringFromDate:timestamp];
        
        CentChartDataLabel *label = [CentChartDataLabel labelWithType:CentChartDataLabelTypeRate name:timestampStr value:[NSNumber numberWithDouble:candle.volume]];
        
        return @[label];
    }
    else {
        return nil;
    }
}

@end
