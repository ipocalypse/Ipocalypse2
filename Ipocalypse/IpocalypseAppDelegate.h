//
//  IpocalypseAppDelegate.h
//  Ipocalypse
//
//  Created by Grif Priest on 9/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class IpocalypseViewController;

@interface IpocalypseAppDelegate : NSObject <UIApplicationDelegate>

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) IBOutlet IpocalypseViewController *viewController;

@end
