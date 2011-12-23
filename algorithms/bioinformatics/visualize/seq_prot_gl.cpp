/*
 
 Use openGL to draw based on the maze rendering from maze.cpp
 
// This code is written by Daniel Packer and was adapted from 
//   code created by Jeff Molofee '99 and ported by Tony Parker

 The maze rendering happens in DrawGLScene(), and mainly consists
 of positioning the cursor and drawing quads, much like the LOGO turtle.
 
 */

#include <GL/gl.h>			// Header File For The OpenGL32 Library
#include <GL/glu.h>			// Header File For The GLu32 Library
#include <GL/glut.h>			// Header File For The GLUT Library
#include <math.h>
#include <iostream>
#include "stdio.h"
#include "fasta.cpp"

using namespace std;

#define kWindowWidth    750	
#define kWindowHeight	750

void InitGL();
void DrawGLScene();
void ReSizeGLScene(int Width, int Height);

vector<aminoAcid> cells;
int maze_height = 10, maze_width = 10;

void Timer(int extra)
{
	glutPostRedisplay();
	glutTimerFunc(0,Timer,0);
}

int main(int argc, char** argv)
{

	srand ( time(NULL) );

	// first optional command line arg is height, second is width
    FASTA f;
    if (argv[1] != NULL)
    {
      f.read(argv[1], MODE_CODING);
      //f.dump();
      cells = f.getCodingSeq();
    }   
	
	// create glut window and start rendering
    glutInit(&argc, argv);
    glutInitDisplayMode (GLUT_DOUBLE | GLUT_RGB | GLUT_DEPTH);
    glutInitWindowSize (kWindowWidth, kWindowHeight); 
    glutInitWindowPosition (20, 20);
    glutCreateWindow (argv[0]);
	  InitGL();
    glutDisplayFunc(DrawGLScene); 
    glutReshapeFunc(ReSizeGLScene); 
    glutTimerFunc(0,Timer,0);
    
    glutMainLoop();
    
    return 0;
}


// set up
void InitGL()
{

	glClearColor(255.0f, 255.0f, 255.0f, 255.0f);		// This Will Clear The Background Color To Black
	glColor3i(0, 0, 0);
	glClearDepth(1.0);							// Enables Clearing Of The Depth Buffer
	glDepthFunc(GL_LESS);						// The Type Of Depth Test To Do
//	glEnable(GL_DEPTH_TEST);					// Enables Depth Testing
glDepthFunc(GL_NEVER);      
	glShadeModel(GL_SMOOTH);					// Enables Smooth Color Shading

	glMatrixMode(GL_PROJECTION);
	glLoadIdentity();							// Reset The Projection Matrix

//gluPerspective(45.0f,(GLfloat)kWindowWidth/(GLfloat)kWindowHeight,0.1f,100.0f);	// Calculate The Aspect Ratio Of The Window


//glOrtho (0.0f, , ht, 0.0f, -1.0f, 1.0f);
	glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);		// Clear The Screen And The Depth Buffer
}


int x = 0;
int direction=1;

// redraw the maze every frame (kind of a waste for a static image, huh)
void DrawGLScene()
{    
  glClear(GL_COLOR_BUFFER_BIT);
  glPushMatrix();

  gluLookAt (0.0, 0.0, 70.0, 0.0, 0.0, 0.0, 0.0, 1.0, 0.0);



  glPushMatrix();

  for (int i=0; i < cells.size(); i++)
  {


      aminoAcid a = cells[i];
      //a.color.dump();
      glColor3ub(a.color.r, a.color.g, a.color.b);

      //float factor = i* ( 360.0 / cells.size() );
      //glRotatef(factor*1.0, 0.0, 0.0, 1.0);
      glTranslatef(1.0, 1.0, 0.0);
      glRotatef(1.0+.001*x, 0.0, 0.0, 1.0);

      glBegin(GL_QUADS);
      glVertex3f(-1.0, 1.0, 0.0);
      glVertex3f( 1.0, 1.0, 0.0);
      glVertex3f( 1.0,-1.0, 0.0);
      glVertex3f(-1.0,-1.0, 0.0);
      glEnd();
      //cout << i << endl;
  }

  x++;
  cout << "FRAME: " << x << endl;

  glPopMatrix();
  glutSwapBuffers();
}


// as necessary, rescale perspective
void ReSizeGLScene(int Width, int Height)
{
    //glViewport (0, 0, (GLsizei) Width, (GLsizei) Height);
    glMatrixMode(GL_PROJECTION);
    glLoadIdentity();
    gluPerspective(45, (GLfloat) Width / (GLfloat) Height, 10, 0.0);

}

