//
//  Meeting.h
//  Cost_Tracker
//
//  Created by Apple User on 12/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class Person;

@interface Meeting : NSObject {
	NSDate *startingTime;
	NSDate *endingTime;

    Person *person1, *person2;
    Person *person3, *person4;
    
	BOOL person1Present, person2Present;
    BOOL person3Present, person4Present;
}

@property (nonatomic, retain) NSDate *startingTime;
@property (nonatomic, retain) NSDate *endingTime;

@property (nonatomic, retain) Person *person1, *person2;
@property (nonatomic, retain) Person *person3, *person4;

@property (nonatomic, assign) BOOL person1Present, person2Present;
@property (nonatomic, assign) BOOL person3Present, person4Present; 


- (void)dumpStatusToConsole;

- (float)totalBillingRate;
- (float)accruedCost;

- (NSUInteger)elapsedSeconds;
- (double)elapsedHours;
- (NSString *)elapsedTimeDisplayString;

@end
