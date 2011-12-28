//
//  Location.m
//  Weather_Underground
//
//  Created by Apple User on 12/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Location.h"
#import "Observation.h"

static NSUInteger stationCount = 0;

@implementation Location 

@dynamic code;
@dynamic latitude;
@dynamic name;
@dynamic longitude;
@dynamic observations;

- (void)awakeFromInsert
{
	self.code = [NSString stringWithFormat:@"KSFO", ++stationCount];
	self.name = [NSString stringWithFormat:@"Station KSFO%02d", stationCount];
	self.latitude = [NSNumber numberWithDouble:37.37];
	self.longitude = [NSNumber numberWithDouble:-122.22];
}


- (NSString *)URLStringForWeatherUndergroundConditions
{
	return [NSString 
				stringWithFormat:@"http://api.wunderground.com/auto/wui/geo/WXCurrentObXML/index.xml?query=%@",
			self.code];
}


- (NSURL *)URLForWeatherUndergroundConditions
{
	return [NSURL URLWithString:self.URLStringForWeatherUndergroundConditions];
}

- (void)updateCurrentConditions:(id)sender
{
	NSLog(@"updateCurrentCondition %@", self);
	NSLog(@"%@", self.URLStringForWeatherUndergroundConditions);
	
	NSError *error;
	NSXMLDocument *xmlDoc =
	 [[NSXMLDocument alloc] initWithContentsOfURL:self.URLForWeatherUndergroundConditions 
										  options:0
											error: &error];
	NSLog(@"%@", xmlDoc);
	NSLog(@"%@", [[xmlDoc rootElement] elementsForName:@"observation_time"]);
	NSLog(@"%@ %@", [[xmlDoc rootElement] elementsForName:@"temp_f"],
		  [[xmlDoc rootElement] elementsForName:@"observation_epoch"]);
				  
	Observation *newObservation = 
		[NSEntityDescription insertNewObjectForEntityForName:@"Observation"
												inManagedObjectContext:self.managedObjectContext];
	NSXMLElement *temperatureElement =
		[[[xmlDoc rootElement] elementsForName:@"temp_f"] lastObject];
	newObservation.temperature = [NSNumber numberWithInt:temperatureElement.stringValue.intValue];
		  
	NSXMLElement *windElement =
		[[[xmlDoc rootElement] elementsForName:@"wind_mph"] lastObject];
	newObservation.windspeed = [NSNumber numberWithInt:windElement.stringValue.intValue];
	
	NSXMLElement *pressureElement =
	[[[xmlDoc rootElement] elementsForName:@"pressure_mb"] lastObject];
	newObservation.pressure = [NSNumber numberWithInt:pressureElement.stringValue.intValue];

	
	NSXMLElement *timeElement =
		[[[xmlDoc rootElement] elementsForName:@"observation_epoch"] lastObject];
	NSLog(@"%@ %f", timeElement.stringValue, timeElement.stringValue.doubleValue);
	NSDate *timeObserved = [NSDate dateWithTimeIntervalSince1970:timeElement.stringValue.doubleValue];
	NSLog(@"%@", timeObserved);
	newObservation.timestamp = timeObserved;

	newObservation.station = self;
	
	[xmlDoc release];
}


@end
