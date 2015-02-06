//
//  ViewController.m
//  07-导航画线
//
//  Created by kun on 15/2/6.
//  Copyright (c) 2015年 kun. All rights reserved.
//

#import "ViewController.h"
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import "FKAnnotation.h"

@interface ViewController () <MKMapViewDelegate>
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (nonatomic, strong) CLLocationManager *locMgr;
@property (nonatomic, strong) CLGeocoder *geocoder;

@end

@implementation ViewController
- (CLGeocoder *)geocoder
{
    if(!_geocoder)
    {
        _geocoder = [[CLGeocoder alloc] init];
    }
    return _geocoder;
}

- (CLLocationManager *)locMgr
{
    if(!_locMgr)
    {
        _locMgr = [[CLLocationManager alloc] init];
    }
    return _locMgr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    if([[UIDevice currentDevice].systemVersion doubleValue] >= 8.0)
    {
        [self.locMgr requestAlwaysAuthorization];
    }
    self.mapView.delegate = self;
    
    NSString *address1 = @"北京";
    NSString *address2 = @"广州";
    
    [self.geocoder geocodeAddressString:address1 completionHandler:^(NSArray *placemarks, NSError *error) {
        
        if(error) return;
        CLPlacemark *fromPm = [placemarks firstObject];
        
        [self.geocoder geocodeAddressString:address2 completionHandler:^(NSArray *placemarks, NSError *error) {
            
            if(error) return;
            
            CLPlacemark *toPm = [placemarks firstObject];
            
            [self addLineFrom:fromPm to:toPm];
        }];
    }];
    
    
}

- (void)addLineFrom:(CLPlacemark *)fromPm to:(CLPlacemark *)toPm
{
    MKDirectionsRequest *request = [[MKDirectionsRequest alloc] init];
    
    MKPlacemark *sourcePm = [[MKPlacemark alloc] initWithPlacemark:fromPm];
    
    request.source = [[MKMapItem alloc] initWithPlacemark:sourcePm];
    
    MKPlacemark *destinationPm = [[MKPlacemark alloc] initWithPlacemark:toPm];
    
    request.destination = [[MKMapItem alloc] initWithPlacemark:destinationPm];
    
    MKDirections *directions = [[MKDirections alloc] initWithRequest:request];
    
    [directions calculateDirectionsWithCompletionHandler:^(MKDirectionsResponse *response, NSError *error) {
        NSLog(@"总共：%d", response.routes.count);
        
        for(MKRoute *route in response.routes)
        {
            [self.mapView addOverlay:route.polyline];
        }
        
        FKAnnotation *fromAnno = [[FKAnnotation alloc] init];
        fromAnno.coordinate = fromPm.location.coordinate;
        fromAnno.title = fromPm.name;
        fromAnno.subtitle = fromPm.subLocality;
        [self.mapView addAnnotation:fromAnno];
        
        FKAnnotation *toAnno = [[FKAnnotation alloc] init];
        toAnno.coordinate = toPm.location.coordinate;
        toAnno.title = toPm.name;
        toAnno.subtitle = toPm.subLocality;
        [self.mapView addAnnotation:toAnno];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - MKMapViewDelegate
- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay
{
    MKPolylineRenderer *renderer = [[MKPolylineRenderer alloc] initWithOverlay:overlay];
    renderer.strokeColor = [UIColor redColor];
    return renderer;
}
@end
