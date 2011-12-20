//
//  MyDocument.h
//  Meet_Tracker
//
//  Created by Apple User on 12/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class Meeting;

@interface MyDocument : NSDocument {
	NSTextField *startingTimeLabel;
	NSTextField *endingTimeLabel;
	NSTextField *elapsedTimeLabel;
	NSTextField *accruedCostLabel;
	NSTextField *totalBillingRateLabel;
	
	NSButton *beginButton;
	NSButton *endButton;
    
    Meeting *meeting;
	NSTimer *timer;
}

@property (nonatomic, retain) IBOutlet NSTextField *startingTimeLabel;    
@property (nonatomic, retain) IBOutlet NSTextField *endingTimeLabel;
@property (nonatomic, retain) IBOutlet NSTextField *elapsedTimeLabel;
@property (nonatomic, retain) IBOutlet NSTextField *accruedCostLabel;
@property (nonatomic, retain) IBOutlet NSTextField *totalBillingRateLabel;
@property (nonatomic, retain) IBOutlet NSButton *beginButton;
@property (nonatomic, retain) IBOutlet NSButton *endButton;

@property (nonatomic, retain) Meeting *meeting;
@property (nonatomic, retain) NSTimer *timer;

- (IBAction)debugDump:(id)sender;

- (IBAction)beginMeeting:(id)sender;
- (IBAction)endMeeting:(id)sender;

- (IBAction)resetToBugsBunnyMeeting:(id)sender;
- (IBAction)resetToBeatlesMeeting:(id)sender;

-(BOOL)validateUserInterfaceItem:(id <NSValidatedUserInterfaceItem>)anItem;

@end
