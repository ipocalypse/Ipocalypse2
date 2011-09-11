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

@interface IpocalypseViewController : UIViewController<MKMapViewDelegate> {
    IBOutlet SM3DARMapView *mapView;
}
@property (nonatomic, retain) IBOutlet SM3DARMapView *mapView;
@end

@interface MapAnnotation : NSObject <MKAnnotation> {
    CLLocationCoordinate2D _coordinate;
}

- (id)initWithCoordinate:(CLLocationCoordinate2D)coordinate;

@end
