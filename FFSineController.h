//
//  FFSineController.h
//  cocoahedron
//
//  Created by Folkert Saathoff on Thu Nov 20 2003.
//  Copyright (c) 2003 folkert@feedface.com. All rights mine.
//

#import <Cocoa/Cocoa.h>
#import "FFsine.h"

@class FFSineView;
@class FFController;

@interface FFSineController : NSObject
{
    IBOutlet FFSineView *miniView;
    IBOutlet FFSineView *detailView;

    IBOutlet NSSlider *ampSlider;
    IBOutlet NSSlider *deltaSlider;
    IBOutlet NSSlider *freqSlider;
    IBOutlet NSSlider *phaseSlider;
		
		IBOutlet FFController *contro;
		
}

- (FFSine*) getFunc: (id) sender;
- (IBAction) update: (id) sender;
- (void) setSliders;
@end
