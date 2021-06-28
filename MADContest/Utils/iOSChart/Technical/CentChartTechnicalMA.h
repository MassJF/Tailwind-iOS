//
//  CentChartTechnicalMA.h
//  MobileTest_iPhone
//
//  Created by wolf on 13-1-23.
//  Copyright (c) 2013年 wolf. All rights reserved.
//

#import "CentChartTechnical.h"

@interface CentChartTechnicalMA : CentChartTechnical

+(NSArray *)MA:(NSArray *)data param:(int)param;
- (id)initWithIndex:(int)index param:(int)param;

@end
