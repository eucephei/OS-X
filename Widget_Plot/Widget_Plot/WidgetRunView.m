//
//  WidgetRunView.m
//  Widget_Plot
//
//  Created by Apple User on 12/21/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "WidgetRunView.h"
#import "Widget.h"
#import "KeyStrings.h"

@implementation WidgetRunView

@synthesize theTestRun;
@synthesize thumbnailImage;
@synthesize shouldDrawMouseInfo;
@synthesize mousePositionViewCoordinates;

#pragma mark -
#pragma mark label

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
        NSTrackingArea *ta = [[NSTrackingArea alloc] initWithRect:NSZeroRect
                                                          options:(NSTrackingMouseEnteredAndExited
                                                                   | NSTrackingMouseMoved
                                                                   | NSTrackingActiveAlways
                                                                   | NSTrackingInVisibleRect)
                                                            owner:self 
                                                         userInfo:nil];
		[self addTrackingArea:ta];
		[ta release];
    }
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

- (void)drawRect:(NSRect)dirtyRect
{
    double xOffset = theTestRun.timeMinimum;
	double yOffset = theTestRun.sensorMinimum;
	double xRange = theTestRun.timeMaximum - theTestRun.timeMinimum;
	double yRange = theTestRun.sensorMaximum - theTestRun.sensorMinimum;	
    
    // Drawing code here.
    NSRect bounds = [self bounds];
	NSLog(@"drawRect: bounds %@", NSStringFromRect(bounds));
    
    NSPoint xAxisStart = bounds.origin;
	NSPoint xAxisEnd = bounds.origin;
	xAxisEnd.x += bounds.size.width;
    
    NSBezierPath *pointsPath = [NSBezierPath bezierPath];
	[pointsPath moveToPoint:xAxisStart];
    
	for (NSValue *val in theTestRun.testData) {
		NSPoint rawPoint = [val pointValue];
		NSPoint projectedPoint;
		projectedPoint.x = (rawPoint.x - xOffset)/xRange * bounds.size.width;
		projectedPoint.y = (rawPoint.y - yOffset)/yRange * bounds.size.height;
		NSLog(@"raw %@; projected %@", NSStringFromPoint(rawPoint), NSStringFromPoint(projectedPoint));
		[pointsPath lineToPoint:projectedPoint];
	}
	[pointsPath lineToPoint:xAxisEnd];
	[pointsPath closePath];
    
    
    NSUInteger drawingStyleNumber = [[NSUserDefaults standardUserDefaults] integerForKey:drawingStyleKey];
    
    switch (drawingStyleNumber) {
		case 0:
			[[NSColor yellowColor] set];
			[NSBezierPath fillRect:bounds];
			
			[[NSColor blackColor] set];
			[pointsPath fill];
			break;
		case 1:
			[[NSColor whiteColor] set];
			[NSBezierPath fillRect:bounds];			
			
			[pointsPath setLineWidth:5.0];
			[[NSColor redColor] set];
			[pointsPath stroke];				
			break;
		case 2:
			[[NSColor whiteColor] set];
			[NSBezierPath fillRect:bounds];
			
			[[NSColor blueColor] set];
			[pointsPath fill];			
			CGFloat dashinArray[2];
			dashinArray[0] = 8.0;
			dashinArray[1] = 6.0;			
			
			[pointsPath setLineDash: dashinArray count:2 phase:0.0];
			[pointsPath setLineWidth:2.0];
			[[NSColor blackColor] set];
			[pointsPath stroke];
			break;
		default:
			NSAssert(NO, @"switch statement fell through");
			break;
	}
    
	if (self.shouldDrawMouseInfo) {
		NSDictionary *stringAttributes = 
        [NSDictionary dictionaryWithObjectsAndKeys:[NSColor redColor], NSForegroundColorAttributeName,
         [NSColor blackColor],NSBackgroundColorAttributeName,
         [NSFont fontWithName:@"Verdana-Italic" size:14.], NSFontAttributeName, nil];
		NSPoint mousePositioinDataCoordinates;
        
		mousePositioinDataCoordinates.x = mousePositionViewCoordinates.x / bounds.size.width * xRange + xOffset;
		mousePositioinDataCoordinates.y = mousePositionViewCoordinates.y / bounds.size.height * yRange + yOffset;
		
        NSString *mouseMessage = [NSString stringWithFormat:@"View:(%4.0f, %4.0f) Data:(%4.1f, %4.1f)",
								  self.mousePositionViewCoordinates,
								  mousePositioinDataCoordinates];
		NSLog(@"%@", mouseMessage);
		NSAttributedString *mouseInfo = [[[NSAttributedString alloc] 
                                          initWithString:mouseMessage
                                          attributes:stringAttributes]
                                         autorelease];
		NSPoint drawPoint = self.mousePositionViewCoordinates;
		NSSize stringSize = mouseInfo.size;
		if ((drawPoint.x + stringSize.width) >= bounds.size.width)
			drawPoint.x -= stringSize.width;
		if ((drawPoint.y + stringSize.height) >= bounds.size.height)
			drawPoint.y -= stringSize.height;
		[mouseInfo drawAtPoint:drawPoint];
	}
}

#pragma mark -
#pragma mark drag source

-(NSDragOperation) draggingSourceOperationMaskForLocal:(BOOL)flag
{
	return NSDragOperationCopy;
}

-(NSBitmapImageRep *)myBitmapImageRepresentation
{
	NSSize size = self.bounds.size;
	[self lockFocus];
	
	NSBitmapImageRep *result =
	[[[NSBitmapImageRep alloc]
      initWithFocusedViewRect:
	  NSMakeRect(0, 0, size.width, size.height)] autorelease];
	
	[self unlockFocus];
	return result;
}

- (void)setUpThumbnailAndFullImageForPasteboard:(NSPasteboard *)pb
{
	NSLog(@"writeToPasteboard %@", pb);
	NSBitmapImageRep* fullImageRepresenation = [self myBitmapImageRepresentation];
	NSLog(@"%@", fullImageRepresenation);
	
	// put the full-blown image onto the pasteboard, once
	[pb declareTypes:[NSArray arrayWithObject:NSPasteboardTypeTIFF]
			   owner:self];
	[pb setData:[fullImageRepresenation TIFFRepresentation] 
		forType:NSTIFFPboardType];
	
	// keep the thumbnail around for repeated mouseDragged: events
	NSSize displayedSize = self.bounds.size;
	
	// this is more steps than should be in production code
    double thumbnailSizeHeight = 100.0;
	double thumbnailSizeRatio = thumbnailSizeHeight / displayedSize.height;
    NSSize thumbnailSize = NSMakeSize(thumbnailSizeHeight, thumbnailSizeRatio * displayedSize.width);
	self.thumbnailImage = [[NSImage alloc] initWithSize:thumbnailSize];
	[self.thumbnailImage lockFocus];
    
	NSRect thumbnailBounds;
	thumbnailBounds.origin = NSZeroPoint;
	thumbnailBounds.size = self.thumbnailImage.size;
	
	NSRect drawFromRect;
	drawFromRect.origin = NSZeroPoint;
	drawFromRect.size = fullImageRepresenation.size;
    
	NSRect drawToRect;
	drawToRect.origin = NSZeroPoint;
	drawToRect.size = self.thumbnailImage.size;
    
	[fullImageRepresenation drawInRect:drawToRect
							  fromRect:drawFromRect
							 operation:NSCompositeSourceOver
							  fraction:0.6		// arbitrary value
						respectFlipped:YES
								 hints:nil];
	[self.thumbnailImage unlockFocus];
}

#pragma mark -
#pragma mark mouse events

- (void)mouseDragged:(NSEvent *)event
{
	NSLog(@"mouseDragged: %@", NSStringFromPoint([event locationInWindow]));
	
	NSPoint p = [self convertPoint:[event locationInWindow] fromView:nil];
	NSPasteboard *thePasteboard = [NSPasteboard pasteboardWithName:NSDragPboard];
	[self dragImage:self.thumbnailImage 
				 at:p 
			 offset:NSZeroSize 
			  event:event 
		 pasteboard:thePasteboard 
			 source:self
		  slideBack:YES];
}

- (void)mouseDown:(NSEvent *)event
{
	NSPasteboard *thePasteboard = [NSPasteboard pasteboardWithName:NSDragPboard];
	[self setUpThumbnailAndFullImageForPasteboard:thePasteboard];
	NSLog(@"mouseDown: %@", NSStringFromPoint([event locationInWindow]));	
}

// - (BOOL)acceptsFirstResponder
//{
//	return YES;
//}

-(void)mouseMoved:(NSEvent *)theEvent
{
	NSLog(@"mouseMoved: %@", NSStringFromPoint(theEvent.locationInWindow));	
	if (theEvent.modifierFlags & (NSShiftKeyMask | NSControlKeyMask)) {
		self.shouldDrawMouseInfo = YES;
		self.mousePositionViewCoordinates = [self convertPoint:theEvent.locationInWindow 
													  fromView:nil];
		[self setNeedsDisplay:YES];
	}
	else if (self.shouldDrawMouseInfo) {
		self.shouldDrawMouseInfo = NO;
		[self setNeedsDisplay:YES];
	}
}

- (void)mouseExited:(NSEvent *)theEvent
{
	NSLog(@"mouseExited: %@", NSStringFromPoint(theEvent.locationInWindow));
	self.shouldDrawMouseInfo = NO;
	self.mousePositionViewCoordinates = [self convertPoint:theEvent.locationInWindow
												  fromView:nil];
	[self setNeedsDisplay:YES];
}

#pragma mark -
#pragma mark actions

- (IBAction)savePDF:(id)sender
{
	NSSavePanel *panel = [NSSavePanel savePanel];
	[panel setRequiredFileType:@"pdf"];
	[panel beginSheetForDirectory:nil file:nil modalForWindow:[self window] modalDelegate:self didEndSelector:@selector(didEnd:returnCode:contextInfo:) contextInfo:NULL];
}

-(void)didEnd:(NSSavePanel *)sheet returnCode:(int)code contextInfo:(void *)contextInfo
{
	if (code != NSOKButton) return;
	
	NSRect r = [self bounds];
	NSData *data = [self dataWithPDFInsideRect:r];
	NSString *path = [sheet filename];
	NSError *error;
	BOOL successful = [data writeToFile:path options:0 error:&error];
	
	if (!successful) {
		NSAlert *a = [NSAlert alertWithError:error];
		[a runModal];
	}
}


@end
