//
//  CentChartDataCandle.h
//  MobileTest_iPhone
//
//  Created by wolf on 13-1-15.
//  Copyright (c) 2013年 wolf. All rights reserved.
//

#import "CentChartData.h"

@interface CentChartDataCandle : CentChartData

@property (strong, nonatomic) NSDate *timestamp;
@property (nonatomic) double open;
@property (nonatomic) double high;
@property (nonatomic) double low;
@property (nonatomic) double close;
@property (nonatomic) double volume;
@property (nonatomic) double balance;
@property (nonatomic) double totleBalance;
@property (nonatomic) NSString *signalType;
@property (nonatomic) BOOL invalid;

@end
