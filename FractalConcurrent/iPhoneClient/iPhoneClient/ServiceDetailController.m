//
//  ServiceDetailController.m
//  iPhoneClient
//
//  Created by Apple User on 3/26/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "ServiceDetailController.h"

@interface ServiceDetailController ()
- (void) connectToService;
- (void) releaseStream;
@end

@implementation ServiceDetailController

@synthesize	service = service_;
@synthesize statusLabel = statusLabel_;
// @synthesize messageTextView = messageTextView_;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
	[service_ release];
    [self releaseStream];
    
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    /*
     [messageTextView_ becomeFirstResponder];
     messageTextView_.returnKeyType = UIReturnKeySend;
     messageTextView_.enablesReturnKeyAutomatically = YES;
     */	
	if (service_) [self connectToService];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
	self.statusLabel = nil;
    //	self.messageTextView = nil;
	self.service = nil;
    
    [self releaseStream];}

- (void) releaseStream
{
    [outputStream_ close];
    [outputStream_ release];
    outputStream_ = nil;
    
    [statusLabel_ release];
    statusLabel_  = nil;
    /*    
     [messageTextView_ release];
     messageTextView_ = nil;
     */
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return YES; // (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - 
#pragma mark Service

- (void) connectToService
{
	// We assume the NSNetService has been resolved at this point
	
	// NSNetService makes it easy for us to connect, we don't have to do any socket management
    // < ADD CODE HERE : get the output stream from the service >
    [service_ getInputStream:NULL outputStream:&outputStream_];
	
	// if we wanted, we could scheudled notifcations or other run loop
	// based reading of the input stream to get messages back from the
	// service we connected to
    // < ADD CODE HERE : statuaLabel to reflect if we connected or not. 
    //    if we could not get the output stream, we could not connect >
    if (outputStream_ != nil ) {
        [outputStream_ open];
        statusLabel_.text = @"Connected to service";
    } else {
        statusLabel_.text = @"Could not connect to service";        
    }
}

- (void) sendMessage:(NSString*)messageText
{
	if ( outputStream_ == nil )
	{
		statusLabel_.text = @"Failed to send message, not connected.";
		return;
	}
    
    const uint8_t* messageBuffer = (const uint8_t*)[messageText UTF8String];
    NSUInteger length = [messageText lengthOfBytesUsingEncoding:
                         NSUTF8StringEncoding]; 
    [outputStream_ write:messageBuffer maxLength:length+1];
    // +1 to length returned, because it does not include NULL terminator
    // this is a synchronous write
	
}

#pragma mark -
#pragma mark Actions


- (IBAction) zoomInTapped:(id)sender
{
    [self sendMessage:@"zoomIn"];
}

- (IBAction) zoomOutTapped:(id)sender
{
    [self sendMessage:@"zoomOut"];
}

- (IBAction) resetTapped:(id)sender
{
    [self sendMessage:@"reset"];
}


@end
