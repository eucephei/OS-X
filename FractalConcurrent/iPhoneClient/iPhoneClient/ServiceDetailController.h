//
//  ServiceDetailController.h
//  iPhoneClient
//
//  Created by Apple User on 3/26/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ServiceDetailController : UIViewController 
{
	NSNetService*		service_;
	NSOutputStream*		outputStream_;
    
	UILabel*			statusLabel_;
    // UITextField*		messageTextView_;
}

@property (nonatomic, retain)			NSNetService*	service;
@property (nonatomic, retain) IBOutlet	UILabel*		statusLabel;
// @property (nonatomic, retain) IBOutlet	UITextField*	messageTextView;

- (IBAction)    zoomInTapped:(id)sender;
- (IBAction)    zoomOutTapped:(id)sender;
- (IBAction)    resetTapped:(id)sender;

@end
