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

vector<int> cells;
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
      f.read(argv[1]);
      f.dump();
    }   
	
	// create glut window and start rendering
    glutInit(&argc, argv);
    glutInitDisplayMode (GLUT_SINGLE | GLUT_RGB | GLUT_DEPTH);
    glutInitWindowSize (kWindowWidth, kWindowHeight); 
    glutInitWindowPosition (20, 20);
    glutCreateWindow (argv[0]);
	InitGL();
    glutDisplayFunc(DrawGLScene); 
    glutReshapeFunc(ReSizeGLScene); 
    glutTimerFunc(0,Timer,0);


	// Randomly break down walls between adjacent cells 
	//   until cell 0 is connected to cell size-1
    cells = f.getSeq();
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


int i = 0;

// redraw the maze every frame (kind of a waste for a static image, huh)
void DrawGLScene()
{    

	   gluLookAt (0.0, 0.0, 70.0, 0.0, 0.0, 0.0, 0.0, 1.0, 0.0);
	glMatrixMode(GL_MODELVIEW);
	glLoadIdentity();

	
	int lineLen = 100;

        //for (int i=1; i <= cells.size(); i++)
	if (i < cells.size())
        {
		switch (cells[i-1]) {
		  case 0:
		  glColor3ub(255, 0, 0);
		  break;
		  case 1:
		  glColor3ub(0, 255, 0);
		  break;
		  case 2:
		  glColor3ub(0, 0, 255);
		  break;
		  case 3:
		  glColor3ub(255, 255, 0);
		  break;
		  case 4:
		  glColor3ub(255, 255, 255);
		  break;
		  default:
		  glColor3ub(0, 0, 0);
		  break;
	
		};

float factor = i * ( 360.0 / cells.size() );

glRotatef(factor*9, 0.f, 0.f, 1.f);
glTranslatef(3.0-.0003*i, 3.0-.0003*i, 0.0f);


		glBegin(GL_QUADS);
		glVertex3f(-.2f+.00001*i, .1f-.00001*i, 0.0f);
		glVertex3f( .2f-.00001*i, .1f-.00001*i, 0.0f);
		glVertex3f( .2f-.00001*i,-.1f+.00001*i, 0.0f);
		glVertex3f(-.2f+.00001*i,-.1f+.00001*i, 0.0f);
		glEnd();
		if (i % lineLen == 0)
		{
//			glTranslatef(lineLen * -2.0f, -2.0f, 0.0f);
		}
     	} 

	else {
cout << "DONE\n";
/*
		cout << "\ndone. press enter\n";
		int stuff;
		cin >> stuff;
		exit(0);
*/
	}

	glFlush();
	i++;
}


// as necessary, rescale perspective
void ReSizeGLScene(int Width, int Height)
{
    //glViewport (0, 0, (GLsizei) Width, (GLsizei) Height);
    glMatrixMode(GL_PROJECTION);
    glLoadIdentity();
    gluPerspective(7.6, (GLfloat) Width / (GLfloat) Height, 200, 0.0);

}

