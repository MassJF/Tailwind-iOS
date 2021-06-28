//
//  CentDreamChart.m
//  MobileTest_iPhone
//
//  Created by wolf on 13-1-14.
//  Copyright (c) 2013年 wolf. All rights reserved.
//

#import "CentChart.h"
#import "CentChartView.h"
#import "CentChartLayerDraw.h"
#import "CentChartLayerActionStyleForJiuFuBao.h"
#import "CentChartLayerLoading.h"
#import "CentChartTechnicalRSI.h"
#import "CentChartTechnicalEMA.h"
#import "CentChartTechBollingerBand.h"
#import "CentChartTechMACD.h"
#import "CentChartTechStochastics.h"
#import "CentChartTechIchimoku.h"
#import "CentChartTechSignal.h"
#import "CentChartTechBablance.h"
#import "CentChartTechTotoalBalance.h"

//#import "TypeDefines.h"

typedef enum {
    CentChartLoadingStatusIdle,
    CentChartLoadingStatusLeft,
    CentChartLoadingStatusRight
} CentChartLoadingStatus;


@interface CentChart () <CAAnimationDelegate>

@property (retain, nonatomic) NSArray *views;

@property (retain, nonatomic) CentChartLayerDraw *drawLayer;
@property (retain, nonatomic) CentChartLayerActionStyleForJiuFuBao *actionLayer;
@property (retain, nonatomic) CentChartLayerLoading *loadingLayer;
@property (retain, nonatomic) NSArray *techListTop;
@property (retain, nonatomic) CentChartTechnical *crossDependentTechnical;

@property (retain, nonatomic) UIPinchGestureRecognizer *pinchGestureRecognizer;
@property (retain, nonatomic) UIPanGestureRecognizer *panGestureRecognizer;
@property (retain, nonatomic) UILongPressGestureRecognizer *longPressGestureRecognizer;
@property (retain, nonatomic) UITapGestureRecognizer *tapGestureRecognizer;

@property (assign, nonatomic) CGPoint dataRangeDefault;
@property (assign, nonatomic) CGRect dataRangeLimit;

@property (assign, nonatomic) CGPoint animationStartDataRange;

@property (assign, nonatomic) CentChartLoadingStatus loadingStatus;

@end


@implementation CentChart

- (id)initWithFrame:(CGRect)frame /*withTechId:(int)techId withBalance:(BOOL)balance withTotoalBalance:(BOOL)totoalBalance*/
{
    self = [super initWithFrame:frame];
    if(self){
    
    }
    return self;
}

-(void)enableUIPanGestureRecognizer:(BOOL)enable{
    if(enable){
        self.panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
        [self addGestureRecognizer:self.panGestureRecognizer];
    }
}

-(void)enableUIPinchGestureRecognizer:(BOOL)enable{
    if(enable){
        self.pinchGestureRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinchGesture:)];
        [self addGestureRecognizer:self.pinchGestureRecognizer];
    }
}

-(void)setDefaultDataRange:(CGPoint)range{
    self.dataRangeDefault = range;
}

-(void)setTechTop:(NSArray *)techListTop{
    self.techListTop = techListTop;
}

-(void)setActionLayerTechnical:(CentChartTechnical* )tech{
    self.crossDependentTechnical = tech;
}

- (id) initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.code = nil;
        self.period = 0;
        self.theme = nil;
        self.views = nil;
        self.data = nil;
        self.dataLoader = nil;
        self.loadingStatus = CentChartLoadingStatusIdle;
//        self.screenOrientation = Portrait;
        
        // Init views
        // ..View top
        int viewIndex = 0;
        self.viewTop = [[CentChartView alloc] init];
        self.viewTop.index = viewIndex;
        self.viewTop.techList = self.techListTop;
        
        NSMutableArray *views = [NSMutableArray arrayWithCapacity:0];
        [views addObject:self.viewTop];
        viewIndex++;
        
        
        
        /*CentChartTechSignal *techSignal = [[CentChartTechSignal alloc] init];
         CentChartTechnicalCandle *techCandle = [[CentChartTechnicalCandle alloc] init];
         
         if(techId == FX_MA){
         CentChartTechnicalMA *techMA1 = [[CentChartTechnicalMA alloc] initWithIndex:0 param:5];
         CentChartTechnicalMA *techMA2 = [[CentChartTechnicalMA alloc] initWithIndex:1 param:21];
         self.techListTop = [NSArray arrayWithObjects:techCandle, techSignal, techMA1, techMA2, nil];
         }
         if(techId == FX_EMA){
         CentChartTechnicalEMA *techEMA1 = [[CentChartTechnicalEMA alloc] initWithIndex:0 param:5];
         CentChartTechnicalEMA *techEMA2 = [[CentChartTechnicalEMA alloc] initWithIndex:1 param:12];
         self.techListTop = [NSArray arrayWithObjects:techCandle, techSignal, techEMA1, techEMA2, nil];
         }
         if(techId == FX_BollingerBand){
         CentChartTechBollingerBand *techBollingerBand = [[CentChartTechBollingerBand alloc] initWithIndex:0 param:21];
         self.techListTop = [NSArray arrayWithObjects:techCandle, techSignal, techBollingerBand, nil];
         }
         if(techId == FX_Ichimoku){
         CentChartTechIchimoku *techIchimoku = [[CentChartTechIchimoku alloc] initWithIndex:0 paramN:26 paramM:9 paramK:26];
         self.techListTop = [NSArray arrayWithObjects:techCandle, techSignal, techIchimoku, nil];
         }
         if(techId == FX_MACD){
         self.techListTop = [NSArray arrayWithObjects:techCandle, techSignal, nil];
         CentChartTechMACD *techMACD = [[CentChartTechMACD alloc] initWithIndex:0 param12:12 param26:26 param9:9];
         // ..View bottom
         CentChartView *viewBottom = [[CentChartView alloc] init];
         viewBottom.index = viewIndex;
         viewBottom.techList = [NSArray arrayWithObjects:techMACD, nil];
         [views addObject:viewBottom];
         viewIndex++;
         }
         if(techId == FX_Stochastic){
         self.techListTop = [NSArray arrayWithObjects:techCandle, techSignal, nil];
         CentChartTechStochastics *techStochastics = [[CentChartTechStochastics alloc] initWithIndex:0 paramPerK:9 paramPerD:3 paramSlowPerD:3];
         // ..View bottom
         CentChartView *viewBottom = [[CentChartView alloc] init];
         viewBottom.index = viewIndex;
         viewBottom.techList = [NSArray arrayWithObjects:techStochastics, nil];
         [views addObject:viewBottom];
         viewIndex++;
         }
         if(techId == FX_RSI){
         self.techListTop = [NSArray arrayWithObjects:techCandle, techSignal, nil];
         CentChartTechnicalRSI *techRSI1 = [[CentChartTechnicalRSI alloc] initWithIndex:0 param:9];
         CentChartTechnicalRSI *techRSI2 = [[CentChartTechnicalRSI alloc] initWithIndex:1 param:14];
         // ..View bottom
         CentChartView *viewBottom = [[CentChartView alloc] init];
         viewBottom.index = viewIndex;
         viewBottom.techList = [NSArray arrayWithObjects:techRSI1, techRSI2, nil];
         [views addObject:viewBottom];
         viewIndex++;
         }
         
         if(balance){
         CentChartTechBablance *techBalance = [[CentChartTechBablance alloc] init];
         // ..View bottom
         CentChartView *viewBottom = [[CentChartView alloc] init];
         viewBottom.index = viewIndex;
         viewBottom.techList = [NSArray arrayWithObjects:techBalance, nil];
         [views addObject:viewBottom];
         viewIndex++;
         }
         
         if(totoalBalance){
         CentChartTechTotoalBalance *techBalance = [[CentChartTechTotoalBalance alloc] init];
         // ..View bottom
         CentChartView *viewBottom = [[CentChartView alloc] init];
         viewBottom.index = viewIndex;
         viewBottom.techList = [NSArray arrayWithObjects:techBalance, nil];
         [views addObject:viewBottom];
         viewIndex++;
         }*/
        
        // ..View list
        self.views = views;
        
        // Init gesture recognizer
        
        self.longPressGestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPressGesture:)];
        self.longPressGestureRecognizer.minimumPressDuration = 0.00f;
        [self addGestureRecognizer:self.longPressGestureRecognizer];
        
        self.tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
        self.tapGestureRecognizer.numberOfTapsRequired = 2;
        [self addGestureRecognizer:self.tapGestureRecognizer];
        
        // Init layers
        self.drawLayer = [CentChartLayerDraw layer];
        self.drawLayer.frame = self.bounds;
        self.drawLayer.views = self.views;
        self.drawLayer.contentsScale = [UIScreen mainScreen].scale;
        
        [self.layer addSublayer:self.drawLayer];
        
        self.actionLayer = [CentChartLayerActionStyleForJiuFuBao layer];
        self.actionLayer.frame = self.bounds;
        self.actionLayer.views = self.views;
        self.actionLayer.opacity = 0;
        self.actionLayer.contentsScale = [UIScreen mainScreen].scale;
        
        [self.layer addSublayer:self.actionLayer];
        
        
    }

    return self;
}

-(void)enableLoading:(BOOL)enable{
    if(enable){
        self.loadingLayer = [CentChartLayerLoading layer];
        self.loadingLayer.frame = self.bounds;
        self.loadingLayer.views = self.views;
        self.loadingLayer.contentsScale = [UIScreen mainScreen].scale;
        
        [self.layer addSublayer:self.loadingLayer];
    }
}

-(void)setDrawAxisBoard:(BOOL)drawAxisBoard{
    self.viewTop.drawAxisBoard = drawAxisBoard;
    self.drawLayer.drawAxisBoard = drawAxisBoard;
}

- (void) setTheme:(CentChartTheme *)newTheme
{
    if(_theme != newTheme) {
        _theme = newTheme;
        
        self.drawLayer.theme = newTheme;
        self.drawLayer.backgroundColor = newTheme.backgroundColor.CGColor;

        self.actionLayer.theme = newTheme;

        self.loadingLayer.theme = newTheme;

        [self.drawLayer setNeedsDisplay];
        [self.actionLayer setNeedsDisplay];
        [self.loadingLayer setNeedsDisplay];
    }
}

- (void) setChartCode:(NSString *)code period:(CentChartPeriod)period
{
    @try {
        [self.dataLoader loadChartDataWidthCode:code period:period startTime:nil endTime:nil];
    }
    @catch (NSException *exception) {
        NSLog(@"exception: period widget clicked when stockDetailView have no data!");
    }
}

-(void)setLimit
{
    self.dataRangeLimit = CGRectMake(0, 1, self.data.count, 220);
}

- (void) setChartData:(NSArray *)data code:(NSString *)code period:(CentChartPeriod)period
{
    // Enable user interaction
    self.userInteractionEnabled = YES;

    // Update loading status
    CentChartLoadingStatus currentLoadingStatus = self.loadingStatus;
    
//    CGFloat defaultDataLength = 80;
//    self.dataRangeDefault = CGPointMake(data.count - defaultDataLength, defaultDataLength);
//    self.dataRangeDefault = CGPointMake(0, data.count);
    
    BOOL isSameData = NO;
    
    if(currentLoadingStatus != CentChartLoadingStatusIdle && period == self.period && [code compare:self.code] == NSOrderedSame)
        isSameData = YES;
    
    // Update data
    if(!isSameData && (data == nil || code == nil || period == 0 || 0 >= [data count] || [code isEqualToString:@""])) {
        self.code = nil;
        self.period = 0;
        self.data = nil;
        
        self.drawLayer.code = code;
        self.drawLayer.period = period;
        self.drawLayer.data = self.data;
        self.drawLayer.needUpdateScrollCache = YES;
        self.drawLayer.dataRange = self.dataRangeDefault;
        
        self.actionLayer.period = period;
        self.actionLayer.dataRange = self.dataRangeDefault;
        
        [self.drawLayer setNeedsDisplay];
        [self.actionLayer setNeedsDisplay];
        
        self.panGestureRecognizer.enabled = NO;
        self.pinchGestureRecognizer.enabled = NO;
        self.tapGestureRecognizer.enabled = NO;
        
        return;
    }else{
        self.panGestureRecognizer.enabled = YES;
        self.pinchGestureRecognizer.enabled = YES;
        self.tapGestureRecognizer.enabled = YES;
        
    }
    
    //给actionLayer指派当前需要显示十字线的technical
    self.actionLayer.crossDependentTechnical = self.crossDependentTechnical;
    
    self.loadingStatus = CentChartLoadingStatusIdle;
    self.loadingLayer.backgroundColor = nil;
    self.loadingLayer.loadingLocation = CGPointMake(0, 0);
    self.loadingLayer.loadingRotation = 0;
    
    [self.loadingLayer setNeedsDisplay];
    
    // Stop loading animation
    [self.loadingLayer removeAllAnimations];

    CentChartView *viewTop = [self.views objectAtIndex:0];
    viewTop.period = period;
    viewTop.techList = self.techListTop;
    
    if(isSameData) {
        NSMutableArray *newData = [NSMutableArray arrayWithArray:self.data];
        int index = 0;
        
        for(CentChartDataCandle *candle in data) {
            if(newData.count == 0) {
                [newData addObject:candle];
            }
            else {
                CentChartDataCandle *targetCandle = newData[index];
            
                if([candle.timestamp compare:targetCandle.timestamp] == NSOrderedSame) {
                    [newData replaceObjectAtIndex:index withObject:candle];
                }
                else if([candle.timestamp compare:targetCandle.timestamp] == NSOrderedAscending) {
                    [newData insertObject:candle atIndex:index];
                    index++;
                }
                else {
                    do {
                        index++;
                        if(index >= newData.count) {
                            targetCandle = nil;
                            break;
                        }
                        
                        targetCandle = newData[index];
                    }
                    while([candle.timestamp compare:targetCandle.timestamp] == NSOrderedDescending);
                    
                    if(targetCandle == nil || [candle.timestamp compare:targetCandle.timestamp] == NSOrderedAscending) {
                        [newData insertObject:candle atIndex:index];
                    }
                    else {
                        [newData replaceObjectAtIndex:index withObject:candle];
                    }
                }
            }
        }
        
        self.data = newData;
    }
    else {
        self.code = code;
        self.period = period;
        self.data = [NSArray arrayWithArray:data];
    }
    
    for (CentChartView *view in self.views) {
        [view prepareData:self.data];
    }

    self.panGestureRecognizer.enabled = YES;
    self.pinchGestureRecognizer.enabled = YES;
    self.tapGestureRecognizer.enabled = YES;

    [self setLimit];

    if(isSameData) {
        CGPoint currentDataRange = self.drawLayer.dataRange;
        CGPoint targetDataRange = currentDataRange;
        
        if(currentLoadingStatus == CentChartLoadingStatusRight) {
            targetDataRange = CGPointMake(self.drawLayer.data.count - currentDataRange.y, currentDataRange.y);
        }
        else {
            currentDataRange.x += self.data.count - self.drawLayer.data.count;
            targetDataRange.x = self.data.count - self.drawLayer.data.count;
        }
        
        if(self.data.count == self.drawLayer.data.count) {
            self.drawLayer.data = self.data;
            self.drawLayer.needUpdateScrollCache = YES;
            self.drawLayer.dataRange = targetDataRange;
            self.actionLayer.dataRange = targetDataRange;
            
            CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"dataRange"];
            anim.duration = 0.5;
            anim.fromValue = [NSValue valueWithCGPoint:currentDataRange];
            anim.toValue = [NSValue valueWithCGPoint:targetDataRange];
            anim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
            
            [self.drawLayer addAnimation:anim forKey:@"animateDataRange"];
        }
        else {
            self.drawLayer.data = self.data;
            self.drawLayer.needUpdateScrollCache = YES;
            self.drawLayer.dataRange = currentDataRange;
            self.actionLayer.dataRange = currentDataRange;
        }
    }
    else {
        
        self.drawLayer.code = code;
        self.drawLayer.period = period;
        self.drawLayer.data = self.data;
        self.drawLayer.needUpdateScrollCache = YES;
        self.drawLayer.dataRange = self.dataRangeDefault;

        self.actionLayer.period = period;
        self.actionLayer.dataRange = self.dataRangeDefault;
        
    }
    
    [self.drawLayer setNeedsDisplay];
    [self.actionLayer setNeedsDisplay];
    
    [self dismissActionLayer];
    
    if(isSameData) [self animationToNormalPositionWithVelocity:0];
}

- (void) layoutSublayersOfLayer:(CALayer *)layer
{
    self.drawLayer.frame = self.bounds;
    self.actionLayer.frame = self.bounds;
    self.loadingLayer.frame = self.bounds;
    
    [self.drawLayer setNeedsDisplay];
    [self.actionLayer setNeedsDisplay];
    [self.loadingLayer setNeedsDisplay];
    
    [self dismissActionLayer];
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self dismissActionLayer];
    [self stopAnimation];
}

- (void)handlePanGesture:(UIPanGestureRecognizer *)sender
{
    if(sender.state == UIGestureRecognizerStateBegan) {
        self.animationStartDataRange = self.drawLayer.dataRange;
    }
    else if (sender.state == UIGestureRecognizerStateEnded || sender.state == UIGestureRecognizerStateCancelled) {
        CGFloat velocity = [sender velocityInView:self].x;
        
        if(self.loadingStatus != CentChartLoadingStatusIdle && self.loadingLayer) {
            // Disable user interaction
            self.userInteractionEnabled = NO;
            
            // Show loading background
            self.loadingLayer.backgroundColor = self.theme.loadingBackgroundColor.CGColor;
            
            // Show loading animation
            CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"loadingRotation"];
            anim.duration = 0.5;
            anim.fromValue = [NSNumber numberWithFloat:0];
            anim.toValue = [NSNumber numberWithFloat:1];
            anim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
            anim.repeatCount = HUGE_VALF;
            
            [self.loadingLayer addAnimation:anim forKey:@"animateLoadingRotation"];
        }
        
        [self animationToNormalPositionWithVelocity:velocity];
        
        return;
    }
    
    // Prepare mapping
//    CGRect chartRect = CGRectInset(self.bounds, self.theme.chartPadding * 2, self.theme.chartPadding * 2);
    CGRect chartRect = CGRectMake(self.bounds.origin.x + self.theme.chartPaddingLeft,
                                  self.bounds.origin.y + self.theme.chartPaddingTop,
                                  self.bounds.size.width - self.theme.chartPaddingLeft - self.theme.chartPaddingRight,
                                  self.bounds.size.height - self.theme.chartPaddingTop - self.theme.chartPaddingBottom);
    
    chartRect.size.width -= self.theme.axisWidth;
    
    CentChartMapping *mapping = [CentChartMapping mappingWithIndex:0 dataRange:self.drawLayer.dataRange viewPort:chartRect theme:self.theme period:self.period];
    float unitWidth = mapping.getUnitWidth;
    
    // Update data range
    CGPoint translate = [sender translationInView:self];
    
    CGFloat offset = - translate.x / unitWidth;
    
    CGPoint targetDataRange = CGPointMake(self.animationStartDataRange.x + offset, self.drawLayer.dataRange.y);
    
    CGRect dataRangeLimit = self.dataRangeLimit;
    CGPoint currentDataRange = self.drawLayer.dataRange;
    
    CGFloat dataStartIndexMax = CGRectGetMaxX(dataRangeLimit) - currentDataRange.y;
    CGFloat dataStartIndexMin = MIN(0, dataStartIndexMax);
    
    if(targetDataRange.x > dataStartIndexMax) {
        CGFloat extendOffset = targetDataRange.x - dataStartIndexMax;
        
        targetDataRange.x -= MIN(offset, extendOffset) * 2 / 3;
    }
    else if(targetDataRange.x < dataStartIndexMin) {
        CGFloat extendOffset = targetDataRange.x - dataStartIndexMin;

        targetDataRange.x -= MAX(offset, extendOffset) * 2 / 3;
    }

    self.drawLayer.dataRange = targetDataRange;
    [self.drawLayer setNeedsDisplay];
    [self dismissActionLayer];
    
    // Update loading location
    CGPoint currentLoadingLocation = self.loadingLayer.loadingLocation;
    CGPoint targetLoadingLocation = currentLoadingLocation;
    
    if(targetDataRange.x >= dataStartIndexMax + 0.5) {   //load more
        CGFloat offsetx = MIN((targetDataRange.x - dataStartIndexMax - 0.5) * unitWidth, self.theme.loadingWidth);
        
        if(offsetx == self.theme.loadingWidth) {
            targetLoadingLocation = CGPointMake(offsetx, 1);
            self.loadingStatus = CentChartLoadingStatusRight;
        }
        else {
            targetLoadingLocation = CGPointMake(offsetx, 0);
            self.loadingStatus = CentChartLoadingStatusIdle;
        }
    }
    else if(targetDataRange.x < dataStartIndexMin - 0.5) {
        CGFloat offsetx = MAX((targetDataRange.x - dataStartIndexMin + 0.5) * unitWidth, -self.theme.loadingWidth);

        if(offsetx == -self.theme.loadingWidth) {
            targetLoadingLocation = CGPointMake(offsetx, 1);
            self.loadingStatus = CentChartLoadingStatusLeft;
        }
        else {
            targetLoadingLocation = CGPointMake(offsetx, 0);
            self.loadingStatus = CentChartLoadingStatusIdle;
        }
    }
    else {
        targetLoadingLocation = CGPointMake(0, 0);
        self.loadingStatus = CentChartLoadingStatusIdle;
    }

    if(currentLoadingLocation.y != targetLoadingLocation.y) {
        CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"loadingLocation"];
        anim.duration = 0.1;
        anim.fromValue = [NSValue valueWithCGPoint:currentLoadingLocation];
        anim.toValue = [NSValue valueWithCGPoint:targetLoadingLocation];
        anim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        
        [self.loadingLayer addAnimation:anim forKey:@"animateLoadingLocation"];
        self.loadingLayer.loadingLocation = targetLoadingLocation;
        
    }
    else {
        self.loadingLayer.loadingLocation = targetLoadingLocation;
        [self.loadingLayer setNeedsDisplay];
    };
}

- (void)handlePinchGesture:(UIPinchGestureRecognizer *)sender
{
    if(sender.state == UIGestureRecognizerStateBegan) {
        [self stopAnimation];
        self.animationStartDataRange = self.drawLayer.dataRange;
    }
    else if (sender.state == UIGestureRecognizerStateEnded || sender.state == UIGestureRecognizerStateCancelled) {
        if(!CGRectContainsPoint(self.dataRangeLimit, self.drawLayer.dataRange)) {
            [self animationToNormalPositionWithVelocity:0];
        }
        
        return;
    }
    
    // Update data range
    CGFloat scale = sender.scale;

    CGRect dataRangeLimit = self.dataRangeLimit;
    CGPoint originalDataRange = self.animationStartDataRange;
    CGPoint targetDataRange = originalDataRange;

    // Update data length
    targetDataRange.y = originalDataRange.y / scale;
    
    /*
     CGRect chartRect = CGRectInset(self.bounds, self.theme.chartPadding * 2, self.theme.chartPadding * 2);
     chartRect.size.width -= self.theme.axisWidth;
     float width = chartRect.size.width - self.theme.axisHPadding  * 2 - 2;
     float unitWidth = width / self.drawLayer.dataRange.y;
     NSLog(@"---------->> self.drawLayer.candleWidth=%f, scale=%f", unitWidth, scale);
     */
    
    if(targetDataRange.y > CGRectGetMaxY(dataRangeLimit)) {
        CGFloat dampRate = (CGRectGetMaxY(dataRangeLimit) - 5) / CGRectGetMaxY(dataRangeLimit);
        
        if(originalDataRange.y > CGRectGetMaxY(dataRangeLimit)) {
            targetDataRange.y -= (targetDataRange.y - originalDataRange.y) * dampRate;
        }
        else {
            targetDataRange.y -= (targetDataRange.y - CGRectGetMaxY(dataRangeLimit)) * dampRate;
        }
    }
    else if(targetDataRange.y < CGRectGetMinY(dataRangeLimit)) {
        CGFloat dampRate = (CGRectGetMinY(dataRangeLimit) - 5) / CGRectGetMinY(dataRangeLimit);

        if(originalDataRange.y < CGRectGetMinY(dataRangeLimit)) {
            targetDataRange.y -= (targetDataRange.y - originalDataRange.y) * dampRate;
        }
        else {
            targetDataRange.y -= (targetDataRange.y - CGRectGetMinY(dataRangeLimit)) * dampRate;
        }
    }
    
    targetDataRange.x = originalDataRange.x + (originalDataRange.y - targetDataRange.y) / 2;
    
    // Update data start index
    // Attache to right edge
    if(originalDataRange.x + originalDataRange.y == CGRectGetMaxX(dataRangeLimit)) {
        targetDataRange.x = CGRectGetMaxX(dataRangeLimit) - targetDataRange.y;
    }
    // Right edge limit
    else if(targetDataRange.x + targetDataRange.y > CGRectGetMaxX(dataRangeLimit)) {
        targetDataRange.x = CGRectGetMaxX(dataRangeLimit) - targetDataRange.y;
    }
    // Left edge limit
    else if(targetDataRange.x < CGRectGetMinX(dataRangeLimit)) {
        targetDataRange.x = CGRectGetMinX(dataRangeLimit);
    }
    
    // Draw
    self.drawLayer.dataRange = targetDataRange;
    [self.drawLayer setNeedsDisplay];
}

- (void)handleLongPressGesture:(UILongPressGestureRecognizer *)sender
{
    if(sender.state == UIGestureRecognizerStateBegan) {
        [self stopAnimation];
        self.actionLayer.dataRange = self.drawLayer.dataRange;
        self.actionLayer.opacity = 1.0;
    }
    else if (sender.state == UIGestureRecognizerStateEnded || sender.state == UIGestureRecognizerStateCancelled) {
        
        return;
    }

    self.actionLayer.dataRange = self.drawLayer.dataRange;
    self.actionLayer.actionLocation = [sender locationInView:self];
    [self.actionLayer setNeedsDisplay];
}

-(void)dismissActionLayer
{
    self.actionLayer.opacity = 0.0;
    self.actionLayer.dataRange = self.drawLayer.dataRange;
    self.actionLayer.actionLocation = CGPointMake(0, 0);
    [self.actionLayer setNeedsDisplay];
}

- (void)handleTapGesture:(UITapGestureRecognizer *)sender
{
    CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"dataRange"];
    anim.duration = 0.25;
    anim.fromValue = [NSValue valueWithCGPoint:self.drawLayer.dataRange];
    anim.toValue = [NSValue valueWithCGPoint:self.dataRangeDefault];
    anim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    [self.drawLayer addAnimation:anim forKey:@"animateDataRange"];
    self.drawLayer.dataRange = self.dataRangeDefault;
}

- (void)animationDidStop:(CAAnimation *)theAnimation finished:(BOOL)flag
{
    if(self.loadingStatus != CentChartLoadingStatusIdle) {
        // Load data
        NSDate *startTime = nil;
        NSDate *endTime = nil;
        
        if(self.data.count > 0) {
            if(self.loadingStatus == CentChartLoadingStatusRight) {
                CentChartDataCandle *candle = self.data.lastObject;
                startTime = candle.timestamp;
            }
            else {
                CentChartDataCandle *candle = self.data[0];
                endTime = candle.timestamp;
            }
        }
        NSLog(@"---->>> startTime:%@, endTime:%@", [NSString stringWithFormat:@"%@" , startTime], [NSString stringWithFormat:@"%@" , endTime]);
        [self.dataLoader loadChartDataWidthCode:self.code period:self.period startTime:startTime endTime:endTime]; //load more
    }
}

- (void) animationToNormalPositionWithVelocity:(CGFloat)velocity
{
    CGRect dataRangeLimit = self.dataRangeLimit;
    CGPoint currentDataRange = self.drawLayer.dataRange;
    
    CGFloat dataStartIndexMax = CGRectGetMaxX(dataRangeLimit) - currentDataRange.y;
    CGFloat dataStartIndexMin = MIN(0, dataStartIndexMax);

    if(currentDataRange.x < dataStartIndexMin||
       currentDataRange.x > dataStartIndexMax||
       currentDataRange.y < CGRectGetMinY(dataRangeLimit) ||
       currentDataRange.y > CGRectGetMaxY(dataRangeLimit)) {
        
        CGPoint targetDataRange = currentDataRange;
        
        // Check data length
        if(targetDataRange.y < CGRectGetMinY(dataRangeLimit)) targetDataRange.y = CGRectGetMinY(dataRangeLimit);
        else if(targetDataRange.y > CGRectGetMaxY(dataRangeLimit)) targetDataRange.y = CGRectGetMaxY(dataRangeLimit);

        // Check data start index
        targetDataRange.x = currentDataRange.x + (currentDataRange.y - targetDataRange.y) / 2;

        dataStartIndexMax = CGRectGetMaxX(dataRangeLimit) - targetDataRange.y;
        dataStartIndexMin = MIN(0, dataStartIndexMax);
        
        if(self.loadingStatus != CentChartLoadingStatusIdle && self.loadingLayer) {
//            CGRect chartRect = CGRectInset(self.bounds, self.theme.chartPadding * 2, self.theme.chartPadding * 2);
            CGRect chartRect = CGRectMake(self.bounds.origin.x + self.theme.chartPaddingLeft,
                                          self.bounds.origin.y + self.theme.chartPaddingTop,
                                          self.bounds.size.width - self.theme.chartPaddingLeft - self.theme.chartPaddingRight,
                                          self.bounds.size.height - self.theme.chartPaddingTop - self.theme.chartPaddingBottom);
            
//            if(self.period == CentChartPeriodCandle1Minute) {
//                chartRect.origin.x += self.theme.axisWidth;
//                chartRect.size.width -= self.theme.axisWidth * 2;
//            }
//            else {
                chartRect.size.width -= self.theme.axisWidth;
//            }
            
            CentChartMapping *mapping = [CentChartMapping mappingWithIndex:0 dataRange:self.drawLayer.dataRange viewPort:chartRect theme:self.theme period:self.period];
            float unitWidth = mapping.getUnitWidth;
            
            if(self.loadingStatus == CentChartLoadingStatusLeft) {
                dataStartIndexMin -= self.theme.loadingWidth / unitWidth + 0.5;
            }
            else if(self.loadingStatus == CentChartLoadingStatusRight) {
                dataStartIndexMax += self.theme.loadingWidth / unitWidth + 0.5;
            }
        }

        // Attache to right edge
        if(currentDataRange.x >= dataStartIndexMax) {
            targetDataRange.x = dataStartIndexMax;
        }
        // Attache to left edge
        else if(currentDataRange.x <= dataStartIndexMin) {
            targetDataRange.x = dataStartIndexMin;
        }

        CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"dataRange"];
        anim.duration = 0.25;
        anim.fromValue = [NSValue valueWithCGPoint:currentDataRange];
        anim.toValue = [NSValue valueWithCGPoint:targetDataRange];
        anim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        anim.delegate = self;
        
        [self.drawLayer addAnimation:anim forKey:@"animateDataRange"];
        self.drawLayer.dataRange = targetDataRange;
    }
    else if(velocity != 0) {
        CGFloat dataStartIndexMax = CGRectGetMaxX(dataRangeLimit) - currentDataRange.y;
        CGFloat dataStartIndexMin = MIN(0, dataStartIndexMax);
        
        // Prepare mapping
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

        CentChartMapping *mapping = [CentChartMapping mappingWithIndex:0 dataRange:currentDataRange viewPort:chartRect theme:self.theme period:self.period];

        CGFloat unitWidth = mapping.getUnitWidth;
        
        // Calculate values
        CGFloat extendLimit = 100;
        CGFloat a = 5000;
        
        CGFloat d = velocity > 0 ? -1 : 1;
        CGFloat s = velocity * velocity / 2 / a * d;
        CGFloat t = fabs(velocity) / a;
        
        bool needBack = NO;
        CGPoint backDataRange = CGPointMake(0, 0);
        
        if(currentDataRange.x + s / unitWidth > dataStartIndexMax) {
            CGFloat extendS = (currentDataRange.x + s / unitWidth - dataStartIndexMax) * unitWidth;
            CGFloat excludeS = extendS - MIN(extendLimit, extendS / 2);
            
            CGFloat t1 = sqrtf(2 * excludeS / a);
            
            t = MAX(0, t - t1);
            s -= excludeS;
            
            needBack = YES;
            backDataRange = CGPointMake(dataStartIndexMax, currentDataRange.y);
        }
        else if(currentDataRange.x + s / unitWidth < dataStartIndexMin) {
            CGFloat extendS = (dataStartIndexMin - currentDataRange.x - s / unitWidth) * unitWidth;
            CGFloat excludeS = extendS - MIN(extendLimit, extendS / 2);

            CGFloat t1 = sqrtf(2 * excludeS / a);
            
            t = MAX(0, t - t1);
            s += excludeS;
            
            needBack = YES;
            backDataRange = CGPointMake(dataStartIndexMin, currentDataRange.y);
        }
        
        CGPoint targetDataRange = CGPointMake(currentDataRange.x + s / unitWidth, currentDataRange.y);

        if(needBack) {
            CAKeyframeAnimation *anim = [CAKeyframeAnimation animationWithKeyPath:@"dataRange"];
            anim.duration = t + 0.2;
            anim.values = @[[NSValue valueWithCGPoint:currentDataRange], [NSValue valueWithCGPoint:targetDataRange], [NSValue valueWithCGPoint:backDataRange]];
            anim.keyTimes = @[[NSNumber numberWithDouble:0], [NSNumber numberWithDouble:t / anim.duration], [NSNumber numberWithDouble:1.0]];
            anim.timingFunctions = @[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut], [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
            anim.calculationMode = kCAAnimationLinear;

            [self.drawLayer addAnimation:anim forKey:@"animateDataRange"];
            self.drawLayer.dataRange = backDataRange;
        }
        else {
             CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"dataRange"];
             anim.duration = t;
             anim.fromValue = [NSValue valueWithCGPoint:currentDataRange];
             anim.toValue = [NSValue valueWithCGPoint:targetDataRange];
             anim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];

            [self.drawLayer addAnimation:anim forKey:@"animateDataRange"];
            self.drawLayer.dataRange = targetDataRange;
        }
    }
    
    // Animate loading layer
    if(self.loadingLayer && self.loadingLayer.loadingLocation.x != 0 && self.loadingStatus == CentChartLoadingStatusIdle) {
        CGPoint currentLoadingLocation = self.loadingLayer.loadingLocation;
        CGPoint targetLoadingLocation = CGPointMake(0, 0);

        CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"loadingLocation"];
        anim.duration = 0.25;
        anim.fromValue = [NSValue valueWithCGPoint:currentLoadingLocation];
        anim.toValue = [NSValue valueWithCGPoint:targetLoadingLocation];
        anim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];

        [self.loadingLayer addAnimation:anim forKey:@"animateLoadingLocation"];
        self.loadingLayer.loadingLocation = targetLoadingLocation;
    }

}

- (void) stopAnimation
{
    self.drawLayer.dataRange = ((CentChartLayerDraw *)self.drawLayer.presentationLayer).dataRange;
    [self.drawLayer removeAnimationForKey:@"animateDataRange"];
}

@end
