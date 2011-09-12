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
    
        [super viewDidLoad];
    mapView.showsUserLocation = YES;
    CLLocationCoordinate2D coordinate;
    coordinate.latitude = 51.779;
    coordinate.longitude = -1.499;
    mapView.region = MKCoordinateRegionMakeWithDistance(coordinate, 2000, 2000);

    for(int i = 0; i < 30; i++)
    {
        CGFloat latDelta = rand()*.035/RAND_MAX -.02;
        CGFloat longDelta = rand()*.03/RAND_MAX -.015;
        
        CLLocationCoordinate2D newCoord = { coordinate.latitude + latDelta, coordinate.longitude + longDelta };
        MapAnnotation* annotation = [[MapAnnotation alloc] initWithCoordinate:newCoord];
        [mapView addAnnotation:annotation];
        [annotation release];
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