//
//  Observation.m
//  Weather_Underground
//
//  Created by Apple User on 12/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Observation.h"
#import "Location.h"

@implementation Observation 

@dynamic timestamp;
@dynamic temperature;
@dynamic windspeed;
@dynamic pressure;
@dynamic station;

- (void)awakeFromInsert
{
//	self.timestamp = [NSDate date];
//	self.temperature = [NSNumber numberWithInt:(rand()%100)];
//	self.windspeed = [NSNumber numberWithInt:(rand()%20)];
//	self.pressure = [NSNumber numberWithInt:1000+(rand()%50)];
}


@end
