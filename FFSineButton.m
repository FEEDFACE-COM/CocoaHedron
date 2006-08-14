//
//  FFSineButton.m
//  cocoahedron
//
//  Created by Folkert Saathoff on Thu Nov 20 2003.
//  Copyright (c) 2003 folkert@feedface.com. All rights mine.
//

#import "FFSineButton.h"


@implementation FFSineButton


- (void)
awakeFromNib
{
	if (view) {
		[self addSubview: view];
		[view setFrame:  NSInsetRect([self bounds],10.0,10.0)];
	}	
}



@end
