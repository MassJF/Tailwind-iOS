//
//  CentChartProjector.h
//  MobileTest_iPhone
//
//  Created by wolf on 13-1-15.
//  Copyright (c) 2013年 wolf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CentChartTheme.h"
#import "CentChartMapping.h"

@interface CentChartProjector : NSObject

- (void) projectWithContext:(CGContextRef)context mapping:(CentChartMapping *)mapping data:(NSArray *)data colors:(NSArray *)colors;

@end
