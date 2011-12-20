//
//  Person.h
//  Cost_Tracker
//
//  Created by Apple User on 12/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface Person : NSObject {
    NSString *participantName;
	NSNumber *rate;
}

@property (nonatomic, retain) NSString *participantName;
@property (nonatomic, retain) NSNumber *rate;

+ (Person *) personWithName:(NSString *)newName
					   rate:(double)billingRate;

@end
