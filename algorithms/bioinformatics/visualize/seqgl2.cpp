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
#define MODE_ORFS 1

void InitGL();
void DrawGLScene();
void ReSizeGLScene(int Width, int Height);

vector<int> nucleotides;
vector<aminoAcid> cells;
int maze_height = 10, maze_width = 10;
FASTA f;

void Timer(int extra)
{
	glutPostRedisplay();
	glutTimerFunc(0,Timer,0);
}

int main(int argc, char** argv)
{

	srand ( time(NULL) );

	// first optional command line arg is height, second is width
    if (argv[1] != NULL)
    {
      f.read(argv[1], MODE_CODING);
      //f.dump();
      cells = f.getCodingSeq();
      f.read(argv[1]);
      nucleotides = f.getSeq();
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
int stopFlag = 0;
int nonStop = 0;
float avgGeneSize = 835;
int highBlend;

// redraw the maze every frame (kind of a waste for a static image, huh)
void DrawGLScene()
{    

  if (i < cells.size())
  {

    gluLookAt (0.0, 0.0, 70.0, 0.0, 0.0, 0.0, 0.0, 1.0, 0.0);
    glMatrixMode(GL_MODELVIEW);
    glLoadIdentity();
    
    int lineLen = 100;

    aminoAcid a = cells[i];
    //a.color.dump();
    glColor3ub(a.color.r, a.color.g, a.color.b);

    float factor = i * ( 360.0 / cells.size() );

    glRotatef(factor*9, 0.f, 0.f, 1.f);

    float transDiff = .0001*(cells.size()/2300)*i;

    glTranslatef(3.0-transDiff, 3.0-transDiff, 0.0f);

    float sizeDiff = 0.00001*(cells.size()/9000)*pow(i, 1.01);

    if (MODE_ORFS)
    {

      if (a.color.r == 0 && a.color.g == 0 && a.color.b == 0)
      {
        stopFlag = 1;
        if (highBlend >= 255)
        {
          glColor3ub(0, 0, 255);
          sizeDiff = -.05;
            
          int endNuc = i*3;
          int numNuc = nonStop*3;
          int startNuc = endNuc - numNuc;
          int numAA = nonStop;

          cout << "Found possible gene (" << numAA << " amino acids, " << numNuc << " nucleotides)!"  << endl;
          cout << "Start: " << startNuc << ", End: " << endNuc << endl;

  /*
          cout << "found a possible gene ending at aa " << i << " (ending at nucleotide " << i*3 << ")" << endl;
          cout << "sequence was " << nonStop << " aa's long (" << nonStop*3 << " nucleotides)" << endl;
          cout << "beginning of sequence was " << i*3 - nonStop*3 << endl;
          cout << endl;
          */
          /*
          cout << "\n --------------------------- Sequence: -------------- " << endl;
          for (int j = startNuc; j <= endNuc; j++)
          {
            cout << f.nucLookup(nucleotides[j]);
          }
          cout << "\n ---------------------------------------------------- \n" << endl;
          */


        }
        nonStop = 0;
      }
      else 
      {
        stopFlag = 0;
        nonStop++;
        //cout << "nonStop: " << nonStop << " at pos: " << i << endl;
        int blend = (255/(avgGeneSize/3)) * nonStop;
        highBlend = pow(blend, 1.3);
        //cout << "highBlend: " << highBlend << endl;
        int blendVal = 255 - highBlend;
        blendVal = (blendVal < 0) ? 0 : blendVal;
        glColor3ub(255, blendVal, blendVal);
      }
    }

    glBegin(GL_QUADS);
      glVertex3f(-.2f+sizeDiff, .01f-sizeDiff, 0.0f);
      glVertex3f( .2f-sizeDiff, .01f-sizeDiff, 0.0f);
      glVertex3f( .2f-sizeDiff,-.01f+sizeDiff, 0.0f);
      glVertex3f(-.2f+sizeDiff,-.01f+sizeDiff, 0.0f);
    glEnd();

	}
  else
  {  
    glRotatef(1.0, 0.0, 1.0, 0.0);
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

