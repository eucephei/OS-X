//
//  Person.m
//  Cost_Tracker
//
//  Created by Apple User on 12/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Person.h"


@implementation Person

@synthesize participantName;
@synthesize rate;

- (id)init
{
    if ((self = [super init])) {
        [self setParticipantName: @""];
        [self setRate: [NSNumber numberWithFloat:75.]];
    }
    return self;
}

- (void)dealloc
{
    [self setParticipantName:nil];
    [self setRate:nil];
	
    [super dealloc];
}

+ (Person *)personWithName:(NSString *)newName
					  rate:(double)billingRate
{
	Person *result = [[[Person alloc] init] autorelease];
	[result setParticipantName:newName];
	[result setRate:[NSNumber numberWithDouble:billingRate]];
    
	return result;
}

@end
