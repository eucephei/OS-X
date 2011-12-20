//
//  Cost_TrackerAppDelegate.m
//  Cost_Tracker
//
//  Created by Apple User on 12/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Cost_TrackerAppDelegate.h"
#import "Meeting.h"
#import "Person.h"

@implementation Cost_TrackerAppDelegate

@synthesize window;

@synthesize startingTimeLabel;
@synthesize endingTimeLabel;
@synthesize elapsedTimeLabel;
@synthesize accruedCostLabel;
@synthesize totalBillingRateLabel;
@synthesize beginButton;
@synthesize endButton;

@synthesize person1NameField;
@synthesize person2NameField;
@synthesize person3NameField;
@synthesize person4NameField;

@synthesize person1RateField;
@synthesize person2RateField;
@synthesize person3RateField;
@synthesize person4RateField;

@synthesize person1PresentCheckbox;
@synthesize person2PresentCheckbox;
@synthesize person3PresentCheckbox;
@synthesize person4PresentCheckbox;


- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
    [self setMeeting:[[[Meeting alloc] init] autorelease]];
    
    [person1NameField setObjectValue:[[[self meeting] person1] participantName]];
    [person2NameField setObjectValue:[[[self meeting] person2] participantName]];
    [person3NameField setObjectValue:[[[self meeting] person3] participantName]];
    [person4NameField setObjectValue:[[[self meeting] person4] participantName]];

	[person1RateField setObjectValue:[[[self meeting] person1] rate]];	
	[person2RateField setObjectValue:[[[self meeting] person2] rate]];	
    [person3RateField setObjectValue:[[[self meeting] person3] rate]];	
    [person4RateField setObjectValue:[[[self meeting] person4] rate]];	
    
    [person1PresentCheckbox setState:[[self meeting] person1Present]];
    [person2PresentCheckbox setState:[[self meeting] person2Present]];
    [person3PresentCheckbox setState:[[self meeting] person3Present]]; 
    [person4PresentCheckbox setState:[[self meeting] person4Present]];
    
    [endButton setEnabled:NO];
    
	[self setTimer:
	 [NSTimer scheduledTimerWithTimeInterval:0.2 
									  target:self
									selector:@selector(updateGUI:)
									userInfo:nil
									 repeats:YES]];
    
}

- (void)dealloc
{
	[self setMeeting:nil];
	[self setTimer:nil];
	[super dealloc];
}

- (void)updateGUI:(NSTimer *)theTimer
{
	[[self totalBillingRateLabel] setObjectValue:[NSNumber numberWithFloat: [[self meeting] totalBillingRate]]];
	[[self elapsedTimeLabel] setStringValue:[[self meeting] elapsedTimeDisplayString]];
	[[self accruedCostLabel] setObjectValue:[NSNumber numberWithFloat:[[self meeting] accruedCost]]];
}

#pragma mark -
#pragma mark actions

- (void)beginMeeting:(id)sender
{
	NSLog(@"beginMeeting");
	[[self meeting] setStartingTime:[NSDate date]];
	[[self startingTimeLabel] setObjectValue:[[self meeting] startingTime]];
	[[self beginButton] setEnabled:NO];
	[[self endButton] setEnabled:YES];
}

- (void)endMeeting:(id)sender
{
	NSLog(@"endMeeting");
	[[self meeting] setEndingTime:[NSDate date]];
	[[self endingTimeLabel] setObjectValue:[[self meeting] endingTime]];
	[[self endButton] setEnabled:NO];
}

- (void)changePerson1Name:(id)sender
{
	[[[self meeting] person1] setParticipantName:[sender objectValue]];
}
- (void)changePerson1Rate:(id)sender
{
	[[[self meeting] person1] setRate:[sender objectValue]];
}
- (void)togglePerson1Presence:(id)sender
{
	[[self meeting] setPerson1Present:![[self meeting] person1Present]];
}

- (void)changePerson2Name:(id)sender
{
	[[[self meeting] person2] setParticipantName:[sender objectValue]];
}
- (void)changePerson2Rate:(id)sender
{
	NSLog(@"changing person2 rate");
	[[[self meeting] person2] setRate:[[self person2RateField] objectValue]];
}
- (void)togglePerson2Presence:(id)sender
{
	[[self meeting] setPerson2Present:![[self meeting] person2Present]];
}

- (void)changePerson3Name:(id)sender
{
	[[[self meeting] person3] setParticipantName:[sender objectValue]];
}
- (void)changePerson3Rate:(id)sender
{
	[[[self meeting] person3] setRate:[[self person3RateField] objectValue]];
}
- (void)togglePerson3Presence:(id)sender
{
	[[self meeting] setPerson3Present:![[self meeting] person3Present]];
}

- (void)changePerson4Name:(id)sender
{
	[[[self meeting] person4] setParticipantName:[sender objectValue]];
}
- (void)changePerson4Rate:(id)sender
{
	[[[self meeting] person4] setRate:[[self person4RateField] objectValue]];
}
- (void)togglePerson4Presence:(id)sender
{
	[[self meeting] setPerson4Present:
	 ! [[self meeting] person4Present]];
}

- (void)debugDump:(id)sender
{
	[[self meeting] dumpStatusToConsole];
}

#pragma mark -
#pragma mark accessors


- (Meeting *)meeting
{
	return meeting; 
}
- (void)setMeeting:(Meeting *)aTheMeeting
{
	if (meeting != aTheMeeting) {
		[aTheMeeting retain];
		[meeting release];
		meeting = aTheMeeting;
	}
}

- (NSTimer *)timer
{
	return timer; 
}
- (void)setTimer:(NSTimer *)aTheTimer
{
	if (timer != aTheTimer) {
		[aTheTimer retain];
		[timer invalidate];
		[timer release];
		timer = aTheTimer;
	}
}


@end
