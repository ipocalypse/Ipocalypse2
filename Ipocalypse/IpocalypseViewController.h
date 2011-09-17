//
//  IpocalypseViewController.h
//  Ipocalypse
//
//  Created by Grif Priest on 9/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "SM3DAR.h"
#import <CoreLocation/CoreLocation.h>

@interface IpocalypseViewController : UIViewController<MKMapViewDelegate> {
    IBOutlet SM3DARMapView *mapView;
    CLLocationManager *locationManager;
}
@property (nonatomic, retain) IBOutlet SM3DARMapView *mapView;
@property (nonatomic, retain) CLLocationManager *locationManager;
@end

@interface MapAnnotation : NSObject <MKAnnotation> {
    CLLocationCoordinate2D _coordinate;
}

- (id)initWithCoordinate:(CLLocationCoordinate2D)coordinate;

@end
