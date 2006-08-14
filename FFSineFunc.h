//
//  FFSineFunc.h
//  sine
//
//  Created by Folkert Saathoff on Sat Nov 15 2003.
//  Copyright (c) 2003 folkert@feedface.com. All rights mine.
//

#import <Foundation/Foundation.h>




@interface FFSineFunc : NSObject {
	float amp,freq,phase,delta;
	IBOutlet NSSlider *ampSlider, *freqSlider, *phaseSlider, *deltaSlider;
}

- (float) valueAt: (float) t;
- (float) amp;
- (float) freq;
- (float) phase;
- (float) delta;
- (void) setAmp: (float) a;
- (void) setFreq: (float) f;
- (void) setPhase: (float) p;
- (void) setDelta: (float) d;
- (void) update: (id) sender;


@end
