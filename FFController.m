//
//  FFController.m
//  cocoahedron
//
//  Created by Folkert Saathoff on Mon Nov 10 2003.
//  Copyright (c) 2003 folkert@feedface.com. All rights mine.
//


#import "FFController.h"
#import "FFSineView.h"
#import "FFSineButton.h"
#import "FFSineController.h"
#import "FFCocoaHedronView.h"

@implementation FFController

- (void)
setControls
{
	NSUserDefaults *prefs= [ScreenSaverDefaults defaultsForModuleWithName: USERDEFAULTS];
		
	[axisSwitch setIntValue: [prefs boolForKey: @"drawAxis"]];
	[logoSwitch setIntValue: [prefs boolForKey: @"drawLogo"]];
	[shadeSwitch setIntValue: [prefs boolForKey: @"drawShades"]];
	[smoothSwitch setIntValue: [prefs boolForKey: @"drawSmooth"]];
	[borderSwitch setIntValue: [prefs boolForKey: @"drawBorder"]];
	[delaySwitch setIntValue: [prefs boolForKey: @"delay"]];

	[axisSwitch setNeedsDisplay: TRUE];
	[logoSwitch setNeedsDisplay: TRUE];
	[shadeSwitch setNeedsDisplay: TRUE];
	[smoothSwitch setNeedsDisplay: TRUE];
	[borderSwitch setNeedsDisplay: TRUE];
	[delaySwitch setNeedsDisplay: TRUE];

	[lowDepthSlider setIntValue: [prefs integerForKey: @"lowThresh"]];
	[highDepthSlider setIntValue: [prefs integerForKey: @"highThresh"]];
	[lowDepthSlider setNeedsDisplay: TRUE];
	[highDepthSlider setNeedsDisplay: TRUE];

	[turnSlider setFloatValue: [prefs floatForKey: @"tetraTurn"]];
	[yankSlider setFloatValue: [prefs floatForKey: @"tetraYank"]];
	[zoomSlider setFloatValue: [prefs floatForKey: @"cam_zoom"]];
	[turnSlider setNeedsDisplay: TRUE];
	[yankSlider setNeedsDisplay: TRUE];
	[zoomSlider setNeedsDisplay: TRUE];
	
	[distButton setNeedsDisplay: TRUE];
	[sizeButton setNeedsDisplay: TRUE];
	[turnButton setNeedsDisplay: TRUE];
}

- (IBAction)
showPrefs: (id) sender
{
	[self setControls];	
#ifdef FF_APP	
	[prefsWindow setIsVisible: TRUE];
	if (inFullScreen) {
		[prefsWindow setLevel: NSScreenSaverWindowLevel -1];
		[fullWindow makeKeyWindow];
	}	else {
		[prefsWindow orderFront: self];
		[prefsWindow setLevel: NSFloatingWindowLevel];
		[mainWindow makeKeyWindow];
	}
	[prefsWindow makeFirstResponder: mainView];
#else
	[prefsWindow setOpaque: FALSE];
	[prefsWindow setAlphaValue: 0.95];
#endif	
}	

- (IBAction)
showDist: (id) sender
{
	[distWindow setIsVisible: TRUE];
	if (inFullScreen) {
		[distWindow setLevel: NSScreenSaverWindowLevel -1];
	} else {
		[distWindow makeKeyAndOrderFront: self];
		[distWindow setLevel: NSFloatingWindowLevel];
	}
	[distWindow makeFirstResponder: mainView];
	[distContro setSliders];
}

- (IBAction)
showSize: (id) sender
{
	[sizeWindow setIsVisible: TRUE];
	if (inFullScreen) {
		[sizeWindow setLevel: NSScreenSaverWindowLevel -1];
	} else {
		[sizeWindow orderFront: self];
		[sizeWindow setLevel: NSFloatingWindowLevel];
	}
	[sizeWindow makeFirstResponder: mainView];
	[sizeContro setSliders];
}

- (IBAction)
showTurn: (id) sender
{
	[turnWindow setIsVisible: TRUE];
	if (inFullScreen) {
		[turnWindow setLevel: NSScreenSaverWindowLevel -1];
	} else {
		[turnWindow orderFront: self];
		[turnWindow setLevel: NSFloatingWindowLevel];
	}
	[turnWindow makeFirstResponder: mainView];
	[turnContro setSliders];	
}


- (IBAction) 
updateSettings: (id) sender
{
	NSUserDefaults *prefs= [ScreenSaverDefaults defaultsForModuleWithName: USERDEFAULTS];
	[mainView setShowAxis: [axisSwitch intValue]];
	[prefs setBool: ([axisSwitch intValue]!=0) forKey: @"drawAxis"];
	[mainView setShowLogo: [logoSwitch intValue]];
	[prefs setBool: ([logoSwitch intValue]!=0) forKey: @"drawLogo"];
	[mainView setShaded: [shadeSwitch intValue]];
	[prefs setBool: ([shadeSwitch intValue]!=0) forKey: @"drawShades"];
	[mainView setSmooth: [smoothSwitch intValue]];
	[prefs setBool: ([smoothSwitch intValue]!=0) forKey: @"drawSmooth"];
	[mainView setBorder: [borderSwitch intValue]];
	[prefs setBool: ([borderSwitch intValue]!=0) forKey: @"drawBorder"];
//	[mainView setDelay: [delaySwitch intValue]];
	[prefs setBool: ([delaySwitch intValue]!=0) forKey: @"delay"];
#ifdef FF_APP
	[mainView setNeedsDisplay: TRUE];
#else
	[mainView draw];
#endif		
}


- (IBAction) 
updateGlobal: (id) sender
{
	NSUserDefaults *prefs= [ScreenSaverDefaults defaultsForModuleWithName: USERDEFAULTS];
	[mainView setTurn: [turnSlider floatValue]];
	[prefs setFloat: [turnSlider floatValue] forKey: @"tetraTurn"];
	[mainView setYank: [yankSlider floatValue]];
	[prefs setFloat: [yankSlider floatValue] forKey: @"tetraYank"];
	[mainView setZoom: [zoomSlider floatValue]];
	[prefs setFloat: [zoomSlider floatValue] forKey: @"cam_zoom"];
#ifdef FF_APP
	[mainView setNeedsDisplay: TRUE];
#else
		[mainView draw];
#endif		
}


- (IBAction)
updateDepth: (id) sender
{
	NSUserDefaults *prefs= [ScreenSaverDefaults defaultsForModuleWithName: USERDEFAULTS];

	if ([lowDepthSlider intValue] > [highDepthSlider intValue]) {
		if (sender == highDepthSlider) 
			[lowDepthSlider setIntValue: [highDepthSlider intValue]]; 
		else
			[highDepthSlider setIntValue: [lowDepthSlider intValue]]; 
	}
		
	[mainView setLowDepth: [lowDepthSlider intValue]];
	[mainView setHighDepth: [highDepthSlider intValue]];

	[prefs setInteger: [lowDepthSlider intValue] forKey: @"lowThresh"];	
	[prefs setInteger: [highDepthSlider intValue] forKey: @"highThresh"];	
#ifdef FF_APP
	[mainView setNeedsDisplay: TRUE];
#else
	[mainView draw];
#endif		
}


- (IBAction)
updateTurn: (id) sender
{
	NSUserDefaults *prefs= [ScreenSaverDefaults defaultsForModuleWithName: USERDEFAULTS];
	[turnContro update: sender];
#ifdef FF_APP
	[mainView setNeedsDisplay: TRUE];
#else
		[mainView draw];
#endif		
	[prefs setFloat: [mainView turn]->a forKey: @"turn_amp"];
	[prefs setFloat: [mainView turn]->f forKey: @"turn_freq"];
	[prefs setFloat: [mainView turn]->d forKey: @"turn_delta"];
	[prefs setFloat: [mainView turn]->p forKey: @"turn_phase"];
}

- (IBAction)
updateDist: (id) sender
{
	NSUserDefaults *prefs= [ScreenSaverDefaults defaultsForModuleWithName: USERDEFAULTS];
	[distContro update: sender];
#ifdef FF_APP
	[mainView setNeedsDisplay: TRUE];
#else
		[mainView draw];
#endif		
	[prefs setFloat: [mainView dist]->a forKey: @"dist_amp"];
	[prefs setFloat: [mainView dist]->f forKey: @"dist_freq"];
	[prefs setFloat: [mainView dist]->d forKey: @"dist_delta"];
	[prefs setFloat: [mainView dist]->p forKey: @"dist_phase"];
}


- (IBAction)
updateSize: (id) sender
{
	NSUserDefaults *prefs= [ScreenSaverDefaults defaultsForModuleWithName: USERDEFAULTS];
	[sizeContro update: sender];
#ifdef FF_APP
	[mainView setNeedsDisplay: TRUE];
#else
		[mainView draw];
#endif		
	[prefs setFloat: [mainView size]->a forKey: @"size_amp"];
	[prefs setFloat: [mainView size]->f forKey: @"size_freq"];
	[prefs setFloat: [mainView size]->d forKey: @"size_delta"];
	[prefs setFloat: [mainView size]->p forKey: @"size_phase"];
}


- (void)
generateMiniWindow
{
	NSImage *img;
	NSBitmapImageRep *rep;
	unsigned char *buf;
    float *zbuf;
	unsigned long w,h,vw,vh;
	
	vw= (unsigned long) [mainView frame].size.width;
	vh= (unsigned long) [mainView frame].size.height;

	w= h= vw<vh?vw:vh;

	rep= [[[NSBitmapImageRep alloc] 
		initWithBitmapDataPlanes: NULL
		pixelsWide: w
		pixelsHigh: h
		bitsPerSample: 8
		samplesPerPixel: 4 
		hasAlpha: TRUE
		isPlanar: FALSE
		colorSpaceName: NSCalibratedRGBColorSpace
		bytesPerRow: w*4
		bitsPerPixel: 32
	] autorelease];	
		
	buf= [rep bitmapData];
	glReadBuffer(GL_FRONT);
	glReadPixels(vw>vh?vw/2-vh/2:0,vh>vw?vh/2-vw/2:0,w,h,GL_RGBA,GL_UNSIGNED_BYTE,buf);

    zbuf= malloc( w * h * sizeof(float)  );
    if (!zbuf)
        return;
	glReadBuffer(GL_DEPTH);
	glReadPixels(vw>vh?vw/2-vh/2:0,vh>vw?vh/2-vw/2:0,w,h,GL_DEPTH_COMPONENT,GL_FLOAT,zbuf);


	//make bg color transparent
    int n= 0;
    for (int y= 0; y<h; y++) {
        for (int x= 0; x<w; x++) {
#if 1 //fast, but depends on internal pixel format
            const int RED= 0;
            const int GREEN= 1;
            const int BLUE= 2;
            const int ALPHA= 3; //offset due to RGBA
            unsigned char *pixel;
            pixel= (unsigned char*) &buf[x * 4 + y * w * 4];
            if (zbuf[n] == 1.0) {
                pixel[ALPHA]= 0x00;
                pixel[RED]= 0x00;
                pixel[GREEN]= 0x00;
                pixel[BLUE]= 0x00;
            }
            n++;
        }
    }
//cleaner, but slow:
#else
            CGFloat red, green, blue, alpha;
            NSColor *color=  [rep colorAtX: x y: y];
            [color getRed:&red green:&green blue:&blue alpha:&alpha];
            if (zbuf[n] == 1.0)
                alpha= 0.0;
            [rep setColor: [NSColor colorWithCalibratedRed: red green: green blue: blue alpha: alpha] atX: x y: y];
            n++;
        }
    }
#endif            
//	for (i=0; i<w*h*4; i+=4) 
//        if (zbuf[i/4] == 1.0)
//		if (buf[i]==0xcc && buf[i+1]==0xcc && buf[i+2]==0xcc) 
//			buf[i+3] = 0x00; //set alpha to zero
		
	img= [[[NSImage alloc] initWithSize: NSMakeSize(0.8*w,0.8*h)] autorelease];
	[img addRepresentation: rep];
	[img setFlipped: TRUE];
	[mainWindow setMiniwindowImage: img];
    free(zbuf);
}


- (void) 
goFullScreen
{
 	if (!inFullScreen) {
		fullWindow= [[NSWindow alloc] initWithContentRect: [[mainWindow screen] frame]
			styleMask: NSBorderlessWindowMask backing: NSBackingStoreBuffered defer: FALSE];
		if (fullWindow != nil) {		
			[fullWindow setTitle: @"CocoaHedron"];
			[fullWindow setReleasedWhenClosed: TRUE];
			[fullWindow setContentView: mainView];
			[mainView setInFullScreen: TRUE];
			[mainView resizeGL];		
			[fullWindow setLevel: NSScreenSaverWindowLevel -2];
			[fullWindow makeKeyAndOrderFront: self];
			
			[prefsWindow setLevel: NSScreenSaverWindowLevel -1];		
			[prefsWindow setOpaque: FALSE];
			[prefsWindow setAlphaValue: 0.8];
			
			[distWindow setLevel: NSScreenSaverWindowLevel -1];		
			[distWindow setOpaque: FALSE];
			[distWindow setAlphaValue: 0.8];

			[sizeWindow setLevel: NSScreenSaverWindowLevel -1];		
			[sizeWindow setOpaque: FALSE];
			[sizeWindow setAlphaValue: 0.8];

			[turnWindow setLevel: NSScreenSaverWindowLevel -1];		
			[turnWindow setOpaque: FALSE];
			[turnWindow setAlphaValue: 0.8];

			[aboutBox setLevel: NSScreenSaverWindowLevel -1];		
			[aboutBox setOpaque: FALSE];
			[aboutBox setAlphaValue: 0.8];

			[helpBox setLevel: NSScreenSaverWindowLevel -1];		
			[helpBox setOpaque: FALSE];
			[helpBox setAlphaValue: 0.8];

			inFullScreen= TRUE;
		}
	}	
}

- (void)
leaveFullScreen
{
	if (inFullScreen) {
		NSSize ss= [[mainWindow screen] frame].size;
		[fullWindow close];
		[mainWindow setContentView: mainView];
		[mainView setInFullScreen: FALSE];
		[mainWindow setContentAspectRatio: ss];
		//TODO: resize!!
		[mainWindow makeKeyWindow];
		[mainView resizeGL];		

		[prefsWindow setLevel: NSFloatingWindowLevel];			
		[prefsWindow setOpaque: TRUE];
		[prefsWindow setAlphaValue: 1.0];
		
		[distWindow setLevel: NSFloatingWindowLevel];			
		[distWindow setOpaque: TRUE];
		[distWindow setAlphaValue: 1.0];

		[sizeWindow setLevel: NSFloatingWindowLevel];			
		[sizeWindow setOpaque: TRUE];
		[sizeWindow setAlphaValue: 1.0];

		[turnWindow setLevel: NSFloatingWindowLevel];			
		[turnWindow setOpaque: TRUE];
		[turnWindow setAlphaValue: 1.0];

		[helpBox setLevel: NSFloatingWindowLevel];			
		[helpBox setOpaque: TRUE];
		[helpBox setAlphaValue: 1.0];

		[aboutBox setLevel: NSFloatingWindowLevel];			
		[aboutBox setOpaque: TRUE];
		[aboutBox setAlphaValue: 1.0];

				
		inFullScreen= FALSE;
	}
}

- (IBAction) 
toggleFullScreen: (id) sender
{
	if (inFullScreen)
		[self leaveFullScreen];
	else
		[self goFullScreen];
}


- (IBAction)
closeSheet: (id) sender;
{
	[NSApp endSheet: prefSheet];
}

- (IBAction)
gotoFF: (id) sender
{
	NSURL *ff= [[[NSURL alloc] initWithString: @"http://www.feedface.com."] autorelease];
	[[NSWorkspace sharedWorkspace] openURL: ff];
}


- (void) 
cleanUp
{
	[aboutBox close];
	[helpBox close];
	[distWindow close];
	[sizeWindow close];
	[turnWindow close];
}

- (IBAction)
restoreDefaults: (id) sender
{
	NSUserDefaults *prefs= [ScreenSaverDefaults defaultsForModuleWithName: USERDEFAULTS];

	[prefs removeObjectForKey: @"drawShades"]; 
	[prefs removeObjectForKey: @"drawBorder"]; 
	[prefs removeObjectForKey: @"drawSmooth"]; 
	[prefs removeObjectForKey: @"drawAxis"]; 
	[prefs removeObjectForKey: @"drawLogo"]; 
	[prefs removeObjectForKey: @"delay"]; 

	[prefs removeObjectForKey: @"cam_orientation_x"]; 
	[prefs removeObjectForKey: @"cam_orientation_y"]; 
	[prefs removeObjectForKey: @"cam_orientation_z"]; 
	[prefs removeObjectForKey: @"cam_zoom"]; 

	[prefs removeObjectForKey: @"lowThresh"]; 
	[prefs removeObjectForKey: @"highThresh"]; 

	[prefs removeObjectForKey: @"tetraTurn"]; 
	[prefs removeObjectForKey: @"tetraYank"]; 

	[prefs removeObjectForKey: @"dist_amp"]; 
	[prefs removeObjectForKey: @"dist_freq"]; 
	[prefs removeObjectForKey: @"dist_delta"]; 
	[prefs removeObjectForKey: @"dist_phase"]; 

	[prefs removeObjectForKey: @"size_amp"]; 
	[prefs removeObjectForKey: @"size_freq"]; 
	[prefs removeObjectForKey: @"size_delta"]; 
	[prefs removeObjectForKey: @"size_phase"]; 

	[prefs removeObjectForKey: @"turn_amp"]; 
	[prefs removeObjectForKey: @"turn_freq"]; 
	[prefs removeObjectForKey: @"turn_delta"]; 
	[prefs removeObjectForKey: @"turn_phase"]; 

	[self setControls];
	[mainView initScene];
	[distContro setSliders];
	[sizeContro setSliders];
	[turnContro setSliders];
	[mainView setNeedsDisplay: TRUE];
}


- (FFSine*)
getFunc: (id) sender
{
	if (sender == distContro)
		return [mainView dist];
	if (sender == sizeContro)
		return [mainView size];
	if (sender == turnContro)
		return [mainView turn];
	NSLog(@"fell through: %@ getFunc",self);	
	return 0;
}



@end
