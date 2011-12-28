//
//  Observation.h
//  Weather_Underground
//
//  Created by Apple User on 12/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//


#import <CoreData/CoreData.h>

@class Location;

@interface Observation :  NSManagedObject  
{
}

@property (nonatomic, retain) NSDate * timestamp;
@property (nonatomic, retain) NSNumber * temperature;
@property (nonatomic, retain) NSNumber * windspeed;
@property (nonatomic, retain) NSNumber * pressure;
@property (nonatomic, retain) Location * station;

@end



