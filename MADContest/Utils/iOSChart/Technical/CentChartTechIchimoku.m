//
//  CentChartTechIchimoku.m
//  PushApp
//
//  Created by ma on 14/12/23.
//  Copyright (c) 2014年 Centillion. All rights reserved.
//

#import "CentChartTechIchimoku.h"
#import "CentChartProjectorLine.h"
#import "CentChartDataCandle.h"

@interface CentChartTechIchimoku()

@property (nonatomic) int index;
@property (nonatomic) int paramN;
@property (nonatomic) int paramM;
@property (nonatomic) int paramK;
@property (retain, nonatomic) NSArray *data1;
@property (retain, nonatomic) NSArray *data2;
@property (retain, nonatomic) NSArray *data3;
@property (retain, nonatomic) NSArray *data4;
@property (retain, nonatomic) NSArray *data5;
@property (retain, nonatomic) CentChartProjectorLine *lineProjector;

@end

@implementation CentChartTechIchimoku

- (id)init
{
    self = [super init];
    
    if (self) {
        self.lineProjector = [[CentChartProjectorLine alloc] init];
    }
    
    return self;
}

- (id)initWithIndex:(int)index paramN:(int)paramN paramM:(int)paramM paramK:(int)paramK
{
    self = [self init];
    
    if (self) {
        self.index = index;
        self.paramN = paramN;
        self.paramM = paramM;
        self.paramK = paramK;
        self.data1 = nil;
        self.data2 = nil;
        self.data3 = nil;
    }
    
    return self;
}

- (void) prepareData:(NSArray *)data
{
    @try {
        NSMutableArray *resultN = [NSMutableArray arrayWithCapacity:0];
        NSMutableArray *resultM = [NSMutableArray arrayWithCapacity:0];
        NSMutableArray *resultPrecede1 = [NSMutableArray arrayWithCapacity:0];
        NSMutableArray *resultClose = [NSMutableArray arrayWithCapacity:0];
        NSMutableArray *resultPrecede2 = [NSMutableArray arrayWithCapacity:0];
        
        NSMutableArray *placeHoldArray = [NSMutableArray arrayWithCapacity:25];
        for(int j = 0; j < self.paramK - 1; j++){
            [placeHoldArray addObject:[NSNumber numberWithDouble:NAN]];
        }
        [resultPrecede1 addObjectsFromArray:placeHoldArray];
        [resultPrecede2 addObjectsFromArray:placeHoldArray];
        
        for(int i = 0; i < [data count]; i++){
            CentChartDataCandle *candle = [data objectAtIndex:i];
            if(candle.invalid){
                continue;
            }
            
            [resultN addObject:[CentChartTechIchimoku ichimoku:data index:i param:self.paramN]];
            [resultM addObject:[CentChartTechIchimoku ichimoku:data index:i param:self.paramM]];
            
            
            if(i < self.paramM + self.paramK - 2){
                [resultPrecede1 addObject:[NSNumber numberWithDouble:NAN]];
            }else{
                NSNumber *n = [CentChartTechIchimoku ichimoku:data index:i param:self.paramN];
                NSNumber *m = [CentChartTechIchimoku ichimoku:data index:i param:self.paramM];
                [resultPrecede1 addObject:[NSNumber numberWithDouble:([n doubleValue] + [m doubleValue]) / 2]];
            }
            
            if(i > self.paramK - 2){
                
                [resultClose addObject:[NSNumber numberWithDouble:candle.close]];
            }
            
            if(i < self.paramK * 2 - 1){
                [resultPrecede2 addObject:[NSNumber numberWithDouble:NAN]];
            }else{
                [resultPrecede2 addObject:[CentChartTechIchimoku ichimoku:data index:i param:self.paramK * 2]];
            }
            
        }
        [resultClose addObjectsFromArray:placeHoldArray];
        
        self.data1 = resultN;
        self.data2 = resultM;
        self.data3 = resultPrecede1;
        self.data4 = resultClose;
        self.data5 = resultPrecede2;
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
}

+(NSNumber *)ichimoku:(NSArray *)data index:(int)index param:(int)param{
    
    if(index < param - 1){
        return [NSNumber numberWithDouble:NAN];
    }else{
        double minLow = MAXFLOAT;
        double maxHigh = -MAXFLOAT;
        
        for(int j = index; j > index - param; j--){
            CentChartDataCandle *candle = [data objectAtIndex:j];
            
            if(candle.low < minLow) minLow = candle.low;
            if(candle.high > maxHigh) maxHigh = candle.high;
        }
        return [NSNumber numberWithDouble:(minLow + maxHigh) / 2];
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
            NSNumber *data4 = [self.data4 objectAtIndex:i];
            NSNumber *data5 = [self.data5 objectAtIndex:i];
            
            if(!isnan(data1.doubleValue) &&
               !isnan(data2.doubleValue) &&
               !isnan(data3.doubleValue) &&
               !isnan(data4.doubleValue) &&
               !isnan(data5.doubleValue)) {
                
                double MA1 = data1.doubleValue;
                double MA2 = data2.doubleValue;
                double MA3 = data3.doubleValue;
                double MA4 = data4.doubleValue;
                double MA5 = data5.doubleValue;
                
                double v2 = MIN(MA1, MIN(MA2, MIN(MA3, MIN(MA4, MA5))));
                double v1 = MAX(MA1, MAX(MA2, MAX(MA3, MAX(MA4, MA5))));
                
                if(isnan(*min) || *min > v2) *min = v2;
                if(isnan(*max) || *max < v1) *max = v1;
                
            }
        }
    }
}

- (void) drawWithContext:(CGContextRef)context mapping:(CentChartMapping *)mapping
{
    if(self.data1) {
        NSArray *colors1 = @[mapping.theme.techIchimokuColors[self.index]];
        NSArray *colors2 = @[mapping.theme.techIchimokuColors[self.index + 1]];
        NSArray *colors3 = @[mapping.theme.techIchimokuColors[self.index + 2]];
        NSArray *colors4 = @[mapping.theme.techIchimokuColors[self.index + 3]];
        NSArray *colors5 = @[mapping.theme.techIchimokuColors[self.index + 4]];
        
        [CentChartTechIchimoku drawShadowWithData1:self.data3 data2:self.data5 context:context mappint:mapping];
        
        [self.lineProjector projectWithContext:context mapping:mapping data:self.data1 colors:colors1];
        [self.lineProjector projectWithContext:context mapping:mapping data:self.data2 colors:colors2];
        [self.lineProjector projectWithContext:context mapping:mapping data:self.data3 colors:colors3];
        [self.lineProjector projectWithContext:context mapping:mapping data:self.data4 colors:colors4];
        [self.lineProjector projectWithContext:context mapping:mapping data:self.data5 colors:colors5];
    }
}

+(void)drawShadowWithData1:(NSArray *)data1 data2:(NSArray *)data2 context:(CGContextRef)context mappint:(CentChartMapping *)mapping{
    
    @try {
        int startIndex = mapping.dataRange.x;
        int endIndex = mapping.dataRange.x + mapping.dataRange.y;
        startIndex = MAX(0, startIndex);
        endIndex = MIN((int)data1.count - 1, endIndex);
        
        CGContextSetFillColorWithColor(context, [[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.1] CGColor]);
        CGContextBeginPath(context);
        
        int valideStartIndex = startIndex;
        double y1 = [[data1 objectAtIndex:startIndex] doubleValue];
        double y2 = [[data2 objectAtIndex:startIndex] doubleValue];
        
        if(isnan(y1) || isnan(y2)){
            for(int i = startIndex; i <= endIndex; i++){
                y1 = [[data1 objectAtIndex:i] doubleValue];
                y2 = [[data2 objectAtIndex:i] doubleValue];
                if(!isnan(y1) && !isnan(y2)){
                    valideStartIndex = i;
                    break;
                }
                if(i == endIndex)
                    return;
            }
        }
        
        float startX = roundf([mapping transformIndex:valideStartIndex]) + 0.5;
        float startY = roundf([mapping transformValue:y1]) + 0.5;
        CGContextMoveToPoint(context, startX, startY);
        CGContextAddLineToPoint(context, startX, startY);
        
        for(int i = valideStartIndex; i <= endIndex; i++){
            double startY1 = [[data1 objectAtIndex:i] doubleValue];
            double startY2 = [[data2 objectAtIndex:i] doubleValue];
            if(!isnan(startY1) && !isnan(startY2)){
                float x = roundf([mapping transformIndex:i]) + 0.5;
                float y = roundf([mapping transformValue:startY1]) + 0.5;
                CGContextAddLineToPoint(context, x, y);
            }
        }
        
        double dy = [[data2 objectAtIndex:endIndex] doubleValue];
        float endX = roundf([mapping transformIndex:endIndex]) + 0.5;
        float endY = roundf([mapping transformValue:dy]) + 0.5;
        CGContextAddLineToPoint(context, endX, endY);
        
        for(int i = endIndex; i >= valideStartIndex; i--){
            double startY2 = [[data2 objectAtIndex:i] doubleValue];
            double startY1 = [[data1 objectAtIndex:i] doubleValue];
            if(!isnan(startY2) && !isnan(startY1)){
                float x = roundf([mapping transformIndex:i]) + 0.5;
                float y = roundf([mapping transformValue:startY2]) + 0.5;
                CGContextAddLineToPoint(context, x, y);
            }
        }
        
        
        CGContextFillPath(context);
    }
    @catch (NSException *exception) {
        NSLog(@"CentChart ichimoku drawShadow method exception.");
    }
    @finally {
        
    }
    
}

- (NSArray *) getColorLabels:(CentChartTheme *)theme
{
    CentChartColorLabel *label1 = [CentChartColorLabel labelWithColor:theme.techIchimokuColors[self.index] lable:[NSString stringWithFormat:@"一目均衡表"]];
    
    return @[label1];
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
