//
//  CentChartLayerDraw.m
//  MobileTest_iPhone
//
//  Created by wolf on 13-1-24.
//  Copyright (c) 2013年 wolf. All rights reserved.
//

#import "CentChartLayerDraw.h"
#import "CentChartView.h"
#import "CentChartMapping.h"
#import "CentChartUtil.h"
#import "Utils.h"
#import <CoreText/CoreText.h>

@interface CentChartLayerDraw ()

@property (retain, nonatomic) UIImage *scrollCache;

@end


@implementation CentChartLayerDraw

- (id)init
{
    self = [super init];
    
    if(self) {
        self.scrollCache = nil;
        self.needUpdateScrollCache = NO;
    }
    
    return self;
}

- (id)initWithLayer:(id)layer {
    self = [super initWithLayer:layer];
    
    if(self) {
        if([layer isKindOfClass:[CentChartLayerDraw class]]) {
            CentChartLayerDraw *other = (CentChartLayerDraw *)layer;
            
            self.code = other.code;
            self.period = other.period;
            self.theme = other.theme;
            self.views = other.views;
            self.data = other.data;
            self.dataRange = other.dataRange;
            self.scrollCache = nil;
            self.scrollCache = other.scrollCache;
            self.needUpdateScrollCache = other.needUpdateScrollCache;
            //            self.yesterdayEndPrice = other.yesterdayEndPrice;
        }
    }
    
    return self;
}

- (void) setTheme:(CentChartTheme *)newTheme
{
    if(_theme != newTheme) {
        _theme = newTheme;
        
        self.needUpdateScrollCache = YES;
    }
}

- (void) setData:(NSArray *)data
{
    if(_data!= data) {
        _data = data;
        
        self.needUpdateScrollCache = YES;
    }
}

- (void)drawInContext:(CGContextRef)context
{
    if(!self.data || [self.data count] <= 0) return;
    
//        CGRect chartRect = CGRectInset(self.bounds, self.theme.chartPadding * 2, self.theme.chartPadding * 2);
    CGRect chartRect = CGRectMake(self.bounds.origin.x + self.theme.chartPaddingLeft,
                                  self.bounds.origin.y + self.theme.chartPaddingTop,
                                  self.bounds.size.width - self.theme.chartPaddingLeft - self.theme.chartPaddingRight,
                                  self.bounds.size.height - self.theme.chartPaddingTop - self.theme.chartPaddingBottom);
    
    
//        if(self.period == CentChartPeriodCandle1Minute) {
//            chartRect.origin.x += self.theme.axisWidth;
//            chartRect.size.width -= self.theme.axisWidth * 2;
//        }
//        else {
    chartRect.size.width -= self.theme.axisWidth;
//        }
    
    // Prepare mapping
    CentChartMapping *mapping = [CentChartMapping mappingWithIndex:0 dataRange:self.dataRange viewPort:chartRect theme:self.theme period:self.period];
//        mapping.yesterdayEndPrice = self.yesterdayEndPrice;
    
    if(self.drawAxisBoard){
        // Draw H axis labels
        CGContextSetAllowsAntialiasing(context, true);
        
        NSDictionary *attrs = [NSDictionary dictionaryWithObjectsAndKeys:
                               self.theme.axisLabelFont,
                               NSFontAttributeName,
                               nil];
        
//            CGContextSelectFont(context,
//                                [self.theme.axisLabelFont.fontName cStringUsingEncoding:NSMacOSRomanStringEncoding],
//                                self.theme.axisLabelFont.pointSize,
//                                kCGEncodingMacRoman);
        
        CGAffineTransform tranform = CGAffineTransformMake(1, 0, 0, -1, 0, 0);
        CGContextSetTextMatrix(context, tranform);
        
        NSString *hlabelFormat = [CentChartUtil getHLabelFormat:self.period];
        
        CGContextSetFillColorWithColor(context, self.theme.axisLabelColor.CGColor);
        CGContextSetStrokeColorWithColor(context, self.theme.axisLabelColor.CGColor);
        
        // ..Measure label size
        NSArray *data = self.data;
        
//        const char *cHlabelFormat = [hlabelFormat cStringUsingEncoding:NSMacOSRomanStringEncoding];
        
        CGContextSetTextDrawingMode(context, kCGTextInvisible);
//        CGContextShowTextAtPoint(context, 0, 0, cHlabelFormat, strlen(cHlabelFormat));
        [hlabelFormat drawAtPoint:CGPointMake(0, 0) withAttributes:attrs];
        
        CGFloat labelWidth = CGContextGetTextPosition(context).x;
        
        NSMutableArray *hlabelIndexes = [NSMutableArray arrayWithCapacity:20];
        
        // ..Draw label
        int startIndex = (int)floor(mapping.dataRange.x);
        unsigned long endIndex = (int)ceil(mapping.dataRange.x + mapping.dataRange.y);
        self.candleWidth = floor((mapping.getUnitWidth - 1 ) / 2);
        
//        NSLog(@"--------------->>> %f", mapping.getUnitWidth);
        startIndex = MAX(0, startIndex);
        endIndex = MIN(data.count - 1, endIndex);
        
        
        int labelIndexWidth = (int)ceilf((labelWidth + 10) / [mapping getUnitWidth]);
        int labelStartIndex = (int)(labelIndexWidth / 2);
        
        NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
        [fmt setDateFormat:hlabelFormat];
        
        CGFloat drawy = CGRectGetMaxY(chartRect) - self.theme.scrollHeight - 3;
        
        //---画横坐标Lables
        
        if(self.period == CentChartStyleYueJiDuShouYiLv){
            //智能平铺横坐标labels
            for(int i = startIndex; i <= endIndex; i++) {   //draw timestamp label
                if(0 != labelIndexWidth
                   && ((i - labelStartIndex) % labelIndexWidth) == 0) {   //经常crash
                    CGFloat drawx = [mapping transformIndex:i];
                    
                    if(drawx > CGRectGetMinX(mapping.viewPort)
                       && drawx < CGRectGetMaxX(mapping.viewPort)
                       ) {
                        [hlabelIndexes addObject:[NSNumber numberWithInt:i]];
                        
                        CentChartDataCandle *candle = data[i];
                        
                        if(!candle.invalid){
                            NSString *label = [fmt stringFromDate:candle.timestamp];
//                            const char *cLabel = [label cStringUsingEncoding:NSMacOSRomanStringEncoding];
                            
                            CGContextSetTextDrawingMode(context, kCGTextInvisible);
//                            CGContextShowTextAtPoint(context, 0, 0, cLabel, strlen(cLabel));
                            [label drawAtPoint:CGPointMake(0, 0) withAttributes:attrs];
                            
                            labelWidth = CGContextGetTextPosition(context).x;
                            drawx -= labelWidth / 2;
                            
                            CGContextSetTextDrawingMode(context, kCGTextFill);
//                            CGContextShowTextAtPoint(context, drawx, drawy, cLabel, strlen(cLabel));
                            [label drawAtPoint:CGPointMake(drawx, drawy) withAttributes:attrs];
                        }
                    }
                }
                
                mapping.hLableIndexes = hlabelIndexes;
            }
        }else if (self.period == CentChartStyleJingZhiZouShi){
            //只画头尾两个labels
            CGFloat firstLableX = [mapping transformIndex:startIndex];
            CentChartDataCandle* firstCandle = data[startIndex];
            
            if(!firstCandle.invalid){
                NSString *str = [fmt stringFromDate:firstCandle.timestamp];
//                const char *cLabel = [str cStringUsingEncoding:NSMacOSRomanStringEncoding];
                CGContextSetTextDrawingMode(context, kCGTextFill);
//                CGContextShowTextAtPoint(context, firstLableX, drawy, cLabel, strlen(cLabel));
                [str drawAtPoint:CGPointMake(firstLableX, drawy) withAttributes:attrs];
            }
            
            CGFloat lastLableX = [mapping transformIndex:endIndex];
            CentChartDataCandle* lastCandle = data[endIndex];
            
            if(!lastCandle.invalid){
                NSString *str = [fmt stringFromDate:lastCandle.timestamp];
//                const char *cLabel = [str cStringUsingEncoding:NSMacOSRomanStringEncoding];
                
                CGContextSetTextDrawingMode(context, kCGTextInvisible);
//                CGContextShowTextAtPoint(context, 0, 0, cLabel, strlen(cLabel));
                [str drawAtPoint:CGPointMake(0, 0) withAttributes:attrs];
                
                labelWidth = CGContextGetTextPosition(context).x;
                lastLableX -= labelWidth;
                
                CGContextSetTextDrawingMode(context, kCGTextFill);
//                CGContextShowTextAtPoint(context, lastLableX, drawy, cLabel, strlen(cLabel));
                [str drawAtPoint:CGPointMake(lastLableX, drawy) withAttributes:attrs];
            }
            
        }
    }
    //---画横坐标Lables
    
    
    // Draw scroll
    if(self.theme.scrollHeight > 0.0f) {
        CGFloat scrollDrawxMin = roundf(CGRectGetMinX(chartRect)) + 0.5;
        CGFloat scrollDrawxMax = roundf(CGRectGetMaxX(chartRect) + self.theme.axisWidth) - 0.5;
        CGFloat scrollDrawyMin = roundf(CGRectGetMaxY(chartRect) - self.theme.scrollHeight) + 0.5;
        CGFloat scrollDrawyMax = roundf(CGRectGetMaxY(chartRect)) - 0.5;
        
        CGRect scrollRect = CGRectMake(scrollDrawxMin, scrollDrawyMin, scrollDrawxMax - scrollDrawxMin, scrollDrawyMax - scrollDrawyMin);
        
        // Update scroll cache image
        if(!self.scrollCache || self.needUpdateScrollCache || !CGSizeEqualToSize(self.scrollCache.size, scrollRect.size)) {
            // Create scroll context
            CGRect scrollImageRect = CGRectMake(0, 0, scrollRect.size.width * self.contentsScale, scrollRect.size.height * self.contentsScale);
            
            CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
            CGContextRef contextScroll = CGBitmapContextCreate(NULL, scrollImageRect.size.width, scrollImageRect.size.height, 8, scrollImageRect.size.width * 4, colorSpace, kCGImageAlphaPremultipliedLast/*kCGBitmapByteOrderDefault*/);
            CGColorSpaceRelease(colorSpace);
            
            // Create scroll image
            double dataMin = NAN;
            double dataMax = NAN;
            
            for(CentChartDataCandle *data in self.data) {
                if(isnan(dataMin) || data.close < dataMin) dataMin = data.close;
                if(isnan(dataMax) || data.close > dataMax) dataMax = data.close;
            }
            
            if(self.contentsScale > 1.0) CGContextSetAllowsAntialiasing(contextScroll, true);
            else CGContextSetAllowsAntialiasing(contextScroll, false);
            
            CGContextSetLineWidth(contextScroll, 1);
            CGContextSetFillColorWithColor(contextScroll, mapping.theme.scrollBackgroundColor.CGColor);
            CGContextFillRect(contextScroll, CGRectOffset(scrollImageRect, 0.0, 0.0));
            
            if(self.data.count > 0) {
                // Draw scroll chart
                CGContextSetFillColorWithColor(contextScroll, mapping.theme.scrollFillColor.CGColor);
                
                CGContextBeginPath(context);
                
                NSInteger dataCount = self.data.count;
                
                for(int i = 0; i < dataCount; i++) {
                    CentChartDataCandle *data = (CentChartDataCandle *)self.data[i];
                    
                    CGFloat scrollDrawx = roundf((CGRectGetWidth(scrollImageRect) - 1) * (i + 0.5) / dataCount) + 0.5;
                    CGFloat scrollDrawy = 2 + roundf((CGRectGetHeight(scrollImageRect) - 4) * (dataMax - data.close) / (dataMax - dataMin)) + 0.5;
                    
                    if(i == 0) {
                        CGContextMoveToPoint(contextScroll, scrollDrawx, CGRectGetMaxY(scrollImageRect) - 0.5);
                        
                    }
                    
//                    CGContextAddLineToPoint(contextScroll, scrollDrawx, scrollDrawy);
                    [self saveWayOfCGContextAddLineToPointWithContext:contextScroll
                                                                withX:scrollDrawx
                                                                withY:scrollDrawy];  //safe way
                    
                    if(i == dataCount - 1) {
//                        CGContextAddLineToPoint(contextScroll, scrollDrawx, CGRectGetMaxY(scrollImageRect) - 0.5);
                        [self saveWayOfCGContextAddLineToPointWithContext:contextScroll
                                                                    withX:scrollDrawx
                                                                    withY:CGRectGetMaxY(scrollImageRect) - 0.5];   //safe way
                    }
                }
                
                CGContextClosePath(contextScroll);
                CGContextFillPath(contextScroll);
            }
            
            // Create scroll image
            CGImageRef imageScroll = CGBitmapContextCreateImage(contextScroll);
            CGContextRelease(contextScroll);
            
            self.scrollCache = [UIImage imageWithCGImage:imageScroll scale:self.contentsScale orientation:UIImageOrientationUp];
            self.needUpdateScrollCache = NO;
        }
        
        // Draw scroll cache iamge
        CGContextDrawImage(context, scrollRect, self.scrollCache.CGImage);
        
        // Draw scroll mask
        if(self.data.count > 0) {
            CGFloat scrollDrawxLeft = roundf(scrollDrawxMin + (scrollDrawxMax - scrollDrawxMin - 1) * (mapping.dataRange.x + 0.5) / self.data.count) + 0.5;
            CGFloat scrollDrawxRight = roundf(scrollDrawxMin + (scrollDrawxMax - scrollDrawxMin - 1) * (mapping.dataRange.x + mapping.dataRange.y + 0.5) / self.data.count) + 0.5;
            
            CGContextSetFillColorWithColor(context, mapping.theme.scrollMaskColor.CGColor);
            
            if(scrollDrawxLeft > scrollDrawxMin) {
                CGRect rectLeft = CGRectMake(scrollDrawxMin, scrollDrawyMin, scrollDrawxLeft - scrollDrawxMin, scrollDrawyMax - scrollDrawyMin);
                CGContextFillRect(context, rectLeft);
            }
            
            if(scrollDrawxRight < scrollDrawxMax) {
                CGRect rectRight = CGRectMake(scrollDrawxRight, scrollDrawyMin, scrollDrawxMax - scrollDrawxRight, scrollDrawyMax - scrollDrawyMin);
                CGContextFillRect(context, rectRight);
            }
        }
    }
    
    // Draw views
    CGRect viewRect = chartRect;
    
    //    if(self.period == CentChartPeriodCandle1Minute) {
    //        viewRect.size.height -= self.theme.axisHeight;
    //    }
    //    else {
    viewRect.size.height -= self.theme.scrollHeight + self.theme.axisHeight;
    //    }
    
    CGFloat lastViewTop = viewRect.origin.y;
    
    float totalHeightWeight = 0;
    
    for (int i = 0; i < self.views.count; i++) {
        totalHeightWeight += ((NSNumber *)self.theme.viewHeights[i]).floatValue;
    }
    
    for (int i = 0; i < self.views.count; i++) {
        CentChartView *view = self.views[i];
        
        CGFloat viewHeight = floor(viewRect.size.height * ((NSNumber *)self.theme.viewHeights[i]).floatValue / totalHeightWeight);
        CGRect viewPort = CGRectMake(viewRect.origin.x, lastViewTop, viewRect.size.width, viewHeight);
        
        if(i == self.views.count - 1) {
            viewPort.size.height = viewRect.origin.y + viewRect.size.height - viewPort.origin.y;
        }
        
        // Set draw area
        lastViewTop += viewHeight + self.theme.viewGap;
        
        mapping.index = i;
        mapping.viewPort = viewPort;
        
        [view drawWithContext:context mapping:mapping];
    }
}

-(void)saveWayOfCGContextAddLineToPointWithContext:(CGContextRef)context withX:(CGFloat)x withY:(CGFloat)y
{
    if(isnan(x) || isnan(y))
        return;
    
    CGContextAddLineToPoint(context, x, y);
}

+ (BOOL)needsDisplayForKey:(NSString *)key
{
    if([key isEqualToString:@"dataRange"]) {
        return YES;
    }
    else {
        return [super needsDisplayForKey:key];
    }
}

@end
