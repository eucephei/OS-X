//
//  ApplicationController.h
//  DesktopService
//
//  Created by Apple User on 3/26/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "FractalGenerator.h"

@class FractalControl;
@class ListenService;

@interface ApplicationController : NSObject 
{
  //  NSButton *cancelButton;
}

@property (assign) IBOutlet NSWindow*               window;
@property (assign) IBOutlet NSTextView*             logTextField;
@property (assign) IBOutlet FractalControl*         fractalControl;
@property (assign) IBOutlet NSProgressIndicator*	progressIndicator;
@property (assign) IBOutlet NSButton*               resetButton;
@property (assign) IBOutlet NSButton*               zoomInButton;
@property (assign) IBOutlet NSButton*               zoomOutButton;

// BONJOUR SERVICE

- (void) startService;
- (void) appendStringToLog:(NSString*)logString;

// ACTIONS

- (IBAction)	resetPressed:(id)sender;
- (IBAction)	zoomInPressed:(id)sender;
- (IBAction)	zoomOutPressed:(id)sender;
- (IBAction)	regionChanged:(id)sender;


@end
