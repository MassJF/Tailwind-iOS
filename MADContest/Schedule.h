//
//  Schedule.h
//  MADContest
//
//  Created by JingFeng Ma on 2020/4/6.
//  Copyright © 2020 JingFeng Ma. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Schedule : NSObject
@property (nonatomic) int confirmed;
@property (nonatomic) NSInteger scheduleId;
@property (strong, nonatomic) NSString *orderId;
@property (nonatomic) NSInteger orderStatus;
@property (nonatomic) NSInteger scheduleStatus;
@property (nonatomic) int64_t startTime;
@property (nonatomic) int64_t endTime;
@property (nonatomic) CLLocationCoordinate2D startCoordinate;
@property (nonatomic) CLLocationCoordinate2D endCoordinate;
@property (strong, nonatomic) NSString *startLocation;
@property (strong, nonatomic) NSString *endLocation;
@end

NS_ASSUME_NONNULL_END
