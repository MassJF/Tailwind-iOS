//
//  CentChartPoint.h
//  JiuFuBao
//
//  Created by superMa on 2017/3/8.
//  Copyright © 2017年 taurus. All rights reserved.
//

#import "CentChartProjector.h"

@interface CentChartProjectorPoint : CentChartProjector

- (void) projectWithContext:(CGContextRef)context mapping:(CentChartMapping *)mapping data:(NSArray *)data colors:(NSArray *)colors radius:(CGFloat)radius;

@end
