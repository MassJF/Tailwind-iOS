//
//  CentChartTechnicalEMA.h
//  PushApp
//
//  Created by ma on 14/12/19.
//  Copyright (c) 2014年 Centillion. All rights reserved.
//

#import "CentChartTechnical.h"

@interface CentChartTechnicalEMA : CentChartTechnical

+(NSArray *)EMA:(NSArray *)data withParam:(int)param;
- (id)initWithIndex:(int)index param:(int)param;

@end
