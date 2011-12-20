//
//  Cost_TrackerAppDelegate.h
//  Cost_Tracker
//
//  Created by Apple User on 12/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class Meeting;

@interface Cost_TrackerAppDelegate : NSObject <NSApplicationDelegate> {

    NSWindow *window;
    
	NSTextField *startingTimeLabel;
	NSTextField *endingTimeLabel;
	NSTextField *elapsedTimeLabel;
	NSTextField *accruedCostLabel;
	NSTextField *totalBillingRateLabel;
	
	NSButton *beginButton;
	NSButton *endButton;

    Meeting *meeting;
	NSTimer *timer;

	NSButton *person1PresentCheckbox;
	NSButton *person2PresentCheckbox;
	NSButton *person3PresentCheckbox;
	NSButton *person4PresentCheckbox;
    
    NSTextField *person1NameField;
	NSTextField *person2NameField;
	NSTextField *person3NameField;
	NSTextField *person4NameField;
	
	NSTextField *person1RateField;
	NSTextField *person2RateField;
	NSTextField *person3RateField;
	NSTextField *person4RateField;
}

@property (assign) IBOutlet NSWindow *window;

@property (nonatomic, retain) IBOutlet NSTextField *startingTimeLabel;    
@property (nonatomic, retain) IBOutlet NSTextField *endingTimeLabel;
@property (nonatomic, retain) IBOutlet NSTextField *elapsedTimeLabel;
@property (nonatomic, retain) IBOutlet NSTextField *accruedCostLabel;
@property (nonatomic, retain) IBOutlet NSTextField *totalBillingRateLabel;

@property (nonatomic, retain) IBOutlet NSButton *beginButton;
@property (nonatomic, retain) IBOutlet NSButton *endButton;

@property (nonatomic, retain) IBOutlet NSButton *person1PresentCheckbox;
@property (nonatomic, retain) IBOutlet NSButton *person2PresentCheckbox;
@property (nonatomic, retain) IBOutlet NSButton *person3PresentCheckbox;
@property (nonatomic, retain) IBOutlet NSButton *person4PresentCheckbox;

@property (nonatomic, retain) IBOutlet NSTextField *person1NameField;
@property (nonatomic, retain) IBOutlet NSTextField *person2NameField;
@property (nonatomic, retain) IBOutlet NSTextField *person3NameField;
@property (nonatomic, retain) IBOutlet NSTextField *person4NameField;

@property (nonatomic, retain) IBOutlet NSTextField *person1RateField;
@property (nonatomic, retain) IBOutlet NSTextField *person2RateField;
@property (nonatomic, retain) IBOutlet NSTextField *person3RateField;
@property (nonatomic, retain) IBOutlet NSTextField *person4RateField;

- (Meeting *)meeting;
- (void)setMeeting:(Meeting *)aTheMeeting;

- (NSTimer *)timer;
- (void)setTimer:(NSTimer *)aTheTimer;


- (IBAction)beginMeeting:(id)sender;
- (IBAction)endMeeting:(id)sender;

- (IBAction)changePerson1Name:(id)sender;
- (IBAction)changePerson1Rate:(id)sender;
- (IBAction)togglePerson1Presence:(id)sender;

- (IBAction)changePerson2Name:(id)sender;
- (IBAction)changePerson2Rate:(id)sender;
- (IBAction)togglePerson2Presence:(id)sender;

- (IBAction)changePerson3Name:(id)sender;
- (IBAction)changePerson3Rate:(id)sender;
- (IBAction)togglePerson3Presence:(id)sender;

- (IBAction)changePerson4Name:(id)sender;
- (IBAction)changePerson4Rate:(id)sender;
- (IBAction)togglePerson4Presence:(id)sender;

- (IBAction)debugDump:(id)sender;

@end
