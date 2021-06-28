//
//  CentChartTechTotoalBalance.m
//  PushApp
//
//  Created by ma on 14/12/29.
//  Copyright (c) 2014年 Centillion. All rights reserved.
//

#import "CentChartTechTotoalBalance.h"
#import "CentChartDataCandle.h"
#import "CentChartProjectorBalance.h"

@interface CentChartTechTotoalBalance()

@property (retain, nonatomic) NSArray *data;
@property (strong, nonatomic) CentChartProjectorBalance *balanceProjector;

@end

@implementation CentChartTechTotoalBalance

- (id)init
{
    self = [super init];
    
    if (self) {
        self.balanceProjector = [[CentChartProjectorBalance alloc] init];
    }
    
    return self;
}

- (void) prepareData:(NSArray *)data
{
    NSMutableArray *result = [NSMutableArray arrayWithCapacity:[data count]];
    
    CentChartDataCandle *candle = [data objectAtIndex:0];
    double frontBalance = candle.totleBalance;
    if(isnan(frontBalance)){
        frontBalance = 0.0f;
    }
    [result addObject:[NSNumber numberWithDouble:frontBalance]];
    for(int i = 1; i < [data count]; i++){
        CentChartDataCandle *nextCandle = [data objectAtIndex:i];
        if(nextCandle.invalid){
            continue;
        }
        double balance = nextCandle.totleBalance;
        if(isnan(balance) || balance == 0.0f){
            balance = frontBalance;
        }else{
            frontBalance = balance;
        }
        [result addObject:[NSNumber numberWithDouble:balance]];
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
    if(self.data){
        [self.balanceProjector projectWithContext:context mapping:mapping data:self.data colors:mapping.theme.techBalanceColors];
    }
}

- (NSArray *) getColorLabels:(CentChartTheme *)theme
{
    return nil;
}

- (NSArray *) getDataLabels:(int)index
{
    return nil;
}

@end
