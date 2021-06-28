//
//  CentChartTechnicalAVG.m
//  CaiKuMobile
//
//  Created by ma on 13-3-25.
//  Copyright (c) 2013年 wolf. All rights reserved.
//

#import "CentChartTechnicalAVG.h"
#import "CentChartProjectorLine.h"
#import "CentChartDataCandle.h"


@interface CentChartTechnicalAVG ()

@property (retain, nonatomic) NSArray *data;
@property (retain, nonatomic) CentChartProjectorLine *projector;

@end

@implementation CentChartTechnicalAVG

- (id)init
{
    self = [super init];
    
    if (self) {
        self.data = nil;
        self.projector = [[CentChartProjectorLine alloc] init];
    }
    
    return self;
}

- (void) prepareData:(NSArray *)data
{
    NSMutableArray *result = [NSMutableArray arrayWithCapacity:data.count];
    
    double sum = 0.0f;
    
    for(int i = 0; i < [data count]; i++){
        CentChartDataCandle *candle = [data objectAtIndex:i];
        sum += candle.close;
        double avg = sum / (i + 1);
//        NSLog(@"------->>  ma = %@", [NSNumber numberWithDouble:avg]);
        [result addObject:[NSNumber numberWithDouble:avg]];
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
        NSArray *colors = @[mapping.theme.techAVGColor];
        [self.projector projectWithContext:context mapping:mapping data:self.data colors:colors];
    }
}

- (NSArray *) getColorLabels:(CentChartTheme *)theme
{
    CentChartColorLabel *label = [CentChartColorLabel labelWithColor:theme.techAVGColor lable:@"均价"];
    
    return @[label];
}

- (NSArray *) getDataLabels:(int)index
{
    if(index >= 0 && index < self.data.count) {
        NSNumber *value = self.data[index];
        
        if(isnan(value.doubleValue)) return nil;
        
        CentChartDataLabel *label1 = [CentChartDataLabel labelWithType:CentChartDataLabelTypeValue name:@"均价" value:value];
        
        return @[label1];
    }
    else {
        return nil;
    }
}

@end
