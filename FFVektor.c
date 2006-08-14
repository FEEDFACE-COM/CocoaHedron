/*
 *  FFVektor.c
 *  cocoahedron
 *
 *  Created by Folkert Saathoff on Thu Nov 13 2003.
 *  Copyright (c) 2003 folkert@feedface.com. All rights mine.
 *
 */

#import "FFVektor.h"

inline void initVektor(FFVektor *v, GLfloat x, GLfloat y, GLfloat z)
{
	v->x= x; 	v->y= y; 	v->z= z;
}

inline void copyVektor(FFVektor *v, FFVektor *u)
{
	v->x= u->x;
	v->y= u->y;
	v->z= u->z;
}
