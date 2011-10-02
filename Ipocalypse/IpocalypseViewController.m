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
    [super didReceiveMemoryWarning];
    
}


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

- (void)viewDidLoad
{
    mapView.delegate = self;
    mapView.showsUserLocation = YES;
    
    [super viewDidLoad];
    //Get data from mysql
    responseData = [[NSMutableData data] retain];
	NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.grif.tv/json.php"]];
	[[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    [NSThread detachNewThreadSelector:@selector(UploadUserLocation:) toTarget:self withObject:nil];
    
}

-(void) UploadUserLocation:(id)anObject {
    

    NSAutoreleasePool *autoreleasepool = [[NSAutoreleasePool alloc] init];
    
    for (int i=0; i<1000000; i++){
    
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
        [NSThread sleepForTimeInterval:5.0];    
    }
    [NSThread exit];
    
    //we need to do this to prevent memory leaks
    
    [autoreleasepool release];

}
- (void)PopulateMap
{
    
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
    //Place User locations on Map and in 3DAR with UID
    
    for (int i=0; i<[locations count]; i++){
        corde.latitude = [[[locations objectAtIndex:i] valueForKey:@"Latitude"]floatValue];
        corde.longitude = [[[locations objectAtIndex:i] valueForKey:@"Longitude"]floatValue];
          NSString *Name = [[locations valueForKey:@"Name"]objectAtIndex:i];
        
        
        
        SM3DARTexturedGeometryView *modelView = [[[SM3DARTexturedGeometryView alloc] initWithOBJ:@"cube.obj" textureNamed:nil] autorelease];
        SM3DARTexturedGeometryView *model2View = [[[SM3DARTexturedGeometryView alloc] initWithOBJ:@"Creep.obj" textureNamed:nil] autorelease];
        
        SM3DARPointOfInterest *poi = (SM3DARPointOfInterest *)[[mapView.sm3dar addPointAtLatitude:corde.latitude
                                                                                        longitude:corde.longitude
                                                                                         altitude:0 
                                                                                            title:Name
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
