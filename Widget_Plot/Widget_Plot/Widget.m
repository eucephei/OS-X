//
//  Widget.m
//  Widget_Plot
//
//  Created by Apple User on 12/21/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Widget.h"


@implementation Widget

#pragma mark -
#pragma mark properties

@synthesize sampleSize;
@synthesize testData;
@synthesize sensorMinimum;
@synthesize sensorMaximum;

#pragma mark -
#pragma mark initializers / destructors

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
        self.sampleSize = 50;
		[self performTest];
    }
    
    return self;
}

- (void)dealloc
{
    [self setTestData:nil];
    [super dealloc];
}

#pragma mark -
#pragma mark data simulation

- (void)performTest
{
	NSUInteger i;
	NSPoint p;
	
    double timeIncrement = 0.1;
	double startingTime = 10.0;
	double sensorValueMean = 13.2;
	int sensorValueRange = 8;
    
	self.sensorMinimum = sensorValueMean + sensorValueRange;
	self.sensorMaximum = sensorValueMean - sensorValueRange;
    
	self.testData = [NSMutableArray arrayWithCapacity:self.sampleSize];
	for (i = 0; i < self.sampleSize; i++) {
		p.x = startingTime + timeIncrement * i;
		p.y = sensorValueMean - sensorValueRange/2. + ((double)rand()/(double)RAND_MAX * sensorValueRange);
        
		self.sensorMinimum = MIN(p.y, self.sensorMinimum);
		self.sensorMaximum = MAX(p.y, self.sensorMaximum);
        
        // use NSValue to convert from C struct (the NSPoint) to what an NSMutableArray can store
		// To retrieve it, use below:
        // NSPoint thePoint = [[testData objectAtIndex:0] pointValue];
		[self.testData addObject:[NSValue valueWithPoint:p]];
	}
    
	NSLog(@"%@", self.testData);
	NSLog(@"sensor range %f to %f", self.sensorMinimum, self.sensorMaximum);
}

- (NSPoint)startingPoint
{
	return [(NSValue *)[self.testData objectAtIndex:0] pointValue];
}

- (NSPoint)endingPoint
{
	return [(NSValue *)[self.testData lastObject] pointValue];
}

- (double)timeMinimum
{
	return self.startingPoint.x;
}
- (double)timeMaximum 
{
	return self.endingPoint.x;	
}



@end
