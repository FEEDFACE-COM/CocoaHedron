/*
 *  FFCam.h
 *  cocoahedron
 *
 *  Created by Folkert Saathoff on Thu Nov 13 2003.
 *  Copyright (c) 2003 folkert@feedface.com. All rights mine.
 *
 */

#import <OpenGL/gl.h>
#import "FFVektor.h"

typedef struct _FFCam {
	FFVektor p,o;
	GLfloat zoom;
} FFCam;


void initCam(FFCam *cam);
void drawCam(FFCam *cam); 


