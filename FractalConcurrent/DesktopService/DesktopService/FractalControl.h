//
//  FractalControl.h
//  DesktopService
//
//  Created by Apple User on 3/26/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface FractalControl : NSControl
{        
    // FRACTAL DRAWING
    NSRect              region_;
    NSBitmapImageRep*	fractalBitmap_;
        
    // FRACTAL ZOOMING
    BOOL	dragging_;      // true if draggins is in progress on the view
    NSPoint	downPoint_;     // the location of the downed mouse in this view
    NSPoint	currentPoint_;	// the location of the current point in a drag operation
}

 // the fractal image to display, represented as a bitmap
@property (retain)				NSBitmapImageRep*		fractalBitmap;
 // the region in the complex number space for which the view shows the fractal computation
 // this property changes when the user selects a region in the view
 // the horizontal components of the rect represent the range of the real part	
 // the vertical components of the rect represents the range of the imaginary part
@property (assign)				NSRect					region;
 // need to provide implementations of the target and action properties so as to use IB to set an action for this control
 // in this case the action fires when the user changes the region with a mouse drag in the view
@property (nonatomic, assign)	id						target;
@property (nonatomic, assign)   SEL						action;
 // when disabled, the user cannot drag to change the region
@property (nonatomic, assign)	BOOL					disabled;
 // return to the default region that has a nice centered view on the fractal
- (void) resetToDefaultRegion;
 // adjust the region so that it is zoomed in around its current center
- (void) zoomIn;
 // adjust the region so that it is zoomed out around its current center
- (void) zoomOut;

@end
