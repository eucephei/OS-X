//
//  WidgetRunView.h
//  Widget_Plot
//
//  Created by Apple User on 12/21/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class Widget;

@interface WidgetRunView : NSView {
	Widget *theTestRun;
    
	NSImage *thumbnailImage;
	NSPoint mousePositionViewCoordinates;
    
    BOOL shouldDrawMouseInfo;
}

@property (nonatomic,retain) Widget *theTestRun;
@property (nonatomic,retain) NSImage *thumbnailImage;

@property (nonatomic) NSPoint mousePositionViewCoordinates;
@property (nonatomic) BOOL shouldDrawMouseInfo;

- (IBAction)savePDF:(id)sender;

@end
