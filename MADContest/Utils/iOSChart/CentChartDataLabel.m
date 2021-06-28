//
//  CentChartDataLabel.m
//  MobileTest_iPhone
//
//  Created by wolf on 13-2-6.
//  Copyright (c) 2013年 wolf. All rights reserved.
//

#import "CentChartDataLabel.h"

@implementation CentChartDataLabel

+ (CentChartDataLabel *) labelWithType:(CentChartDataLabelType)type name:(NSString *)name value:(id)value
{
    CentChartDataLabel *dataLabel = [[CentChartDataLabel alloc] init];
    
    if(dataLabel) {
        dataLabel.type = type;
        dataLabel.name = name;
        dataLabel.value = value;
    }
    
    return dataLabel;
}

@end

