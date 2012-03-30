//
//  ListenService.h
//  DesktopService
//
//  Created by Apple User on 3/26/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString* const kListenServiceErrorDomain;

typedef enum {
    kListenServiceSocketFailedCode = 1,
    kListenServiceSocketOptionsFailedCode,
    kListenServiceSocketBindFailedCode,
} ListenServiceErrorCode;

typedef enum {
    kListenServiceMessageUnknown = -1,
    kListenServiceMessageReset = 0,
    kListenServiceMessageZoomIn,
    kListenServiceMessageZoomOut,
} ListenServiceMessageType;

@protocol  ListenServiceDelegate <NSObject>
@required
// sent when service successfully parses a message from an open connection
- (void) receivedMessage:(ListenServiceMessageType) message;  
// sent if service cannot be started
- (void) failedToStartServiceWithError:(NSError*) error;     
// sent when service successfully starts
- (void) serviceStarted;                                     
@optional
// sent when service is successfully published via Bonjour
- (void) publishedServiceOfType:(NSString*)type withName:(NSString*)name onPort:(NSNumber*)port;
// sent when a new connection is made
- (void) connectionOpened;  
// sent when a connection is closed
- (void) connectionClosed;  
// sent anytime data is received by the service, regardless of whether it was successfully parsed as a message in the protocol or not
- (void) receivedNewData:(NSData*)newData;
@end

/***********************************************************/

@class ApplicationController;
@protocol ListenServiceDelegate;

@interface ListenService : NSObject <NSNetServiceDelegate> 
{
    CFSocketRef     socket_;
}

@property (assign) id<ListenServiceDelegate>  delegate;

- (BOOL) startService;      // Start the service and begin listening on network port
- (void) publishService;    // attempt to publish service via Bonjour

@end


