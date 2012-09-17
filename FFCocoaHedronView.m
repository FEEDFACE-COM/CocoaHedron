//
//  FFCocoaHedronView.m
//  CocoaHedron
//
//  Created by Folkert Saathoff on Wed Feb 11 2004.
//  Copyright (c) 2004, folkert@feedface.com. All rights reserved.
//

#ifdef FF_SAVER
#import "FFCocoaHedronView_SAVER.h"
#else
#import "FFCocoaHedronView_APP.h"
#endif

#import "FFController.h"


#define MAXDEPTH (6)
#define MOVEDELAY (30)
#define FADEDELAY (20.5)

#define DISTCOEFF		(1.5f/2.0f)
#define DISTOFFSET	(1.25f)
#define DISTFUNC		(DISTCOEFF*f(&dist,rads)+DISTOFFSET)
#define TURNCOEFF		(120.0f)
#define TURNOFFSET	(0.0f)
#define TURNFUNC		(TURNCOEFF*f(&turn,rads)+TURNOFFSET)
#define SIZECOEFF		(0.25f/2.0f)
#define SIZEOFFSET	(0.493f)
#define SIZEFUNC		(SIZECOEFF*f(&size,rads)+SIZEOFFSET)

extern FFVektor a,b,c,d;

@implementation FFCocoaHedronView



#ifdef FF_SAVER

/*
 #####      #     #     #  #######  ######   
#     #    # #    #     #  #        #     #  
#         #   #   #     #  #        #     #  
 #####   #     #  #     #  #####    ######   
      #  #######   #   #   #        #   #    
#     #  #     #    # #    #        #    #   
 #####   #     #     #     #######  #     #  
*/


- (void)
dealloc
{
    [controller cleanUp];
    free(logo);
    [super dealloc];
}




- (id)initWithFrame:(NSRect)frame isPreview:(BOOL)isPreview
{
	self = [super initWithFrame:frame isPreview:isPreview];
	if (self) {
		GLint val= 1;
		NSOpenGLPixelFormatAttribute attribs[]= {
			NSOpenGLPFAAccelerated,
			(NSOpenGLPixelFormatAttribute) YES,
			NSOpenGLPFADepthSize,
			(NSOpenGLPixelFormatAttribute) 32,
//			NSOpenGLPFAMinimumPolicy,
//			NSOpenGLPFAClosestPolicy,
			(NSOpenGLPixelFormatAttribute) nil
		};	
		
		NSOpenGLPixelFormat *format= 
			[[[NSOpenGLPixelFormat alloc] initWithAttributes: attribs] autorelease];
			
			
		view= [[NSOpenGLView alloc] initWithFrame: NSZeroRect pixelFormat: format];
		[[view openGLContext] setValues: &val forParameter: NSOpenGLCPSwapInterval];	
		[self addSubview: view];
												
		if (isPreview) {
//			screenSize= [[[self window] screen] frame].size;
			screenSize= frame.size;
			inFullScreen= FALSE;
		}	
		else {
			screenSize= frame.size;
			inFullScreen= TRUE;
		}	
				
		[self initScene];
		[self initGL];
		[self initLogo];
		[self resizeGL];
		[self initClock];

  }
	return self;
}


- (void)
setFrameSize: (NSSize) newSize
{
    [super setFrameSize:newSize];
    [view setFrameSize:newSize];
		w= newSize.width;
		h= newSize.height;
		[self resizeGL];
}
 

- (BOOL)hasConfigureSheet { return YES; }
- (NSWindow*)configureSheet
{
	if (prefSheet == nil)
		[NSBundle loadNibNamed:@"ConfigureSheet" owner: self];
	[controller showPrefs: self];
	return prefSheet;
}

#endif //FF_SAVER


#ifdef FF_APP

/*
   #     ######   ######   
  # #    #     #  #     #  
 #   #   #     #  #     #  
#     #  ######   ######   
#######  #        #        
#     #  #        #        
#     #  #        #        

*/

+ (NSOpenGLPixelFormat*) 
basicPixelFormat
{
	NSOpenGLPixelFormatAttribute attribs[]= {
			NSOpenGLPFAAccelerated,
			NSOpenGLPFAFullScreen,
			NSOpenGLPFAWindow,
			NSOpenGLPFADoubleBuffer,
			NSOpenGLPFADepthSize,
			(NSOpenGLPixelFormatAttribute) 32,
			(NSOpenGLPixelFormatAttribute) nil
	};
	return [[[NSOpenGLPixelFormat alloc] initWithAttributes: attribs] autorelease];
}

- (void)
awakeFromNib
{
  	GLint val= 1;
	fade= 0.0;
	[[self openGLContext] setValues: &val forParameter: NSOpenGLCPSwapInterval];	
	inFullScreen= FALSE;
	view= self; //so we dont have to ifdef anymore below...
	screenSize= [[[view window] screen] frame].size;
	[[self openGLContext] makeCurrentContext];
	[self initScene];
	[self initGL];
	[self initLogo];
	[self resizeGL];
	[self initClock];
}

/*keyboard*********************************************************************/

- (void)
keyDown: (NSEvent*) eve
{
	if ([[eve characters] characterAtIndex: 0] == ' ')
		[controller toggleFullScreen: self];
	else if ([[eve characters] characterAtIndex: 0] == 0x1b) //ESC
		[controller leaveFullScreen];
	else
		[super keyDown: eve];
}

#endif //FF_APP




/*
######   #######  #######  #     #  
#     #  #     #     #     #     #  
#     #  #     #     #     #     #  
######   #     #     #     #######  
#     #  #     #     #     #     #  
#     #  #     #     #     #     #  
######   #######     #     #     #  
*/

+ (void)
initialize
{
	NSDictionary *dict;
	NSUserDefaults *prefs;

	prefs= [ScreenSaverDefaults defaultsForModuleWithName:USERDEFAULTS];
	dict= [NSDictionary dictionaryWithObjectsAndKeys:
		@"YES", @"drawShades",
		@"NO",  @"drawBorder",
		@"NO",  @"drawSmooth",
		@"NO",  @"drawAxis",
		@"YES",  @"drawLogo",
		@"YES", @"delay",
		
		[NSNumber numberWithFloat: 0.0],	@"cam_orientation_x",
		[NSNumber numberWithFloat: -54.735],		@"cam_orientation_y",
		[NSNumber numberWithFloat: 120.0],	@"cam_orientation_z",
		[NSNumber numberWithFloat: 2.0],		@"cam_zoom",
		
		[NSNumber numberWithInt: 1], @"lowThresh",
		[NSNumber numberWithInt: 3], @"highThresh",
		
		[NSNumber numberWithFloat: 0.1], @"tetraTurn",
		[NSNumber numberWithFloat: 0.1], @"tetraYank",
		
		[NSNumber numberWithFloat: 0.382] ,@"dist_amp",
		[NSNumber numberWithFloat: 4.5] ,@"dist_freq",
		[NSNumber numberWithFloat: -0.59] ,@"dist_delta",
		[NSNumber numberWithFloat: 0.0] ,@"dist_phase",

		[NSNumber numberWithFloat: 0.2] ,@"size_amp",
		[NSNumber numberWithFloat: 4.5] ,@"size_freq",
		[NSNumber numberWithFloat: -0.12] ,@"size_delta",
		[NSNumber numberWithFloat: 1.0] ,@"size_phase",
		
		[NSNumber numberWithFloat: 0.05] ,@"turn_amp",
		[NSNumber numberWithFloat: 0.0] ,@"turn_freq",
		[NSNumber numberWithFloat: 0.0] ,@"turn_delta",
		[NSNumber numberWithFloat: 0.0] ,@"turn_phase",

		nil];
		
	[prefs registerDefaults: dict];
}




- (void)
drawRect: (NSRect) rect
{

	w= rect.size.width;
	h= rect.size.height;

//	[[NSColor blackColor] set];
//	[NSBezierPath fillRect: rect];

	[self updateTime];
	[self drawScene];
	
	
	
}

/*mouse************************************************************************/


- (void) mouseDown: (NSEvent*) eve {	tracking= TRUE; }
- (void) mouseUp: (NSEvent*) eve {tracking= FALSE;}

- (void)
mouseDragged: (NSEvent*) eve
{
	NSUserDefaults *prefs= [ScreenSaverDefaults defaultsForModuleWithName:USERDEFAULTS];

	NSPoint loc;
	NSRect rectView;
	
	if (tracking) {
		loc= [self convertPoint: [eve locationInWindow] fromView: nil];
		rectView= [self bounds];
		w= rectView.size.width;
		h= rectView.size.height;
		if (loc.x<0) loc.x= 0;
		if (loc.x>w) loc.x= w;	
		if (loc.y<0) loc.y= 0;
		if (loc.y>h) loc.y= h;
		
		cam.o.x= 180.0 * (h-loc.y) / h;
		cam.o.y= 180.0 * (w-loc.x) / w;
		
		[prefs setFloat: cam.o.x forKey: @"cam_orientation_x"];
		[prefs setFloat: cam.o.y forKey: @"cam_orientation_y"];
		[prefs setFloat: cam.o.z forKey: @"cam_orientation_z"];
		
		[self setNeedsDisplay: TRUE];
	}
}

/*logo*************************************************************************/

- (void)
initLogo
{
	NSImage *img;
    NSBitmapImageRep *rep;
	NSString *path;
	path= [NSString stringWithFormat: @"%@/fs.tif", [[NSBundle bundleForClass: [self class]] resourcePath]];
	img= [[NSImage alloc] initWithContentsOfFile: path];
    rep= [[img representations] objectAtIndex: 0];
    unsigned int bytes= [rep bitsPerPixel] /8 * [rep pixelsWide] * [rep pixelsHigh];
    logo= (unsigned char*) malloc(bytes);
    memcpy(logo, [rep bitmapData],bytes);
//    [rep release]; //this will crash the whole app at startup on 10.8 :D
    [img release];
}


/*time*************************************************************************/

- (void)
initClock
{
	NSTimer *clock= [NSTimer 
		timerWithTimeInterval: (1.0/30.0)
		target: self
		selector: @selector(draw)
		userInfo: nil
		repeats: TRUE
	];
	[[NSRunLoop currentRunLoop] addTimer: clock forMode: NSDefaultRunLoopMode];
	[[NSRunLoop currentRunLoop] addTimer: clock forMode: NSEventTrackingRunLoopMode];				
}

- (void)
updateTime
{
	CFTimeInterval delta= CFAbsoluteTimeGetCurrent() - time;
	time= CFAbsoluteTimeGetCurrent();
	rads+= (delta/8);

	if (!waitDelay || (time - startTime > MOVEDELAY)) {
		o.x+= bobble * cos(rads);
		o.z-= bubble;
		if (o.z <= 0.0)
			o.z+= 360.0;	
	}		

// doesnt work, investig8:	
#if 0
	if ((time - startTime) < FADEDELAY) 
		fade= (time-startTime)/FADEDELAY;
	else
#endif	
		fade= 1.0;

}


/*grafx************************************************************************/

- (void)
initScene
{
	NSUserDefaults *prefs= [ScreenSaverDefaults defaultsForModuleWithName:USERDEFAULTS];

	//init time
	startTime= CFAbsoluteTimeGetCurrent();
	time= CFAbsoluteTimeGetCurrent();
	rads= 0;
	fade= 0.0;

		
	//load settings
	waitDelay= [prefs boolForKey: @"delay"];
	showAxis= [prefs boolForKey: @"drawAxis"];
	showLogo= [prefs boolForKey: @"drawLogo"];
	drawBorder= [prefs boolForKey: @"drawBorder"];
	drawSmooth= [prefs boolForKey: @"drawSmooth"];
	lightScene= [prefs boolForKey: @"drawShades"];
	low= [prefs integerForKey: @"lowThresh"];
	high= [prefs integerForKey: @"highThresh"];
	o.x= 0.0;
	o.y= 0.0;
	o.z= 0.0;

	//initialize vars 
	dirty= TRUE;
	tracking= FALSE;
	initCam(&cam);
	cam.o.x= [prefs floatForKey: @"cam_orientation_x"];
	cam.o.y= [prefs floatForKey: @"cam_orientation_y"];
	cam.o.z= [prefs floatForKey: @"cam_orientation_z"];
	cam.p.z= -10.0;
	cam.zoom= [prefs floatForKey: @"cam_zoom"];
	setCorners();
	tetra= glGenLists(MAXDEPTH);
	glListBase(tetra);
	

	bubble= [prefs floatForKey: @"tetraTurn"];
	bobble= [prefs floatForKey: @"tetraYank"];
		
	dist.a= [prefs floatForKey: @"dist_amp"];
	dist.f= [prefs floatForKey: @"dist_freq"];
	dist.d= [prefs floatForKey: @"dist_delta"];
	dist.p= [prefs floatForKey: @"dist_phase"];

	size.a= [prefs floatForKey: @"size_amp"];
	size.f= [prefs floatForKey: @"size_freq"];
	size.d= [prefs floatForKey: @"size_delta"];
	size.p= [prefs floatForKey: @"size_phase"];
		
	turn.a= [prefs floatForKey: @"turn_amp"];
	turn.f= [prefs floatForKey: @"turn_freq"];
	turn.d= [prefs floatForKey: @"turn_delta"];
	turn.p= [prefs floatForKey: @"turn_phase"];

		
}

- (void)
initGL
{
	[[view openGLContext] makeCurrentContext];

	glEnable(GL_DEPTH_TEST);
	glEnable(GL_CULL_FACE);
	glEnable(GL_LIGHTING);
	glEnable(GL_NORMALIZE);
	glEnable(GL_COLOR_MATERIAL);
//	glEnable(GL_POLYGON_SMOOTH);
//	glHint(GL_POLYGON_SMOOTH_HINT, GL_DONT_CARE); 
//	glEnable(GL_LINE_SMOOTH);
//	glHint(GL_LINE_SMOOTH,GL_DONT_CARE);
	glCullFace(GL_BACK);
	glPolygonMode(GL_FRONT,GL_FILL);
	glPolygonMode(GL_BACK,GL_NONE);
	glShadeModel(GL_FLAT);
	glClearColor(0.0,0.0,0.0,1.0);
	glClearAccum(0.0,0.0,0.0,0.0);
	
	//enable alpha blending:
	//glBlendFunc(GL_SRC_ALPHA,GL_ONE_MINUS_SRC_ALPHA);


	//turn on light:
	{
//		GLfloat position[4]= {-1000.0,-1000.0,-1000.0,0.0};
		GLfloat position[4]= {1000.0,0.0,-1000.0,0.0};
//		GLfloat position[4]= {000.0,0.0,-000.0,-1000.0};
		GLfloat ambient[4]= {1.0,1.0,1.0,0.0};
		GLfloat diffuse[4]= {1.0,1.0,1.0,1.0};
		GLfloat specular[4]= {0.0,0.0,0.0,0.0};
//		glLightModeli(GL_LIGHT_MODEL_LOCAL_VIEWER, GL_TRUE);
		glLightfv(GL_LIGHT0,GL_POSITION,position);
		glLightfv(GL_LIGHT0,GL_AMBIENT,ambient);
		glLightfv(GL_LIGHT0,GL_DIFFUSE,diffuse);
		glLightfv(GL_LIGHT0,GL_SPECULAR,specular);
		glEnable(GL_LIGHT0);
		setColors(GL_TRUE,fade);
	}		

}



- (void)
drawScene
{
	[[view openGLContext] makeCurrentContext];

	glClearColor(0.8*fade,0.8*fade,0.8*fade,1.0);

	glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
	glViewport(0,0,(GLsizei)w,(GLsizei)h);

	glLoadIdentity();


	if (lightScene) {
		glEnable(GL_LIGHTING);
		setColors(GL_TRUE,fade);	
	}
	else {
		glDisable(GL_LIGHTING);
		setColors(GL_FALSE,fade);
	}		




	{
	}

	if (inFullScreen && showLogo) {
			glBlendFunc(GL_SRC_ALPHA,GL_ONE_MINUS_SRC_ALPHA);	
			glEnable(GL_BLEND);
			drawLogo(logo,round(w),round(h));
			glDisable(GL_BLEND);
	}
	glPushMatrix();
	
		if (showAxis)	drawAxis(200.0,2.0);
		drawCam(&cam);
		if (showAxis)	drawAxis(200.0,2.0);
		
		glScalef(200.0,200.0,200.0);	
		glRotatef(o.x,1.0,0.0,0.0);
		glRotatef(o.y,0.0,1.0,0.0);
		glRotatef(o.z,0.0,0.0,1.0);
		
		if (showAxis) drawAxis(1.0,2.0);


		glPushMatrix();
		
#warning dirty flag is useless just now...	
			if (dirty) {
//                glNewList(tetra,GL_COMPILE);
				drawTetra(tetra,0,low,high,DISTFUNC,TURNFUNC,SIZEFUNC);
//                glEndList();
				dirty= FALSE;
			}	

	
			
			if (drawBorder) {
				glDisable(GL_LIGHTING);
				setColors(GL_FALSE,fade);

				glPushMatrix();
					if (lightScene)
						setBlackColor();
					else
						setWhiteColor();
					glPushMatrix();
						glTranslatef(a.x/40.0,a.y/40.0,a.z/40.0);
						glCallList(tetra);
					glPopMatrix();
					glPushMatrix();
						glTranslatef(b.x/40.0,b.y/40.0,b.z/40.0);
						glCallList(tetra);
					glPopMatrix();
					glPushMatrix();
						glTranslatef(c.x/40.0,c.y/40.0,c.z/40.0);
						glCallList(tetra);
					glPopMatrix();
					glPushMatrix();
						glTranslatef(d.x/40.0,d.y/40.0,d.z/40.0);
						glCallList(tetra);
					glPopMatrix();
					
					setBlackColor();
					glRotatef(180.0,0.0,0.0,1.0);
					glRotatef(180.0,1.0,0.0,0.0);
					
					glPushMatrix();
						glTranslatef(a.x/40.0,a.y/40.0,a.z/40.0);
						glCallList(tetra);
					glPopMatrix();
					glPushMatrix();
						glTranslatef(b.x/40.0,b.y/40.0,b.z/40.0);
						glCallList(tetra);
					glPopMatrix();
					glPushMatrix();
						glTranslatef(c.x/40.0,c.y/40.0,c.z/40.0);
						glCallList(tetra);
					glPopMatrix();
					glPushMatrix();
						glTranslatef(d.x/40.0,d.y/40.0,d.z/40.0);
						glCallList(tetra);
					glPopMatrix();
									
				glPopMatrix();
				if (lightScene) {
					glEnable(GL_LIGHTING);
					setColors(GL_TRUE,fade);
				}	
			}
			glClear(GL_DEPTH_BUFFER_BIT);

			glPushMatrix();
				setBlackColor();	
				glCallList(tetra);
//				drawTetra(tetra,0,low,high,DISTFUNC,TURNFUNC,SIZEFUNC);
				glRotatef(180.0,0.0,0.0,1.0);
				glRotatef(180.0,1.0,0.0,0.0);
				setWhiteColor();
//				drawTetra(tetra,0,low,high,DISTFUNC,TURNFUNC,SIZEFUNC);
				glCallList(tetra);
			glPopMatrix();		
	

		glPopMatrix();
	glPopMatrix();



if (drawSmooth)
	goSmooth(w,h);
	
				
//	glFlush(); //wtf?
	glFinish();

	[[view openGLContext] flushBuffer];
}


- (void)
resizeGL
{
	GLfloat sw, sh;

	[[view openGLContext] makeCurrentContext];
	glMatrixMode(GL_PROJECTION);
	glLoadIdentity();
#if 0 //always same size
	glOrtho(-w/2.0,w/2.0,-h/2.0,h/2.0,10*(w>h?-w:-h),10*(w>h?w:h));
#else //scale with window size
	sw= (GLfloat) screenSize.width;
	sh= (GLfloat) screenSize.height; 
	glOrtho(sw/-2.0f,sw/2.0f,sh/-2.0f,sh/2.0f,(sw>sh?-sw:-sh),(sw>sh?sw:sh));
#endif	
	glMatrixMode(GL_MODELVIEW);
}


- (void)
animateOneFrame
{
	[self setNeedsDisplay: TRUE];
}

- (void) 
draw
{
	[self drawRect: [self bounds]];
}

- (void) setShaded: (int) val {lightScene= (val!=0);}
- (void) setDelay: (int) val { waitDelay= (val!=0); }
- (void) setShowAxis: (int) val { showAxis= (val!=0); }
- (void) setShowLogo: (int) val {	showLogo= (val!=0); }
- (void) setSmooth: (int) val { drawSmooth= (val!=0); }
- (void) setBorder: (int) val {	drawBorder= (val!=0); }
- (void) setLowDepth: (int) val {	low= val; dirty= TRUE; }
- (void) setHighDepth: (int) val { high= val; dirty= TRUE; }
- (void) setTurn: (float) val {	bubble= val; }
- (void) setYank: (float) val {	bobble= val; }
- (void) setZoom: (float) val {	cam.zoom= val; }
- (void) setInFullScreen: (bool) val { inFullScreen= val; } 
- (FFSine*) dist { return &dist; }
- (FFSine*) size { return &size; }
- (FFSine*) turn { return &turn; }

@end
