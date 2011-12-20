//
//  Meeting.h
//  Meeting_Tracker
//
//  Created by Apple User on 12/13/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class Person;

@interface Meeting : NSObject {
    NSDate *startingTime;
	NSDate *endingTime;
	
	NSMutableArray *personsPresent;
	NSNumber *totalBillingRate;
    
	NSUndoManager *undoManager;
}

@property (nonatomic, retain) NSDate *startingTime;
@property (nonatomic, retain) NSDate *endingTime;
@property (nonatomic, assign) NSNumber *totalBillingRate;
@property (nonatomic, retain) NSMutableArray *personsPresent;
@property (nonatomic, retain) NSUndoManager *undoManager;

- (void)dumpStatusToConsole;

- (void) updateTotalBillingRate;
- (NSNumber *) liveComputedTotalBillingRateNumber;
- (double) liveComputedTotalBillingRateDouble;

- (NSUInteger)elapsedSeconds;
- (double)elapsedHours;
- (NSString *)elapsedTimeDisplayString;

- (float)accruedCost;

- (BOOL) canStart;
- (BOOL) canStop;
- (BOOL) canRepopulate;

- (void)removeObjectFromPersonsPresentAtIndex:(NSUInteger)idx;
- (void)insertObject:(id)anObject inPersonsPresentAtIndex:(NSUInteger)idx;

@end
