/*
 *  FFCam.c
 *  cocoahedron
 *
 *  Created by Folkert Saathoff on Thu Nov 13 2003.
 *  Copyright (c) 2003 folkert@feedface.com. All rights mine.
 *
 */

#import <OpenGL/gl.h>
#import "FFCam.h"

void
initCam(FFCam *cam)
{
	cam->zoom= 1.0;
	initVektor(&(cam->p),0.0,0.0,0.0);
	initVektor(&(cam->o),0.0,0.0,0.0);
}

void drawCam(FFCam *cam)
{
	glRotatef(cam->o.x,1.0,0.0,0.0);
	glRotatef(cam->o.y,0.0,1.0,0.0);
	glRotatef(cam->o.z,0.0,0.0,1.0);
	glTranslatef(cam->p.x,cam->p.y,cam->p.z);
	glScalef(cam->zoom,cam->zoom,cam->zoom);
}
