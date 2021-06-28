//
//  CentChartDataLabel.h
//  MobileTest_iPhone
//
//  Created by wolf on 13-2-6.
//  Copyright (c) 2013年 wolf. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef enum {
    CentChartDataLabelTypeDate = 1,
    CentChartDataLabelTypeTitle = 2,
    CentChartDataLabelTypeValue = 3,
    CentChartDataLabelTypeRate = 4
} CentChartDataLabelType;


@interface CentChartDataLabel : NSObject

@property (assign, nonatomic) CentChartDataLabelType type;
@property (retain, nonatomic) NSString *name;
@property (retain, nonatomic) id value;

+ (CentChartDataLabel *) labelWithType:(CentChartDataLabelType)type name:(NSString *)name value:(id)value;

@end
