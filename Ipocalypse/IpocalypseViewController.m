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
    mapView.delegate = self;
    mapView.showsUserLocation = YES;
    
    
    [super viewDidLoad];
    responseData = [[NSMutableData data] retain];
	NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.grif.tv/json.php"]];
	[[NSURLConnection alloc] initWithRequest:request delegate:self];
    // Upload UID, LAT, and LONG to server
    
    locationManager = [[CLLocationManager alloc] init];
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    locationManager.distanceFilter = kCLDistanceFilterNone;
    [locationManager startUpdatingLocation];
    
    CLLocation *location = [locationManager location];
    CLLocationCoordinate2D coordinate = [location coordinate];
    
    NSString *Latitude = [NSString stringWithFormat:@"%f", coordinate.latitude];
    NSString *Longitude = [NSString stringWithFormat:@"%f", coordinate.longitude];
    NSString *Uid = [[UIDevice currentDevice] uniqueIdentifier];
    NSString *post = [NSString stringWithFormat:@"http://www.grif.tv/add2.php?Uid=%@&Latitude=%@&Longitude=%@", Uid, Latitude, Longitude];
    [NSData dataWithContentsOfURL:[NSURL URLWithString:post]];
    
}
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
	[responseData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	[responseData appendData:data];
}




- (void)connectionDidFinishLoading:(NSURLConnection *)connection 
{		
	[connection release];
    NSString *responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
	[responseData release];
    
    SBJsonParser *json = [[SBJsonParser new] autorelease];
    
    NSError *jsonError;

    NSArray *locations = [json objectWithString:responseString error:&jsonError];
   // NSLog(@"Longitude: %@", [locations valueForKey:@"Longitude"]); 
  //  NSLog(@"Latitude: %@", [locations valueForKey:@"Latitude"]); 
   // NSString *getLat = [[NSString alloc] initWithFormat: @"%@", [locations valueForKey:@"Latitude"]];
   // NSString *getLong = [[NSString alloc] initWithFormat: @"%@", [locations valueForKey:@"Longitude"]];
   // NSArray *Uid = [locations valueForKey:@"Uid"];
   // NSArray *Latitude = [locations valueForKey:@"Latitude"];
  //  NSArray *Longitude = [locations valueForKey:@"Longitude"];
    CLLocationCoordinate2D corde;

    //corde.latitude = [getLat doubleValue];
    
    //corde.longitude = [getLong doubleValue];
    
    for (int i=0; i<[locations count]; i++){
    corde.latitude = [[[locations objectAtIndex:i] valueForKey:@"Latitude"]floatValue];
    corde.longitude = [[[locations objectAtIndex:i] valueForKey:@"Longitude"]floatValue];
    
    
    SM3DARTexturedGeometryView *modelView = [[[SM3DARTexturedGeometryView alloc] initWithOBJ:@"cube.obj" textureNamed:nil] autorelease];
    
    SM3DARPointOfInterest *poi = (SM3DARPointOfInterest *)[[mapView.sm3dar addPointAtLatitude:corde.latitude
                                                                                    longitude:corde.longitude
                                                                                     altitude:0 
                                                                                        title:nil 
                                                                                         view:modelView] autorelease];
    
    [mapView addAnnotation:poi];
    }
}

- (void) sm3darLoadPoints:(SM3DARController *)sm3dar
{ 


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