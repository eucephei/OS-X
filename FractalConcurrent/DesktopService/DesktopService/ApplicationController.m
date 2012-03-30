//
//  ApplicationController.m
//  DesktopService
//
//  Created by Apple User on 3/26/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "ApplicationController.h"
#import "ListenService.h"
#import "FractalControl.h"
#import "FractalGenerator.h"

#import <mach/mach_time.h>

#pragma mark Private 

// Constants and Globals

@interface ApplicationController() <ListenServiceDelegate>
@property (retain)   ListenService*      listenService;
@property (retain)   NSOperationQueue*   fractalGenerationQueue;
@property (retain)   NSBitmapImageRep*   fractalBitmap;
@property (assign)   uint64_t            startTime;
@property (assign)   BOOL                fractalInProgress;
@property (assign)   BOOL                shouldCancelGeneration;
- (void) generateFractal;
- (void) fractalOperationCompleted;
- (void) cancelFractalGeneration;
- (void) updateForGenerationInProgress:(BOOL)inProgress;
- (void) disableControls:(BOOL)disabled;
- (void) startTiming;
- (float) endTiming;
@end


@implementation ApplicationController

@synthesize window;
@synthesize logTextField, fractalControl, progressIndicator;
@synthesize resetButton, zoomInButton, zoomOutButton;
@synthesize listenService;
@synthesize fractalGenerationQueue, fractalBitmap, startTime;
@synthesize fractalInProgress, shouldCancelGeneration;

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
        self.fractalInProgress = NO;
        self.shouldCancelGeneration = NO;
        self.fractalGenerationQueue = [[[NSOperationQueue alloc] init] autorelease];
    }
    
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [fractalBitmap release];
	fractalBitmap = nil;
    [fractalGenerationQueue release];
    fractalGenerationQueue = nil;
    [listenService release];
    listenService = nil;
    
    [super dealloc];
}

#pragma mark -
#pragma mark Nib Loading

-(void) awakeFromNib
{	
	[self.progressIndicator setHidden:YES];
	[self generateFractal];
    
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(windowResized:) 
                                                 name:NSWindowDidResizeNotification 
                                               object:[self window]];
}

#pragma mark -
#pragma mark Action

- (IBAction) zoomInPressed:(id)sender
{
	[self.fractalControl zoomIn];
	[self generateFractal];
}

- (IBAction) zoomOutPressed:(id)sender
{
	[self.fractalControl zoomOut];
	[self generateFractal];
}

- (IBAction) resetPressed:(id)sender
{
	[self.fractalControl resetToDefaultRegion];
	[self generateFractal];
}

- (IBAction) regionChanged:(id)sender
{
	[self generateFractal];
}

#pragma mark -
#pragma mark Notification

- (void) windowResized:(NSNotification*)notification 
{
    // generate a new fractal for the updated bounds
    [self generateFractal];
}

#pragma mark -
#pragma mark Fractal Computation

- (void) cancelFractalGeneration
{
    // No model changes are reverted-only the rendering operation
    if ( !self.fractalInProgress)    
        return;
    
    [self appendStringToLog:@"Cancel fractal generation in progress..."];
    self.shouldCancelGeneration = YES;
    [self.fractalGenerationQueue cancelAllOperations];
}

- (void) generateFractal
{
    if ( self.fractalInProgress )
    {
        // Guard against starting a new fractal rendering while one is already in progress. 
        // If implement canceling, one can instead cancel and start or queue up a new generation instead
        [self appendStringToLog:@"canceling current fractal generation, delaying new fractal generation"];
        [self cancelFractalGeneration];
        
        NSOperationQueue* delayedGenerateQueue = [[NSOperationQueue alloc] init];
        NSBlockOperation* queueMonitorBlock = [NSBlockOperation blockOperationWithBlock:^(void) {
            // wait until the queue is empty then queue back new fractal generation on main thread
            [self.fractalGenerationQueue waitUntilAllOperationsAreFinished];
            NSBlockOperation* delayedGenerationBlock = [NSBlockOperation blockOperationWithBlock:^(void) {
                    [delayedGenerateQueue autorelease];
                    [self generateFractal];
            }];
            [[NSOperationQueue mainQueue] addOperation:delayedGenerationBlock];
        }];
        
        [delayedGenerateQueue addOperation:queueMonitorBlock];
        
        return;
    }
    
    [self appendStringToLog:@"New fractal generation starting"];
    self.fractalInProgress = YES;
	
	// start timing and progress indication
	[self startTiming];
	
	// Disable anything that recomputes the fractal during computation
    [self updateForGenerationInProgress:YES];
    
    // Create 1 generator per row of pixels
    // Adjust this to fit the model you choose for concurrency by dividing bitmap in half and make 2 regions
    NSRect bounds = [self.fractalControl bounds];
    
    NSInteger pixelsHigh = bounds.size.height;
    NSInteger pixelsWide = bounds.size.width;
    
    NSUInteger rowsPerGenerator = 1;
    NSUInteger generatorCount   = pixelsHigh;
    
    // Create the image rep the threaded generators will draw into
    self. fractalBitmap = [[[NSBitmapImageRep alloc] 
						    initWithBitmapDataPlanes:NULL
						    pixelsWide:pixelsWide
						    pixelsHigh:pixelsHigh
						    bitsPerSample:8 
						    samplesPerPixel:3
						    hasAlpha:NO
						    isPlanar:NO
						    colorSpaceName:NSCalibratedRGBColorSpace
						    bytesPerRow:3*pixelsWide 
						    bitsPerPixel:0] autorelease];
    
    // Get the pointer to the raw data
	// Each generator will write pixel data to this shared memory
	// It is 'thread-safe' because no two generators are writting to the same region of this bitmap
    unsigned char* bitmap = [self.fractalBitmap bitmapData];
	
    CGFloat maxY = NSMaxY(self.fractalControl.region);
    CGFloat maxX = NSMaxX(self.fractalControl.region);
    CGFloat deltaY = self.fractalControl.region.size.height / pixelsHigh;
    
    // create 1 operation, and fill with a block and generator per row
    NSBlockOperation* blockOperation = [[[NSBlockOperation alloc] init] autorelease];
    
	// create 1 generator per region
    //  NSMutableArray* generators = [NSMutableArray arrayWithCapacity:generatorCount];
    for (int i = 0; i < generatorCount; i++) {
		FractalGenerator* generator = [[FractalGenerator alloc] init];
		
		// setup the region the generator will draw into
		generator.minimumX		= self.fractalControl.region.origin.x;
		generator.minimumY		= maxY - deltaY;
		generator.maximumX		= maxX;
		generator.maximumY		= maxY;
		generator.width			= (int) pixelsWide;
		generator.height		= (int) rowsPerGenerator;
		generator.pixelBuffer	= bitmap;
		
        // Move down the image
        maxY = maxY - deltaY;
        
        // Move to next region in bitmapData
        bitmap = bitmap + (pixelsWide * rowsPerGenerator * 3);
        
        // [generators addObject:generator];
        [blockOperation addExecutionBlock:^(void) {
             if (!self.shouldCancelGeneration ) 
                 [generator fill];
             [generator release];
         }];
        
    }
    
	// Change this synchronous, sequential computation that follows to instead use concurrent execution with NSOperations and NSOperationsQueues
    // Note that the main thread will block here!
    /*  
        for ( FractalGenerator* generator in generators)
            [generator fill];
     */   
    
    [blockOperation setCompletionBlock:^(void) {
         // make sure updates state on the main thread that updates UI
         // NOTE: NOT (fractalOperationCompleted:) BECAUSE NO PARAMETER(S) FOR THAT FUNCTION
         [self performSelectorOnMainThread:@selector(fractalOperationCompleted) withObject:self waitUntilDone:NO];
     }];
    
    // now update everything since we have finished rendering the fractal bitmap
    // this will update the user interface    
    //  [self fractalOperationCompleted];
    [self.fractalGenerationQueue addOperation:blockOperation];
    
}


- (void) fractalOperationCompleted
{    
    BOOL wasCanceled = self.shouldCancelGeneration;
    
    self.fractalInProgress = NO;
    self.shouldCancelGeneration = NO;
    
    float millisecondsElapsed = [self endTiming];
    
    if (wasCanceled) 
        [self appendStringToLog:[NSString stringWithFormat:@"Canceled fractal rendering %5.2f milliseconds", millisecondsElapsed]];
    else {
        [self appendStringToLog:[NSString stringWithFormat:@"Fractal rendering complete %5.2f milliseconds", millisecondsElapsed]];
        
        self.fractalControl.fractalBitmap	= self.fractalBitmap;   
    }
    
    [self updateForGenerationInProgress:NO];
}

- (void) updateForGenerationInProgress:(BOOL)inProgress
{
    // Disable controls so that we don't try to start a second fractal generation while one is in progress    
    //  [self disableControls:inProgress];
    [self.progressIndicator setHidden:!inProgress];
    
    if (inProgress)
        [self.progressIndicator startAnimation:nil];
    else
        [self.progressIndicator stopAnimation:nil];
}

- (void) disableControls:(BOOL)disabled
{
    [self.fractalControl setDisabled:disabled];
	[self.zoomInButton setEnabled:!disabled];
	[self.zoomOutButton setEnabled:!disabled];
	[self.resetButton setEnabled:!disabled];
}

#pragma mark -
#pragma mark Time passed in milliseconds

- (void) startTiming
{
	self.startTime = mach_absolute_time();
}

- (float) endTiming
{
	mach_timebase_info_data_t info;
	uint64_t end, elapsed;
	mach_timebase_info( &info );
    
	end = mach_absolute_time();
	
	elapsed = end - self.startTime;
	float millis = elapsed * (info.numer / info.denom) * pow(10.0f, -6.0f);
	return millis;
}

#pragma mark -
#pragma mark Service

- (void) appendStringToLog:(NSString*)logString
{
	NSString* newString = [NSString stringWithFormat:@"%@\n", logString];
	[[[self.logTextField textStorage] mutableString] appendString: newString];
	NSUInteger lastPosition = [[self.logTextField string] length];
	[self.logTextField scrollRangeToVisible:NSMakeRange(lastPosition, 1)];
}

- (void) startService
{   
   	NSLog(@"Start Service is implemented");
    ListenService* service = [[[ListenService alloc] init] autorelease];
    service.delegate = self;
    [service startService];
    [service publishService];
    
    // only publish if service starts
    self.listenService = service;
}


#pragma mark -
#pragma mark ListenServiceDelegate

- (void) receivedMessage:(ListenServiceMessageType)message
{
    [self appendStringToLog:[NSString stringWithFormat:@"Received Message : %d", message]];
    
    switch (message)  {
        case kListenServiceMessageReset:
            [self resetPressed:self];
            break;
        case kListenServiceMessageZoomIn:
            [self zoomInPressed:self];
            break;
        case kListenServiceMessageZoomOut:
            [self zoomOutPressed:self];
            break;
        case kListenServiceMessageUnknown:
        default:
            [self appendStringToLog:@"Unknown message, no action taken"];
            break;
    }
    
}

- (void) failedToStartServiceWithError:(NSError *)error
{
    [self appendStringToLog:[NSString stringWithFormat:@"Could not start service: %@", [error localizedDescription]]];
}

- (void) serviceStarted
{
    [self appendStringToLog:@"Service started"];
}

- (void) publishedServiceOfType:(NSString *)type withName:(NSString *)name onPort:(NSNumber *)port
{
    [self appendStringToLog:[NSString stringWithFormat:@"Published service %@ called %@ on port %d", type, name, [port integerValue]]];
}

- (void) connectionOpened
{
    [self appendStringToLog:@"New connection opend"];
}

- (void) connectionClosed
{
    [self appendStringToLog:@"Connection was closed!"];
}

- (void) receivedNewData:(NSData *)newData
{
    [self appendStringToLog:[NSString stringWithFormat:@"Received data from connection:%s", [newData bytes]]];
    // Note: above unsafe if newData has no terminating Null character, logging garbage
}

@end
