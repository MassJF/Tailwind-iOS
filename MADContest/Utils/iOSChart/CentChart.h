//
//  CentDreamChart.h
//  MobileTest_iPhone
//
//  Created by wolf on 13-1-14.
//  Copyright (c) 2013年 wolf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CentChartTechnical.h"
#import "CentChartTheme.h"
#import "CentChartData.h"
#import "CentChartDataCandle.h"
#import "CentChartDataTick.h"
#import "CentChartTechnicalCandle.h"
#import "CentChartTechnicalVolume.h"
#import "iOSChartReturnRatioTechnical.h"
#import "CentChartTechnicalAVG.h"
#import "CentChartTechnicalMA.h"
#import "CentChartTechnicalTradeLine.h"
#import "CentChartTechnicalTradeLineWithPoints.h"
#import "CentChartView.h"

@protocol CentChartDataLoader <NSObject>

- (void) loadChartDataWidthCode:(NSString *)code period:(CentChartPeriod)period startTime:(NSDate *)startTime endTime:(NSDate *)endTime;

@end


@interface CentChart : UIView

//@property (nonatomic) int screenOrientation;
@property (retain, nonatomic) NSArray *data;
@property (retain, nonatomic) NSString *code;
@property (nonatomic) CentChartPeriod period;
@property (retain, nonatomic) CentChartTheme *theme;
@property (retain, nonatomic) id<CentChartDataLoader> dataLoader;
@property (retain, nonatomic) CentChartView *viewTop;

//@property (retain, nonatomic) NSArray *techListBottom;

- (void) setChartCode:(NSString *)code period:(CentChartPeriod)period;
- (void) setChartData:(NSArray *)data code:(NSString *)code period:(CentChartPeriod)period;
-(void)setLimit;

//初始化相关
-(void)setDefaultDataRange:(CGPoint)range;
-(void)enableUIPanGestureRecognizer:(BOOL)enable;
-(void)enableUIPinchGestureRecognizer:(BOOL)enable;
-(void)setTechTop:(NSArray *)techListTop;
-(void)setActionLayerTechnical:(CentChartTechnical* )tech;
-(void)setDrawAxisBoard:(BOOL)drawAxisBoard;
-(void)enableLoading:(BOOL)enable;

@end
