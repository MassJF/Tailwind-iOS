//
//  CentChartTheme.h
//  MobileTest_iPhone
//
//  Created by wolf on 13-1-15.
//  Copyright (c) 2013年 wolf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

//typedef enum {
//    JING_ZHI_ZOU_SHI = 0,
//    YUE_JI_DU_SHOU_YI_LV
//} CHARTSTYLE;

typedef enum {
    CentChartPeriodTick = 1,
    CentChartPeriodCandle1Minute,
    CentChartPeriodCandle5Minute,
    CentChartPeriodCandle10Minute,
    CentChartPeriodCandle15Minute,
    CentChartPeriodCandle30Minute,
    CentChartPeriodCandle1Hour,
    CentChartPeriodCandle2Hour,
    CentChartPeriodCandle4Hour,
    CentChartPeriodCandle1Day,
    CentChartPeriodCandle1Week,
    CentChartPeriodCandle1Month,
    CentChartStyleJingZhiZouShi,
    CentChartStyleYueJiDuShouYiLv
} CentChartPeriod;


@interface CentChartTheme : NSObject

@property (assign, nonatomic) CGFloat chartPadding;
@property (assign, nonatomic) CGFloat chartPaddingLeft;
@property (assign, nonatomic) CGFloat chartPaddingTop;
@property (assign, nonatomic) CGFloat chartPaddingRight;
@property (assign, nonatomic) CGFloat chartPaddingBottom;
@property (retain, nonatomic) NSArray *viewHeights;
@property (assign, nonatomic) CGFloat viewGap;
@property (retain, nonatomic) NSArray *axisVPaddings;
@property (assign, nonatomic) CGFloat axisHPadding;
@property (assign, nonatomic) CGFloat axisWidth;
@property (assign, nonatomic) CGFloat axisHeight;
@property (assign, nonatomic) CGFloat scrollHeight;
@property (assign, nonatomic) CGFloat loadingWidth;
@property (assign, nonatomic) CGFloat loadingRadius;

@property (retain, nonatomic) UIColor *backgroundColor;
@property (retain, nonatomic) UIColor *axisBorderColor;
@property (assign, nonatomic) CGFloat axisBoardWidth;
@property (retain, nonatomic) UIColor *axisFillColor;
@property (retain, nonatomic) UIColor *axisLineColor;
@property (retain, nonatomic) UIColor *axisLabelColor;
@property (retain, nonatomic) UIColor *scrollBackgroundColor;
@property (retain, nonatomic) UIColor *scrollFillColor;
@property (retain, nonatomic) UIColor *scrollMaskColor;
@property (retain, nonatomic) UIColor *crossLineColor;
@property (retain, nonatomic) UIColor *crossBackgroundColor;
@property (retain, nonatomic) UIColor *crossBorderColor;
@property (retain, nonatomic) UIColor *crossLabelColor;
@property (retain, nonatomic) UIColor *loadingBackgroundColor;
@property (retain, nonatomic) UIColor *loadingFillColor;
@property (retain, nonatomic) UIColor *loadingLineColor;
@property (retain, nonatomic) UIColor *loadingActiveLineColor;

@property (retain, nonatomic) NSArray *techCandleColors;
@property (retain, nonatomic) NSArray *techSignalColors;
@property (retain, nonatomic) NSArray *techVolumeColors;
@property (retain, nonatomic) NSArray *techMaColors;
@property (retain, nonatomic) NSArray *techEMAColors;
@property (retain, nonatomic) NSArray *techRsiColors;
@property (retain, nonatomic) UIColor *techAVGColor;
@property (retain, nonatomic) NSArray *techBollingerBandColors;
@property (retain, nonatomic) NSArray *techIchimokuColors;
@property (retain, nonatomic) NSArray *techMACDColors;
@property (retain, nonatomic) NSArray *techStochasticColors;
@property (retain, nonatomic) NSArray *techBalanceColors;
@property (retain, nonatomic) UIFont *axisLabelFont;
@property (retain, nonatomic) UIFont *colorLabelFont;
@property (retain, nonatomic) UIFont *crossLabelFont;

@property (nonatomic) BOOL showLeftVerticalAxis;

+ (CentChartTheme *) themeOfBlackBackground;
+ (CentChartTheme *) themeOfWhiteBackground;
+ (CentChartTheme *) themeOfOrangeBackground;

@end
