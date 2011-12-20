//
//  IB_CalisthenicsAppDelegate.m
//  IB_Calisthenics
//
//  Created by Apple User on 12/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "IB_CalisthenicsAppDelegate.h"

@implementation IB_CalisthenicsAppDelegate

@synthesize window;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
    [seasonsLabel setStringValue:@"January"];
    
    [self setSpeechSynth:[[[NSSpeechSynthesizer alloc] init] autorelease]];
	[speechRateSlider setFloatValue:[[self speechSynth] rate]];
	[[self speechSynth] setDelegate:self];
}

- (void)dealloc
{
    [self setSpeechSynth:nil];
	
    [super dealloc];
}

#pragma mark - push Buttons

- (IBAction)changeToHello:(id)sender
{
	[copyingLabel setStringValue:@"Hello world"];
}

- (IBAction)changeToGoodbye:(id)sender
{
	[copyingLabel setStringValue:@"Goodbye"];
}

- (IBAction)changeToEntered:(id)sender
{
	[copyingLabel setStringValue:[copiedInput stringValue]];
}

- (IBAction)showSegmentValue:(id)sender
{
	[countingLabel setStringValue:[NSString stringWithFormat:@"%d: %@",
								   [sender selectedSegment],
								   [sender labelForSegment:[sender selectedSegment]]]];
}

- (IBAction)showSeasonStart:(id)sender
{
	switch ([sender selectedRow]) {
		case 0:
			[seasonsLabel setStringValue:@"December"];
			break;
		case 1:
			[seasonsLabel setStringValue:@"March"];
			break;
		case 2:
			[seasonsLabel setStringValue:@"June"];
			break;
		case 3:
			[seasonsLabel setStringValue:@"September"];         
			break;           
	}
}

- (IBAction)displayCurrentTime:(id)sender
{
	[currentTime setObjectValue:[NSDate date]];
}

- (IBAction)computeSliderSquared:(id)sender
{
	NSLog(@"computeSliderSquared %f %@", [sender doubleValue], [sender objectValue]);
    
	double sliderSetting = [squaringSlider doubleValue];
	[squareInput setStringValue:[NSString stringWithFormat:@"%3.1f", sliderSetting]];
	[squareOutput setDoubleValue:sliderSetting*sliderSetting];
}

#pragma mark - speechSynth 

- (NSSpeechSynthesizer *)speechSynth
{
    return speechSynth; 
}

- (void)setSpeechSynth:(NSSpeechSynthesizer *)aSpeechSynth
{
    if (speechSynth != aSpeechSynth) {
        [aSpeechSynth retain];
        [speechSynth release];
        speechSynth = aSpeechSynth;
    }
}

- (IBAction)changeVoice:(id)sender
{
	NSString *stringForVoice = [NSString stringWithFormat:@"com.apple.speech.synthesis.voice.%@",
								[sender labelForSegment:[sender selectedSegment]]];
	[[self speechSynth] setVoice:stringForVoice];
    
	[speechRateSlider setFloatValue:[[self speechSynth] rate]];
}

- (IBAction)changeSpeechRate:(id)sender
{
	[[self speechSynth] setRate:[sender floatValue]];
}

- (IBAction)startSpeaking:(id)sender
{
	[[self speechSynth] startSpeakingString:[speakerInput stringValue]];
}

- (IBAction)stopSpeaking:(id)sender
{
	[[self speechSynth] stopSpeaking];
}

@end
