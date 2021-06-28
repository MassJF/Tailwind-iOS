//
//  CentChartTheme.m
//  MobileTest_iPhone
//
//  Created by wolf on 13-1-15.
//  Copyright (c) 2013年 wolf. All rights reserved.
//

#import "CentChartTheme.h"

#define RGBA(r, g, b, a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
#define RGB(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]


@implementation CentChartTheme

- (CentChartTheme *) init
{
    self = [super init];
    
    if(self) {
//        self.chartPadding = 1;
        self.viewHeights = @[@5.0f, @1.0f, @1.0f, @1.0f, @1.0f, @1.0f, @1.0f];
        self.viewGap = 2;
        self.axisVPaddings = @[@7.0f, @7.0f, @7.0f, @7.0f, @7.0f, @7.0f, @7.0f];
        self.axisHPadding = 1.0f;
        self.axisWidth = 50;
        self.axisHeight = 15;
        self.scrollHeight = 20;

        self.axisLabelFont = [UIFont systemFontOfSize:11];
        self.colorLabelFont = [UIFont systemFontOfSize:10];
        self.crossLabelFont = [UIFont systemFontOfSize:14];
        
        self.loadingWidth = 50;
        self.loadingRadius = 15;
        self.axisBoardWidth = 1.0;
        self.showLeftVerticalAxis = NO;
    }
    
    return self;
}

+ (CentChartTheme *) themeOfBlackBackground
{
    CentChartTheme *theme = [[CentChartTheme alloc] init];
    
    if(theme) {
        theme.backgroundColor = [UIColor blackColor];
        theme.axisBorderColor = [UIColor colorWithWhite:0.5 alpha:1.0];
        theme.axisFillColor = [UIColor colorWithWhite:0.1 alpha:1.0];
        theme.axisLineColor = [UIColor colorWithWhite:0.2 alpha:1.0];//坐标色
        theme.axisLabelColor = [UIColor colorWithWhite:0.7 alpha:1.0];
        
        theme.scrollBackgroundColor = [UIColor colorWithWhite:0.5 alpha:1.0];
        theme.scrollFillColor = [UIColor colorWithWhite:0.9 alpha:1.0];
        theme.scrollMaskColor = [UIColor colorWithWhite:0.0 alpha:0.6];

        theme.crossLineColor = [UIColor colorWithWhite:1.0 alpha:0.8];
        theme.crossBackgroundColor = [UIColor colorWithWhite:0.0 alpha:0.3];
        theme.crossBorderColor = [UIColor colorWithWhite:0.3 alpha:1.0];
        theme.crossLabelColor =[UIColor colorWithWhite:0.9 alpha:1.0];
        
        theme.techCandleColors = @[RGB(0xFF, 0x26, 0x26), RGB(0xFF, 0x26, 0x26), RGB(0x00, 0x6d, 0xd9), RGB(0x00, 0x6d, 0xd9), RGB(70 + 50, 119 + 50, 192 + 50)];
        theme.techSignalColors = @[RGB(0x00, 0x00, 0xFF), RGBA(0x00, 0x00, 0xFF, 0.4), RGB(0xFF, 0x00, 0x00), RGBA(0xFF, 0x00, 0x00, 0.4)];
        theme.techVolumeColors = @[/*RGB(0xF4, 0x90, 0x90)*/RGB(255, 49, 49), /*RGB(0x52, 0xF4, 0xF6)*/RGB(70 + 0, 119 + 0, 192 + 0)];
        theme.techMaColors = @[RGB(0x2F, 0x63, 0xFF), RGB(0x2F, 0xAC, 0x2F), RGB(0xFF, 0x2F, 0x2F)];
        theme.techEMAColors = @[RGB(0xff, 0x00, 0x00), RGB(0xc6, 0x00, 0xff)];
        theme.techRsiColors = @[RGB(0x2F, 0xAC, 0x2F), RGB(0xFF, 0x2F, 0x2F), RGB(0x2F, 0x63, 0xFF)];
        theme.techAVGColor = RGB(0xFF, 0xCC, 0x25);  //均线颜色
        theme.techBollingerBandColors = @[RGB(0x74, 0x74, 0x74), RGB(0xfd, 0x48, 0x48), RGB(0xff, 0x00, 0x00), RGB(0x4f, 0xb4, 0xfb), RGB(0x01, 0x83, 0xde)];

        
        theme.loadingBackgroundColor = RGBA(0x0, 0x0, 0x0, 0.4);
        theme.loadingFillColor = RGBA(0xFF, 0xFF, 0xFF, 0.5);
        theme.loadingLineColor = RGBA(0x0, 0x0, 0x0, 0.9);
        theme.loadingActiveLineColor = RGBA(0xff, 0x0, 0x0, 0.9);
    }
    
    return theme;
}

+ (CentChartTheme *) themeOfOrangeBackground
{
    CentChartTheme *theme = [[CentChartTheme alloc] init];
    
    if(theme) {
        theme.backgroundColor = [UIColor orangeColor];
        theme.axisBorderColor = [UIColor colorWithWhite:0.5 alpha:1.0];
        theme.axisFillColor = [UIColor clearColor];
        theme.axisLineColor = [UIColor colorWithWhite:0.2 alpha:1.0];//坐标色
        theme.axisLabelColor = [UIColor colorWithWhite:0.7 alpha:1.0];
        
        theme.scrollBackgroundColor = [UIColor colorWithWhite:0.5 alpha:1.0];
        theme.scrollFillColor = [UIColor colorWithWhite:0.9 alpha:1.0];
        theme.scrollMaskColor = [UIColor colorWithWhite:0.0 alpha:0.6];
        
        theme.crossLineColor = [UIColor colorWithWhite:1.0 alpha:0.8];
        theme.crossBackgroundColor = [UIColor colorWithWhite:0.0 alpha:1.0f];
        theme.crossBorderColor = [UIColor colorWithWhite:0.3 alpha:1.0];
        theme.crossLabelColor =[UIColor colorWithWhite:0.9 alpha:1.0];
        
        theme.techCandleColors = @[RGB(0xFF, 0x26, 0x26), RGB(0xFF, 0x26, 0x26), RGB(0x00, 0x6d, 0xd9), RGB(0x00, 0x6d, 0xd9), RGB(70 + 50, 119 + 50, 192 + 50)];
        theme.techSignalColors = @[RGB(0x00, 0x00, 0xFF), RGBA(0x00, 0x00, 0xFF, 0.4), RGB(0xFF, 0x00, 0x00), RGBA(0xFF, 0x00, 0x00, 0.4)];
        theme.techVolumeColors = @[/*RGB(0xF4, 0x90, 0x90)*/RGB(255, 49, 49), /*RGB(0x52, 0xF4, 0xF6)*/RGB(70 + 0, 119 + 0, 192 + 0)];
        theme.techMaColors = @[RGB(0x2F, 0x63, 0xFF), RGB(0x2F, 0xAC, 0x2F), RGB(0xFF, 0x2F, 0x2F)];
        theme.techEMAColors = @[RGB(0xff, 0x00, 0x00), RGB(0xc6, 0x00, 0xff)];
        theme.techRsiColors = @[RGB(0x2F, 0xAC, 0x2F), RGB(0xFF, 0x2F, 0x2F), RGB(0x2F, 0x63, 0xFF)];
        theme.techAVGColor = RGB(0xFF, 0xCC, 0x25);  //均线颜色
        theme.techBollingerBandColors = @[RGB(0x74, 0x74, 0x74), RGB(0xfd, 0x48, 0x48), RGB(0xff, 0x00, 0x00), RGB(0x4f, 0xb4, 0xfb), RGB(0x01, 0x83, 0xde)];
        
        
        theme.loadingBackgroundColor = RGBA(0x0, 0x0, 0x0, 0.4);
        theme.loadingFillColor = RGBA(0xFF, 0xFF, 0xFF, 0.5);
        theme.loadingLineColor = RGBA(0x0, 0x0, 0x0, 0.9);
        theme.loadingActiveLineColor = RGBA(0xff, 0x0, 0x0, 0.9);
    }
    
    return theme;
}

+ (CentChartTheme *) themeOfWhiteBackground
{
    CentChartTheme *theme = [[CentChartTheme alloc] init];
    
    if(theme) {
        theme.backgroundColor = [UIColor whiteColor];
        theme.axisBorderColor = [UIColor colorWithWhite:0.5 alpha:1.0];
        theme.axisFillColor = [UIColor colorWithWhite:0.99 alpha:1.0];
        theme.axisLineColor = [UIColor colorWithWhite:0.9 alpha:1.0];//坐标色
        theme.axisLabelColor = [UIColor colorWithWhite:0.3 alpha:1.0];

        theme.scrollBackgroundColor = [UIColor colorWithWhite:0.7 alpha:1.0];
        theme.scrollFillColor = [UIColor colorWithWhite:0.3 alpha:1.0];
        theme.scrollMaskColor = [UIColor colorWithWhite:1.0 alpha:0.6];

        theme.crossLineColor = [UIColor colorWithWhite:0.0 alpha:0.8];
        theme.crossBackgroundColor = [UIColor colorWithWhite:1.0 alpha:0.4];
        theme.crossBorderColor = [UIColor colorWithWhite:0.7 alpha:1.0];
        theme.crossLabelColor =[UIColor colorWithWhite:0.1 alpha:1.0];
        
        theme.techCandleColors = @[RGB(0xFF, 0x26, 0x26), RGB(0xFF, 0x26, 0x26), RGB(0x00, 0x6d, 0xd9), RGB(0x00, 0x6d, 0xd9), RGB(70 + 50, 119 + 50, 192 + 50)];
        theme.techBalanceColors = @[RGB(0xFF, 0x26, 0x26), RGBA(0xFF, 0x26, 0x26, 0.6), RGB(0x00, 0x6d, 0xd9), RGBA(0x00, 0x6d, 0xd9, 0.6)];
        theme.techSignalColors = @[RGB(0x00, 0x00, 0xFF), RGBA(0x00, 0x00, 0xFF, 0.4), RGB(0xFF, 0x00, 0x00), RGBA(0xFF, 0x00, 0x00, 0.4)];
        theme.techVolumeColors = @[RGB(0xF4, 0x90, 0x90), RGB(0x77, 0x9D, 0xCB)];
        theme.techMaColors = @[RGB(0xEB, 0x75, 0x02), RGB(0x61, 0xb9, 0x02), RGB(0xFF, 0x2F, 0x2F)];
        theme.techRsiColors = @[RGB(0x46, 0xbe, 0x05), RGB(0xF7, 0x6a, 0x03)];
        theme.techEMAColors = @[RGB(0xff, 0x00, 0x00), RGB(0xc6, 0x00, 0xff)];
        theme.techAVGColor = RGB(0xFF, 0xBC, 0x25);
        theme.techBollingerBandColors = @[RGB(0x74, 0x74, 0x74), RGB(0xfd, 0x48, 0x48), RGB(0xff, 0x00, 0x00), RGB(0x4f, 0xb4, 0xfb), RGB(0x01, 0x83, 0xde)];
        theme.techIchimokuColors = @[RGB(0x66, 0xcc, 0x00), RGB(0xff, 0x33, 0x00), RGB(0xff, 0x33, 0xcc), RGB(0xcc, 0x99, 0x00), RGB(0x33, 0x99, 0xff)];
        theme.techMACDColors = @[RGB(0x01, 0x83, 0xde), RGB(0xf5, 0x62, 0x00), RGB(0x83, 0xc8, 0x55)];
        theme.techStochasticColors = @[RGB(0xff, 0x00, 0x00), RGB(0x00, 0x78, 0xff), RGB(0xff, 0xa2, 0x00)];

        theme.loadingBackgroundColor = RGBA(0xFF, 0xFF, 0xFF, 0.4);
        theme.loadingFillColor = RGBA(0x0, 0x0, 0x0, 0.5);
        theme.loadingLineColor = RGBA(0xFF, 0xFF, 0xFF, 0.9);
        theme.loadingActiveLineColor = RGBA(0xFF, 0x0, 0x0, 0.9);
    }
    
    return theme;
}

@end
