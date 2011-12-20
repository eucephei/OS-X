//
//  Person.m
//  Meeting_Tracker
//
//  Created by Apple User on 12/13/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Person.h"
#import "MeetTrackerPreferences.h"

@implementation Person

NSString *personBillingRateKeypath = @"rate";

@synthesize participantName;
@synthesize rate;
@synthesize meeting;

- (id)init
{
    if ((self = [super init])) {
        [self setParticipantName:
            [NSString stringWithFormat:@"gummibar #%d",
            [[NSUserDefaults standardUserDefaults] integerForKey:MeetingParticipantCounterKey]]];
		[self setRate: 
            [NSNumber numberWithFloat:[[NSUserDefaults standardUserDefaults] doubleForKey:DefaultBillingRateKey]]];
        
        [[NSUserDefaults standardUserDefaults] setInteger:
            ([[NSUserDefaults standardUserDefaults] integerForKey:MeetingParticipantCounterKey] +1)
                forKey:MeetingParticipantCounterKey];    
    }
    return self;
}

- (void)dealloc
{
    [self setParticipantName:nil];
    [self setRate:nil];
    [self setMeeting:nil];
	
    [super dealloc];
}

#pragma mark -
#pragma mark accessors

-(id)initWithParticipantName:(NSString *)aParticipantName rate:(double)aRate
{
	if ((self = [super init])) {
		[self setParticipantName:aParticipantName];
		[self setRate:[NSNumber numberWithDouble:aRate]];
	}
	return self;
}

- (void)setParticipantName:(NSString *)aName
{
    if (participantName != aName) {
		[[self undoManager] registerUndoWithTarget:self
										  selector:@selector(setParticipantName:) 
											object:[self participantName]];		
		[participantName release];
		participantName = [aName retain];
    }
}

- (void)setRate:(NSNumber *)aRate
{
    if (rate != aRate) {
		[[self undoManager] registerUndoWithTarget:self
										  selector:@selector(setRate:) 
											object:[self rate]];
		[rate release];
		rate = [aRate retain];
    }
}

#pragma mark -
#pragma mark archiving

- (void)encodeWithCoder:(NSCoder *)encoder 
{
    [encoder encodeObject:[self participantName] forKey:@"participantName"];
    [encoder encodeObject:[self rate] forKey:@"rate"];
    [encoder encodeObject:[self meeting] forKey:@"meeting"];
}

- (id)initWithCoder:(NSCoder *)decoder 
{
    if ((self = [super init])) {
        [self setParticipantName:[decoder decodeObjectForKey:@"participantName"]];
        [self setRate:[decoder decodeObjectForKey:@"rate"]];
        [self setMeeting:[decoder decodeObjectForKey:@"meeting"]];
    }
    return self;
}

#pragma mark -
#pragma mark undo

- (NSUndoManager *) undoManager
{
	return [[self meeting] undoManager];
}

@end
