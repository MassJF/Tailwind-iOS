//
//  MapViewController.m
//  MADContest
//
//  Created by JingFeng Ma on 2020/2/18.
//  Copyright © 2020 JingFeng Ma. All rights reserved.
//

#import "MapViewController.h"
#import "ScheduleDetailsWidget.h"
#import "Utils.h"
#import "HTTPModelUseCompletionBlok.h"
#import "BlackProcesserViewController.h"
#import "QRScanningViewController.h"
#import "QRCodeGeneratingBVC.h"

@interface MapViewController () <ScheduleDetailsWidgetProtocol>{
//    BOOL selectedAPosition;
    BOOL selectedStartingPosition;
    BOOL selectedDestination;
}

@property (retain, nonatomic) CLPlacemark* tapPlacemark;
//@property (strong, nonatomic) MKPointAnnotation *tapAnnotation;
@property (strong, nonatomic) MKPointAnnotation *startingPointAnnotation;
@property (retain, nonatomic) CLPlacemark* startingPointPlacemark;
@property (strong, nonatomic) MKPointAnnotation *destinationAnnotation;
@property (retain, nonatomic) CLPlacemark* destinationPlacemark;
@property (strong, nonatomic) CLGeocoder *geocoder;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) BaseTimePickerViewController *datePicker;
@property (nonatomic) int64_t startTimeStamp;
@property (nonatomic) int64_t endTimeStamp;
@property (strong, nonatomic) ScheduleDetailsWidget *scheduleDetailWidget;
@property (strong, nonatomic) BlackProcesserViewController *indicator;
@property (retain, nonatomic) MKRoute *finalRoute;
@property (strong, nonatomic) QRScanningViewController *qrScanning;
@property (strong, nonatomic) QRCodeGeneratingBVC *qrCode;

@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    self->selectedAPosition = NO;
    self->selectedStartingPosition = NO;
    self->selectedDestination = NO;
    self.tapPlacemark = nil;
    self.startingPointPlacemark = nil;
    self.destinationPlacemark = nil;
    self.finalRoute = nil;
    
    self.mapView.showsUserLocation = YES;
    self.mapView.showsCompass = YES;
    
//    self.tapAnnotation = [[MKPointAnnotation alloc] init];
    self.startingPointAnnotation = [[MKPointAnnotation alloc] init];
    self.destinationAnnotation = [[MKPointAnnotation alloc] init];
    self.qrScanning = [[QRScanningViewController alloc] initWithNibName:@"QRScanningViewController" bundle:nil];
    self.qrCode = [[QRCodeGeneratingBVC alloc] initWithNibName:@"QRCodeGeneratingBVC" bundle:nil];
    
    //location manager initialization
    self.locationManager = [[CLLocationManager alloc] init];//创建位置管理器
    self.locationManager.delegate = self;//设置代理
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;//指定需要的精度级别
    self.locationManager.distanceFilter = 1000.0f;//设置距离筛选器
    [self.locationManager requestAlwaysAuthorization];
    
    self.indicator = [[BlackProcesserViewController alloc] initWithNibName:@"BlackProcesserViewController" bundle:nil style:LargeStyle];
    self.indicator.view.center = self.view.center;
    [self.view addSubview:self.indicator.view];
    
    self.datePicker = [[BaseTimePickerViewController alloc] initWithNibName:@"BaseTimePickerViewController"
                                                                     bundle:nil];
    //date picker
    self.datePicker.delegate = self;
    self.datePicker.view.frame = CGRectMake(0,
                                 selfSize.height,
                                 selfSize.width,
                                 self.datePicker.view.frame.size.height);
    
    [self.view addSubview:self.datePicker.view];
    
    //schedule detail widget
    self.scheduleDetailWidget = [GET_STORYBOARD(@"Main") instantiateViewControllerWithIdentifier:@"scheduleDetailWidget"];
    self.scheduleDetailWidget.delegate = self;
    self.scheduleDetailWidget.view.frame = CGRectMake(0,
                                                      selfSize.height - SCHEDULEDETAILSWIDGET_BOTTOM_MARGIN,
                                                      selfSize.width,
                                                      SCHEDULEDETAILSWIDGET_BOTTOM_MARGIN);
    [self.view addSubview:self.scheduleDetailWidget.view];
    
    UILongPressGestureRecognizer *tapGesture = [[UILongPressGestureRecognizer alloc]
                                                initWithTarget:self
                                                action:@selector(mapViewdidPressed:)];
    [self.mapView addGestureRecognizer:tapGesture];
    self.geocoder = [[CLGeocoder alloc] init];
    
//    [self performSelector:@selector(retrieveAvailableSchedules) withObject:nil afterDelay:5];
    [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(retrieveAvailableSchedules) userInfo:nil repeats:YES];
    [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(retrieveMySchedules) userInfo:nil repeats:YES];
}

-(void)viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

-(void)viewDidAppear:(BOOL)animated{
    [self relocate];
}

-(void)finishWithDate:(NSDate *)date{
    NSLog(@"date:%@", date);
}

-(void)clearEdittingSchedules{
    [self clearPaths:self.mapView];
    
    [self.mapView removeAnnotation:self.startingPointAnnotation];
    [self.mapView removeAnnotation:self.destinationAnnotation];
    self->selectedStartingPosition = NO;
    self->selectedDestination = NO;
    
    [self.scheduleDetailWidget removeScheduleStarting];
}

-(void)cancelStartAnnotation{
    UIAlertController *action = [UIAlertController alertControllerWithTitle:@"Confirmation"
                                                                    message:@"Are you sure to remove all locations?"
                                                             preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self clearEdittingSchedules];
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleDefault handler:nil];
    [action addAction:ok];
    [action addAction:cancel];
    [self presentViewController:action animated:YES completion:nil];
}

-(void)cancelEndAnnotation{
    UIAlertController *action = [UIAlertController alertControllerWithTitle:@"Confirmation"
                                                                    message:@"Are you sure to remove ending location?"
                                                             preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self clearPaths:self.mapView];
        [self.mapView removeAnnotation:self.destinationAnnotation];
        self->selectedDestination = NO;
        
        [self.scheduleDetailWidget removeScheduleEnding];
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleDefault handler:nil];
    [action addAction:ok];
    [action addAction:cancel];
    [self presentViewController:action animated:YES completion:nil];
    
}

-(void)canceled{
    
}

- (IBAction)relocateClicked:(id)sender {
//    [self.mapView setCenterCoordinate:self.mapView.userLocation.coordinate animated:YES];
    [self relocate];
}

#define MINIMUM_ZOOM_ARC 0.014 //approximately 1 miles (1 degree of arc ~= 69 miles)
#define ANNOTATION_REGION_PAD_FACTOR 1.25
#define MAX_DEGREES_ARC 360
- (void)zoomMapViewToFitAnnotations:(MKMapView *)mapView animated:(BOOL)animated
{
    NSArray *annotations = mapView.annotations;
    NSUInteger count = [mapView.annotations count];
    if ( count == 0) { return; } //bail if no annotations
    
    //convert NSArray of id <MKAnnotation> into an MKCoordinateRegion that can be used to set the map size
    //can't use NSArray with MKMapPoint because MKMapPoint is not an id
    MKMapPoint points[count]; //C array of MKMapPoint struct
    for( int i=0; i<count; i++ ) //load points C array by converting coordinates to points
    {
        CLLocationCoordinate2D coordinate = [(id <MKAnnotation>)[annotations objectAtIndex:i] coordinate];
        points[i] = MKMapPointForCoordinate(coordinate);
    }
    [self zoomMapView:mapView toFitPoints:points count:count animated:animated];
    /*//create MKMapRect from array of MKMapPoint
    MKMapRect mapRect = [[MKPolygon polygonWithPoints:points count:count] boundingMapRect];
    //convert MKCoordinateRegion from MKMapRect
    MKCoordinateRegion region = MKCoordinateRegionForMapRect(mapRect);
      
    //add padding so pins aren't scrunched on the edges
    region.span.latitudeDelta  *= ANNOTATION_REGION_PAD_FACTOR;
    region.span.longitudeDelta *= ANNOTATION_REGION_PAD_FACTOR;
    //but padding can't be bigger than the world
    if( region.span.latitudeDelta > MAX_DEGREES_ARC ) { region.span.latitudeDelta  = MAX_DEGREES_ARC; }
    if( region.span.longitudeDelta > MAX_DEGREES_ARC ){ region.span.longitudeDelta = MAX_DEGREES_ARC; }
      
    //and don't zoom in stupid-close on small samples
    if( region.span.latitudeDelta  < MINIMUM_ZOOM_ARC ) { region.span.latitudeDelta  = MINIMUM_ZOOM_ARC; }
    if( region.span.longitudeDelta < MINIMUM_ZOOM_ARC ) { region.span.longitudeDelta = MINIMUM_ZOOM_ARC; }
    //and if there is a sample of 1 we want the max zoom-in instead of max zoom-out
    if( count == 1 )
    {
        region.span.latitudeDelta = MINIMUM_ZOOM_ARC;
        region.span.longitudeDelta = MINIMUM_ZOOM_ARC;
    }
    [mapView setRegion:region animated:animated];*/
}

-(void)zoomMapView:(MKMapView *)mapView toFitPoints:(MKMapPoint[])points count:(NSUInteger)count animated:(BOOL)animated{
    
    //create MKMapRect from array of MKMapPoint
    MKMapRect mapRect = [[MKPolygon polygonWithPoints:points count:count] boundingMapRect];
    //convert MKCoordinateRegion from MKMapRect
    MKCoordinateRegion region = MKCoordinateRegionForMapRect(mapRect);
      
    //add padding so pins aren't scrunched on the edges
    region.span.latitudeDelta  *= ANNOTATION_REGION_PAD_FACTOR;
    region.span.longitudeDelta *= ANNOTATION_REGION_PAD_FACTOR;
    //but padding can't be bigger than the world
    if( region.span.latitudeDelta > MAX_DEGREES_ARC ) { region.span.latitudeDelta  = MAX_DEGREES_ARC; }
    if( region.span.longitudeDelta > MAX_DEGREES_ARC ){ region.span.longitudeDelta = MAX_DEGREES_ARC; }
      
    //and don't zoom in stupid-close on small samples
    if( region.span.latitudeDelta  < MINIMUM_ZOOM_ARC ) { region.span.latitudeDelta  = MINIMUM_ZOOM_ARC; }
    if( region.span.longitudeDelta < MINIMUM_ZOOM_ARC ) { region.span.longitudeDelta = MINIMUM_ZOOM_ARC; }
    //and if there is a sample of 1 we want the max zoom-in instead of max zoom-out
    if(count == 1)
    {
        region.span.latitudeDelta = MINIMUM_ZOOM_ARC;
        region.span.longitudeDelta = MINIMUM_ZOOM_ARC;
    }
    [mapView setRegion:region animated:animated];
}

- (IBAction)zoomInClicked:(id)sender {
//    CLLocationCoordinate2D centerCoordinate = [self.mapView convertPoint:self.mapView.center
//                                                    toCoordinateFromView:self.mapView];
    
    MKCoordinateRegion region = self.mapView.region;
    MKCoordinateSpan span = region.span;
    span.latitudeDelta /= ANNOTATION_REGION_PAD_FACTOR * 2;
    span.longitudeDelta /= ANNOTATION_REGION_PAD_FACTOR * 2;
    region.span = span;
    [self.mapView setRegion:region
                   animated:YES];
    
}

- (IBAction)zoomOutClicked:(id)sender {
    MKCoordinateRegion region = self.mapView.region;
    MKCoordinateSpan span = region.span;
    span.latitudeDelta = MIN(90, span.latitudeDelta * ANNOTATION_REGION_PAD_FACTOR * 2);
    span.longitudeDelta = MIN(61, span.longitudeDelta * ANNOTATION_REGION_PAD_FACTOR * 2);
    region.span = span;
    [self.mapView setRegion:region
                   animated:YES];
}

- (IBAction)startNavigationClicked:(id)sender {
    CLLocationCoordinate2D centerCoordinate = [self.mapView
                                               convertPoint:self.mapView.center
                                               toCoordinateFromView:self.mapView];
//    MKMapCamera *camera = [MKMapCamera cameraLookingAtCenterCoordinate:centerCoordinate
//                                                          fromDistance:10
//                                                                 pitch:90
//                                                               heading:0];
    MKMapCamera *camera = [MKMapCamera camera];
    [camera setCenterCoordinate:centerCoordinate];
    [camera setPitch:90];
    [camera setHeading:90];
    [self.mapView setCamera:camera animated:YES];
}

-(void)relocate{
//    [self.locationManager startUpdatingLocation];//启动位置管理器
    if ([CLLocationManager locationServicesEnabled] &&
        [CLLocationManager authorizationStatus] != kCLAuthorizationStatusDenied) {// 开启状态
        [self.locationManager requestLocation];
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    MKCoordinateRegion theRegion;
    MKCoordinateSpan theSpan;
    //地图的范围 越小越精确
    theSpan.latitudeDelta = 0.05;
    theSpan.longitudeDelta = 0.05;
    
    if(locations && locations.count > 0 && locations.firstObject){
        theRegion.center = [locations.firstObject coordinate];
        theRegion.span = theSpan;
        [self.mapView setRegion:theRegion animated:YES];
    }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    if ([error code] == kCLErrorDenied) {
        NSLog(@"访问被拒绝");
    }
    if ([error code] == kCLErrorLocationUnknown) {
        NSLog(@"无法获取位置信息");
    }
    NSLog(@"Locating error:%@", error);
}

-(void)drawPaths{
    if(self->selectedStartingPosition && self->selectedDestination){
        [self clearPaths:self.mapView];
        [self drawPathFrom:self.startingPointPlacemark toCLP:self.destinationPlacemark];
    }
}

-(void)searchResultDidClicked:(CLLocation *)location withRegion:(CLRegion *)region{
    MKMapPoint points[1]; //C array of MKMapPoint struct
    points[0] = MKMapPointForCoordinate(location.coordinate);
    [self zoomMapView:self.mapView toFitPoints:points count:1 animated:NO];
    [self showAnnotationOnMapWithCoordinate:location.coordinate];
}

-(void)showAndZoomToFitPathsAndAnnotationsWithLocations:(NSArray<CLLocation *> *)locations{
    
}

-(void)searchLocationsWithString:(NSString *)string{
    [self.indicator startAnimating];
    
    MKCoordinateRegion region = self.mapView.region;
    MKLocalSearchRequest *req = [[MKLocalSearchRequest alloc] init];
    req.region = region;
    req.naturalLanguageQuery = string;
    MKLocalSearch *ser = [[MKLocalSearch alloc] initWithRequest:req];
    //开始检索，结果返回在block中
    [ser startWithCompletionHandler:^(MKLocalSearchResponse *response, NSError *error) {
        [self.indicator stopAnimating];
        
        if (error) {
            return [self.scheduleDetailWidget showLocationSearchingResults:nil withSourceString:@""];
        }
        //兴趣点节点数组
        NSMutableArray<NSDictionary *> *locations = [NSMutableArray arrayWithCapacity:response.mapItems.count];
        
        for (MKMapItem *item in response.mapItems) {
            CLPlacemark *placemark = item.placemark;
            
            NSArray* addrArray = placemark.addressDictionary[@"FormattedAddressLines"];
            // 将详细地址拼接成一个字符串
            NSMutableString* address = [[NSMutableString alloc] init];
            
            for(int i = 0 ; i < addrArray.count ; i ++)
            {
                [address appendString:addrArray[i]];
            }
            
            NSDictionary *compondLocation = [NSDictionary dictionaryWithObjects:@[placemark.name,
                                                                                  address,
                                                                                  placemark.location,
                                                                                  placemark.region]
                                                                        forKeys:@[@"name",
                                                                                  @"address",
                                                                                  @"location",
                                                                                  @"region"]];
            [locations addObject:compondLocation];
        }
        [self.scheduleDetailWidget showLocationSearchingResults:locations withSourceString:string];
    }];
}

-(void)mapViewdidPressed:(UIGestureRecognizer *)sender{
    if(sender.state != UIGestureRecognizerStateBegan) return;
    
    //这里touchPoint是点击的某点在地图控件中的位置
    CGPoint touchPoint = [sender locationInView:self.mapView];
    // 将经度、维度值包装为CLLocation对象
    CLLocationCoordinate2D touchMapCoordinate = [self.mapView convertPoint:touchPoint
                                                      toCoordinateFromView:self.mapView];
    
    NSLog(@"touching %f, %f", touchMapCoordinate.latitude, touchMapCoordinate.longitude);
    
    [self showAnnotationOnMapWithCoordinate:touchMapCoordinate];
}

/*-(void)retrieveAddressFromCoordinate:(CLLocationCoordinate2D)coordinate withBlock:(void(^)(NSString *))completionBlock{
    CLLocation *location = [[CLLocation alloc] initWithLatitude:coordinate.latitude
                                                      longitude:coordinate.longitude];
    // 根据经、纬度反向解析地址
    [_geocoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if ( error == nil)
        {
            // 获取解析得到的第一个地址信息
            CLPlacemark *placemark = [placemarks objectAtIndex:0];
            // 获取地址信息中的FormattedAddressLines对应的详细地址
            NSArray* addrArray = placemark.addressDictionary[@"FormattedAddressLines"];
            // 将详细地址拼接成一个字符串
            NSMutableString* address = [[NSMutableString alloc] init];
            
            for(int i = 0 ; i < addrArray.count ; i ++)
            {
                [address appendString:addrArray[i]];
            }
            completionBlock(address);
        }
    }];
}*/

-(void)showAnnotationOnMapWithCoordinate:(CLLocationCoordinate2D)coordinate{
    
    CLLocation *location = [[CLLocation alloc] initWithLatitude:coordinate.latitude
                                                      longitude:coordinate.longitude];
    // 根据经、纬度反向解析地址
    [_geocoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if ( error == nil)
        {
            // 获取解析得到的第一个地址信息
            self.tapPlacemark = [placemarks objectAtIndex:0];
            // 获取地址信息中的FormattedAddressLines对应的详细地址
            NSArray* addrArray = self.tapPlacemark.addressDictionary[@"FormattedAddressLines"];
            // 将详细地址拼接成一个字符串
            NSMutableString* address = [[NSMutableString alloc] init];
            
            for(int i = 0 ; i < addrArray.count ; i ++)
            {
                [address appendString:addrArray[i]];
            }
//            [self.searchBar setText:address];
            
            // 创建MKPointAnnotation对象——代表一个锚点
            if(self->selectedStartingPosition && !self->selectedDestination){
                [self.mapView removeAnnotation:self.destinationAnnotation];
                
                self.destinationPlacemark = [placemarks objectAtIndex:0];
                self.destinationAnnotation.title = self.tapPlacemark.name;
                self.destinationAnnotation.subtitle = address;
                self.destinationAnnotation.coordinate = coordinate;
                // 添加锚点
                [self.mapView addAnnotation:self.destinationAnnotation];
            }else if(!self->selectedStartingPosition){
                [self.mapView removeAnnotation:self.startingPointAnnotation];
                
                self.startingPointPlacemark = [placemarks objectAtIndex:0];
                self.startingPointAnnotation.title = self.tapPlacemark.name;
                self.startingPointAnnotation.subtitle = address;
                self.startingPointAnnotation.coordinate = coordinate;
                // 添加锚点
                [self.mapView addAnnotation:self.startingPointAnnotation];
            }
        }
    }];
}

-(void)backButtonClicked{
    [self clearEdittingSchedules];
    [self.navigationController popViewControllerAnimated:YES];
}

#define DESTINATIONPOINTANNOTATION @"destinationPointAnnotation"
#define STARTINGPOINTANNOTATION @"startingPointAnnotation"

- (nullable MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation{
    // If the annotation is the user location, just return nil.（如果是显示用户位置的Annotation,则使用默认的蓝色圆点）
    if ([annotation isKindOfClass:[MKUserLocation class]])
        return nil;
    if ([annotation isKindOfClass:[MKPointAnnotation class]]) {
        // Try to dequeue an existing pin view first.
        
        MKPinAnnotationView *customPinView = nil;
        if(self->selectedStartingPosition){
            customPinView = (MKPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:DESTINATIONPOINTANNOTATION];
        }else{
            customPinView = (MKPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:STARTINGPOINTANNOTATION];
        }
        
        if (!customPinView){
            // If an existing pin view was not available, create one.
            if(self->selectedStartingPosition){
                customPinView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation
                                                                reuseIdentifier:DESTINATIONPOINTANNOTATION];
                
                UIButton *rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 90, 50)];
                rightButton.backgroundColor = [UIColor systemTealColor];
                rightButton.tag = 190;
                [rightButton setTitle:@"End Here" forState:UIControlStateNormal];
                customPinView.rightCalloutAccessoryView = rightButton;
                customPinView.pinTintColor = [UIColor systemTealColor];
            }else{
                customPinView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation
                                                                reuseIdentifier:STARTINGPOINTANNOTATION];
                
                UIButton *rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 90, 50)];
                rightButton.backgroundColor = [UIColor systemPurpleColor];
                rightButton.tag = 190;
                [rightButton setTitle:@"Start Here" forState:UIControlStateNormal];
                customPinView.rightCalloutAccessoryView = rightButton;
                customPinView.pinTintColor = [UIColor systemPurpleColor];
            }
            // Add a custom image to the left side of the callout.（设置弹出起泡的左面图片）
//            UIImageView *myCustomImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"myimage"]];
//            customPinView.leftCalloutAccessoryView = myCustomImage;
            
        }
        //iOS9中用pinTintColor代替了pinColor
        
        customPinView.animatesDrop = NO;
        customPinView.canShowCallout = YES;
        
        return customPinView;
    }
    return nil;
}

- (void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray<MKAnnotationView *> *)views{
    for(MKAnnotationView *av in views){
        if([av.reuseIdentifier isEqualToString:STARTINGPOINTANNOTATION]){
            UIButton *button = [av viewWithTag:190];
            button.enabled = self->selectedStartingPosition;
            [mapView selectAnnotation:[av annotation] animated:YES];
        }
        if([av.reuseIdentifier isEqualToString:DESTINATIONPOINTANNOTATION]){
            UIButton *button = [av viewWithTag:190];
            button.enabled = self->selectedDestination;
            [mapView selectAnnotation:[av annotation] animated:YES];
        }
    }
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control API_UNAVAILABLE(tvos){
    NSString *reuseIdentifier = view.reuseIdentifier;
    [mapView deselectAnnotation:view.annotation animated:YES];
    
    if([reuseIdentifier isEqualToString:STARTINGPOINTANNOTATION]){
        if(self->selectedStartingPosition) return;
        
        [self.datePicker showWithMessage:@"Start on:" withCompletion:^(NSDate *date){
            self->selectedStartingPosition = YES;
            self.startTimeStamp = date.timeIntervalSince1970;
            [self->_scheduleDetailWidget addScheduleStartAt:view.annotation.coordinate
                                                     onTime:self.startTimeStamp
                                                   location:self->_startingPointAnnotation.subtitle];
        }];
    }
    if([reuseIdentifier isEqualToString:DESTINATIONPOINTANNOTATION]){
        if(self->selectedDestination) return;
        
        self.destinationPlacemark = self.tapPlacemark;
        [self.datePicker showWithMessage:@"End before:" withCompletion:^(NSDate *date){
            NSLog(@"time=%f", date.timeIntervalSince1970 - self.startTimeStamp);
            if(date.timeIntervalSince1970 - self.startTimeStamp < 86400){
                UIAlertController *action = [UIAlertController alertControllerWithTitle:@"Oops" message:@"Starting time should priore to Ending time at least 1 day." preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
                [action addAction:ok];
                return [self presentViewController:action animated:YES completion:nil];
            }
            self->selectedDestination = YES;
            self.endTimeStamp = date.timeIntervalSince1970;
            [self->_scheduleDetailWidget addScheduleEndAt:view.annotation.coordinate
                                                   onTime:self.endTimeStamp
                                                 location:self->_destinationAnnotation.subtitle];
            [self drawPaths];
            [self zoomMapViewToFitAnnotations:self.mapView animated:YES];
        }];
            
//        }
    }
}

-(void)retrieveMySchedules{
    NSString *action;
    
    if(self.role == TailWindRole_Deliverer){
        //deliverer
        action = @"/api/delivererSchedule/query";
    }else{
        //sender
        action = @"/api/senderSchedule/query";
    }
    [HTTPModelUseCompletionBlok HTTPModelWithBaseUrl:SERVER_IP WithPath:action param:nil getOrPost:@"POST" withCache:NO maxTimes:1 completionBlock:^(id responseData, NSError *error) {
        
        if(error == nil && responseData != nil){
            if([[responseData valueForKey:@"status"] isEqual:@"1"]){
                
                NSArray *array = nil;
                if(self.role == TailWindRole_Deliverer){
                    //deliverer
                    array = [responseData objectForKey:@"deliver schedule"];
                    
                }else{
                    //sender
                    array = [responseData objectForKey:@"deliver schedule"];
                    
                }
                
                [self.scheduleDetailWidget.mySchedules removeAllObjects];
                
                if(array && [array count] > 0){
                   
                    for (int i = 0; i < [array count]; i++) {
                        NSDictionary *r = [array objectAtIndex:i];
                        Schedule *s = [[Schedule alloc] init];
                        
                        s.startTime = [[r valueForKey:@"startTime"] intValue];
                        s.endTime = [[r valueForKey:@"endTime"] intValue];
                        if(self.role == TailWindRole_Deliverer){
                            s.scheduleId = [[r valueForKey:@"ssId"] intValue];
                        }else{
                            s.scheduleId = [[r valueForKey:@"dsId"] intValue];
                        }
                        
                        s.orderId = [r valueForKey:@"orderId"];
                        CLLocationCoordinate2D start, end;
                        start.latitude = [[r valueForKey:@"startPointLatitude"] doubleValue];
                        start.longitude = [[r valueForKey:@"startPointLongitude"] doubleValue];
                        s.startLocation = [r valueForKey:@"startAddress"];
                        s.startCoordinate = start;
                        end.latitude = [[r valueForKey:@"endPointLatitude"] doubleValue];
                        end.longitude = [[r valueForKey:@"endPointLongitude"] doubleValue];
                        s.endCoordinate = end;
                        s.endLocation = [r valueForKey:@"endAddress"];
                        s.confirmed = [[r valueForKey:@"status"] intValue];
                        
                        [self.scheduleDetailWidget.mySchedules addObject:s];
                    }
                }
                [self.scheduleDetailWidget refreshTableView];
            }
        }
    }];
}

-(void)retrieveAvailableSchedules{
    NSString *action;
    
    if(self.role == TailWindRole_Deliverer){
        //deliverer
        action = @"/api/delivererOrder/query";
    }else{
        //sender
        action = @"/api/senderOrder/query";
    }
    
    [HTTPModelUseCompletionBlok HTTPModelWithBaseUrl:SERVER_IP WithPath:action param:nil getOrPost:@"POST" withCache:NO maxTimes:1 completionBlock:^(id responseData, NSError *error) {
        
        if(error == nil && responseData != nil){
            if([[responseData valueForKey:@"status"] isEqual:@"1"]){
//                self.scheduleDetailWidget.availableSchedule = nil;
                
                NSArray *newSchedules = nil;
                NSArray *newOrders = nil;
                
                if(self.role == TailWindRole_Deliverer){
                    //deliverer
                    newOrders = [responseData objectForKey:@"Deliverer order"];
                    /*if(newOrders && newOrders.count > 0){
                        NSDictionary *order = [newOrders objectAtIndex:0];
                        if(order){
                            s.orderStatus = [[order valueForKey:@"orderStatus"] intValue];
                            newSchedules = [order objectForKey:@"senderSchedules"];
                        }
                    }*/
                }else{
                    //sender
                    newOrders = [responseData objectForKey:@"Sender order"];
                    /*if(newOrders && newOrders.count > 0){
                        NSDictionary *order = [newOrders objectAtIndex:0];
                        if(order){
                            s.orderStatus = [[order valueForKey:@"orderStatus"] intValue];
                            newSchedules = [order objectForKey:@"delivererSchedules"];
                        }
                    }*/
                }
                
                if(newOrders && [newOrders count] > 0){
                    
//                    UIAlertController *action = [UIAlertController alertControllerWithTitle:@"Notification"
//                                                                                    message:@"You have been assigned an available service."
//                                                                             preferredStyle:UIAlertControllerStyleAlert];
//                    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
//                    [action addAction:ok];
//                    [self presentViewController:action animated:YES completion:nil];
                    
                    [self.scheduleDetailWidget.availableSchedule removeAllObjects];
                    
                    for(id order in newOrders){
                        
                        NSDictionary *r = nil;
                            if(self.role == TailWindRole_Deliverer){
                                r = [[order objectForKey:@"senderSchedules"] objectAtIndex:0];
                            }else{
                                r = [[order objectForKey:@"delivererSchedules"] objectAtIndex:0];
                            }
                        if(r){
                            Schedule *s = [[Schedule alloc] init];
                            s.orderStatus = [[order valueForKey:@"orderStatus"] intValue];
                            s.startTime = [[r valueForKey:@"startTime"] intValue];
                            s.endTime = [[r valueForKey:@"endTime"] intValue];
                            s.orderId = [r valueForKey:@"orderId"];
                            if(self.role == TailWindRole_Deliverer){
                                s.scheduleId = [[r valueForKey:@"ssId"] intValue];
                            }else{
                                s.scheduleId = [[r valueForKey:@"dsId"] intValue];
                            }
                            s.scheduleStatus = [[r valueForKey:@"status"] intValue];
                            s.orderId = [r valueForKey:@"orderId"];
                            CLLocationCoordinate2D start, end;
                            start.latitude = [[r valueForKey:@"startPointLatitude"] doubleValue];
                            start.longitude = [[r valueForKey:@"startPointLongitude"] doubleValue];
                            s.startLocation = [r valueForKey:@"startAddress"];
                            s.startCoordinate = start;
                            end.latitude = [[r valueForKey:@"endPointLatitude"] doubleValue];
                            end.longitude = [[r valueForKey:@"endPointLongitude"] doubleValue];
                            s.endCoordinate = end;
                            s.endLocation = [r valueForKey:@"endAddress"];
                            s.confirmed = [[r valueForKey:@"status"] intValue];
                            [self.scheduleDetailWidget.availableSchedule addObject:s];
                        }
                        
                    }
                    
                }
                
                [self.scheduleDetailWidget refreshTableView];
            }
        }
    }];
}

-(void)confirmSchedule:(Schedule *)schedule{
    NSString *action;
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:2];
    
    if(self.role == TailWindRole_Deliverer){
        action = @"/api/delivererSchedule/confirm";
        [params setValue:@(schedule.scheduleId) forKey:@"ssId"];
        [params setValue:schedule.orderId forKey:@"orderId"];
    }else{
        action = @"/api/senderSchedule/confirm";
        [params setValue:@(schedule.scheduleId) forKey:@"dsId"];
        [params setValue:schedule.orderId forKey:@"orderId"];
    }
    [self.indicator startAnimating];
    [HTTPModelUseCompletionBlok HTTPModelWithBaseUrl:SERVER_IP WithPath:action param:params getOrPost:@"POST" withCache:NO maxTimes:1 completionBlock:^(id responseData, NSError *error) {
        
        if(error == nil && responseData != nil){
            
            if([[responseData valueForKey:@"status"] isEqual:@"1"]){
//                self.scheduleDetailWidget.availableSchedule.confirmed = 2;
                [self.scheduleDetailWidget refreshTableView];
            }
        }
        [self.indicator stopAnimating];
    }];
}

-(void)uploadSchedule:(Schedule *)schedule{
    NSString *action;
    if(self.role == TailWindRole_Deliverer){
        action = @"/api/delivererSchedule/insert";
        
    }
    if(self.role == TailWindRole_Sender){
        action = @"/api/senderSchedule/insert";
    }
    NSDictionary *params = [[NSDictionary alloc] initWithObjects:@[@(schedule.startCoordinate.latitude),
                                                                   @(schedule.startCoordinate.longitude),
                                                                   @(schedule.endCoordinate.latitude),
                                                                   @(schedule.endCoordinate.longitude),
                                                                   schedule.startLocation,
                                                                   schedule.endLocation,
                                                                   @(schedule.startTime),
                                                                   @(schedule.endTime)]
                                                         forKeys:@[@"startPointLatitude",
                                                                   @"startPointLongitude",
                                                                   @"endPointLatitude",
                                                                   @"endPointLongitude",
                                                                   @"startAddress",
                                                                   @"endAddress",
                                                                   @"startTime",
                                                                   @"endTime"]];
    [self.indicator startAnimating];
    [HTTPModelUseCompletionBlok HTTPModelWithBaseUrl:SERVER_IP
                                            WithPath:action
                                               param:params
                                           getOrPost:@"POST"
                                           withCache:NO
                                            maxTimes:1
                                     completionBlock:^(id responseData, NSError *error) {
        
        if(error == nil && responseData != nil){
            
            if([[responseData valueForKey:@"status"] isEqual:@"1"]){
                NSString *scheduleId = [responseData valueForKey:@"scheduleId"];
                
                if(self.role == TailWindRole_Deliverer && self.finalRoute){
                    //retrieve matched schedules
                    /*id macthedSchedul = [responseData objectForKey:@"matched sender schedule"];
                    if([macthedSchedul isKindOfClass:[NSDictionary class]]){
                        NSDictionary *r = macthedSchedul;
                        Schedule *s = self.scheduleDetailWidget.availableSchedule;
                        s.startTime = [[r valueForKey:@"startTime"] intValue];
                        s.endTime = [[r valueForKey:@"endTime"] intValue];
                        CLLocationCoordinate2D start, end;
                        start.latitude = [[r valueForKey:@"startPointLatitude"] doubleValue];
                        start.longitude = [[r valueForKey:@"startPointLongitude"] doubleValue];
                        s.startLocation = [r valueForKey:@"startAddress"];
                        s.startCoordinate = start;
                        end.latitude = [[r valueForKey:@"endPointLatitude"] doubleValue];
                        end.longitude = [[r valueForKey:@"endPointLongitude"] doubleValue];
                        s.endCoordinate = end;
                        s.endLocation = [r valueForKey:@"endAddress"];;
                    }*/
                    
                    //upload deliverer route
                    NSUInteger pointCount = self.finalRoute.polyline.pointCount;
                    CLLocationCoordinate2D * routeCoordinates = malloc(pointCount * sizeof(CLLocationCoordinate2D));
                    [self.finalRoute.polyline getCoordinates:routeCoordinates range:NSMakeRange(0, pointCount)];
                    
                    NSMutableArray *list = [NSMutableArray arrayWithCapacity:pointCount];
                    
                    for(int i = 0; i < pointCount; i++){
                        NSDictionary *point = [NSDictionary dictionaryWithObjects:@[scheduleId,
                                                                                    [NSString stringWithFormat:@"%d", i],
                                                                                    [NSString stringWithFormat:@"%f", routeCoordinates[i].latitude],
                                                                                    [NSString stringWithFormat:@"%f", routeCoordinates[i].longitude]]
                                                                          forKeys:@[
                                                                              @"scheduleId",
                                                                              @"sequence",
                                                                              @"latitude",
                                                                              @"longitude"]];
                        [list addObject:point];
                    }
//                    NSDictionary *routeParams = [NSDictionary dictionaryWithObject:list forKey:@""];
                    
                    [HTTPModelUseCompletionBlok HTTPModelWithBaseUrl:SERVER_IP
                                                            WithPath:@"/api/route/insert"
                                                               param:list
                                                           getOrPost:@"POST"
                                                           withCache:NO
                                                            maxTimes:1
                                                     completionBlock:^(id responseData, NSError *error) {
                        if(error == nil && responseData != nil){
                            
                            if([[responseData valueForKey:@"status"] isEqual:@"1"]){
                                
                            }
                        }
                    }];
                }
                if(self.role == TailWindRole_Sender){
                    
                }
                [self clearEdittingSchedules];
            }
        }
//        [self.indicator stopAnimating];
        [self.indicator showMessage:@"Success!" forTime:1];
    }];
}

-(void)clearPaths:(MKMapView *)mapView{
    self.finalRoute = nil;
    [mapView removeOverlays:mapView.overlays];
}

-(void)drawPathFrom:(CLPlacemark *)fromCLP toCLP:(CLPlacemark *)toCLP{
    //1.创建方向请求
    MKDirectionsRequest *request = [[MKDirectionsRequest alloc] init];
    
    //2.设置起点
    MKPlacemark *fromMKP = [[MKPlacemark alloc] initWithPlacemark:fromCLP];
    request.source = [[MKMapItem alloc] initWithPlacemark:fromMKP];
    
    //3.设置终点
    MKPlacemark *toMKP = [[MKPlacemark alloc] initWithPlacemark:toCLP];
    request.destination = [[MKMapItem alloc] initWithPlacemark:toMKP];
    
    //4.创建方向对象
    MKDirections *directions = [[MKDirections alloc] initWithRequest:request];
    
    //5.计算所有路线
    [directions calculateDirectionsWithCompletionHandler:^(MKDirectionsResponse *response, NSError *error) {
        NSLog(@"路线条数：%lu", (unsigned long)response.routes.count);
        
        //获取所有路线
        for (MKRoute *route in response.routes) {
            //添加线路到MapView中
            self.finalRoute = route;
            [self.mapView addOverlay:route.polyline];
            NSLog(@"------->点数：%lu", (unsigned long)route.polyline.pointCount);
            
            //points!!!
            /*NSUInteger pointCount = route.polyline.pointCount;
            CLLocationCoordinate2D * routeCoordinates = malloc(pointCount * sizeof(CLLocationCoordinate2D));
            [route.polyline getCoordinates:routeCoordinates range:NSMakeRange(0, pointCount)];
            for(int i = 0; i < pointCount; i++){
                NSLog(@"point %d = %f, %f", i, routeCoordinates[i].latitude, routeCoordinates[i].longitude);
            }*/
        }
        
    }];
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    // 位置发生变化调用
//    NSLog(@"lan = %f, long = %f", userLocation.coordinate.latitude, userLocation.coordinate.longitude);
}

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay{
    if([overlay isKindOfClass:[MKPolyline class]]){
        //将线画到地图上
        MKPolylineRenderer *renderer = [[MKPolylineRenderer alloc] initWithOverlay:overlay];
        //设置线的颜色
        renderer.strokeColor = [UIColor systemBlueColor];
        renderer.lineWidth = 5.0f;
        
        return renderer;
    }
    return nil;
}

-(void)showQRScanningView{
    [self.navigationController pushViewController:self.qrScanning animated:YES];
}

-(void)showQRCode{
    if(self.role == TailWindRole_Sender){
        if(self.scheduleDetailWidget.selectedSchedule){
            if(self.scheduleDetailWidget.selectedSchedule.scheduleStatus >= 2){
                self.qrCode.qrCodeSourceStr = [NSString stringWithFormat:@"orderId=%@", self.scheduleDetailWidget.selectedSchedule.orderId];
                [self.navigationController pushViewController:self.qrCode animated:YES];
            }else{
                [self.indicator showMessage:@"Schedule hasn't been confirmed." forTime:2];
            }
            
        }else{
            [self.indicator showMessage:@"No Selected Schedule." forTime:1];
        }
    }else{
        [self.indicator showMessage:@"Wrong Role." forTime:1];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
