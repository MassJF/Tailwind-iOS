//
//  CentChartColorLabel.m
//  MobileTest_iPhone
//
//  Created by wolf on 13-2-6.
//  Copyright (c) 2013年 wolf. All rights reserved.
//

#import "CentChartColorLabel.h"

@implementation CentChartColorLabel

+ (CentChartColorLabel *) labelWithColor:(UIColor *)color lable:(NSString *)label
{
    CentChartColorLabel *colorLabel = [[CentChartColorLabel alloc] init];
 
    if(colorLabel) {
        colorLabel.color = color;
        colorLabel.label = label;
    }
    
    return colorLabel;
}


@end
