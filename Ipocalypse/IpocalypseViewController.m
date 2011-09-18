//
//  IpocalypseViewController.m
//  Ipocalypse
//
//  Created by Grif Priest on 9/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "IpocalypseViewController.h"

@implementation IpocalypseViewController
@synthesize mapView;
@synthesize locationManager;

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)mapView:(SM3DARMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation

{
    self.mapView.centerCoordinate = 
    userLocation.location.coordinate;
} 

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
        
     [mapView startCamera];
}



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.

 - (void)viewDidLoad
{
    self.mapView = [[[SM3DARMapView alloc] initWithFrame:CGRectMake(0, 0, 320, 460)] autorelease]; 
    mapView.delegate = self;
    mapView.showsUserLocation = YES;
    
    // Only add the mapView and call init3DAR 
    // if the mapView is not already set up in an .xib file.
    
    [self.view addSubview:mapView];   
    [mapView init3DAR];

        [super viewDidLoad];
    
    locationManager = [[CLLocationManager alloc] init];
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    locationManager.distanceFilter = kCLDistanceFilterNone;
    [locationManager startUpdatingLocation];
    
    CLLocation *location = [locationManager location];
    
    // Configure the new event with information from the location
    CLLocationCoordinate2D coordinate = [location coordinate];
    
    NSString *Latitude = [NSString stringWithFormat:@"%f", coordinate.latitude];
    NSString *Longitude = [NSString stringWithFormat:@"%f", coordinate.longitude];
    
    NSString *Uid = [[UIDevice currentDevice] uniqueIdentifier];
    
    NSString *post = [NSString stringWithFormat:@"http://www.grif.tv/add2.php?Uid=%@&Latitude=%@&Longitude=%@", Uid, Latitude, Longitude];
    [NSData dataWithContentsOfURL:[NSURL URLWithString:post]];
  
}

- (void) sm3darLoadPoints:(SM3DARController *)sm3dar
{ 
    SM3DARTexturedGeometryView *modelView = [[[SM3DARTexturedGeometryView alloc] initWithOBJ:@"Creep.obj" textureNamed:nil] autorelease];
    
    SM3DARPointOfInterest *poi = (SM3DARPointOfInterest *)[[mapView.sm3dar addPointAtLatitude:mapView.sm3dar.userLocation.coordinate.latitude + 0.0005
                                                                                    longitude:mapView.sm3dar.userLocation.coordinate.longitude + 0.0001 
                                                                                     altitude:0 
                                                                                        title:nil 
                                                                                         view:modelView] autorelease];
    
    [mapView addAnnotation:poi];
}
- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
@implementation MapAnnotation
@synthesize coordinate = _coordinate;

- (id)initWithCoordinate:(CLLocationCoordinate2D)coordinate
{
    self = [super init];
    
    if (self != nil)
    {
        _coordinate = coordinate;
    }
    
    return self;
}


@end