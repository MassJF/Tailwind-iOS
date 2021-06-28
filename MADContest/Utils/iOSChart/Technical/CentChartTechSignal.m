//
//  CentChartTechSignal.m
//  PushApp
//
//  Created by ma on 14/12/24.
//  Copyright (c) 2014年 Centillion. All rights reserved.
//

#import "CentChartTechSignal.h"
#import "CentchartProjectorSignal.h"

@interface CentChartTechSignal()

@property (retain, nonatomic) NSArray *data;
@property (strong, nonatomic) CentchartProjectorSignal *signalProjector;

@end

@implementation CentChartTechSignal

- (id)init
{
    self = [super init];
    
    if (self) {
        self.signalProjector = [[CentchartProjectorSignal alloc] init];
    }
    
    return self;
}

- (void) prepareData:(NSArray *)data
{
    self.data = data;
}

- (void) getDataMin:(double *)min max:(double *)max mapping:(CentChartMapping *)mapping
{
    
}

- (void) drawWithContext:(CGContextRef)context mapping:(CentChartMapping *)mapping
{
    [self.signalProjector projectWithContext:context mapping:mapping data:self.data colors:mapping.theme.techSignalColors];
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
