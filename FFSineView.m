//
//  FFSineView.h
//  cocoahedron
//
//  Created by Folkert Saathoff on Thu Nov 20 2003.
//  Copyright (c) 2003 folkert@feedface.com. All rights mine.
//

#import "FFSineView.h"
#define PI (3.14159265358979323844)
#define NUMSAMPLES (0xff)

@implementation FFSineView

- (void)
drawRect:(NSRect)rect
{
	FFSine *func;
	unsigned long i;
	float x,y;
	NSPoint p;
	NSBezierPath *path;
	
	func= [contro getFunc: self];

	path= [NSBezierPath bezierPath];
	[path setLineWidth: 1.0];
	[[NSColor blackColor] set];

	x= 0.0;
	y= f(func,x);
	p.x= 0.0;
	p.y= y * rect.size.height/2.0f  + rect.size.height/2.0f;
	[path moveToPoint: p];

	for (i=0; i<NUMSAMPLES; i++) {
		x+= 2*PI/NUMSAMPLES;
		y= f(func,x);
		p.x+= rect.size.width/NUMSAMPLES;
		p.y= y * rect.size.height/2.0f  + rect.size.height/2.0f;
		[path lineToPoint: p];
	}

	[path stroke];
}



@end
