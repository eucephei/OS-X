//
//  PrefsWindow.m
//  Meet_Tracker
//
//  Created by Apple User on 12/18/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PrefsWindow.h"


@implementation PrefsWindow

- (id)init 
{
	if (![super initWithWindowNibName:@"PrefsWindow"])
		return nil;
	return self;
}


- (void)dealloc
{
    [super dealloc];
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
}

@end
