#include <iostream>
#include <vector>
#include <math.h>

#include "DisjSets.cpp" // disjoint set implementation

using namespace std;

#define NETWORK_SIZE 10

bool everyNodeInfected( const DisjSets & dj, int infected_node=1 )
{
//    for (int i=0; i < NETWORK_SIZE; i++) if (dj.find(i) 
    return true;
}

int main ( int argc, char * argv[] )
{
    srand ( time(NULL) );
    DisjSets dj(NETWORK_SIZE);

    return 0;

    int ticks = 0;
    for (;;) // start simulation
    {
        int random_node_1 = rand() % NETWORK_SIZE;
        int random_node_2 = rand() % NETWORK_SIZE;

        ticks++;

        // if every node is infected, stop simulation
        if (everyNodeInfected(dj))
            break;
    }

    float seconds = ticks/10;
    int minutes = seconds/60;
    int hours = minutes/60;
    cout << "Total time for complete infection: "
         << hours << " hours, "
         << minutes << " minutes, "
         << seconds << " seconds" << endl;
    cout << "Total random connections for complete infection: "
         << ticks << endl;

    return 0;
}
