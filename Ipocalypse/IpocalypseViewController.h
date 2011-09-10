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

@end

