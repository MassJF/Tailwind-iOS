//
//  CentChartDataTick.h
//  MobileTest_iPhone
//
//  Created by wolf on 13-1-18.
//  Copyright (c) 2013年 wolf. All rights reserved.
//

#import "CentChartData.h"

@interface CentChartDataTick : CentChartData

@property (strong, nonatomic) NSDate *timestamp;
@property (nonatomic) double price;

@end
