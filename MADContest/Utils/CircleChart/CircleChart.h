//
//  PieGraph.h
//  PieGraphTest
//
//  Created by BaoZhen on 14-10-10.
//  Copyright (c) 2014年 BaoZhen. All rights reserved.
//

#import <UIKit/UIKit.h>

#define PADDING  10

@interface RadiusRange : NSObject

@property (nonatomic, assign) CGFloat start;
@property (nonatomic, assign) CGFloat end;
@property (nonatomic, assign) CGFloat percent;

@end

@interface CircleChartData : NSObject

@property (strong, nonatomic) NSString* value;
@property (strong, nonatomic) NSString* text;

@end

@protocol CircleChartProtocol <NSObject>

-(void)circleChartNeedReloadData:(NSInteger)type;

@end

@interface CircleChart : UIView
{
    UITapGestureRecognizer * _tap;
    CGPoint _centerPoint;
    CGFloat _radius;
    NSArray *_radiusValues;
    NSInteger _currentTag;
}

//@property (nonatomic, strong) NSArray *values;
//@property (nonatomic, strong) NSArray *texts;
@property (nonatomic, strong) UIColor *lineColor;
//@property (nonatomic, strong) NSArray *areaColor;
@property (retain, nonatomic) id<CircleChartProtocol>delegate;
@property (nonatomic, strong) UIColor *textColor;
@property (nonatomic, strong) UIView *detialView;
@property (nonatomic, strong) UIColor* themeColor;

- (NSInteger)PointOnArea:(CGPoint)point;
-(void)setData:(NSArray* )data;

@end
