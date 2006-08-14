//
//  FFWindow.m
//  cocoahedron
//
//  Created by Folkert Saathoff on Mon Nov 10 2003.
//  Copyright (c) 2003 folkert@feedface.com. All rights mine.
//

#import "FFWindow.h"
#import "FFController.h"
#import "FFCocoaHedronView.h"

@implementation FFWindow


- (void)
awakeFromNib
{
	NSNotificationCenter *notify;
	[self center];
	[self makeFirstResponder: view];
	[self newScreen: nil];
	notify= [NSNotificationCenter defaultCenter];
	[notify addObserver: self
		selector: @selector(newScreen:)
		name: @"NSWindowDidChangeScreenNotification"
		object: nil];
}

- (void)
newScreen: (NSNotification*) note
{
	NSSize ss= [[self screen] frame].size;
	[self setContentAspectRatio: ss];
	[self setContentMaxSize: NSMakeSize(ss.width,ss.height)];
	[self setContentMinSize: NSMakeSize(ss.width/8.0,ss.height/8.0)];
	[self setContentSize: NSMakeSize(ss.width/2.0,ss.height/2.0)];
	NSLog(@"in new screen");
}



- (void)
zoom: (id) sender
{
	[controller goFullScreen];
}

- (void)
miniaturize:(id)sender
{
	[controller generateMiniWindow];
	[super miniaturize: sender];
}

@end
