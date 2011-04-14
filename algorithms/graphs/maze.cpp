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

*/


#include <iostream>
#include <vector>
#include <math.h>

#include "utility.cpp"      // import utility functions
#include "DisjSets.cpp"     // disjoint set implementation

using namespace std;

// Top is    1000 (0x08)
// Bottom is 0001 (0x01)
// Left is   0100 (0x04)
// Right is  0010 (0x02)
#define TOP    0x08
#define BOTTOM 0x01
#define LEFT   0x04
#define RIGHT  0x02
#define ALL    0x0F

#define HEIGHT 5 // default height
#define WIDTH  5 // default width

class Maze
{
    public:

        Maze ( int size = HEIGHT * WIDTH )
        {
            sets.resize(size);
            cells = vector<int>(size);
            for (int i=0; i < size; i++)
                cells[i] = ALL;
        }

        // randomly knock down a wall between cells
        void random_knockdown ( )
        {
            int c1 = (rand() % height) * (rand() % width);
            vector<int> adj = find_adjacent_cells(c1);
            int c2 = adj[rand() % adj.size()];

            if (sets.find(c1) != sets.find(c2))
            {
                // they're not already connected
                // we have to find their common walls, knock them down
                // and then join them in union
                
                int diff = c1 - c2;
                // c2 below c1 - if c1-c2 == -width
                if (diff == -1*width)
                {
                    cells[c2] -= TOP;       // remove top wall
                    cells[c1] -= BOTTOM;    // remove bottom wall
                }
                // c1 below c2 - if c1-c2 == width
                else if (diff == width)
                {
                    cells[c1] -= TOP;       // remove top
                    cells[c2] -= BOTTOM;    // remove bottom
                }
                // c1 to left of c2 - if c1-c2 == -1
                else if (diff == -1)
                {
                    cells[c1] -= RIGHT;     // remove right
                    cells[c2] -= LEFT;      // remove left
                }
                // c2 to left of c1 - if c1-c2 == 1
                else if (diff == 1)
                {
                    cells[c1] -= LEFT;      // remove left;
                    cells[c2] -= RIGHT;     // remove right;
                }

                sets.unionSets(sets.find(c1), sets.find(c2)); // record relation

            }
        }

        vector<int> find_adjacent_cells ( int cell )
        {
            vector<int> adj;
            // cell above exists if cell > width
            //   cell above is cell-width
            if (cell > width)
                adj.push_back(cell-width);

            // cell below exists if cell < height*width-width
            //   cell below is cell+width
            if (cell < (height*width - width))
                adj.push_back(cell+width);

            // cell to right exists if cell % width < width-1
            //   right cell is cell + 1
            if ((cell % width) < (width-1))
                adj.push_back(cell+1);

            // cell to left exists if cell % width > 1 
            //   left cell is cell - 1
            if ((cell % width) > 1)
                adj.push_back(cell-1);
        }

        // Check to see if cell 0,0 is in the same set as cell height,width
        // If it is, we can complete the maze!
        bool maze_complete ( )
        {
            if (sets.find(0) == sets.find(height*width))
                return true;
            else
                return false;
        }


    private:
        vector<int> cells; // hold cell wall info
        DisjSets sets;     // hold sets of cells
        int height;
        int width;
};

int main ( int argc, char * argv[] )
{
    srand ( time(NULL) );

    int height = HEIGHT, width = WIDTH;
    if (argv[1] != NULL)
    {
        height = atoi(argv[1]);
        if (argv[2] != NULL)
            width = atoi(argv[2]);
        else
            width = height;
    }
    cout << "HEIGHT: " << height << " WIDTH: " << width << endl;
    int total_size = height*width;

    // For any given cell, the value is a binary bitmap
    // top is 1000, bottom is 0001, left is 0100, right is 0010
    int start_val = TOP + BOTTOM + LEFT + RIGHT;

    // Create NxM matrix to hold maze and initialize
    Maze m(total_size);
    // Create a disjoint set object to track connections between
    // the cells

    // Randomly break down walls between adjacent cells 
    // until startCell (0, 0) is connected to endCell (n-1, m-1)
    for (;;)
    {
    }


    return 0;
}
