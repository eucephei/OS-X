//
//  Widget_PlotAppDelegate.m
//  Widget_Plot
//
//  Created by Apple User on 12/20/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Widget_PlotAppDelegate.h"
#import "Widget.h"
#import "WidgetRunView.h"
#import "KeyStrings.h"

@implementation Widget_PlotAppDelegate

NSString *drawingStyleKey = @"drawingStyle";

@synthesize window;
@synthesize widgetTester;


- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
    stylePicker.selectedSegment = [[NSUserDefaults standardUserDefaults] integerForKey:drawingStyleKey];
	self.widgetTester = [[[Widget alloc] init] autorelease];
	testView.theTestRun = self.widgetTester;
	[testView setNeedsDisplay:YES];
}

+ (void)initialize
{
	LogMethod();
	NSMutableDictionary *defaultValues = [NSMutableDictionary dictionary];
	[defaultValues setObject:[NSNumber numberWithInt:0] forKey:drawingStyleKey];
	
	[[NSUserDefaults standardUserDefaults] registerDefaults:defaultValues];
}

- (IBAction)changeDrawingStyle:(id)sender
{
	LogMethod();
	[[NSUserDefaults standardUserDefaults] setInteger:stylePicker.selectedSegment 
											   forKey:drawingStyleKey];
	[testView setNeedsDisplay:YES];
}

- (IBAction)performNewTest:(id)sender
{
	LogMethod();
	[self.widgetTester performTest];
	[testView setNeedsDisplay:YES];
}


@end
