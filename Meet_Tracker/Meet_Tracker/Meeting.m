//
//  Meeting.m
//  Meeting_Tracker
//
//  Created by Apple User on 12/13/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Meeting.h"
#import "Person.h"

@implementation Meeting

@synthesize totalBillingRate;
@synthesize startingTime;
@synthesize endingTime;
@synthesize personsPresent;
@synthesize undoManager;

- (id)init
{
    if ((self = [super init])) {
        [self setPersonsPresent: [NSMutableArray array]];
    }
    return self;
}

- (void)dealloc
{
    [self setPersonsPresent:nil];
	[self setStartingTime:nil];
    [self setEndingTime:nil];
	
    [super dealloc];
}

#pragma mark -
#pragma mark calculate

-(void)dumpStatusToConsole
{
	NSLog(@"%@ status", self);
    NSLog(@"total billing rate %f", [self liveComputedTotalBillingRateDouble]);
	NSLog(@"%ld members", [[self personsPresent] count]);
	for (Person *participant in [self personsPresent]) {
		NSLog(@"%@ %@", [participant participantName], [participant rate]);
	}
}

- (void) updateTotalBillingRate
{
	LogMethod();
	self.totalBillingRate = self.liveComputedTotalBillingRateNumber;
}

- (NSNumber *) liveComputedTotalBillingRateNumber
{
	return [self.personsPresent valueForKeyPath:@"@sum.rate"];
}

- (double) liveComputedTotalBillingRateDouble
{
	return [self.liveComputedTotalBillingRateNumber doubleValue];
}

+ (NSSet *)keyPathsForValuesAffectingTotalBillingRate
{
	return [NSSet setWithObject:@"personsPresent"];
}

- (NSUInteger)elapsedSeconds
{
	NSUInteger seconds = 0;
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

- (float)accruedCost
{
	return [self liveComputedTotalBillingRateDouble] * [self elapsedHours];
}

- (BOOL) canStart
{
	LogMethod();
	return ((self.personsPresent.count > 0) && !self.startingTime);
}

- (BOOL) canStop
{
	LogMethod();
	return ((!self.endingTime) && !self.startingTime);
}

- (BOOL) canRepopulate
{
	LogMethod();
	return (!self.startingTime);
}

#pragma mark -
#pragma mark accessors

- (void)setStartingTime:(NSDate *)aStartingTime
{
    if (startingTime != aStartingTime) {
        [[self undoManager] registerUndoWithTarget:self
                                                     selector:@selector(setStartingTime:)
                                                       object:[self startingTime]];
        [aStartingTime retain];
        [startingTime release];
        startingTime = aStartingTime;
    }
}

- (void)setEndingTime:(NSDate *)anEndingTime
{
    if (endingTime != anEndingTime) {
        [[self undoManager] registerUndoWithTarget:self
                                                     selector:@selector(setEndingTime:)
                                                       object:[self endingTime]];
        [anEndingTime retain];
        [endingTime release];
        endingTime = anEndingTime;
    }
}

- (void)setPersonsPresent:(NSMutableArray *)thePersonsPresent
{
    if (personsPresent != thePersonsPresent) {
		for (Person *person in personsPresent) {
			[person removeObserver:self forKeyPath:personBillingRateKeypath];
		}
        [personsPresent release];
        personsPresent = [thePersonsPresent retain];
		for (Person *person in personsPresent) {
			[person addObserver:self forKeyPath:personBillingRateKeypath
						options:NSKeyValueObservingOptionNew context:nil];
		}
    }
}

- (void)removeObjectFromPersonsPresentAtIndex:(NSUInteger)idx 
{
	LogMethod();
    Person *escapee = [self.personsPresent objectAtIndex:idx];
    
	[[[self undoManager] prepareWithInvocationTarget:self]
	 insertObject:escapee inPersonsPresentAtIndex:idx];
	[escapee setMeeting:nil];
    
	[[self.personsPresent objectAtIndex:idx] removeObserver:self forKeyPath:personBillingRateKeypath];
    [[self personsPresent] removeObjectAtIndex:idx];
	[self updateTotalBillingRate];
}

- (void)insertObject:(id)anObject inPersonsPresentAtIndex:(NSUInteger)idx 
{
	LogMethod();
	[[[self undoManager] prepareWithInvocationTarget:self] removeObjectFromPersonsPresentAtIndex:idx];
    
    [[self personsPresent] insertObject:anObject atIndex:idx];
	[anObject addObserver:self forKeyPath:personBillingRateKeypath options:NSKeyValueObservingOptionNew context:nil];
	[self updateTotalBillingRate];
}

#pragma mark -
#pragma mark KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
	LogMethod();
	NSAssert1(keyPath == personBillingRateKeypath, @"don't know what to do with keypath '%@'", keyPath);
	[self updateTotalBillingRate];
}


#pragma mark -
#pragma mark archiving

- (void)encodeWithCoder:(NSCoder *)encoder 
{
    [encoder encodeObject:[self startingTime] forKey:@"startingTime"];
    [encoder encodeObject:[self endingTime] forKey:@"endingTime"];
    [encoder encodeObject:[self personsPresent] forKey:@"personsPresent"];
}

- (id)initWithCoder:(NSCoder *)decoder 
{
    if ((self = [super init])) {
        [self setStartingTime:[decoder decodeObjectForKey:@"startingTime"]];
        [self setEndingTime:[decoder decodeObjectForKey:@"endingTime"]];
        [self setPersonsPresent:[decoder decodeObjectForKey:@"personsPresent"]];
        [self updateTotalBillingRate];
    }

    return self;
}

@end
