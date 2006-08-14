/*
 *  FFTetra.h
 *  cocoahedron
 *
 *  Created by Folkert Saathoff on Thu Nov 13 2003.
 *  Copyright (c) 2003 folkert@feedface.com. All rights mine.
 *
 */

#import <OpenGL/gl.h>
#import "FFVektor.h"


void setWhiteColor(void);
void setBlackColor(void);
void drawTetra(GLuint tetra, GLuint depth, GLuint low, GLuint high, GLfloat dF, GLfloat tF, GLfloat sF);
void setCorners(void);
void setColors(GLboolean shaded, GLfloat fade);

