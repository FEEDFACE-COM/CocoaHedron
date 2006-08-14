//
//  FFWindow.h
//  cocoahedron
//
//  Created by Folkert Saathoff on Mon Nov 10 2003.
//  Copyright (c) 2003 folkert@feedface.com. All rights mine.
//

#import <Foundation/Foundation.h>
@class FFController;
@class FFCocoaHedronView;

@interface FFWindow : NSWindow 
{
	IBOutlet FFController *controller;
	IBOutlet FFCocoaHedronView *view;
}

- (void) newScreen: (NSNotification*) note;


@end
