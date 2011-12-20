//
//  Person.h
//  Meeting_Tracker
//
//  Created by Apple User on 12/13/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

extern NSString *personBillingRateKeypath;

@class Meeting;

@interface Person : NSObject {
    NSString *participantName;
	NSNumber *rate;
    Meeting *meeting;
}

@property (nonatomic, retain) NSString *participantName;
@property (nonatomic, retain) NSNumber *rate;
@property (nonatomic, retain) Meeting *meeting;

-(id)initWithParticipantName:(NSString *)aParticipantName rate:(double)aRate;

- (NSUndoManager *) undoManager;

@end
