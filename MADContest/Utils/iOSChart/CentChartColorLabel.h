//
//  CentChartColorLabel.h
//  MobileTest_iPhone
//
//  Created by wolf on 13-2-6.
//  Copyright (c) 2013年 wolf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface CentChartColorLabel : NSObject

@property (retain, nonatomic) UIColor *color;
@property (retain, nonatomic) NSString *label;

+ (CentChartColorLabel *) labelWithColor:(UIColor *)color lable:(NSString *)label;

@end
