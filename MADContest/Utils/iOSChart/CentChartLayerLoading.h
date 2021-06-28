//
//  CentChartLayerLoading.h
//  MobileTest_iPhone
//
//  Created by wolf on 13-2-21.
//  Copyright (c) 2013年 wolf. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "CentChart.h"

@interface CentChartLayerLoading : CALayer

@property (retain, nonatomic) CentChartTheme *theme;
@property (retain, nonatomic) NSArray *views;
@property (assign, nonatomic) CGPoint loadingLocation;
@property (assign, nonatomic) CGFloat loadingRotation;

@end
