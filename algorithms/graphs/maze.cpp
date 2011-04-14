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
#define TOP    0x01
#define BOTTOM 0x04
#define LEFT   0x08
#define RIGHT  0x02
#define ALL    0x0F

#define HEIGHT 5 // default height
#define WIDTH  5 // default width

class Maze
{
    public:

        Maze ( int h = HEIGHT, int w = WIDTH ) : height(h), width(w)
        {
            size = height * width;
            sets.resize(size);
            cells = vector<int>(size);
            for (int i=0; i < size; i++)
                cells[i] = ALL;
        }

        // randomly knock down a wall between cells
        void randomKnockdown ( )
        {
            int c1 = (rand() % height) * (rand() % width);
            vector<int> adj = findAdjacentCells(c1);
            int c2 = adj[rand() % adj.size()];

            int c1_set = sets.find(c1), c2_set = sets.find(c2);

            // only connect if not already connected
            if (c1_set != c2_set)
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

                sets.unionSets(c1_set, c2_set); // record relation

            }
        }

        vector<int> findAdjacentCells ( int cell )
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

            return adj;
        }

        // Check to see if cell 0,0 is in the same set as cell height,width
        // If it is, we can complete the maze!
        bool mazeComplete ( )
        {
            if (sets.find(0) == sets.find(size-1))
                return true;
            else
                return false;
        }

        // draw maze as a grid
        void draw ( )
        {
            cout << "DRAWING\n";
            for (int i=0; i < height; i++)
            {
                for (int j=0; j < width; j++)
                    drawCell(i*j);
                 cout << endl;
            }
        }

        // draw an indivual cell
        void drawCell ( int c )
        {
            cout << hex << cells[c] << " ";
            /*
            if (c==TOP+BOTTOM+LEFT+RIGHT)
            else if (c==TOP+BOTTOM+LEFT)
            else if (c==TOP+BOTTOM+RIGHT)
            else if (c==TOP+LEFT+RIGHT)
            else if (c==BOTTOM+LEFT+RIGHT)
            else if (c==BOTTOM+RIGHT)
            else if (c==BOTTOM+LEFT)
            else if (c==TOP+RIGHT)
            else if (c==TOP+LEFT)
            else if (c==TOP)
            else if (c==RIGHT)
            else if (c==LEFT)
            else if (c==BOTTOM)
            else if (c==TOP+BOTTOM)
            else if (c==LEFT+RIGHT)
            else if (c==0)
                */
        }

        void dump ( )
        {
            printVec(cells);
        }


    private:
        vector<int> cells; // hold cell wall info
        DisjSets sets;     // hold sets of cells
        int height;
        int width;
        int size;
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
    Maze m(height, width);

    m.dump(); m.draw();
    vector<int> adj = m.findAdjacentCells(2);
    cout << "adj: ";
    printVec(adj);
    m.randomKnockdown();
    m.dump(); m.draw();

    return 0;

    // Create a disjoint set object to track connections between
    // the cells

    // Randomly break down walls between adjacent cells 
    // until startCell (0, 0) is connected to endCell (n-1, m-1)
    int wait;
    for (;;)
    {
        m.randomKnockdown();
        m.draw();
        cin >> wait;
    }


    return 0;
}
