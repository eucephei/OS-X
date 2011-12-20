//
//  AppDelegate.h
//  
//
//  Created by Apple User on 2/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class PrefsWindow;

@interface AppDelegate : NSObject {
	PrefsWindow *preferenceEditingWindow;
}

- (IBAction)showPreferencesEditingWindow:(id)sender;

@end

