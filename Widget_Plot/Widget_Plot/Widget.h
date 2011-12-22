//
//  Widget.h
//  Widget_Plot
//
//  Created by Apple User on 12/21/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface Widget : NSObject {
	NSUInteger sampleSize;
	NSMutableArray *testData;
	double sensorMinimum;
	double sensorMaximum;
}

@property (nonatomic,assign) NSUInteger sampleSize;
@property (nonatomic,retain) NSMutableArray *testData;

@property (nonatomic,assign) double sensorMinimum;
@property (nonatomic,assign) double sensorMaximum;

- (void)performTest;

- (NSPoint)startingPoint;
- (NSPoint)endingPoint;

- (double)timeMinimum;
- (double)timeMaximum;

@end
