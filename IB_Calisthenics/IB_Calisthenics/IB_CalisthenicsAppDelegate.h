//
//  IB_CalisthenicsAppDelegate.h
//  IB_Calisthenics
//
//  Created by Apple User on 12/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface IB_CalisthenicsAppDelegate : NSObject <NSApplicationDelegate, NSSpeechSynthesizerDelegate> {
    
@private
    NSWindow *window;
    NSSpeechSynthesizer *speechSynth;
    
    IBOutlet NSTextField *copyingLabel;
	IBOutlet NSTextField *copiedInput;
	IBOutlet NSTextField *countingLabel;
	IBOutlet NSTextField *seasonsLabel;
	IBOutlet NSTextField *currentTime;
	IBOutlet NSSlider *squaringSlider;
	IBOutlet NSTextField *squareInput;
	IBOutlet NSTextField *squareOutput;
	IBOutlet NSSegmentedControl *voiceChooser;
	IBOutlet NSSlider *speechRateSlider;
	IBOutlet NSTextField *speakerInput;
	

}

- (IBAction)changeToHello:(id)sender;
- (IBAction)changeToGoodbye:(id)sender;
- (IBAction)changeToEntered:(id)sender;

- (IBAction)showSegmentValue:(id)sender;
- (IBAction)showSeasonStart:(id)sender;

- (IBAction)displayCurrentTime:(id)sender;

- (IBAction)computeSliderSquared:(id)sender;

- (IBAction)changeVoice:(id)sender;
- (IBAction)changeSpeechRate:(id)sender;
- (IBAction)startSpeaking:(id)sender;
- (IBAction)stopSpeaking:(id)sender;

- (NSSpeechSynthesizer *)speechSynth;
- (void)setSpeechSynth:(NSSpeechSynthesizer *)aSpeechSynth;


@property (assign) IBOutlet NSWindow *window;

@end
