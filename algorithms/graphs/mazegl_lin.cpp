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
#include "maze.h"
#include "maze.cpp"
#include <iostream>
#include "stdio.h"

using namespace std;

#define kWindowWidth	600
#define kWindowHeight	400

void InitGL();
void DrawGLScene();
void ReSizeGLScene(int Width, int Height);

vector<int> cells;
int maze_height = DEFAULT_MAZE_HEIGHT, maze_width = DEFAULT_MAZE_WIDTH;
int app_height=kWindowHeight,app_width=kWindowWidth;
float appfac = 4.0;
Maze m(maze_height, maze_width);

int main(int argc, char** argv)
{
 
	// first optional command line arg is height, second is width
  if (argc > 1)
  {
    if (argv[1] != NULL)
    {
      maze_width = atoi(argv[1]);

      if (argc > 2)
      {
        if (argv[2] != NULL)
          maze_height = atoi(argv[2]);
      }
      else
      {
        cout << "setting width to " << maze_height << endl;
        maze_height = maze_width;
      }

      if (argc > 3)
        if (argv[3] != NULL)
          appfac = (float)atoi(argv[3]);
    }
  }   

  int margin = 10;
  app_height = appfac*maze_height + margin*2;
  app_width = appfac*maze_width + margin*2;
  /*
  */
	
	// create glut window and start rendering
  glutInit(&argc, argv);
  glutInitWindowSize (app_width, app_height); 
  glutInitDisplayMode (GLUT_DOUBLE | GLUT_RGB | GLUT_DEPTH);
  glutInitWindowPosition (20, 20);
  glutCreateWindow ("Maze render");
  //glutReshapeFunc(ReSizeGLScene); 
  glutDisplayFunc(DrawGLScene); 
  InitGL();


	// Randomly break down walls between adjacent cells 
	//   until cell 0 is connected to cell size-1
	srand(time(NULL));

/*
	while (! m.mazeComplete())
		bool success = m.randomKnockdown();
  m.cleanUp(); // remove islands best we can
	cells = m.getCells(); // grab cells for rendering
  */
	
  glutMainLoop(); // start drawing
    
  return 0;
}


// set up
void InitGL()
{

	glClearColor(255.0f, 255.0f, 255.0f, 255.0f);		// This Will Clear The Background Color To Black
	glColor3i(0.0f, 0.0f, 0.0f);
  /*
	glClearDepth(1.0);							// Enables Clearing Of The Depth Buffer

	glEnable(GL_DEPTH_TEST);					// Enables Depth Testing
	glDepthFunc(GL_LESS);						// The Type Of Depth Test To Do
	glShadeModel(GL_SMOOTH);					// Enables Smooth Color Shading
  */
  //glEnable(GL_LIGHTING);
  //glEnable(GL_LIGHT0);


}


// redraw the maze every frame (kind of a waste for a static image, huh)
void DrawGLScene()
{    
	while (! m.mazeComplete())
	  bool success = m.randomKnockdown();
	cells = m.getCells(); // grab cells for rendering

	
	glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);		
  glEnable(GL_DEPTH_TEST);
  glMatrixMode(GL_PROJECTION);
	glLoadIdentity();										// Reset The View

  glOrtho(-(app_width/2), (app_width/2), -(app_height/2), (app_height/2), -100.0, 100.0);
  glMatrixMode(GL_MODELVIEW);
  glLoadIdentity();
  //glScalef(.5,.5,.5);
  //glRotatef(30, 0, 0, 1);
  glTranslatef(-(app_width/2-10), (app_height/2-10), 0);

  float red=0.0,blue=0.0,green=0.0;
  float frequency = 0.3/(cells.size()/16);
  bool rainbow = true;
  bool rainbow2 = false;
  float cVal = 0.0;
      if (rainbow) cVal = 128.0;
  float sV = appfac / 4.0;


	// Go through the cells of the maze and draw the glyphs
	for (int x=1; x <= cells.size(); x++)
	{
    //glRotatef((float)(360.0/(cells.size()/maze_width)), 0.0, 1.0, 0.0);
    //glRotatef(5.0, 0.0, 1.0, 0.0);
    if (rainbow)
    {
      green = (float)sin(frequency*(float)x + 0.0) * 127.0 + cVal;
      red   = (float)sin(frequency*(float)x + 2.0) * 127.0 + cVal;
      blue  = (float)sin(frequency*(float)x + 4.0) * 127.0 + cVal;
      //cout << "red " << red << " green " << green << " blue " << blue << endl;
    }
    red = red/255.0; blue = blue/255.0; green = green/255.0;
    if (rainbow2)
      glClearColor(0.0f, 0.0f, 0.0f, 0.0f);
    glColor3f(red, green, blue);

		int c = cells[x-1];
		
		//cout << x << " c: " << c << " maze_width: " << maze_width << endl;
	
		// write out the sides according to the bitmap for the cell
		for (int i=0; i < 3; i++)
		{
			if ((c & TOP) == TOP)
			{
				glBegin(GL_QUADS);
					glVertex3f(-1.0f*sV, 1.0f*sV, 0.0f*sV);
					glVertex3f( 1.0f*sV, 1.0f*sV, 0.0f*sV);
					glVertex3f( 1.0f*sV,-1.0f*sV, 0.0f*sV);
					glVertex3f(-1.0f*sV,-1.0f*sV, 0.0f*sV);
				glEnd();
			}
			if (i < 2)
				glTranslatef(2.0f*sV,0.0f*sV,0.0f*sV);
		}
	
		for (int i=0; i < 3; i++)
		{
			if ((c & RIGHT) == RIGHT)
			{
				glBegin(GL_QUADS);
				glVertex3f(-1.0f*sV, 1.0f*sV, 0.0f*sV);
				glVertex3f( 1.0f*sV, 1.0f*sV, 0.0f*sV);
				glVertex3f( 1.0f*sV,-1.0f*sV, 0.0f*sV);
				glVertex3f(-1.0f*sV,-1.0f*sV, 0.0f*sV);
				glEnd();			
			}
			if (i < 2)
				glTranslatef(0.0f*sV,-2.0f*sV,0.0f*sV);
		}

		for (int i=0; i < 3; i++)
		{
			if ((c & BOTTOM) == BOTTOM)
			{
				glBegin(GL_QUADS);
				glVertex3f(-1.0f*sV, 1.0f*sV, 0.0f*sV);
				glVertex3f( 1.0f*sV, 1.0f*sV, 0.0f*sV);
				glVertex3f( 1.0f*sV,-1.0f*sV, 0.0f*sV);
				glVertex3f(-1.0f*sV,-1.0f*sV, 0.0f*sV);
				glEnd();
			}
			if (i < 2)
				glTranslatef(-2.0f*sV,0.0f*sV,0.0f*sV);
		}

		for (int i=0; i < 3; i++)
		{
			if ((c & LEFT) == LEFT)
			{
				glBegin(GL_QUADS);
				glVertex3f(-1.0f*sV, 1.0f*sV, 0.0f*sV);
				glVertex3f( 1.0f*sV, 1.0f*sV, 0.0f*sV);
				glVertex3f( 1.0f*sV,-1.0f*sV, 0.0f*sV);
				glVertex3f(-1.0f*sV,-1.0f*sV, 0.0f*sV);
				glEnd();
			}
			if (i < 2)
				glTranslatef(0.0f*sV,2.0f*sV,0.0f*sV);
		}

		// shift to the right for next glyph
		glTranslatef(4.0f*sV,0.0f*sV,0.0f*sV);

		// new line (graphical carriage return)
		if ((x % maze_width) == 0)
			glTranslatef(-maze_width*4.0*sV, -4.0f*sV, 0.0f*sV);

    //glRotatef(-5.0, 0.0, 1.0, 0.0);
  }
	      
	//glTranslatef(-(float)(app_width/2), (float)(app_height)/2, 0);

  glutSwapBuffers();
  //m.cleanUp(); // remove islands best we can
  glFlush();

}


// as necessary, rescale perspective
void ReSizeGLScene(int Width, int Height)
{
//    glMatrixMode(GL_PROJECTION);
 //   glLoadIdentity();
    //glViewport (-(app_width),(-app_height), (GLsizei) Width, (GLsizei) Height);
  //  gluPerspective(30.0, (GLfloat) Width / (GLfloat) Height, 5.0f, 5.0f);

//	gluPerspective(45.0f, (GLfloat)Width/(GLfloat)Height, 1.0f, (float)(app_width+1));	// Calculate The Aspect Ratio Of The Window
	//gluPerspective(45.0f,(GLfloat)app_width/(GLfloat)app_height,00.0f,00.0f);	// Calculate The Aspect Ratio Of The Window
 //   glMatrixMode(GL_MODELVIEW);
  //  glLoadIdentity();
}

