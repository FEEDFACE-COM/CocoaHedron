/*
 *  FFsine.c
 *  CocoaHedron
 *
 *  Created by Folkert Saathoff on Sat Feb 14 2004.
 *  Copyright (c) 2004 folkert@feedface.com. All rights mine.
 *
 */

#import "FFsine.h"
#import "math.h"

#define PI (3.14159265358979323844)

float f(FFSine *f, float t)
{
	return f->a*sin(f->f*t+f->p*PI)+f->d;
}