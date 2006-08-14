/*
 *  FFsine.h
 *  CocoaHedron
 *
 *  Created by Folkert Saathoff on Sat Feb 14 2004.
 *  Copyright (c) 2004 folkert@feedface.com. All rights mine.
 *
 */


typedef struct {
	float f;	//frequency
	float a;	//amplitude
	float d;	//delta
	float p;	//phase 
} FFSine;

float f(FFSine *f, float t);
