/*
 *  FFTetra.c
 *  cocoahedron
 *
 *  Created by Folkert Saathoff on Thu Nov 13 2003.
 *  Copyright (c) 2003 folkert@feedface.com. All rights mine.
 *
 */

#import <stdlib.h>
#import <math.h>
#import "FFTetra.h"

FFVektor a,b,c,d;
static FFVektor black,white;

void
setWhiteColor(void)
{
	GLfloat specular[4]=  {0.0,0.0,0.0,1.0};
	GLfloat ambient[4]=  {0.0,0.0,0.0,1.0};
	GLfloat diffuse[4]= {white.x,white.y,white.z,1.0};
	GLfloat shininess= 1.0;

	glMaterialfv(GL_FRONT, GL_AMBIENT, ambient);
	glMaterialfv(GL_FRONT, GL_DIFFUSE, diffuse);
	glMaterialfv(GL_FRONT, GL_SPECULAR, specular);
	glMaterialfv(GL_FRONT,GL_SHININESS, &shininess);

	glColor3f(white.x,white.y,white.z);

}

void
setBlackColor(void)
{
	GLfloat specular[4]=  {0.0,0.0,0.0,1.0};
	GLfloat ambient[4]=  {0.0,0.0,0.0,1.0};
	GLfloat diffuse[4]= {black.x,black.y,black.z,1.0};
	GLfloat shininess= 1.0;
	
	glMaterialfv(GL_FRONT, GL_AMBIENT, ambient);
	glMaterialfv(GL_FRONT, GL_DIFFUSE, diffuse);
	glMaterialfv(GL_FRONT, GL_SPECULAR, specular);
	glMaterialfv(GL_FRONT,GL_SHININESS, &shininess);

	glColor3f(black.x,black.y,black.z);	
}


void
drawSingleTetra(void)
{
	glBegin(GL_TRIANGLES); {    
		//ABC
		glNormal3f(d.x,d.y,d.z);
		glVertex3f(a.x,a.y,a.z); //glNormal3f(d.x,d.y,d.z);
		glVertex3f(b.x,b.y,b.z); //glNormal3f(d.x,d.y,d.z);
		glVertex3f(c.x,c.y,c.z); //glNormal3f(d.x,d.y,d.z);
		
		//ADB
		glNormal3f(c.x,c.y,c.z);
		glVertex3f(a.x,a.y,a.z); //glNormal3f(c.x,c.y,c.z);
		glVertex3f(d.x,d.y,d.z); //glNormal3f(c.x,c.y,c.z);
		glVertex3f(b.x,b.y,b.z); //glNormal3f(c.x,c.y,c.z);
		
		//ACD
		glNormal3f(b.x,b.y,b.z);
		glVertex3f(a.x,a.y,a.z); //glNormal3f(b.x,b.y,b.z);
		glVertex3f(c.x,c.y,c.z); //glNormal3f(b.x,b.y,b.z);
		glVertex3f(d.x,d.y,d.z); //glNormal3f(b.x,b.y,b.z);
		
		//BDC
		glNormal3f(a.x,a.y,a.z);
		glVertex3f(b.x,b.y,b.z); //glNormal3f(a.x,a.y,a.z);
		glVertex3f(d.x,d.y,d.z); //glNormal3f(a.x,a.y,a.z);
		glVertex3f(c.x,c.y,c.z); //glNormal3f(a.x,a.y,a.z);
	}glEnd();
}


void 
drawTetra(GLuint tetra, GLuint depth, GLuint low, GLuint high, GLfloat dF, GLfloat tF, GLfloat sF)
{

	if (depth > high) {
		glNewList(tetra+depth,GL_COMPILE);
		glEndList();
		return;
	}
		
	drawTetra(tetra,depth+1,low,high,dF,tF,sF);
	
	glNewList(tetra+depth,GL_COMPILE); {
		if (depth >= low) drawSingleTetra();
		glPushMatrix();
			glRotatef(tF,a.x,a.y,a.z);
			glTranslatef(dF*a.x,dF*a.y,dF*a.z);
			glScalef(sF,sF,sF);
			glCallList(tetra+depth+1);
//            drawTetra(tetra,depth+1,low,high,dF,tF,sF);
		glPopMatrix();
		glPushMatrix();
			glRotatef(tF,d.x,d.y,d.z);
			glTranslatef(dF*d.x,dF*d.y,dF*d.z);
			glScalef(sF,sF,sF);
			glCallList(tetra+depth+1);
//            drawTetra(tetra,depth+1,low,high,dF,tF,sF);
		glPopMatrix();
		glPushMatrix();
			glRotatef(tF,b.x,b.y,b.z);		
			glTranslatef(dF*b.x,dF*b.y,dF*b.z);
			glScalef(sF,sF,sF);
			glCallList(tetra+depth+1);
//            drawTetra(tetra,depth+1,low,high,dF,tF,sF);
		glPopMatrix();
		glPushMatrix();
			glRotatef(tF,c.x,c.y,c.z);
			glTranslatef(dF*c.x,dF*c.y,dF*c.z);
			glScalef(sF,sF,sF);
			glCallList(tetra+depth+1);
//            drawTetra(tetra,depth+1,low,high,dF,tF,sF);
		glPopMatrix();
		
	} glEndList();

}

void
setColors(GLboolean shaded, GLfloat fade)
{
	if (shaded) {
		black.x= 0.25 * fade; black.y= 0.25 * fade; black.z= 0.25 * fade;
		white.x= 0.75 * fade; white.y= 0.75 * fade; white.z= 0.75 * fade;
	} else {
		black.x= 0.0; black.y= 0.0; black.z= 0.0;
		white.x= 1.0 * fade; white.y= 1.0 * fade; white.z= 1.0  * fade;
	}
}

void
setCorners(void)
{
	/* from http://mathworld.wolfram.com/Tetrahedron.html: */
	
	GLfloat size= 1.0;
	
	GLfloat xC= (1.0/ 3.0) * sqrt(3.0) * size;
	GLfloat rC= (1.0/12.0) * sqrt(6.0) * size;
	GLfloat RC= (1.0/ 4.0) * sqrt(6.0) * size;
	GLfloat dC= (1.0/ 6.0) * sqrt(3.0) * size;

	a.x= 0.0;  a.y= 0.0;        a.z= RC;
	b.x= -dC;  b.y= size/2.0;   b.z= -rC;
	c.x= -dC;  c.y= size/-2.0;  c.z= -rC;
	d.x=  xC;  d.y= 0.0;        d.z= -rC;
}

