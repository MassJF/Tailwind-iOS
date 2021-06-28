//
//  CentChartLayerDraw.h
//  MobileTest_iPhone
//
//  Created by wolf on 13-1-24.
//  Copyright (c) 2013年 wolf. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "CentChart.h"

@interface CentChartLayerDraw : CALayer

@property (nonatomic) BOOL drawAxisBoard;
@property (nonatomic) float candleWidth;
@property (retain, nonatomic) NSString *code;
//@property (nonatomic) double yesterdayEndPrice;
@property (assign, nonatomic) CentChartPeriod period;
@property (retain, nonatomic) CentChartTheme *theme;
@property (retain, nonatomic) NSArray *views;
@property (retain, nonatomic) NSArray *data;
@property (assign, nonatomic) CGPoint dataRange;

@property (assign, nonatomic) BOOL needUpdateScrollCache;


@end
