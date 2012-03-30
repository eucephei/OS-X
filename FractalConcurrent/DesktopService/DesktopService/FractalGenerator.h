//
//  FractalGenerator.h
//  DesktopService
//
//  Created by Apple User on 3/26/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@protocol FractalGeneratorDelegate;

@interface FractalGenerator : NSObject
{
	float				minimumX_;
	float				maximumX_;
	float				minimumY_;
	float				maximumY_;
	int					width_;
	int					height_;
	unsigned char*		pixelBuffer_;
}

@property (nonatomic, assign)	float				minimumX;
@property (nonatomic, assign)	float				minimumY;
@property (nonatomic, assign)	float				maximumX;
@property (nonatomic, assign)	float				maximumY;
@property (nonatomic, assign)	int					width;
@property (nonatomic, assign)	int					height;
@property (nonatomic, assign)	unsigned char*		pixelBuffer;

 // fills the pixel buffer with the fractal image
 // using the the min, max, width and height properties set before calling
- (void) fill;

@end
