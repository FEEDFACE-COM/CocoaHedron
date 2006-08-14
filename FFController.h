//
//  FFController.h
//  cocoahedron
//
//  Created by Folkert Saathoff on Mon Nov 10 2003.
//  Copyright (c) 2003 folkert@feedface.com. All rights mine.
//

#import <Cocoa/Cocoa.h>
#import <ScreenSaver/ScreenSaverDefaults.h>
#import "FFsine.h"


#define USERDEFAULTS @"com.feedface.screensaver.CocoaHedron"


@class FFSineView;
@class FFSineButton;
@class FFSineController;
@class FFCocoaHedronView;

@interface FFController : NSObject
{
		IBOutlet id prefSheet;
    IBOutlet FFCocoaHedronView *mainView;
		
		IBOutlet NSButton *axisSwitch, *logoSwitch, *shadeSwitch,
											*smoothSwitch, *borderSwitch, *delaySwitch;
		IBOutlet NSSlider *lowDepthSlider, *highDepthSlider;
		IBOutlet NSSlider *turnSlider, *yankSlider, *zoomSlider;

		IBOutlet FFSineButton *distButton, *sizeButton, *turnButton;
		IBOutlet FFSineController *distContro, *sizeContro, *turnContro;
		IBOutlet NSWindow *distWindow, *sizeWindow, *turnWindow;
					
    IBOutlet NSWindow *mainWindow, *prefsWindow;		
		IBOutlet NSWindow *aboutBox, *helpBox;
		
		NSWindow *fullWindow; 
		bool inFullScreen;
}

- (IBAction) showPrefs: (id)sender;
- (IBAction) showDist: (id)sender;
- (IBAction) showSize: (id)sender;
- (IBAction) showTurn: (id) sender;
- (IBAction) updateSettings: (id) sender;
- (IBAction) updateGlobal: (id) sender;
- (IBAction) updateDist: (id) sender;
- (IBAction) updateSize: (id) sender;
- (IBAction) updateTurn: (id) sender;
- (IBAction) updateDepth: (id) sender;
- (void) goFullScreen;
- (void) leaveFullScreen;
- (IBAction) toggleFullScreen: (id) sender;
- (void) generateMiniWindow;
- (IBAction) closeSheet: (id) sender;
- (IBAction) gotoFF: (id) sender;
- (IBAction) restoreDefaults: (id) sender;
- (void) cleanUp;
- (void) setControls;
- (FFSine*) getFunc: (id) sender;

@end
