//
//  Meeting.m
//  Cost_Tracker
//
//  Created by Apple User on 12/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Meeting.h"
#import "Person.h"

@implementation Meeting

@synthesize startingTime;
@synthesize endingTime;

@synthesize person1, person2;
@synthesize person3, person4;

@synthesize person1Present, person2Present;
@synthesize person3Present, person4Present;

- (id)init
{
    if ((self = [super init])) {
        [self setPerson1:[Person personWithName:@"Gummibar"
										   rate:200.]];
        [self setPerson2:[Person personWithName:@"Panda"
										   rate:100.]];
        [self setPerson3:[Person personWithName:@"Knut"
										   rate:250.]];
        [self setPerson4:[Person personWithName:@"Lalikuma"
										   rate:150.]];
        [self setPerson1Present: YES];
        [self setPerson2Present: NO];
        [self setPerson3Present: YES];
        [self setPerson4Present: NO];
        
        
    }
    return self;
}

- (void)dealloc
{
	[self setStartingTime:nil];
    [self setEndingTime:nil];

    [self setPerson1:nil];
    [self setPerson2:nil];
    [self setPerson3:nil];
    [self setPerson4:nil];
    
    [super dealloc];
}

#pragma mark -
#pragma mark calculate

- (void)dumpStatusToConsole
{
	NSLog(@"%@ status", self);
	NSLog(@"total billing rate %f", [self totalBillingRate]);
}

- (float)totalBillingRate
{
	double result = 0.;
    
	if ([self person1Present]) 
		result += [[[self person1] rate] floatValue];
	if ([self person2Present])
		result += [[[self person2] rate] floatValue];
	if ([self person3Present])
		result += [[[self person3] rate] floatValue];
	if ([self person4Present])
		result += [[[self person4] rate] floatValue]; 
    
	return result;
}

- (float)accruedCost
{
	return [self totalBillingRate] * [self elapsedHours];
}


- (NSUInteger)elapsedSeconds
{
	NSUInteger seconds = 45;
	if (![self endingTime])
		seconds = -1 * [[self startingTime] timeIntervalSinceNow];
	else {
		seconds = [[self endingTime] timeIntervalSinceDate:[self startingTime]];
	}
	return seconds;
	
}

- (NSString *)elapsedTimeDisplayString
{
	NSUInteger elapsedSeconds = [self elapsedSeconds];
	NSUInteger displaySeconds, displayMinutes, displayHours;
	displayHours = elapsedSeconds / 3600;
	displayMinutes = (elapsedSeconds / 60) % 60; 
	displaySeconds = elapsedSeconds % 60;
	return [NSString stringWithFormat:@"%0d:%02d:%02d", displayHours, displayMinutes, displaySeconds];
}

- (double)elapsedHours
{
	return [self elapsedSeconds] / 3600.;
}

#pragma mark -
#pragma mark accessors

@end
