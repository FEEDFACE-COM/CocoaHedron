/*
 *  FFVektor.h
 *  cocoahedron
 *
 *  Created by Folkert Saathoff on Thu Nov 13 2003.
 *  Copyright (c) 2003 folkert@feedface.com. All rights mine.
 *
 */

#import <OpenGL/gl.h>

typedef struct _FFVektor {
	GLfloat x,y,z;
} FFVektor;

void initVektor(FFVektor *v, GLfloat x, GLfloat y, GLfloat z);
void copyVektor(FFVektor *u, FFVektor *v);
