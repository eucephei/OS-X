//
//  AppDelegate.m
//  
//
//  Created by Apple User on 2/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"
#import "PrefsWindow.h"
#import "MeetTrackerPreferences.h"

NSString *DefaultBillingRateKey = @"defaultBillingRate";
NSString *MeetingParticipantCounterKey = @"meetingParticipantCounter";

@implementation AppDelegate

+ (void)initialize
{
	LogMethod();
	NSMutableDictionary *defaultValues = [NSMutableDictionary dictionary];
	[defaultValues setObject:[NSNumber numberWithDouble:75.0] forKey:DefaultBillingRateKey];
	[defaultValues setObject:[NSNumber numberWithInt:0] forKey:MeetingParticipantCounterKey];
	
	[[NSUserDefaults standardUserDefaults] registerDefaults:defaultValues];
}

- (IBAction)showPreferencesEditingWindow:(id)sender
{
	LogMethod();
	if (!preferenceEditingWindow)
		preferenceEditingWindow = [[PrefsWindow alloc] init];
	
	[preferenceEditingWindow showWindow:sender];
}


@end