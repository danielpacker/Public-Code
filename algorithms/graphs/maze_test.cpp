/*

Daniel Packer, CSCI335
Assignment 4, Union Find, Part B

We implement a maze class that
generates mazes of size N*M by
randomly knocking down walls between
adjacent cells of the maze until you
can get to the exit cell from the 
start cell. When a wall is knocked 
down between two cells, they join
the same set.
 
Each cell is represented in the output by a
 hex digit. The hex digit represents the bitmask
 for the cell walls:
 top: 0x01, right: 0x02, bottom: 0x04, left: 0x08
 
compile:
	g++ maze.cpp maze_test.cpp -o maze_test
 
run (for example for a 5x10 maze):
	./maze_test 5 10

*/


#include <iostream>
#include <vector>
#include <math.h>

#include "maze.h"           // constants for TOP, etc.
#include "maze.cpp"
#include "utility.cpp"      // import utility functions

using namespace std;

int main ( int argc, char * argv[] )
{
    srand ( time(NULL) );

	// take height/width on command line
    int height = DEFAULT_MAZE_HEIGHT, width = DEFAULT_MAZE_WIDTH;
    if (argv[1] != NULL)
    {
        height = atoi(argv[1]);
        if (argv[2] != NULL)
            width = atoi(argv[2]);
        else
            width = height;
    }

    // Create NxM matrix to hold maze and initialize
    Maze m(height, width);

    // Randomly break down walls between adjacent cells 
    //   until cell 0 is connected to cell size-1
    while (! m.mazeComplete())
        m.randomKnockdown();

    m.draw();   // Now display the complete maze 

    return 0;
}
