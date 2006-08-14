/*
 *  FFdraw.c
 *  cocoahedron
 *
 *  Created by Folkert Saathoff on Sat Nov 08 2003.
 *  Copyright (c) 2003 folkert@feedface.com. All rights mine.
 *
 */

#import <OpenGL/gl.h>
#import <math.h>


void
drawAxis(GLfloat length, GLfloat width)
{
	glEnable(GL_LINE_STIPPLE);
	glLineWidth(width);
	glLineStipple(1,0xff00);
	glBegin(GL_LINES);
		glColor3f(1.0,0.0,0.0);
		glVertex3f(0.0,0.0,0.0);
		glVertex3f(length,0.0,0.0);
	glEnd();
	glLineStipple(1,0xff00);
	glBegin(GL_LINES);
		glColor3f(0.0,1.0,0.0);
		glVertex3f(0.0,0.0,0.0);
		glVertex3f(0.0,length,0.0);
	glEnd();
	glLineStipple(1,0xff00);
	glBegin(GL_LINES);
		glColor3f(0.0,0.0,1.0);
		glVertex3f(0.0,0.0,0.0);
		glVertex3f(0.0,0.0,length);
  glEnd();
	glLineWidth(1.0);
	glDisable(GL_LINE_STIPPLE);
}


void drawLogo(unsigned char *logo, GLfloat w, GLfloat h) 
{
	glEnable(GL_BLEND);
	glPushMatrix();
		glRasterPos2f(w/2.0f-96,-h/2.0f+32);
		glDrawPixels(64,64,GL_RGBA,GL_UNSIGNED_BYTE,logo);
	glPopMatrix();	
	glDisable(GL_BLEND);
}




unsigned long in[1280*854];
unsigned long out[1280*854];


void
goSmooth(unsigned long w, unsigned long h)
{
	long i,x,y;
	unsigned long tmp;

	glReadBuffer(GL_BACK);
	glReadPixels(0,0,w,h,GL_RGBA,GL_UNSIGNED_INT_8_8_8_8,in);


	for (i=0; i<w*h; i++) {
	}

	glDrawBuffer(GL_FRONT);
	glRasterPos2f(-0.5*w,-0.5*h);	
//	glColorMask(GL_TRUE,GL_TRUE,GL_TRUE,GL_FALSE);
	glDrawPixels(w,h,GL_RGBA,GL_UNSIGNED_INT_8_8_8_8,out);
}

