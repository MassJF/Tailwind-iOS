//
//  PieGraph.m
//  PieGraphTest
//
//  Created by BaoZhen on 14-10-10.
//  Copyright (c) 2014年 BaoZhen. All rights reserved.
//

#import "CircleChart.h"
#import "SwitchButton.h"
//#import "StringDefines.h"

#define RADIUS_TO(value) ((M_PI * value) / 180)
#define TO_RADIUS(value) ((value / M_PI) * 180)
#define LINE_WIDTH 2.0f

@interface CircleChart ()

@property (strong, nonatomic) NSArray* circleChartData;
@property (strong, nonatomic) NSArray* colors;
@property (strong, nonatomic) SwitchButton* switchButton1;
@property (strong, nonatomic) SwitchButton* switchButton2;
@property (nonatomic) NSInteger type;

@end

@implementation CircleChart

-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if(self){
        _currentTag = -1;
//        _tap =  [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selfTap:)];
//        [self addGestureRecognizer:_tap];
        self.type = 1;
        self.colors = @[[UIColor colorWithRed:0x63/255.0 green:0xb8/255.0 blue:0xff/255.0 alpha:1.0f],
                        [UIColor colorWithRed:0x00/255.0 green:0xee/255.0 blue:0x00/255.0 alpha:1.0f],
                        [UIColor colorWithRed:0xee/255.0 green:0xee/255.0 blue:0x00/255.0 alpha:1.0f],
                        [UIColor colorWithRed:0xee/255.0 green:0x9a/255.0 blue:0x49/255.0 alpha:1.0f],
                        [UIColor colorWithRed:0xee/255.0 green:0x5c/255.0 blue:0x42/255.0 alpha:1.0f]];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _currentTag = -1;
        _tap =  [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selfTap:)];
        [self addGestureRecognizer:_tap];
        
        _centerPoint.x = frame.size.width / 3;
        _centerPoint.y = frame.size.height / 2;
        if (_centerPoint.x > _centerPoint.y) {
            _radius = frame.size.height / 2 - PADDING;
        } else {
            _radius = frame.size.width / 3 - PADDING;
        }
        
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    CGRect frame = self.frame;
    _centerPoint.x = frame.size.width / 4;
    _centerPoint.y = frame.size.height / 2;
    if (_centerPoint.x > _centerPoint.y) {
        _radius = frame.size.height / 2 - PADDING;
    } else {
        _radius = frame.size.width / 4 - PADDING;
    }
    
    // 自定义绘制饼图
    for (int i = 0; i < _radiusValues.count; i++) {
        RadiusRange * r = [_radiusValues objectAtIndex:i];
        
//        NSLog(@"%f", r.start);
//        NSLog(@"%f", r.end);
//        NSLog(@"%f", RADIUS_TO(r.start));
//        NSLog(@"%f", RADIUS_TO(r.end));
        
        UIBezierPath*  aPath = [UIBezierPath bezierPathWithArcCenter:_centerPoint
                                                              radius:_radius
                                                          startAngle:RADIUS_TO(r.start)
                                                            endAngle:RADIUS_TO(r.end)
                                                           clockwise:YES];
        
        [aPath setLineWidth:LINE_WIDTH];
        [aPath addLineToPoint:_centerPoint];
        
        [aPath closePath];
        [[self.colors objectAtIndex:i % [self.colors count]] setFill];
        [_lineColor setStroke];
        [aPath stroke];
        [aPath fill];
//        CABasicAnimation *opacityAnim = [CABasicAnimation animationWithKeyPath:@"alpha"];
//        opacityAnim.fromValue = [NSNumber numberWithFloat:1.0];
//        opacityAnim.toValue = [NSNumber numberWithFloat:0.1];
//        opacityAnim.removedOnCompletion = YES;
//        [self.layer addAnimation:opacityAnim forKey:nil];
    }
    [self showColorAndText];
}

-(void)switchButtonClicked:(id)sender{
    
    if([sender isEqual:self.switchButton1]){
        self.type = 1;
    }
    if([sender isEqual:self.switchButton2]){
        self.type = 2;
    }
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(circleChartNeedReloadData:)]){
        [self.delegate circleChartNeedReloadData:self.type];
    }
}

- (void)showColorAndText {
    CGFloat switchButtonWidth = 70.0f;
    CGFloat switchButtonHeight = 25.0f;
    self.switchButton1 = [[SwitchButton alloc] init];
    self.switchButton2 = [[SwitchButton alloc] init];
    [self.switchButton1 addTarget:self action:@selector(switchButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.switchButton2 addTarget:self action:@selector(switchButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.switchButton1 setTitle:@"按产品分类" forState:UIControlStateNormal];
    [self.switchButton2 setTitle:@"按类型分类" forState:UIControlStateNormal];
    [self.switchButton1 setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [self.switchButton2 setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    self.switchButton1.titleLabel.font = [UIFont systemFontOfSize:12.0];
    self.switchButton2.titleLabel.font = [UIFont systemFontOfSize:12.0];
    self.switchButton1.layer.borderColor = [[UIColor colorWithRed:0.8f green:0.8f blue:0.8f alpha:1.0f] CGColor];
    self.switchButton2.layer.borderColor = [[UIColor colorWithRed:0.8f green:0.8f blue:0.8f alpha:1.0f] CGColor];
    self.switchButton1.layer.borderWidth = 1;
    self.switchButton2.layer.borderWidth = 1;
    
    [self.switchButton1 setBackgroundColor:[UIColor colorWithRed:0.9f green:0.9f blue:0.9f alpha:1.0f]];
    [self.switchButton2 setBackgroundColor:[UIColor colorWithRed:0.9f green:0.9f blue:0.9f alpha:1.0f]];
    [self.switchButton1 setClicked:NO];
    [self.switchButton2 setClicked:NO];
    
    if(self.type == 1){
        [self.switchButton1 setTitleColor:self.themeColor forState:UIControlStateNormal];
        [self.switchButton1 setBackgroundColor:[UIColor whiteColor]];
    }else{
        [self.switchButton2 setTitleColor:self.themeColor forState:UIControlStateNormal];
        [self.switchButton2 setBackgroundColor:[UIColor whiteColor]];
    }
    
    CGRect frame1 = CGRectMake(_centerPoint.x * 2 + PADDING, 0, switchButtonWidth, switchButtonHeight);
    CGRect frame2 = CGRectMake(CGRectGetMaxX(frame1) - 1, 0, switchButtonWidth, switchButtonHeight);
    
    self.switchButton1.frame = frame1;
    self.switchButton2.frame = frame2;
    
    [self addSubview:self.switchButton1];
    [self addSubview:self.switchButton2];
    
//    CGFloat colorWidth = (self.frame.size.height - 4 * PADDING) / _radiusValues.count * 0.6;
    for (int i = 0; i < MIN(_radiusValues.count, 5) ; i++) {
        
        if(i < 4){
            RadiusRange* radiusRange = [_radiusValues objectAtIndex:i];
            
            CGRect rect = CGRectMake(_centerPoint.x * 2 + PADDING,
                                     CGRectGetMaxY(frame2) + PADDING + i * (15.0f + PADDING),
                                     15.0f,
                                     15.0f);
            
            UIView * vi = [[UIView alloc] initWithFrame:rect];
            vi.backgroundColor = [self.colors objectAtIndex:i % [self.colors count]];
            [self addSubview:vi];
            
            CGRect lRect = CGRectMake(CGRectGetMaxX(vi.frame) + 5,
                                      vi.frame.origin.y,
                                      self.frame.size.width - CGRectGetMaxX(vi.frame),
                                      vi.frame.size.height);
            UILabel * lable = [[UILabel alloc] initWithFrame:lRect];
            lable.lineBreakMode = NSLineBreakByTruncatingMiddle;
            CircleChartData* data = [self.circleChartData objectAtIndex:i];
            NSString* text = data.text;
            text = [NSString stringWithFormat:@"%@(%.1f%%)", text, radiusRange.percent];
            [lable setText:text];
            lable.textAlignment = NSTextAlignmentLeft;
            [lable setBackgroundColor:[UIColor clearColor]];
            [lable setTextColor:[UIColor grayColor]];
            [lable setFont:[UIFont systemFontOfSize:13.0f]];
            [self addSubview:lable];
        }else{
            CGRect rect = CGRectMake(_centerPoint.x * 2 + PADDING,
                                     CGRectGetMaxY(frame2) + PADDING + i * (15.0f + PADDING),
                                     15.0f,
                                     15.0f);
            
            CGRect lRect = CGRectMake(CGRectGetMaxX(rect) + 5,
                                      rect.origin.y,
                                      self.frame.size.width - CGRectGetMaxX(rect),
                                      rect.size.height);
            UILabel * lable = [[UILabel alloc] initWithFrame:lRect];
//            CircleChartData* data = [self.circleChartData objectAtIndex:i];
//            NSString* text = data.text;
//            text = [NSString stringWithFormat:@"%@(%.1f%%)", text, radiusRange.percent];
            [lable setText:@"更多省略..."];
            lable.textAlignment = NSTextAlignmentLeft;
            [lable setBackgroundColor:[UIColor clearColor]];
            [lable setTextColor:self.themeColor];
            [lable setFont:[UIFont systemFontOfSize:13.0f]];
            [self addSubview:lable];
        }
    }
}

-(void)setData:(NSArray* )data{
    for(UIView* view in [self subviews]){
        [view removeFromSuperview];
    }
    
    if(data){
        self.circleChartData = [NSArray arrayWithArray:data];
    }

    if (data.count > 0) {
        
        NSMutableArray * array = [[NSMutableArray alloc] init];
        CGFloat num = 0;
        for (CircleChartData* val in data) {
            num += [val.value floatValue];
        }
        CGFloat end = 0;
        for (int i = 0; i < data.count; i++) {
            RadiusRange * r = [[RadiusRange alloc] init];
            CircleChartData* circleChartData = [data objectAtIndex:i];
            
            if (i == 0) {
                r.start = -90;
                r.end = r.start + [circleChartData.value floatValue] / num * 360;
                r.percent = [circleChartData.value floatValue] / num * 100;
                [array addObject:r];
                end = r.end;
            } else {
                r.start = end;
                r.end = r.start + [circleChartData.value floatValue] / num * 360;
                r.percent = [circleChartData.value floatValue] / num * 100;
                [array addObject:r];
                end = r.end;
            }
//            NSLog(@"%f,%f",r.start,r.end);
        }
        _radiusValues = array;
        [self setNeedsDisplay];
    }
}

#pragma mark -- 根据点判断点击的位置在哪个扇形区
- (NSInteger)PointOnArea:(CGPoint)point {
    CGPoint p = [self PointAboutCenter:point];
    CGFloat radius = [self PointToRadiu:p];
    NSInteger num = [self RadiusToTag:radius];
    return num;
}

//判断角度对应扇形区
- (NSInteger)RadiusToTag:(CGFloat)radius {
    for (int i = 0; i < _radiusValues.count; i++) {
        RadiusRange * range = [_radiusValues objectAtIndex:i];
        if (radius >= range.start && radius <= range.end) {
            return i;
        }
    }
    return -1;
}

- (CGFloat)PointToRadiu:(CGPoint)point {
    float r = atan(point.y/point.x);
    
    CGFloat radius = TO_RADIUS(r);
    if (point.x < 0 && point.y > 0) {
        radius = 180 + radius;
    } else if (point.x < 0 && point.y < 0) {
        radius += 180;
    } else if (point.x >0 && point.y <0) {
        radius = 360 + radius;
    }
//    NSLog(@"%f",radius);
    return radius;
}

- (CGPoint)PointAboutCenter:(CGPoint)point {
    CGPoint  p;
    p.x = point.x - _centerPoint.x;
    p.y = point.y - _centerPoint.y;
    return p;
}

#pragma mark -- getMethod

- (UILabel *)getDitalView:(NSInteger)index {
    UILabel * label = [[UILabel alloc] init];
    label.frame = CGRectMake(0, 0, _radius / 2, _radius / 4);
    RadiusRange * range = [_radiusValues objectAtIndex:index];
    NSString * str = [NSString stringWithFormat:@"%.1f%%",(range.end - range.start)/3.6];
    label.font = [UIFont systemFontOfSize:label.frame.size.width/(str.length - 1)];
    label.text = str;
    label.textColor = [self.colors objectAtIndex:index];
    label.textAlignment = NSTextAlignmentCenter;
    label.layer.masksToBounds = YES;
    label.layer.borderWidth = 1;
    label.layer.borderColor = self.textColor.CGColor;
    label.layer.cornerRadius = _radius / 16;
    label.backgroundColor = self.textColor;
    return label;
}

#pragma mark -- SetMethod

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    [self setNeedsDisplay];
}

- (void)selfTap:(UITapGestureRecognizer *)tap {
    CGPoint point = [tap locationInView:self];
    if (point.x < _centerPoint.x * 2) {
        NSInteger num = [self PointOnArea:[tap locationInView:self]];
        [self showDitealView:num];
    }
}

- (void)showDitealView:(NSInteger)num {
    if (_currentTag != num) {
        CGPoint point = [self getShowCenterPoint:num];
        UILabel * label = [self getDitalView:num];
        CGRect rect = CGRectMake(point.x - label.frame.size.width / 3, point.y  - label.frame.size.width / 3, label.frame.size.width, label.frame.size.height);
        label.frame = rect;
        if (self.detialView.superview) {
            [self.detialView removeFromSuperview];
        }
        self.detialView = label;
        [self addSubview:self.detialView];
        _currentTag = num;
//        NSLog(@"xx:%f,yy:%f",point.x,point.y);
    } else {
        if (self.detialView.superview) {
            [self.detialView removeFromSuperview];
        } else {
            [self addSubview:self.detialView];
        }
    }
}

- (CGPoint)getShowCenterPoint:(NSInteger)num {
    CGPoint point;
    CGFloat changeRadiu = 0.6 * _radius;
    RadiusRange *range = [_radiusValues objectAtIndex:num];
    CGFloat radiu = (range.end - range.start) / 2 + range.start;
    if (radiu >= 0 && radiu < 90) {
        point.y = sin(RADIUS_TO(radiu))* changeRadiu;
        point.x = point.y / tan(RADIUS_TO(radiu));
    } else if (radiu >= 90 && radiu < 180) {
        radiu = 180 - radiu;
        point.y = sin(RADIUS_TO(radiu))* changeRadiu;
        point.x = - point.y / tan(RADIUS_TO(radiu));
    } else if (radiu >= 180 && radiu < 270) {
        radiu -= 180;
        point.y = -sin(RADIUS_TO(radiu))* changeRadiu;
        point.x = point.y / tan(RADIUS_TO(radiu));
    } else {
        radiu = 360 -radiu;
        point.y = -sin(RADIUS_TO(radiu))* changeRadiu;
        point.x = -point.y / tan(RADIUS_TO(radiu));
    }
    point.x += _centerPoint.x;
    point.y += _centerPoint.y;
    return point;
}

@end

@implementation RadiusRange

@end

@implementation CircleChartData

@end
