//
//  MapViewController.h
//  MADContest
//
//  Created by JingFeng Ma on 2020/2/18.
//  Copyright © 2020 JingFeng Ma. All rights reserved.
//

#import "ViewController.h"
#import <MapKit/MapKit.h>
#import "BaseTimePickerViewController.h"


NS_ASSUME_NONNULL_BEGIN

@interface MapViewController : ViewController <MKMapViewDelegate, CLLocationManagerDelegate, BaseDatePickerViewProtocol>

@property (nonatomic) enum Role role;
@property (strong, nonatomic) IBOutlet MKMapView *mapView;

@end

NS_ASSUME_NONNULL_END
