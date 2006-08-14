//
//  FFSineController.h
//  cocoahedron
//
//  Created by Folkert Saathoff on Thu Nov 20 2003.
//  Copyright (c) 2003 folkert@feedface.com. All rights mine.
//

#import "FFController.h"
#import "FFSineController.h"
#import "FFSineView.h"

@implementation FFSineController


- (void)
awakeFromNib
{
}

- (void) 
update: (id) sender
{
	FFSine *func= [contro getFunc: self];
	
	if (sender == freqSlider) 
		func->f= [freqSlider floatValue];
	
	if (sender == phaseSlider)
		func->p= [phaseSlider floatValue];

	if (sender == ampSlider) {	
		if (([deltaSlider floatValue] + [ampSlider floatValue] <= 1.0f)
		&&  ([deltaSlider floatValue] - [ampSlider floatValue] >= -1.0f))
			func->a= [ampSlider floatValue];
		else
			[ampSlider setFloatValue: func->a];
	}	

	if (sender == deltaSlider) {
		if (([deltaSlider floatValue] + [ampSlider floatValue] <= 1.0f)
		&&  ([deltaSlider floatValue] - [ampSlider floatValue] >= -1.0f))
			func->d= [deltaSlider floatValue];
		else
			[deltaSlider setFloatValue: func->d];
	}
	
	[miniView setNeedsDisplay: TRUE];
	[detailView setNeedsDisplay: TRUE];
	
}

- (FFSine*)
getFunc: (id) sender
{
	return [contro getFunc: self];
}

- (void)
setSliders
{
	FFSine *func= [contro getFunc: self];

	[ampSlider setFloatValue: func->a];
	[freqSlider setFloatValue: func->f];
	[deltaSlider setFloatValue: func->d];
	[phaseSlider setFloatValue: func->p];	

	[ampSlider setNeedsDisplay: TRUE];
	[freqSlider setNeedsDisplay: TRUE];
	[deltaSlider setNeedsDisplay: TRUE];
	[phaseSlider setNeedsDisplay: TRUE];

	[detailView setNeedsDisplay: TRUE];
}

@end
