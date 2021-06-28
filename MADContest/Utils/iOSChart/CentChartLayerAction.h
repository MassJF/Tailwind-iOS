//
//  CentChartLayerAction.h
//  MobileTest_iPhone
//
//  Created by wolf on 13-2-2.
//  Copyright (c) 2013年 wolf. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "CentChart.h"

@interface CentChartLayerAction : CALayer

@property (assign, nonatomic) CentChartPeriod period;
@property (retain, nonatomic) CentChartTheme *theme;
@property (retain, nonatomic) NSArray *views;
//@property (retain, nonatomic) CentChartTechnical *crossDependentTechnical;
@property (assign, nonatomic) CGPoint dataRange;
@property (assign, nonatomic) CGPoint actionLocation;

@end
