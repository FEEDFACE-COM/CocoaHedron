//
//  FFSineFunc.m
//  sine
//
//  Created by Folkert Saathoff on Sat Nov 15 2003.
//  Copyright (c) 2003 folkert@feedface.com. All rights mine.
//

#import "FFSineFunc.h"
#define PI (3.14159265358979323844)

@implementation FFSineFunc


-(void)
awakeFromNib
{
	amp= 0.5;
	delta= 0.0;
	freq= 1.0;
	phase= 0.0;
}

- (void) update: (id) sender
{
	if (sender == freqSlider) 
		freq= [freqSlider floatValue];
	
	if (sender == phaseSlider)
		phase= [phaseSlider floatValue];

	if (sender == ampSlider) {	
		if (([deltaSlider floatValue] + [ampSlider floatValue] <= 1.0f)
		&&  ([deltaSlider floatValue] - [ampSlider floatValue] >= -1.0f))
			amp= [ampSlider floatValue];
		else
			[ampSlider setFloatValue: amp];
	}	

	if (sender == deltaSlider) {
		if (([deltaSlider floatValue] + [ampSlider floatValue] <= 1.0f)
		&&  ([deltaSlider floatValue] - [ampSlider floatValue] >= -1.0f))
			delta= [deltaSlider floatValue];
		else
			[deltaSlider setFloatValue: delta];
	}
	
//	NSLog(@"func is %2.2f*sin(%2.2f+%2.2f¹)+%2.2f",amp,freq,phase,delta);
}


//REM values are from -1.0 to 1.0
- (float) valueAt: (float) t {return amp*sin(freq*t+phase*PI)+delta;}
- (float) amp {return amp;}
- (float) freq {return freq;}
- (float) phase {return phase;}
- (float) delta {return delta;}

- (void) setAmp: (float) a 
{
	amp= a;
	[ampSlider setFloatValue: a];
}

- (void) setFreq: (float) f 
{
	freq= f;
	[freqSlider setFloatValue: f];
}

- (void) setPhase: (float) p 
{
	phase= p;
	[phaseSlider setFloatValue: p];
}

- (void) setDelta: (float) d 
{
	delta= d;
	[deltaSlider setFloatValue: d];	
}





@end
