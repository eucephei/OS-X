//
//  Widget_PlotAppDelegate.h
//  Widget_Plot
//
//  Created by Apple User on 12/20/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class Widget;
@class WidgetRunView;

@interface Widget_PlotAppDelegate : NSObject <NSApplicationDelegate> {
@private
    NSWindow *window;
    Widget *widgetTester;
    
	IBOutlet WidgetRunView *testView;
	IBOutlet NSSegmentedControl *stylePicker;
}

@property (assign) IBOutlet NSWindow *window;
@property (nonatomic,retain) Widget *widgetTester;

- (IBAction)changeDrawingStyle:(id)sender;
- (IBAction)performNewTest:(id)sender;

@end
