//
//  MyDocument.m
//  Meet_Tracker
//
//  Created by Apple User on 12/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MyDocument.h"
#import "Meeting.h"
#import "Person.h"

@implementation MyDocument

@synthesize startingTimeLabel;
@synthesize endingTimeLabel;
@synthesize elapsedTimeLabel;
@synthesize accruedCostLabel;
@synthesize totalBillingRateLabel;
@synthesize beginButton;
@synthesize endButton;

@synthesize meeting;
@synthesize timer;

#pragma mark -
#pragma mark initializers / destructors

- (id)init
{
    self = [super init];
    if (self) {
        // Add your subclass-specific initialization here.
        [self setMeeting: [[[Meeting alloc] init] autorelease]];
        [[self meeting] setUndoManager:self.undoManager];
    }
    return self;
}

- (void)dealloc
{
    [self setMeeting:nil];
	
    [super dealloc];
}

#pragma mark -
#pragma mark GUI

/**
- (NSString *)displayName
{
 return @"Document-based Application";
} 
 **/

- (NSString *)windowNibName
{
    // Override returning the nib file name of the document
    // If you need to use a subclass of NSWindowController or if your document supports multiple NSWindowControllers, you should remove this method and override -makeWindowControllers instead.
    return @"MyDocument";
}

- (void)windowControllerDidLoadNib:(NSWindowController *)aController
{
    [super windowControllerDidLoadNib:aController];
    // Add any code here that needs to be executed once the windowController has loaded the document's window.
	[self setTimer: [NSTimer scheduledTimerWithTimeInterval:1.0 
                                                     target:self
                                                   selector:@selector(updateGUI:)
                                                   userInfo:nil
                                                    repeats:YES]];
}

- (void)updateGUI:(NSTimer *)theTimer
{
    [[self totalBillingRateLabel] setObjectValue:[[self meeting] liveComputedTotalBillingRateNumber]];
    [[self elapsedTimeLabel] setStringValue:[[self meeting] elapsedTimeDisplayString]];
	[[self accruedCostLabel] setObjectValue:[NSNumber numberWithFloat:[[self meeting] accruedCost]]];
}

- (void)windowWillClose:(NSNotification *)notification
{
	[self setTimer:nil];
}

#pragma mark -
#pragma mark archiving

- (NSData *)dataOfType:(NSString *)typeName error:(NSError **)outError {
    /*
     Insert code here to write your document to data of the specified type. If outError != NULL, ensure that you create and set an appropriate error when returning nil.
    You can also choose to override -fileWrapperOfType:error:, -writeToURL:ofType:error:, or -writeToURL:ofType:forSaveOperation:originalContentsURL:error: instead.
    */
    if (outError) {
        *outError = [NSError errorWithDomain:NSOSStatusErrorDomain code:unimpErr userInfo:NULL];
    }
	return [NSKeyedArchiver archivedDataWithRootObject:self.meeting];
}

- (BOOL)readFromData:(NSData *)data ofType:(NSString *)typeName error:(NSError **)outError {
    /*
    Insert code here to read your document from the given data of the specified type. If outError != NULL, ensure that you create and set an appropriate error when returning NO.
    You can also choose to override -readFromFileWrapper:ofType:error: or -readFromURL:ofType:error: instead.
    */
    
    Meeting *newMeeting;
	@try {
		newMeeting = [NSKeyedUnarchiver unarchiveObjectWithData:data];
	}
	@catch (NSException *e) {
		if (outError) {
			NSDictionary *d = 
			[NSDictionary dictionaryWithObject:@"Data is corrupted."
										forKey:NSLocalizedFailureReasonErrorKey];
			*outError = [NSError errorWithDomain:NSOSStatusErrorDomain
											code:unimpErr
										userInfo:d];
		}
		return NO;
	}
	self.meeting = newMeeting;
    newMeeting.undoManager = self.undoManager;
    return YES;
}

#pragma mark -
#pragma mark accessors

- (void)setTimer:(NSTimer *)aTheTimer
{
	if (timer != aTheTimer) {
        [[self undoManager] registerUndoWithTarget:self
                                                     selector:@selector(setTimer:)
                                                       object:[self timer]];
		[aTheTimer retain];
		[timer invalidate];
		[timer release];
		timer = aTheTimer;
	}
}

- (void)setBeginButton:(NSButton *)aBeginButton
{
    if (beginButton != aBeginButton) {
        [[self undoManager] registerUndoWithTarget:self
                                                     selector:@selector(setBeginButton:)
                                                       object:[self beginButton]];
        [aBeginButton retain];
        [beginButton release];
        beginButton = aBeginButton;
    }
}

- (void)setEndButton:(NSButton *)anEndButton
{
    if (endButton != anEndButton) {
        [[self undoManager] registerUndoWithTarget:self
                                                     selector:@selector(setEndButton:)
                                                       object:[self endButton]];
        [anEndButton retain];
        [endButton release];
        endButton = anEndButton;
    }
}


#pragma mark -
#pragma mark actions

- (void)debugDump:(id)sender
{
	[[self meeting] dumpStatusToConsole];
}

- (void)beginMeeting:(id)sender
{
	NSLog(@"beginMeeting");
	[[self meeting] setStartingTime:[NSDate date]];
    [[self meeting] setEndingTime:nil];
	[[self startingTimeLabel] setObjectValue:[[self meeting] startingTime]];
    [[self endingTimeLabel] setObjectValue:nil];
	[[self beginButton] setEnabled:NO];
	[[self endButton] setEnabled:YES];
}

- (void)endMeeting:(id)sender
{
	NSLog(@"endMeeting");
	[[self meeting] setEndingTime:[NSDate date]];
	[[self endingTimeLabel] setObjectValue:[[self meeting] endingTime]];
	[[self endButton] setEnabled:NO];  
    [[self beginButton] setEnabled:YES];
}

- (void) resetToBugsBunnyMeeting:(id)sender
{
	LogMethod();
	[self.meeting setPersonsPresent:[NSMutableArray arrayWithCapacity:6]];
	[self.meeting insertObject:[[[Person alloc] initWithParticipantName:@"Bugs Bunny" rate:35.] autorelease ] inPersonsPresentAtIndex:0];
	[self.meeting insertObject:[[[Person alloc] initWithParticipantName:@"Daffy Duck" rate:40.]  autorelease ] inPersonsPresentAtIndex:0];
	[self.meeting insertObject:[[[Person alloc] initWithParticipantName:@"Gummibar" rate:50.]  autorelease ] inPersonsPresentAtIndex:0];
	[self.meeting insertObject:[[[Person alloc] initWithParticipantName:@"Domo Kun" rate:30.]  autorelease ] inPersonsPresentAtIndex:0];
	[self.meeting insertObject:[[[Person alloc] initWithParticipantName:@"Tweety Bird" rate:30.]  autorelease ] inPersonsPresentAtIndex:0];
	[self.meeting insertObject:[[[Person alloc] initWithParticipantName:@"Road Runner" rate:0.]  autorelease ] inPersonsPresentAtIndex:0];
}

- (void) resetToBeatlesMeeting:(id)sender
{
	LogMethod();
	[self.meeting setPersonsPresent:[NSMutableArray arrayWithCapacity:4]];
	[self.meeting insertObject:[[[Person alloc] initWithParticipantName:@"John" rate:50.] autorelease ]inPersonsPresentAtIndex:0];
	[self.meeting insertObject:[[[Person alloc] initWithParticipantName:@"Paul" rate:50.] autorelease ]inPersonsPresentAtIndex:0];
	[self.meeting insertObject:[[[Person alloc] initWithParticipantName:@"George" rate:50.] autorelease ]inPersonsPresentAtIndex:0];
	[self.meeting insertObject:[[[Person alloc] initWithParticipantName:@"Ringo" rate:50.] autorelease ] inPersonsPresentAtIndex:0];
}

- (BOOL)validateUserInterfaceItem:(id <NSValidatedUserInterfaceItem>)anItem
{
	LogMethod();
	SEL theAction = [anItem action];
	
	if (theAction == @selector(beginMeeting:))
		return self.meeting.canStart;
	else if ((theAction == @selector(resetToBugsBunnyMeeting:))
			 || (theAction == @selector(resetToBeatlesMeeting:)))
		return self.meeting.canRepopulate;
	else if (theAction == @selector(endMeeting:))
		return self.meeting.canStop;
	
	return [super validateUserInterfaceItem:anItem];
}

@end
