//
//  CocoaHedronView.h
//  CocoaHedron
//
//  Created by Folkert Saathoff on Wed Feb 11 2004.
//  Copyright (c) 2004, folkert@feedface.com. All rights reserved.
//


#import <Foundation/Foundation.h>
#import <ScreenSaver/ScreenSaver.h>
#import "FFSineFunc.h"
#import <OpenGL/gl.h>

#import "FFSine.h"

#import "FFCam.h"
#import "FFTetra.h"
#import "FFdraw.h"


@class FFController;

@interface FFCocoaHedronView : ScreenSaverView 
{
	IBOutlet id prefSheet;
	IBOutlet FFController *controller;
	FFSine dist, size, turn;
		
	NSOpenGLView *view;
	
	FFCam cam;
	FFVektor o;
	bool tracking;
	bool showAxis;
	bool showLogo;
	bool drawSmooth;
	bool drawBorder;
	bool lightScene;
	bool waitDelay;
	bool inFullScreen;	
	GLuint low,high;
	bool dirty;
	GLfloat rads;	
	GLuint tetra; //display list
	GLfloat w,h;
	GLfloat bubble, bobble;
	GLfloat fade;
	
	unsigned char* logo;

	CFAbsoluteTime startTime, time;
	NSSize screenSize;
}

- (void) draw;
- (void) initScene;
- (void) drawScene;
- (void) initClock;
- (void) updateTime;
- (void) initGL;
- (void) resizeGL;
- (void) initLogo;
- (void) setDelay: (int) val;
- (void) setShowAxis: (int) val;
- (void) setShowLogo: (int) val;
- (void) setLowDepth: (int) val;
- (void) setHighDepth: (int) val;
- (void) setShaded: (int) val;
- (void) setBorder: (int) val;
- (void) setSmooth: (int) val;
- (void) setTurn: (float) val;
- (void) setYank: (float) val;
- (void) setZoom: (float) val;
- (void) setInFullScreen: (bool) val;
- (FFSine*) dist;
- (FFSine*) size;
- (FFSine*) turn;

@end
