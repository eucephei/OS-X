//
//  ListenService.m
//  DesktopService
//
//  Created by Apple User on 3/26/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "ListenService.h"
#import "ApplicationController.h"
#import <sys/socket.h>
#import <netinet/in.h>

#pragma mark -
#pragma mark Constants

NSString* const     kListenServiceErrorDomain   = @"com.ace.ListenService";
NSString* const		kServiceTypeString          = @"_acelistener._tcp.";
NSString* const		kServiceNameString          = @"Desktop listen service";
NSString* const     kSearchDomain               = @"local.";
const	int			kListenPort                 = 8081;

@interface ListenService() <NSNetServiceDelegate> 

@property (retain) NSFileHandle* connectionFileHandle;
@property (retain) NSMutableDictionary* dataForFileHandles;

- (void) handleIncomingConnection:(NSNotification*)notification;
- (void) stopReceivingForFileHandle:(NSFileHandle*)fileHandle closeFileHandle:(BOOL)close;
- (void) readIncomingData:(NSNotification*) notification;
- (void) parseDataReceived:(NSMutableData*) dataSoFar;
- (NSMutableData*) dataForFileHandle:(NSFileHandle*) fileHandle;
- (void) handleMessage:(NSString*) messageString;

@end

/***********************************************************/

@implementation ListenService

@synthesize connectionFileHandle;
@synthesize dataForFileHandles;
@synthesize delegate;

-(id) init
{
    self = [super init];
    if (self != nil) 
    {
        socket_ = nil;
        self.connectionFileHandle = nil;
    }
    return self;
}

- (BOOL) startService
{
	socket_ = CFSocketCreate
	(
     kCFAllocatorDefault,
     PF_INET,
     SOCK_STREAM,
     IPPROTO_TCP,
     0,
     NULL,
     NULL
	 );
	
	// Create a network socket for streaming TCP
	if (!socket_) {
        NSLog(@"Cound not create socket");
		return NO;
	}
    
	int reuse = true;
	int fileDescriptor = CFSocketGetNative(socket_);
    
	// Make sure socket is set for reuse of the address 
    // Without this, one may find that the socket is already in use when restarting or debugging
	int result = setsockopt(
                            fileDescriptor,
                            SOL_SOCKET,
                            SO_REUSEADDR,
                            (void *)&reuse,
                            sizeof(int)
							);
	if ( result != 0) {
        NSLog(@"Unable to set socket options");
		return NO;
	}
	
	// Create the address for the socket. 
	// In this case we don't care what address is incoming but we listen on a specific port - kLisenPort
	struct sockaddr_in address;
	memset(&address, 0, sizeof(address));
	address.sin_len = sizeof(address);
	address.sin_family = AF_INET;
	address.sin_addr.s_addr = htonl(INADDR_ANY);
	address.sin_port = htons(kListenPort);
	
	CFDataRef addressData = 
    CFDataCreate(NULL, (const UInt8 *)&address, sizeof(address));
	[(id)addressData autorelease];
	
	// bind socket to the address
	if (CFSocketSetAddress(socket_, addressData) != kCFSocketSuccess) {
		NSLog(@"Unable to bind socket to address");
		return NO;
	}   
	
	// setup listening to incoming connections
	// we will use notifications to respond as we are not looking for high performance and want to use the simpler Cocoa NSFileHandle APIs
	self.connectionFileHandle = [[[NSFileHandle alloc] initWithFileDescriptor:fileDescriptor closeOnDealloc:YES] autorelease];
	
    [[NSNotificationCenter defaultCenter]
	 addObserver:self
	 selector:@selector(handleIncomingConnection:)
	 name:NSFileHandleConnectionAcceptedNotification
	 object:nil];
    
	[self.connectionFileHandle acceptConnectionInBackgroundAndNotify];
	
	return YES;
}


- (void) publishService
{
    CFStringRef computerName = CSCopyMachineName(); 
    NSString* serviceNameString = 
    [NSString stringWithFormat:@"%@'s %@", (NSString*)computerName, kServiceNameString]; 
    CFRelease(computerName);
    
    NSNetService* netService = [[NSNetService alloc] initWithDomain:@"" 
                                                               type:kServiceTypeString
                                                               name:serviceNameString 
                                                               port:kListenPort];
	// publish on the default domains
    [netService setDelegate:self];
    [netService publish];
    
    // NOTE: not handling for publish failure
    if ( [self.delegate respondsToSelector:@selector(publishedServiceOfType:withName:onPort:)]) {
        [self.delegate publishedServiceOfType:kServiceTypeString withName:kServiceNameString onPort:[NSNumber numberWithInteger:kListenPort]];
    }
}

#pragma mark -
#pragma mark NSFileHandle Notification

-(void) handleIncomingConnection:(NSNotification*)notification
{
	NSDictionary*	userInfo			=	[notification userInfo];
	NSFileHandle*	readFileHandle		=	[userInfo objectForKey:NSFileHandleNotificationFileHandleItem];
	
    if(readFileHandle) {
		[[NSNotificationCenter defaultCenter]
		 addObserver:self
		 selector:@selector(readIncomingData:)
		 name:NSFileHandleDataAvailableNotification
		 object:readFileHandle];
        
        if ( [self.delegate respondsToSelector:@selector(connectionOpened:)])        
            [self.delegate connectionOpened];
        
        [readFileHandle waitForDataInBackgroundAndNotify];
    }
	
	[self.connectionFileHandle acceptConnectionInBackgroundAndNotify];
}

- (void) readIncomingData:(NSNotification*) notification
{
	NSFileHandle*	readFileHandle	= [notification object];
	NSData*			data			= [readFileHandle availableData];
    NSMutableData*  dataSoFar       = [self dataForFileHandle:readFileHandle];
	
	if ([data length] == 0) {
		if ([self.delegate respondsToSelector:@selector(connectionClosed)]) 
            [self.delegate connectionClosed];
		
		[self stopReceivingForFileHandle:readFileHandle closeFileHandle:YES];
		return;
	}	
    
    if ( [self.delegate respondsToSelector:@selector(receiveNewData:)] )
        [self.delegate receivedNewData:data];
    
    // append the data to data so far
    [dataSoFar appendData:data];
    [self parseDataReceived:dataSoFar];
    
	// wait for a read again
	[readFileHandle waitForDataInBackgroundAndNotify];	
}

- (NSMutableData*) dataForFileHandle:(NSFileHandle *)fileHandle
{
    NSMutableData* data = [self.dataForFileHandles objectForKey:fileHandle];
    if ( data == nil ) {
        data = [NSMutableData data];
        [self.dataForFileHandles setObject:data forKey:fileHandle];
    }
    return data;
}


- (void) stopReceivingForFileHandle:(NSFileHandle*)fileHandle closeFileHandle:(BOOL)close
{
	if (close) 
		[fileHandle closeFile];

    NSMutableData* data = [self.dataForFileHandles objectForKey:fileHandle];
    if (data != nil) 
        [self.dataForFileHandles removeObjectForKey:fileHandle];
    
	[[NSNotificationCenter defaultCenter] 
            removeObserver:self
                      name:NSFileHandleDataAvailableNotification
                    object:fileHandle];
}

#pragma mark -
#pragma mark Messages

- (void) parseDataReceived:(NSMutableData *)dataSoFar
{
    // Look for a token taht indicates a complete message, act and remove
    // Our token is the null terminator 0x00
    char token = 0x00;
    
    NSRange result = [dataSoFar rangeOfData:[NSData dataWithBytes:&token length:1] options:0 range:NSMakeRange(0,[dataSoFar length])];
    
    if (result.location != NSNotFound ) {
        NSData* messageData = [dataSoFar subdataWithRange:NSMakeRange(0, result.location+1)];
        NSString* messageString = [NSString stringWithUTF8String:[messageData bytes]];
        
        // act on the message
        NSLog(@"parsed message : %@", messageString);
        [self handleMessage:messageString];
        
        // trim the message we have handled off the data received
        NSUInteger location = result.location + 1;
        NSUInteger length = [dataSoFar length] - [messageData length];  
        
        [dataSoFar setData:[dataSoFar subdataWithRange:NSMakeRange(location, length)]];
    }
}

- (void) handleMessage:(NSString *)messageString 
{
    if (self.delegate == nil)
        return;
    
    ListenServiceMessageType message = kListenServiceMessageUnknown;
    
    if ( [messageString compare:@"zoomIn" options:NSCaseInsensitiveSearch] == NSOrderedSame)
        message = kListenServiceMessageZoomIn;
    else if ( [messageString compare:@"zoomOut" options:NSCaseInsensitiveSearch] == NSOrderedSame)
        message = kListenServiceMessageZoomOut;
    else if ( [messageString compare:@"reset" options:NSCaseInsensitiveSearch] == NSOrderedSame)
        message = kListenServiceMessageReset;
    
    [self.delegate receivedMessage:message];
}

@end

