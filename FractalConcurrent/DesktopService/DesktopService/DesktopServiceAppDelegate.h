//
//  DesktopServiceAppDelegate.h
//  DesktopService
//
//  Created by Apple User on 3/26/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "ApplicationController.h"

@interface DesktopServiceAppDelegate : NSObject <NSApplicationDelegate> 
{
    NSWindow *window;
}

@property (assign) IBOutlet NSWindow *window;
@property (assign) IBOutlet ApplicationController* appController;

@end
