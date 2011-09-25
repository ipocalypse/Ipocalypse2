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
    mapView.showsUserLocation = NO;
    
    
    [super viewDidLoad];
    
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
    
    //Get data from mysql
    responseData = [[NSMutableData data] retain];
	NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.grif.tv/json.php"]];
	[[NSURLConnection alloc] initWithRequest:request delegate:self];
    
}
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response 
{
	[responseData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data 
{
	[responseData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection 
{		
	[connection release];
}

- (void) sm3darLoadPoints:(SM3DARController *)sm3dar
{ 
    NSString *responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
	[responseData release];
    
    SBJsonParser *json = [[SBJsonParser new] autorelease];
    
    NSError *jsonError;
    
    NSArray *locations = [json objectWithString:responseString error:&jsonError];
    
    CLLocationCoordinate2D corde;
    
    
    for (int i=0; i<[locations count]; i++){
        corde.latitude = [[[locations objectAtIndex:i] valueForKey:@"Latitude"]floatValue];
        corde.longitude = [[[locations objectAtIndex:i] valueForKey:@"Longitude"]floatValue];
        
        
        SM3DARTexturedGeometryView *modelView = [[[SM3DARTexturedGeometryView alloc] initWithOBJ:@"cube.obj" textureNamed:nil] autorelease];
        SM3DARTexturedGeometryView *model2View = [[[SM3DARTexturedGeometryView alloc] initWithOBJ:@"Creep.obj" textureNamed:nil] autorelease];
        
        SM3DARPointOfInterest *poi = (SM3DARPointOfInterest *)[[mapView.sm3dar addPointAtLatitude:corde.latitude
                                                                                        longitude:corde.longitude
                                                                                         altitude:0 
                                                                                            title:nil 
                                                                                             view:modelView] autorelease];
        
        
        SM3DARPointOfInterest *poi2 = (SM3DARPointOfInterest *)[[mapView.sm3dar addPointAtLatitude:corde.latitude + 0.0002
                                                                                         longitude:corde.longitude + 0.0002
                                                                                          altitude:0 
                                                                                             title:nil 
                                                                                              view:model2View] autorelease];
        [mapView addAnnotation:poi2];
        [mapView addAnnotation:poi];
    }


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