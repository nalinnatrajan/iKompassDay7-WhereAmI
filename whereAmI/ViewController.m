//
//  ViewController.m
//  whereAmI
//
//  Created by Nalin Natrajan on 14/3/15.
//  Copyright (c) 2015 Nalin Natrajan. All rights reserved.
//

#import "ViewController.h"
#import "MapAnnotation.h"

@interface ViewController () 

@property (weak, nonatomic) IBOutlet UILabel *lattitudeLabel;

@property (weak, nonatomic) IBOutlet UILabel *longitudeLabel;

@property (weak, nonatomic) IBOutlet UILabel *altitudeLabel;

@property (weak, nonatomic) IBOutlet UILabel *hAccuracyLabel;

@property (weak, nonatomic) IBOutlet UILabel *vAccuracyLabel;

@property (weak, nonatomic) IBOutlet UILabel *distanceTravelledLabel;

@property (weak, nonatomic) IBOutlet MKMapView *locationMapView;



@property CLLocationManager *locationManager;

@property CLLocation *location;

@property CLLocationDistance *distance;

- (IBAction)onLocationButtonPressed:(id)sender;

-(void)getMyLocation;

-(void)startLocationManager;

-(void)stopLocationManager;



@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationMapView.showsUserLocation = true;
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onLocationButtonPressed:(id)sender {
    [self getMyLocation];
}

-(void)getMyLocation{
    CLAuthorizationStatus authStatus = [CLLocationManager authorizationStatus];
    
    if (authStatus == kCLAuthorizationStatusNotDetermined) {
        [self.locationManager requestWhenInUseAuthorization];
        return;
    }
    
    if (authStatus == kCLAuthorizationStatusDenied || authStatus == kCLAuthorizationStatusRestricted) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Please enable location services for this app in Settings." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
        return;
    }
    
    [self startLocationManager];
}


- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations{
    CLLocation *newLocation = [locations lastObject];
    NSString *lattitudeString = [NSString stringWithFormat:@"%g\u00B0",newLocation.coordinate.latitude];
    self.lattitudeLabel.text = lattitudeString;
    NSString *longitudeString = [NSString stringWithFormat:@"%g\u00B0",newLocation.coordinate.longitude];
    self.longitudeLabel.text = longitudeString;
    NSString *altitudeString = [NSString stringWithFormat:@"%gm",newLocation.altitude];
    self.altitudeLabel.text = altitudeString;
    NSString *hAccuracyString = [NSString stringWithFormat:@"%gm",newLocation.horizontalAccuracy];
    self.hAccuracyLabel.text = hAccuracyString;
    NSString *vAccuracyString = [NSString stringWithFormat:@"%gm",newLocation.verticalAccuracy];
    self.vAccuracyLabel.text = vAccuracyString;
   
    MapAnnotation *mapAnnotation = [[MapAnnotation alloc] init];
    mapAnnotation.title = @"Start";
    mapAnnotation.subtitle = @"Initial Point";
    mapAnnotation.coordinate = newLocation.coordinate;
    if (self.locationMapView.annotations.count > 0) {
        [self.locationMapView removeAnnotations:self.locationMapView.annotations];
    }
    [self.locationMapView addAnnotation:mapAnnotation];
    MKCoordinateRegion region;
    region = MKCoordinateRegionMakeWithDistance(newLocation.coordinate, 100, 100);
    [self.locationMapView setRegion:region animated:YES];
    
}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error{
    
}

-(void)startLocationManager{
    if ([CLLocationManager locationServicesEnabled]) {
        self.locationManager.delegate = self;
        self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
        [self.locationManager startUpdatingLocation];
    }
    
}

-(void)stopLocationManager{
    
}
@end
