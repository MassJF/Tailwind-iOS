//
//  ScheduleDetailsWidget.h
//  MADContest
//
//  Created by JingFeng Ma on 2020/4/4.
//  Copyright © 2020 JingFeng Ma. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "Schedule.h"

NS_ASSUME_NONNULL_BEGIN

#define SCHEDULEDETAILSWIDGET_TOP_MARGIN 50.0f
#define SCHEDULEDETAILSWIDGET_BOTTOM_MARGIN 80.0f

@protocol ScheduleDetailsWidgetProtocol <NSObject>

-(void)cancelStartAnnotation;
-(void)cancelEndAnnotation;
-(void)uploadSchedule:(Schedule *)schedule;
-(void)confirmSchedule:(Schedule *)schedule;
-(void)searchLocationsWithString:(NSString *)location;
-(void)searchResultDidClicked:(CLLocation *)location withRegion:(CLRegion *)region;
-(void)showQRScanningView;
-(void)showQRCode;
-(void)backButtonClicked;

@end

@interface ScheduleDetailsWidget : UIViewController <UIGestureRecognizerDelegate>

@property (weak, nonatomic) id<ScheduleDetailsWidgetProtocol>delegate;
@property (strong, nonatomic) Schedule *schedule;
@property (strong, nonatomic) NSMutableArray<Schedule *> *mySchedules;
@property (strong, nonatomic, nullable) NSMutableArray<Schedule *> *availableSchedule;
@property (retain, nonatomic) Schedule *selectedSchedule;

-(void)addScheduleStartAt:(CLLocationCoordinate2D)coordinate onTime:(int64_t)time location:(NSString *)location;
-(void)addScheduleEndAt:(CLLocationCoordinate2D)coordinate onTime:(int64_t)time location:(NSString *)location;
-(void)removeScheduleStarting;
-(void)removeScheduleEnding;
-(void)showLocationSearchingResults:(nullable NSArray<NSDictionary *> *)results withSourceString:(NSString *)source;
-(void)refreshTableView;
-(void)dragWidgetWithVelocity:(float)velocity;
-(void)showScheduleWidget:(BOOL)show;
//-(void)setAvailableSchedule:(Schedule *)availableSchedule;

@end

NS_ASSUME_NONNULL_END
