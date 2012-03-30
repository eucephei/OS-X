//
//  DesktopServiceAppDelegate.m
//  DesktopService
//
//  Created by Apple User on 3/26/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "DesktopServiceAppDelegate.h"

@implementation DesktopServiceAppDelegate

@synthesize window;
@synthesize appController;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
    [appController startService];
}

- (void)dealloc
{
    [appController release]; appController = nil;
    [super dealloc];
}

@end
